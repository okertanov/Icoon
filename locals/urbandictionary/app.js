//
// app.js
//

const nextSlideInterval = 20000;

var randomUrbanTerms = undefined;
var initialTimeoutID = undefined;
var recurringTimeoutID = undefined;

let nextSlide = function() {
    if (recurringTimeoutID) {
        window.clearTimeout(recurringTimeoutID);
        recurringTimeoutID = undefined;
    }

    if (randomUrbanTerms) {
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

    var jqxhr = $.get('http://api.urbandictionary.com/v0/random')
        .done(function(d) {
            console.log('Done:', d.list.length);

            randomUrbanTerms = d.list;

            $('.active + .slide + .loading').removeClass('loading-animation');
            $('.slide').not('.loading').each(function(i, slide) {
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
            window.alert(e);
        })
        .always(function(p) {
            console.log('Finished:', p);
        });
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
    console.log('Saving current term...');

    if (!randomUrbanTerms) {
        return;
    }

    $('.slide').not('.loading').each(function(i, slide) {
        if ($(slide).hasClass('active')) {
            let term = randomUrbanTerms[i];
            if (term) {
                publishToBaaS(term);
            }
        }
    });
};

let toggleFreezeCurrentTerm = () => {
    console.log('Freezing/unfreezing current term...');

    if (!randomUrbanTerms) {
        return;
    }

    if (recurringTimeoutID) {
        window.clearTimeout(recurringTimeoutID);
        recurringTimeoutID = undefined;
    }
    else {
        recurringTimeoutID = window.setTimeout(nextSlide, nextSlideInterval);
    }
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
        case 'p':
            toggleFreezeCurrentTerm();
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

var pubnub = undefined;

let initBaaS = () => {
    pubnub = new PubNub({
        publishKey: "pub-c-8a217905-fba2-49fb-8172-6d098d2c064c",
        subscribeKey: "sub-c-954f25ae-f22a-11e7-acf8-26f7716e5467",
        ssl: false
    });

    pubnub.addListener({
        message: function(m) {
            // handle message
            var actualChannel = m.actualChannel;
            var channelName = m.channel; // The channel for which the message belongs
            var msg = m.message; // The Payload
            var publisher = m.publisher;
            var subscribedChannel = m.subscribedChannel;
            var channelGroup = m.subscription; // The channel group or wildcard subscription match (if exists)
            var pubTT = m.timetoken; // Publish timetoken

            console.log('PubNub message:', m);
        },
        presence: function(p) {
            // handle presence
            var action = p.action; // Can be join, leave, state-change or timeout
            var channelName = p.channel; // The channel for which the message belongs
            var channelGroup = p.subscription; //  The channel group or wildcard subscription match (if exists)
            var presenceEventTime = p.timestamp; // Presence event timetoken
            var status = p.status; // 200
            var message = p.message; // OK
            var service = p.service; // service
            var uuids = p.uuids;  // UUIDs of users who are connected with the channel with their state
            var occupancy = p.occupancy; // No. of users connected with the channel

            console.log('PubNub presence:', p);
        },
        status: function(s) {
            // handle status
            var category = s.category; // PNConnectedCategory
            var operation = s.operation; // PNSubscribeOperation
            var affectedChannels = s.affectedChannels; // The channels affected in the operation, of type array.
            var subscribedChannels = s.subscribedChannels; // All the current subscribed channels, of type array.
            var affectedChannelGroups = s.affectedChannelGroups; // The channel groups affected in the operation, of type array.
            var lastTimetoken = s.lastTimetoken; // The last timetoken used in the subscribe request, of type long.
            var currentTimetoken = s.currentTimetoken; // The current timetoken fetched in the subscribe response, which is going to be used in the next request, of type long.

            console.log('PubNub status:', s);
        }
    });

    pubnub.time((status, response) => {
        console.log('PubNub time', status.error, response.timetoken);
    });

    pubnub.subscribe({ channels: ['icoon_channel'] });

    pubnub.history({
        channel: 'icoon_channel',
        reverse: false,
        count: 1000,
        stringifiedTimeToken: true
    },
    (status, response) => {
        console.log('PubNub history', status, response);
    });
};

let finalizeBaaS = () => {
    if (!pubnub) {
        return;
    }

    pubnub.unsubscribe({ channels: ['icoon_channel'] });

    var existingListener = {
        message: function() {}
    };

    pubnub.removeListener(existingListener);
};

let publishToBaaS = (payload) => {
    if (!pubnub) {
        return;
    }

    pubnub.publish({
            message: { such: payload },
            channel: 'icoon_channel',
            sendByPost: false,
            storeInHistory: true,
            meta: { "session": "debug" }
        },
        function (status, response) {
            console.log('PubNub publish', status.error, response.timetoken);
        }
    );
};

// Event Listeners
$(document).on('click', nextSlide);
$(document).on('mousemove', showHintAt);
$(document).on('keypress', keyCommandHandler);

// Initial Bootstrap
performFullReload();

// PubNub Infrastructure
initBaaS();
