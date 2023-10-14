require "rails_helper"

describe CustomFieldLookup do

  describe "apply_serialization" do

    let(:settings) { {"multiselect" => "1"}.with_indifferent_access }
    let(:field) { FactoryBot.create(:custom_field_lookup, name: 'cf_lookup', settings: settings) }
    let(:klass) { field.field_group.klass_name.constantize }

    it "should override the default mutator for multiple choice lookup fields" do
      obj = klass.new
      expect(obj).to receive(:write_attribute).with('cf_lookup', ["steve", "jim", "bob"] )
      obj.cf_lookup = ["", "steve,jim,bob"]
    end

  end

end
