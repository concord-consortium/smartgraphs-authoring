FactoryGirl.define do
  factory :grade_level do
    sequence(:name) { |i| "#{self.class.name.underscore}_#{i}" }

    factory :mid do
      name '6-9'
    end
    factory :high do
      name '10-12'
    end
    factory :first_grade do
      name '1'
    end
    factory :second_grade do
      name '1'
    end
  end
  
end
