class ActivityFilter

  attr_accessor :subject_areas
  attr_accessor :grade_levels
  attr_accessor :search

  def initialize(params)
    self.grade_levels  = [params['grade_levels' ]].flatten.compact.uniq.reject{ |g| g.empty? }.map { |g| GradeLevel.find(g) }
    self.subject_areas = [params['subject_areas']].flatten.compact.uniq.reject{ |s| s.empty? }.map { |s| SubjectArea.find(s)}
    self.search = params['search']
  end

  def all_grade_levels
    GradeLevel.all
  end
  
  def all_subject_areas
    SubjectArea.all
  end

  def is_filtering
    return true unless (self.search.nil? or self.search.empty?)
    return true unless (self.grade_levels.nil? or self.grade_levels.empty?)
    return true unless (self.subject_areas.nil? or self.subject_areas.empty?)
    return false
  end

  def activities
    @activities = Activity.publication_status_is('public')
    if self.search
      @activities = @activities.apply_scopes(:search => [self.search, :name])
    end

    if self.subject_areas.size > 0
      @activities = @activities.any_of_subject_areas(self.subject_areas)
    end

    if self.grade_levels.size > 0 
      @activities = @activities.any_of_grade_levels(self.grade_levels)
    end
    return @activities
  end
end
