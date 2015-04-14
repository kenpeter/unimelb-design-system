<div class="jumpnav"></div>
<h2 id="simplegmap">Simple Google maps</h2>

Adding a map to a page is a great way to describe a location in addition to a text-based description. This component uses the Google Maps API to embed a functional google map into one of your pages easily.

To use the Maps component, you will need to know the latitude and longitude of the location you are looking to map. These can be found easily using [Google Maps](http://maps.google.com) (the latitude and longitude can be found in the url) or a service like [itouchmap.com](http://itouchmap.com/latlong.html).

This implementation is for basic mapping only, anything complex or requiring some level of interaction should work directly on the [Google Maps API](https://developers.google.com/maps/) in a custom JS script.

## New! Open Street Maps

We also provide <a href="#openstreetmap">an alternative</a> for use with the community-curated Open Street Maps data, using the open source Leaflet.js.

## New! Geocoding

There is now <a href="#geocode">a method</a> for generating a map directly from an address searched against Google Maps, rather than lat lng coordinates.
