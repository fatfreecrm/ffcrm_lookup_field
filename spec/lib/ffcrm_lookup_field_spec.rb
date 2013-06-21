require 'spec_helper'

describe FfcrmLookupField do

  it "should serialize multiple choice lookup fields" do
    field = FactoryGirl.create(:field, :as => 'lookup')
    field.stub!(:multiselect?).and_return(true)
    Field.stub!(:where).with(:as => 'lookup').and_return( [field] )
    field.field_group.klass_name.constantize.serialized_attributes.should_not include(field.name)
    FfcrmLookupField.serialize_fields!
    field.field_group.klass_name.constantize.serialized_attributes.should include(field.name)
  end

  it "should override the default mutator for multiple choice lookup fields" do
    field = FactoryGirl.create(:field, :as => 'lookup', :name => 'cf_lookup')
    field.stub!(:multiselect?).and_return(true)
    Field.stub!(:where).with(:as => 'lookup').and_return( [field] )
    FfcrmLookupField.serialize_fields!

    klass = field.field_group.klass_name.constantize
    obj = klass.new
    obj.should_receive(:write_attribute).with('cf_lookup', ["steve", "jim", "bob"] )
    obj.cf_lookup = ["", "steve,jim,bob"]
  end

end
