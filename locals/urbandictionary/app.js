//
// app.js
//

var randomUrbanTerms = undefined;

let nextSlide = () => {
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

let fetchRandomUrbanTerms = () => {
    const startSlideInterval = 3000;
    const nextSlideInterval = 20000;
    if (!randomUrbanTerms) {
        var jqxhr = $.get('http://api.urbandictionary.com/v0/random')
            .done(function(d) {
                console.log('Done:', d.list.length);
                $('.active + .slide + .loading').removeClass('loading-animation');
                $('.slide').not('.loading').each(function(i, slide) {
                    console.log('Iterating:', i, slide);
                    let term = d.list[i];
                    if (term) {
                        $(slide).find('.panel .top').html(term.word);
                        $(slide).find('.panel .top').data('back', term.word);
                        $(slide).find('.panel .bottom').html(term.word);
                        $(slide).find('.panel .bottom').data('back', term.word);
                        $(slide).find('.center h1').html(term.definition);
                    }
                });
                window.setTimeout(() => { nextSlide(); window.setInterval(nextSlide, nextSlideInterval); }, startSlideInterval);
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

fetchRandomUrbanTerms();
