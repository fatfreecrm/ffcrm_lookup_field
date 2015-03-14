require 'spec_helper'

describe CustomFieldLookup do

  describe "apply_serialization" do

    let(:settings) { {"multiselect"=> "1"}.with_indifferent_access }
    let(:field) { FactoryGirl.create(:custom_field_lookup, name: 'cf_lookup', settings: settings) }
    let(:klass) { field.field_group.klass_name.constantize }
    let(:serialized_attributes) { Hash[klass.columns.select{|t| t.cast_type.is_a?(ActiveRecord::Type::Serialized) }.map{|c| [c.name, c.cast_type.coder.object_class] }] }

    it "should serialize multiple choice lookup fields" do
      expect(serialized_attributes.keys).to include(field.name)
      expect(serialized_attributes[field.name]).to eql(Array)
    end

    it "should override the default mutator for multiple choice lookup fields" do
      obj = klass.new
      expect(obj).to receive(:write_attribute).with('cf_lookup', ["steve", "jim", "bob"] )
      obj.cf_lookup = ["", "steve,jim,bob"]
    end

  end

end
