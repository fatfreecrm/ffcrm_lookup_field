require 'spec_helper'

describe FfcrmLookupField do

  it "should serialize multiple choice lookup fields" do
    field = FactoryGirl.create(:field, :as => 'lookup')
    field.stub!(:multiselect?).and_return(true)
    field.field_group.klass_name.constantize.serialized_attributes.should_not include(field.name)
    FfcrmLookupField.serialize_fields!
    field.field_group.klass_name.constantize.serialized_attributes.should include(field.name)
  end

  it "should override the default mutator for multiple choice lookup fields" do

  end

end
