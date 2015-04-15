//= require ./global.js
//= require ./header/header
//= require ./global-nav/modal
//= require ./global-nav/nav
//= require ./footer/footer
//= require ./footer/icons
//= require ./tracking/gtm


window.UOMloadInjection = function() {
  window.UOMinjectHeader(); // Each of them in individual directory
  window.UOMModal()
  window.UOMinjectGlobalNav(); // This contains many listeners 
  window.UOMinjectFooter(); // footer and icon sitting at footer
  window.UOMinjectIcons();

  // There is google tag manager tracking
};

// So this is the entry point.
if (window.attachEvent) {
	// http://stackoverflow.com/questions/15564029/adding-to-window-onload-event
	// So attachEvent is for IE.
	// onload, "load" is the event name, "on" is just indicator.
	// window.UOMloadInjection is a function, so pass a function into attachEvent. 
  window.attachEvent('onload', window.UOMloadInjection);

	// So what about page:change event here? (see below)

} else {
  // http://stackoverflow.com/questions/12045440/difference-between-document-addeventlistener-and-window-addeventlistener
	// Why use document.addEventListener, not window.addEventListener, because in bottom-to-top propagation, document is closer.
  // Also, DOMContentLoaded (i.e. the content) is on document
	//
	// window.UOMloadInjection is a function, the false is false for the callback function.
  document.addEventListener('DOMContentLoaded', window.UOMloadInjection, false);

  document.addEventListener('page:change', function() {
		//test
		console.log('page:change?');

    window.UOMloadInjection();
  }, false);

}

// What is readystate?
// https://www.youtube.com/watch?v=OAd0sGBsWoI

