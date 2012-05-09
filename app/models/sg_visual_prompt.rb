module SgVisualPrompt

  def to_hash
    {
      'type'  => self.class.name,
      'name'  => self.name,
      'point' => [self.point_x, self.point_y],
      'color' => self.color
    }
  end

  def point_from_hash(defs)
    # TODO defs had better be an array...
    self.point_x, self.point_y = defs
  end
end