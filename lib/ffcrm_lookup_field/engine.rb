module FfcrmLookupField
  class Engine < ::Rails::Engine
    paths["app/models"] << "app/models/fields/"

    config.to_prepare do

      #
      # Register the new custom field
      ActiveSupport.on_load(:fat_free_crm_field) do
        self.register(:as => 'lookup', :klass => 'CustomFieldLookup', :type => 'string')
      end

      #
      # Serialize existing custom lookup fields
      ActiveSupport.on_load(:active_record) { FfcrmLookupField.serialize_fields! }

    end

  end
end
