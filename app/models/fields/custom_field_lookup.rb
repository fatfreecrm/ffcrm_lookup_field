class CustomFieldLookup < CustomField

  Settings = %w(lookup_class_name lookup_field lookup_method autocomplete multiselect)
  LIMIT = 50 # autocomplete

  #
  # Ensure serialization is activated when custom lookup fields are created/updated
  after_save { apply_serialization }

  # Renders the value
  #------------------------------------------------------------------------------
  def render(value)
    value && lookup_values(value).map(&lookup_method.to_sym).join(', ')
  end

  # Prepares values for listing in a select box
  #------------------------------------------------------------------------------
  def lookup_values_for_selection
    lookup_values.map{|item| [item.send(lookup_method), item.send(lookup_field)]}.sort_by{|x,y| x[0] <=> y[0]}
  end

  # Looks up a set of values given a list of ids
  # If value is empty it should return all results
  #------------------------------------------------------------------------------
  def lookup_values(value=nil)
    klass = lookup_class
    if klass.methods.include?(:lookup_values)
      # use the custom search class
      klass.lookup_values(value)
    else
      # assume it's an ActiveRecord object that has Ransack on it
      items = klass.my
      items = items.limit(LIMIT) if autocomplete?
      items = items.search("#{lookup_field}_in" => value) # value can be array or string
      items.result
    end
  end

  # Returns class to lookup
  # Note: lookup_class_name can be table or model name e.g. 'contact' or 'contacts'
  #------------------------------------------------------------------------------
  def lookup_class
    lookup_class_name.tableize.classify.constantize
  end

  # Convenience methods for settings
  #------------------------------------------------------------------------------
  Settings.each do |name|
    define_method name do
      settings["#{name}"]
    end
    define_method "#{name}=" do |value|
      settings["#{name}"] = value
    end
  end

  # Define boolean settings methods for convenience
  #------------------------------------------------------------------------------
  %w(autocomplete multiselect).each do |name|
    define_method "#{name}?" do
      settings["#{name}"] == '1'
    end
  end

  # Multiselect lookup_fields need to serialize their data properly
  #------------------------------------------------------------------------------
  #   1) store data as an Array by turning on serialization on the class of the ActiveRecord object this field relates to
  #   2) parse select2 input into a proper array by overriding the mutator on the ActiveRecord object this field relates to
  def apply_serialization

    klass_name = self.field_group.try(:klass_name)
    return if klass_name.blank?
    klass = klass_name.constantize

    if self.multiselect?

      #
      # For lookup fields that are multiselect, turn on ActiveRecord serialization on the object class
      if !klass.serialized_attributes.keys.include?(self.name)
        klass.serialize(self.name.to_sym, Array)
        Rails.logger.debug("FfcrmLookupField: Serializing #{self.name} as Array for #{klass}.")
      end

      #
      # Override the mutator on the object class to ensure items are serialized correctly
      # ["", "steve,jim,bob"] becomes ["steve", "jim", "bob"]
      attr = self.name
      unless klass.instance_methods.include?(:"#{attr}=")
        klass.class_eval <<-READER, __FILE__, __LINE__ + 1
          define_method "#{attr}=" do |value|
            write_attribute( attr, value.join(',').split(',').reject(&:blank?) )
          end
        READER
        Rails.logger.debug("FfcrmLookupField: overriding #{attr}= for #{klass} to handle select2 input.")
      end

    end

  end

end
