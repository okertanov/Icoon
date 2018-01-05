//
// app.js
//

const nextSlideInterval = 20000;

var randomUrbanTerms = undefined;
var initialTimeoutID = undefined;
var recurringTimeoutID = undefined;

let nextSlide = () => {
    if (recurringTimeoutID) {
        window.clearTimeout(recurringTimeoutID);
        recurringTimeoutID = undefined;
    }

    if (!randomUrbanTerms) {
        console.log('Active:', $('.active + .slide').length);

        if ($('.active + .slide').length > 0) {
            $('.active + .slide').not('.loading').addClass('active');
            $($('.active')[0]).removeClass('active');
        }
        else {
            $('.active').removeClass('active');
            $('.slide:nth-child(2)').addClass('active');
        }
    }
    else {
        console.warn('There are no random Urban terms there.');
    }

    recurringTimeoutID = window.setTimeout(nextSlide, nextSlideInterval);
};

let startAutoSlide = (timeout) => {
    initialTimeoutID = window.setTimeout(nextSlide, timeout);
};

let fetchRandomUrbanTerms = () => {
    const startSlideTimeout = 3000;
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
                startAutoSlide(startSlideTimeout);
            })
            .fail(function(e) {
                console.warn('Error:', e);
            })
            .always(function(p) {
                console.log('Finished:', p);
            });
    }
};

let performFullReload = () => {
    if (recurringTimeoutID) {
        window.clearTimeout(recurringTimeoutID);
    }
    if (initialTimeoutID) {
        window.clearTimeout(initialTimeoutID);
    }
    randomUrbanTerms = undefined;

    if ($('.active + .slide').length > 0) {
        $($('.active')[0]).removeClass('active');
    }
    $('.slide:nth-child(1)').addClass('active');
    $('.slide:nth-child(1)').addClass('loading-animation');

    fetchRandomUrbanTerms();
};

let saveCurrentTerm = () => {
    
};

const showOverlayTimeout = 2000;
var hintTimeoutId = undefined;

let hideOverlay = (overlay, timeoutId) => {
    let visible = $(overlay).is(':visible');
    if (visible) {
        $(overlay).fadeTo(1000, 0, () => { $(overlay).css('display', 'none'); });
    }
    if (timeoutId) {
        window.clearTimeout(timeoutId);
    }
};

let showHintAt = (e) => {
    // console.log(e);

    $('#hint-overlay').css({left: event.clientX, top: event.clientY, position:'absolute'});

    let visible = $('#hint-overlay').is(':visible');
    if (!visible) {
        $('#hint-overlay').fadeTo(1000, 0.5, () => { $('#hint-overlay').css('display', 'inline-block'); });
    }
    if (hintTimeoutId) {
        window.clearTimeout(hintTimeoutId);
    }
    hintTimeoutId = window.setTimeout(() => hideOverlay('#hint-overlay', hintTimeoutId), showOverlayTimeout);
};

let keyCommandHandler = (e) => {
    // console.log(e);

    let key = e.key.toLowerCase();
    var handled = false;

    switch (key) {
        case 'n':
            nextSlide();
            handled = true;
        break;
        case 'r':
            performFullReload();
            handled = true;
        break;
        case 's':
            saveCurrentTerm();
            handled = true;
        break;
        default:
            handled = false;
        break;
    }

    if (handled) {
        e.preventDefault();
    }
};

$(document).on('click', nextSlide);
$(document).on('mousemove', showHintAt);
$(document).on('keypress', keyCommandHandler);

// Initial Bootstrap
performFullReload();
