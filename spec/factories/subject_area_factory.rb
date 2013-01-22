FactoryGirl.define do
  factory :subject_area do
    sequence(:name) { |i| "#{self.class.name.underscore}_#{i}" }
    # ["Biology", "Chemistry", "Earth and Space Science", "Engineering", "Mathematics", "Physics", "Social Sciences and Other"] 
    %w{physics math science }.each do |n|
      factory n.to_sym do
        name n
      end
    end
  end
end
