module SgGraphPane

  LineType  = HoboFields::Types::EnumString.for(:connected, :none)
  PointType = HoboFields::Types::EnumString.for(:none, :disc)
  
  def data_from_hash(points)
    tmp_data  = points.map{ |point| point.join(",") }
    self.data = tmp_data.join("\n")
  end

  def x_units_from_hash(definition)
    self.x_unit = Unit.find_or_create_by_name(definition)
  end

  def y_units_from_hash(definition)
    self.y_unit = Unit.find_or_create_by_name(definition)
  end

  def include_annotations_from_from_hash(graph_reference_urls)
    self_ref = self
    callback = Proc.new do
      self_ref.reload
      graphs = self_ref.sg_activity.pages.map { |p| [p.predefined_graph_panes,p.prediction_graph_panes,p.sensor_graph_panes]}
      graphs.flatten!
      graphs.select! { |g| (g.respond_to? :get_indexed_path) && (graph_reference_urls.include?(g.get_indexed_path))}
      graphs.each do |graph|
        self_ref.included_graphs << graph
      end
    end
    self.add_marshall_callback(callback)
  end

  def to_hash
    hash = {
      'type' => self.graph_type,
      'title' => title,
      'yLabel' => y_label,
      'yUnits' => y_unit ? y_unit.name : nil,
      'yMin' => y_min,
      'yMax' => y_max,
      'xLabel' => x_label,
      'xUnits' => x_unit ? x_unit.name : nil,
      'xMin' => x_min,
      'xMax' => x_max,
      'yTicks' => y_ticks,
      'xTicks' => x_ticks
    }
    if included_graphs.size > 0
      hash['includeAnnotationsFrom'] = included_graphs.map{|graph| graph.get_indexed_path }
    end
    hash
  end
end
