/* globals jQuery */
jQuery(function($) {
  'use strict';
    $('.wall-of-images').imagesLoaded(function() {
        $('.wall-of-images').masonry({
            itemSelector: 'img',
            percentPosition: true
        });
    });
});
