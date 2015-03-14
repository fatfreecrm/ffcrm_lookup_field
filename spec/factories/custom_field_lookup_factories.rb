FactoryGirl.define do
  factory :custom_field_lookup, parent: :field, class: 'CustomFieldLookup' do
    type "CustomFieldLookup"
    as    "lookup"
  end
end
