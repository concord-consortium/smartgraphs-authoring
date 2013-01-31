FactoryGirl.define do
  factory :page do
    sequence(:name) {|i| "page_#{i}" } 
    sequence(:text) {|i| "This is the text for Page #{i}" } 
  end
end
