/* globals jQuery */
jQuery(function($) {
  'use strict';
    $('.wall-of-fame').imagesLoaded(function() {
        $('.wall-of-fame').masonry({
            itemSelector: 'img',
            percentPosition: true
        });
    });
});
