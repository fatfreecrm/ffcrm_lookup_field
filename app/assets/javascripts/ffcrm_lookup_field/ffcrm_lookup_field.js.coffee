(($j) ->

  # Initializes ajaxChosen selectors for lookup fields
  # Insert ourselves into the function call stream
  #   perhaps an ffcrm custom event would be better
  old_init_chosen_fields = crm.init_chosen_fields
  crm.init_chosen_fields = ->
    $$('.lookup.autocomplete').each (field) ->
      new ajaxChosen field, {
        allow_single_deselect: true
        show_on_activate: true
        url: field.readAttribute('data-autocomplete-url')
        parameters: { limit: 25 }
        query_key: "auto_complete_query"
      }
    
    old_init_chosen_fields()

) (jQuery)
