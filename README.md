# FfcrmLookupField

A plugin for Fat Free CRM that provides a select/multi-select field that gets its data dynamically from a Rails model. It can be extended to potentially include any ruby class as a data source.

* Do you want to add a list of handpicked opportunities to a contact?
* Do you want to add a list of users to a campaign?

## Installation

Add the following line to your Fat Free CRM Gemfile.

```gem 'ffcrm_lookup_field', :github => 'fatfreecrm/ffcrm_lookup_field'```

## Setup

This example assumes you want to add the ability to select multiple opportunities on a contact

* Goto Admin -> Custom Fields and click 'Create field'
* Enter a label and set the Field type to 'Lookup field'
* Enter 'opportunities' in the 'Lookup class name' - this is the base class for the select box
* Enter 'id' in the 'Lookup field' - this is the data that will be stored on the custom field
* Enter 'name' in the 'Lookup method' - this is the what the user will see on the select box on the form
* Check 'multiselect' and click 'Create field'

Now go to the contact page and create a new contact. You will see you new opportunity field on the form.

## TODO

* Autocomplete feature isn't working yet

## License

See MIT-LICENSE file

## Authors

* Steve Kenworthy (steveyken@gmail.com)
