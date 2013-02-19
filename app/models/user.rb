class User < ActiveRecord::Base

  hobo_user_model # Don't put anything above this

  # This lets us create a CSV serialization using csv_pirate
  has_csv_pirate_ship :booty => [:name, :email_address, :administrator, :created_at, :updated_at, :state, :activity_count, :public_activities_count]

  fields do
    name          :string, :required, :unique
    email_address :email_address, :login => true
    administrator :boolean, :default => false
    timestamps
  end

  scope :active, where("state = 'active'")
  scope :inactive, where("state = 'inactive'")

  has_many :activities, :foreign_key => 'owner_id'
  reverse_association_of :activities, 'Activity#owner'

  # This gives admin rights and an :active state to the first sign-up.
  # Just remove it if you don't want that
  before_create do |user|
    if !Rails.env.test? && user.class.count == 0
      user.administrator = true
      user.state = "active"
    end
  end


  # --- Signup lifecycle --- #

  lifecycle do

    state :inactive, :default => true
    state :active

    create :signup, :available_to => "Guest",
      :params => [:name, :email_address, :password, :password_confirmation],
      :become => :inactive, :new_key => true  do
      UserMailer.activation(self, lifecycle.key).deliver
    end

    transition :activate, { :inactive => :active }, :available_to => :key_holder

    transition :request_password_reset, { :inactive => :inactive }, :new_key => true do
      UserMailer.activation(self, lifecycle.key).deliver
    end

    transition :request_password_reset, { :active => :active }, :new_key => true do
      UserMailer.forgot_password(self, lifecycle.key).deliver
    end

    transition :reset_password, { :active => :active }, :available_to => :key_holder,
               :params => [ :password, :password_confirmation ]

  end

  # --- Class methods --- #

  def self.census(state='active')
    if state == 'active'
      return active.length
    else
      return inactive.length
    end
  end

  def self.registered_since(date=Date.today)
    User.where("created_at > ?", date.to_s(:db)).count
  end

  def self.have_activities
    begin
      return User.joins(:activities).uniq!.count
    rescue
      return 0
    end
  end

  # --- Instance methods --- #

  def signed_up?
    state=="active"
  end

  def activity_count
    activities.length
  end

  def public_activities_count
    activities.public.length
  end

  # --- Permissions --- #

  def create_permitted?
    # Only the initial admin user can be created
    self.class.count == 0
  end

  def update_permitted?
    acting_user.administrator? ||
      (acting_user == self && only_changed?(:email_address, :crypted_password,
                                            :current_password, :password, :password_confirmation))
    # Note: crypted_password has attr_protected so although it is permitted to change, it cannot be changed
    # directly from a form submission.
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end
end
