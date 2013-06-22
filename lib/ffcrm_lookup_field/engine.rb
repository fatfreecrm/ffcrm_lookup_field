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
      # Turn on serialization for multiselect fields at bootup
      ActiveSupport.on_load(:active_record) do
        # If this code is run during bootup, the Fields table might not exist due to empty schema.
        Field.where(:as => 'lookup').map(&:apply_serialization) if Field.table_exists?
      end

    end

  end
end
