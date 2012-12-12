(($j) ->
    
  Ajax.Responders.register({
    onComplete: ->
      $$('select.lookup.autocomplete').each (field) ->
        unless $j(field).hasClass('chzn-done')
          new ajaxChosen field, {
            allow_single_deselect: true
            show_on_activate: true
            url: field.readAttribute('data-autocomplete-url')
            parameters: { limit: 25 }
            query_key: "auto_complete_query"
          }
  })

) (jQuery)
