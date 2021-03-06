unless window.UOMExtraLabel
  window.UOMExtraLabel = ->
    class ExtraLabel
      constructor: (@el) ->
        t = this
        @el.parentNode.addEventListener 'click', (e) ->
          if t.el.checked
            this.addClass("on")
          else
            this.removeClass("on")

    for control in document.querySelectorAll('input[type="radio"],input[type="checkbox"]')
      new ExtraLabel(control)
