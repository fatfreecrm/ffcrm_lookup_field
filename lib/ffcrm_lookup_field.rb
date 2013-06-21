require "ffcrm_lookup_field/engine"

module FfcrmLookupField

  class << self

    #
    # What's going on here?
    # Because lookup_fields can be multiselect we need to:
    #   1) store data as an Array (serialization)
    #   2) parse select2 input into an array so we can save it
    # This code is run at startup to tell Rails what to do.
    def serialize_fields!

      #
      # This code is run during bootup... table won't exist if schema is not yet migrated.
      return unless Field.table_exists?

      Field.where(:as => 'lookup').each do |field|

        klass_name = field.field_group.klass_name
        next if klass_name.blank?
        klass = klass_name.constantize

        #
        # For lookup fields that are multiselect, turn on ActiveRecord serialization
        if !klass.serialized_attributes.keys.include?(field.name) and field.multiselect?
          klass.serialize(field.name.to_sym, Array)
          Rails.logger.debug("FfcrmLookupField: Serializing #{field.name} as Array for #{klass}.")
        end

        #
        # Override the mutator to ensure items are serialized correctly
        # ["", "steve,jim,bob"] becomes ["steve", "jim", "bob"]
        attr = field.name
        unless klass.instance_methods.include?(:"#{attr}=")
          klass.class_eval <<-READER, __FILE__, __LINE__ + 1
            define_method "#{attr}=" do |value|
              write_attribute( attr, value.join(',').split(',').reject(&:blank?) )
            end
          READER
          Rails.logger.debug("FfcrmLookupField: overriding #{attr}= for #{klass} to handle select2 input.")
        end

      end #field

    end #def

  end #class

end
