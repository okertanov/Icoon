//
// app.js
//

var randomUrbanTerms = undefined;

let nextSlide = function() {
  console.log('Active:', $('.active + .slide').length);

  if ($('.active + .slide').length > 0) {
    $('.active + .slide').not('.loading').addClass('active');
    $($('.active')[0]).removeClass('active');
  }
  else {
    $('.active').removeClass('active');
    $('.slide:nth-child(2)').addClass('active');
  }
};

let fetchRandomUrbanTerms = function() {
    if (!randomUrbanTerms) {
        var jqxhr = $.get('http://api.urbandictionary.com/v0/random')
            .done(function(d) {
                console.log('Done:', d.list.length);
            })
            .fail(function(e) {
                console.warn('Error:', e);
            })
            .always(function(p) {
                console.log('Finished:', p);
            });
    }
};

$(document).on('click', nextSlide);

window.setInterval(nextSlide, 10000);
