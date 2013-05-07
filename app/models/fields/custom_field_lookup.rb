class CustomFieldLookup < CustomField

  Settings = %w(lookup_class_name lookup_field lookup_method autocomplete multiselect)
  LIMIT = 50 # autocomplete

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

end
