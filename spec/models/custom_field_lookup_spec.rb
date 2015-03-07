require 'spec_helper'

describe CustomFieldLookup do

  describe "apply_serialization" do

    let(:field) { FactoryGirl.create(:custom_field_lookup, :name => 'cf_lookup') }
    let(:klass) { field.field_group.klass_name.constantize }
    before      { allow(field).to receive(:multiselect?).and_return(true) }

    it "should serialize multiple choice lookup fields" do
      expect(klass.serialized_attributes).not_to include(field.name)
      field.apply_serialization
      expect(klass.serialized_attributes).to include(field.name)
    end

    it "should override the default mutator for multiple choice lookup fields" do
      field.apply_serialization
      obj = klass.new
      expect(obj).to receive(:write_attribute).with('cf_lookup', ["steve", "jim", "bob"] )
      obj.cf_lookup = ["", "steve,jim,bob"]
    end

  end

end
