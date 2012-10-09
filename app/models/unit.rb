class Unit < ActiveRecord::Base

  hobo_model # Don't put anything above this
  include SgMarshal
  include SgAdminOnlyModel  # admin only permissions.

  fields do
    name         :string, :required, :unique
    abbreviation :string
    timestamps
  end

  def to_hash
    {
      'type' => 'Unit',
      'name' => name,
      'abbreviation' => abbreviation
    }
  end

end
