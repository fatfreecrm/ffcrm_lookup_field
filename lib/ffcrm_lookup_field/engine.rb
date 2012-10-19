module FfcrmLookupField
  class Engine < ::Rails::Engine
    paths["app/models"] << "app/models/fields/"
    config.to_prepare do
      Field.register(:as => 'lookup', :klass => 'CustomFieldLookup', :type => 'string')
    end
  end
end
