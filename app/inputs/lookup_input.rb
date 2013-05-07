# Fat Free CRM
# Copyright (C) 2008-2011 by Michael Dvorkin
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#------------------------------------------------------------------------------

class LookupInput < SimpleForm::Inputs::CollectionSelectInput

  # Use chosen to render a lookup widget
  #------------------------------------------------------------------------------
  def input
    add_placeholder!
    add_autocomplete!
    add_multiselect!
    @builder.select(attribute_name, lookup_values, input_options, input_html_options)
  end

  private

  def add_placeholder!
    input_html_options['data-placeholder'] = input_html_options[:placeholder] unless input_html_options[:placeholder].blank?
  end

  def add_autocomplete!
    if cf.autocomplete?
      controller = cf.lookup_class_name.tableize.pluralize
      input_html_options['data-autocomplete-url'] = Rails.application.routes.url_for(:action => 'auto_complete', :controller => controller, :format => :json, :only_path => true)
      input_html_options[:class] << 'autocomplete'
    else
      #~ input_html_options[:class] << 'chzn-select'
    end
  end

  def add_multiselect!
    input_html_options['multiple'] = 'multiple' if cf.multiselect?
  end

  # Get values to show.
  #   - order by 'method' if it is a column, otherwise use field
  #   - if using autocomplete then limit to 100 initial entries.
  #------------------------------------------------------------------------------
  def lookup_values
    cf.lookup_values_for_selection
  end

  def cf
    @cf ||= CustomFieldLookup.find_by_name(attribute_name)
  end

  def lookup_values_for_text_field
    lookup_values.map(&:first).join(', ')
  end

end
