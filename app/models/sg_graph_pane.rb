module SgGraphPane

  LineType  = HoboFields::Types::EnumString.for(:connected, :none)
  PointType = HoboFields::Types::EnumString.for(:none, :dot)
  
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
    self.add_marshal_callback(callback)
  end

  def include_referenced_graphs(graph_reference_urls)
    graphs = self.sg_activity.extract_graphs
    graphs.select! { |g| (g.respond_to? :get_indexed_path) && (graph_reference_urls.include?(g.get_indexed_path))}
    graphs.each do |graph|
      self.included_graphs << graph
    end
  end

  def included_data_sets_from_hash(definitions)
    callback = Proc.new do
      self.reload
      definitions.each do |definition|
        found_data_set = self.page.activity.data_sets.find_by_name(definition['name'])
        self.data_sets << found_data_set
      end
      self.save!
    end
    self.add_marshal_callback(callback)
  end

  def label_set_names_from_hash(definitions)
    callback = Proc.new do
      self.reload
      definitions.each do |definition|
        found_label_set = self.page.activity.label_sets.find_by_name(definition)
        unless found_label_set
          found_label_set = LabelSet.create(:is_for_users => true, :activity_id => self.page.activity.id, :name => definition)
        end
        self.label_sets << found_label_set
      end
      self.save!
    end
    self.add_marshal_callback(callback)
  end

  def to_hash
    hash = {
      'type'   => self.graph_type,
      'title'  => title,
      'yLabel' => y_label,
      'yMin'   => y_min,
      'yMax'   => y_max,
      'xLabel' => x_label,
      'xMin'   => x_min,
      'xMax'   => x_max,
      'yTicks' => y_ticks,
      'xTicks' => x_ticks,
      'includedDataSets' => included_datasets,
      'showCrossHairs'   => show_cross_hairs,
      'showToolTipCoords' => show_tool_tip_coords,
      'showGraphGrid' => show_graph_grid
    }
    if included_graphs.size > 0
      hash['includeAnnotationsFrom'] = included_graphs.map{ |graph| graph.get_indexed_path }
    end
    begin
      if label_sets.size > 0
        hash['labelSetNames'] = label_sets.map{ |label_set| label_set.name }
      end
    rescue NameError
      # Not all GraphPanes have label_sets yet
    end
    hash
  end

  # returns a 1-based indexed path string
  # eg page/2/pane/1
  def get_indexed_path
    page.activity.pages.each_with_index do |pg,pg_i|
      pg.page_panes.each_with_index do |pg_pn, pn_i|
        pn = pg_pn.pane
        if pn == self
          return "page/#{pg_i+1}/pane/#{pn_i+1}"
        end
      end
    end
    return nil
  end
end
