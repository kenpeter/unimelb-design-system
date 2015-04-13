unless window.UOMModal
  window.UOMModal = ->
    blanket = document.querySelector('.modal__blanket')
    unless blanket
      blanket = document.createElement 'div'
      ###
			modal__blanket is the grey cover, like jquery gallery
      ###
      blanket.setAttribute('class', 'modal__blanket')
		
			#comment

			# div.uomcomment
			# 	div.modal__blanket
			#		div.modal__dialog
			#
			# Only 1 .modal_blanket, but many .modal__dialog
      document.querySelector('.uomcontent').appendChild blanket

    parent = document.querySelector('.uomcontent')
		# Good example is login link in menu uses modal__dialog

		# Test
		# So for coffee, I always needs to use space, instead of tab??
    #myDialog = document.querySelectorAll('.modal__dialog')[0]
    #console.log(myDialog.parentNode)
    for modal in document.querySelectorAll('.modal__dialog')
      modal.parentNode.removeChild(modal)
      parent.appendChild modal

    ###
		http://stackoverflow.com/questions/29597629/does-sprocket-strip-comment-in-coffee-erb-when-converting-to-js?noredirect=1#comment47342273_29597629
		data-modal-target is attribute in html tag, so [data-modal-target],
		array of attribute.
    ###
    for trigger in document.querySelectorAll("[data-modal-target]")
      trigger.addEventListener 'click', (e) ->
        e.preventDefault()
        target = document.getElementById(this.getAttribute 'data-modal-target')

        if this.getAttribute('data-modal-offset')==''
          target.style.top = this.offsetTop-160+'px'
          target.addClass('on')
        else
          ###
					* getBoundingClientRect, it respets the window, which means there is window scroll Y is not included.
					* (window.height() - target.offsetHeight) / 2, it get half
					* For this case, image viewport.top === 0, then it is easier to understand.
          ###
          viewport = document.body.getBoundingClientRect()
          top = parseInt( (window.height() - target.offsetHeight) / 2 )
          target.style.top = (top - viewport.top)+'px'
          target.addClass('on')

        blanket.addClass 'on'

    for el in document.querySelectorAll('.modal__blanket,.modal__close')
      el.addEventListener 'click', (e) ->
        e.preventDefault()
        for modal in document.querySelectorAll('.modal__dialog')
          modal.removeClass 'on'
        blanket.removeClass 'on'
