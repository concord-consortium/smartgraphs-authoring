class Activity < ActiveRecord::Base

  hobo_model # Don't put anything above this

  has_csv_pirate_ship # This lets us create a CSV serialization using csv_pirate

  PublicationStatus  = HoboFields::Types::EnumString.for(:public, :private)

  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgMarshal
  include SgRuntimeJsonCaching

  fields do
    name        :string, :required
    author_name :string
    publication_status Activity::PublicationStatus, :default => 'private'
    timestamps
  end

  scope :public, where("publication_status = 'public'")
  scope :private, where("publication_status = 'private'")

  has_many   :pages, :order => :position
  belongs_to :owner, :class_name => "User"
  children   :pages, :data_sets, :label_sets, :animations

  has_many   :activity_grade_levels, :dependent => :destroy
  has_many   :grade_levels, :through => :activity_grade_levels, :accessible => true

  has_many   :activity_subject_areas, :dependent => :destroy
  has_many   :subject_areas, :through => :activity_subject_areas, :accessible => true

  has_many   :data_sets
  has_many   :label_sets
  has_many   :animations

  # --- Event Hooks   --- #
  after_update  :remove_cached_runtime_json
  after_touch   :remove_cached_runtime_json

  # --- Class methods --- #

  def self.public_count_since(date=Date.today)
    public.where("created_at > ?", date.to_s(:db)).count
  end

  def self.private_count_since(date=Date.today)
    private.where("created_at > ?", date.to_s(:db)).count
  end

  # --- Instance methods --- #

  def to_hash
    label_set_array = []
    # LabelSets for users aren't serialized
    label_sets.for_authors.each { |ls| label_set_array << ls.to_hash }
    {
      'type' => 'Activity',
      'name' => name,
      'authorName' => author_name,
      'pages' => pages.map(&:to_hash),
      'datasets' => data_sets.map(&:to_hash),
      # "Dataset" is a single English word and thus is not camel-cased.
      # However, "labelSets" is a concatenation of two English words and is therefore camel-cased
      'animations' => animations.map(&:to_hash),
      'labelSets' => label_set_array,
      'units' => Unit.find(:all).map(&:to_hash)
    }
  end

  def labels
    labels = self.label_sets.map { |ls| ls.graph_labels }.flatten
    labels << pages.map { |p| p.predefined_graph_panes.map { |pdgp| pdgp.graph_labels } }.flatten
    labels << pages.map { |p| p.pick_a_point_sequences.map { |paps| paps.graph_label } }.flatten
    labels.flatten!.uniq!
    labels
  end

  # Array of labels which are not part of a label set
  def free_labels
    self.labels.keep_if { |l| l && (l.parent_type != 'LabelSet' || l.parent_id.blank?) }
  end

  def after_user_new
    self.owner = acting_user
    self.author_name ||= acting_user.name
  end

  def copy_activity(user = self.owner)
    hash_rep = self.to_hash
    the_copy = Activity.from_hash(hash_rep)
    the_copy.owner = user
    the_copy.save
    return the_copy
  end

  def is_owner?(user=acting_user)
    return self.owner_is? user
  end

  def create_permitted?
    acting_user.signed_up?
  end

  def update_permitted?
   return true if acting_user.administrator?
   return true if self.is_owner?
   return false
  end

  def destroy_permitted?
   return true if acting_user.administrator?
   return true if self.is_owner?
   return false
  end

  def view_permitted?(field)
    true
  end

  def datasets_from_hash(definitions)
    self.data_sets = definitions.map {|d| DataSet.from_hash(d)}
  end

  def edit_permitted?(attribute)
    return true if acting_user.administrator?
    return false if attribute == :owner
    return self.is_owner?
  end

  def extract_graphs
    graphs = self.pages.map { |p| [p.predefined_graph_panes,p.prediction_graph_panes,p.sensor_graph_panes]}
    graphs.flatten!
  end

  def remove_cached_runtime_json
    # see RuntimeJsonCaching module
    delete_cache_entries
  end
end
