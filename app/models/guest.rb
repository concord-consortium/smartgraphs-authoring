# TODO: probably don't want this anymore.
class Guest < Hobo::Model::Guest

  def administrator?
    false
  end

end
