require 'spec_helper'

describe CustomFieldLookup do

  describe "apply_serialization" do

    let(:field) { FactoryGirl.create(:custom_field_lookup, :name => 'cf_lookup') }
    let(:klass) { field.field_group.klass_name.constantize }
    before      { field.stub!(:multiselect?).and_return(true) }

    it "should serialize multiple choice lookup fields" do
      klass.serialized_attributes.should_not include(field.name)
      field.apply_serialization
      klass.serialized_attributes.should include(field.name)
    end

    it "should override the default mutator for multiple choice lookup fields" do
      field.apply_serialization
      obj = klass.new
      obj.should_receive(:write_attribute).with('cf_lookup', ["steve", "jim", "bob"] )
      obj.cf_lookup = ["", "steve,jim,bob"]
    end

  end

end
