unless window.UOMValid
  window.UOMValid = ->
    class Valid
      constructor: (@el) ->
        # @el can be form or whatever element has data-validate
        
        @patterns =
          alpha: /[a-zA-Z]+/
          alpha_numeric : /[a-zA-Z0-9]+/
          integer: /-?\d+/
          number: /-?(?:\d+|\d{1,3}(?:,\d{3})+)?(?:\.\d+)?/
          card : /^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$/
          cvv : /^([0-9]){3,4}$/

          # generic password: upper-case, lower-case, number/special character, and min 8 characters
          password : /(?=^.{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/

          # http://www.whatwg.org/specs/web-apps/current-work/multipage/states-of-the-type-attribute.html#valid-e-mail-address
          email : /^[a-zA-Z0-9.!#$%&\'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/

          # abc.de
          domain: /^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z][a-zA-Z]+$/

          datetime: /([0-2][0-9]{3})\-([0-1][0-9])\-([0-3][0-9])T([0-5][0-9])\:([0-5][0-9])\:([0-5][0-9])(Z|([\-\+]([0-1][0-9])\:00))/
          date: /(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))/
          time : /(0[0-9]|1[0-9]|2[0-3])(:[0-5][0-9]){2}/
          dateISO: /\d{4}[\/\-]\d{1,2}[\/\-]\d{1,2}/
          day_month_year : /(0[1-9]|[12][0-9]|3[01])[- \/.](0[1-9]|1[012])[- \/.](19|20)\d\d/

          # url: /(https?|ftp|file|ssh):\/\/(((([a-zA-Z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&\'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-zA-Z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-zA-Z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-zA-Z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-zA-Z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-zA-Z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-zA-Z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-zA-Z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-zA-Z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-zA-Z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&\'\(\)\*\+,;=]|:|@)+(\/(([a-zA-Z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&\'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-zA-Z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&\'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-zA-Z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&\'\(\)\*\+,;=]|:|@)|\/|\?)*)?/

        # So set up error message for require or any passowrd, date, time, dateISO pattern attached to an input element etc.
        @setupMsg(f) for f in @el.querySelectorAll('[aria-required],[data-pattern]')

        t = this
        ###
        In the web.unimelb.edu.au example, data-validate is assign to <form> so, the form (the most outer element)
        is listening to submit
        ###
        @el.addEventListener 'submit', (e) ->
          invalid = 0
          target = e.target || e.srcElement
          for f in target.querySelectorAll('input,select,textarea')

            if f.hasAttribute('aria-required')
              req = f.getAttribute('aria-required')
              if req=="true"
                if f.tagName=='SELECT'
                  if f.value!="-1"
                    t.valid(f)
                  else
                    t.invalid(f)
                    invalid++
                else if f.getAttribute('type')=='checkbox'
                  checked = t.el.countSelector('[name="' + f.getAttribute('name') + '"]:checked')
                  if checked > 0
                    t.valid(f)
                  else
                    t.invalid(f)
                    invalid++
                else
                  if f.value.length > 0
                    t.valid(f)
                  else
                    t.invalid(f)
                    invalid++

            ###
              t is the form, for example,
              then f (f0, f1, f2, etc) are input elements under form, for example.
              
              data-pattern can apply to form or sub elements for example.
            ###
            if f.hasAttribute('data-pattern')
              if t.patterns.hasOwnProperty(f.getAttribute 'data-pattern')
                ###
                  So it only support single pattern validation.
                ###
                re = new RegExp(t.patterns[f.getAttribute 'data-pattern'])
              else
                re = new RegExp(f.getAttribute 'data-pattern')
              if re.test(f.value)
                t.valid(f)
              else
                t.invalid(f)
  
                # So we keep track of invalids.
                invalid++

          if invalid
            e.preventDefault()
            if /(Firefox)/g.test(navigator.userAgent)
              outer = document.querySelector('html')
            else
              outer = document.body
            outer.scrollTop = t.el.offsetTop


      # Move error message out to new node
      setupMsg: (f) ->
        parent = f.parentNode
        parent = parent.parentNode if f.nodeName == 'SELECT'

        if f.getAttribute('type')=='checkbox'
          nameval = '[name="' + f.getAttribute('name') + '"]'
          # Get the last wrapped checkbox in this node
          parent = parent.parentNode.querySelector(nameval).parentNode.parentNode.querySelector('div:last-child').querySelector(nameval).parentNode

        ###
          <div> ===> parent
            <label class="password_label" data-required="true" for="f-password-2">Password: </label>
            <input class="password_input" data-error="Please enter valid password." data-pattern="password" id="f-password-2" name="f[password]" type="text" />
          </div>

          NOTE: it assumes like this
          
          <div>
            <label>
            <input>

          It may cause bug.
        ###
        if parent.countSelector('small') == 0
          error = document.createElement 'small'
          if f.hasAttribute('data-error')
            error.appendChild document.createTextNode f.getAttribute('data-error')
          else
            error.appendChild document.createTextNode 'Required'

          ###
            Aggregate errors
            
            <div>
              <label>
              <input>  
              <small>whatever input error message 1</small> ===> Newly added, here we display the error message
            </div>
            <div>
              <label>
              <textarea>
              <small>whatever textarea error message 1</small>
            </div>
          ###
          parent.appendChild error

      invalid: (f) ->
        parent = f.parentNode

        if parent.hasClass('invalid')
          window.setTimeout ->
            if f.nodeName == 'SELECT'
              parent.parentNode.removeClass('invalid')
            parent.removeClass('invalid')
            f.removeClass('invalid')
            window.setTimeout ->
              if f.nodeName == 'SELECT'
                parent.parentNode.addClass('invalid')
              parent.addClass('invalid')
              f.addClass('invalid')
            , 0
          , 100
        else
          if f.nodeName == 'SELECT'
            parent.parentNode.addClass('invalid')

          ###
            <div class="invalid">
              <input class="invalid">
          ###
          parent.addClass('invalid')
          f.addClass('invalid')

      valid: (f) ->
        if f.nodeName == 'SELECT'
          f.parentNode.parentNode.removeClass('invalid')
        f.parentNode.removeClass('invalid')
        f.removeClass('invalid')

    ###
      The uncompiled code is like:

      if (supportedmodernbrowser) {
        _ref = document.querySelectorAll("[data-validate]");
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          f = _ref[_i];
          _results.push(new Valid(f));
        }
        return _results;
      }

      It seems _results try to aggregate them. 
    ###
    if (supportedmodernbrowser)
      new Valid(f) for f in document.querySelectorAll("[data-validate]")
