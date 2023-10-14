FactoryBot.define do
  factory :custom_field_lookup, parent: :field, class: 'CustomFieldLookup' do
    type { "CustomFieldLookup" }
    as   { "lookup" }
  end

  factory :field_group do
    klass_name          { %w[Contact Account Opportunity Lead Campaign].sample }
    label               { "Label" }
  end

  factory :field do
    type                { "Field" }
    field_group
    position            { nil }
    label               { "Label" }
    name                { "label" }
    as                  { "string" }
  end

end
