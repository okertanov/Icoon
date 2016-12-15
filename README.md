Icoon – OSX Screen Saver with Your Web Page
===========================================

Releases
--------
[Icoon 1.0.0](https://github.com/okertanov/Icoon/releases/download/1.0.0/icoon.saver.1.0.0.zip)  
[Icoon 1.1.0](https://github.com/okertanov/Icoon/releases/download/1.1.0/icoon.saver.1.1.0.zip)

Interesting links to use with Icoon
-----------------------------------

### New 2016
[http://rainbowhunt.club](http://rainbowhunt.club)  
[https://eyes.nasa.gov/](https://eyes.nasa.gov/)  
[https://konard.github.io/twittermatrix/messages.html](https://konard.github.io/twittermatrix/messages.html)  
[https://www.ventusky.com/](https://www.ventusky.com/)  
[http://jozefmaxted.co.uk/petridish/](http://jozefmaxted.co.uk/petridish/)  
[http://maevr.vertigomusic.com/](http://maevr.vertigomusic.com/)  
[http://graphoverflow.com/graphs/3d-periodic-table.html](http://graphoverflow.com/graphs/3d-periodic-table.html)  

### New 2015
[http://stars.chromeexperiments.com/](http://stars.chromeexperiments.com/)  
[https://www.mrgnvr.uk/](https://www.mrgnvr.uk/)  
[http://stars.chromeexperiments.com/](http://stars.chromeexperiments.com/)  
[https://www.chromeexperiments.com/experiment/the-globe-of-economic-complexity](https://www.chromeexperiments.com/experiment/the-globe-of-economic-complexity)  
[http://whatcolourisit.scn9a.org/](http://whatcolourisit.scn9a.org/)  
[http://www.yuichiroharai.com/wgl/14_aiueo/](http://www.yuichiroharai.com/wgl/14_aiueo/)  
[http://stuffin.space/](http://stuffin.space/)  
[http://wwwnui.akamai.com/gnet/globe/index.html](http://wwwnui.akamai.com/gnet/globe/index.html)  
[http://map.norsecorp.com/](http://map.norsecorp.com/)  
[http://autopoet.yandex.ru/](http://autopoet.yandex.ru/)  
[http://sorting.at/](http://sorting.at/)  
[http://www.evolutionoftheweb.com/#/evolution/night](http://www.evolutionoftheweb.com/#/evolution/night)  
[http://pennystocks.la/stock-market-in-real-time/](http://pennystocks.la/stock-market-in-real-time/)  

### Main and beautiful
[http://tweetping.net/](http://tweetping.net/)  
[http://www.google.com/trends/hottrends/visualize](http://www.google.com/trends/hottrends/visualize)  
[http://www.taggalaxy.de/](http://www.taggalaxy.de/)  
[http://www.akamai.com/html/technology/](http://www.akamai.com/html/technology/dataviz1.html)  
[http://newsmap.jp/](http://newsmap.jp/)  
[http://www.axiis.org/examples/BrowserMarketShare.html](http://www.axiis.org/examples/BrowserMarketShare.html)  
[http://mrdoob.github.io/three.js/examples/css3d_periodictable.html](http://mrdoob.github.io/three.js/examples/css3d_periodictable.html)  
[http://roxik.com/cat/](http://roxik.com/cat/)  
[http://wordmap.co/](http://wordmap.co/)  

### Zen-alike
[http://www.donothingfor2minutes.com/](http://www.donothingfor2minutes.com/)  
[http://www.calm.com/](http://www.calm.com/)  
[http://zenrus.ru/](http://zenrus.ru/)  
[http://zengrecha.ru/](http://zengrecha.ru/)  

### Other screensaver-alike pages
[http://stars.chromeexperiments.com/](http://stars.chromeexperiments.com/)  
[http://www.google.com/doodles/rubiks-cube](http://www.google.com/doodles/rubiks-cube)  
[http://oos.moxiecode.com/js_webgl/particles_morph/](http://oos.moxiecode.com/js_webgl/particles_morph/)  
[http://www.chromeexperiments.com/detail/helvetica-clock-2/?f=webgl](http://www.chromeexperiments.com/detail/helvetica-clock-2/?f=webgl)  

### Lots of beautiful screensaver-alike collections
[https://developer.mozilla.org/en-US/demos/](https://developer.mozilla.org/en-US/demos/)  
[http://www.chromeexperiments.com/](http://www.chromeexperiments.com/)  
[http://www.chromeexperiments.com/webgl/](http://www.chromeexperiments.com/webgl/)  
[http://mashable.com/category/data-visualization/](http://mashable.com/category/data-visualization/)  
[http://d3js.org/](http://d3js.org/)  

See also
--------
[tlrobinson/WebSaver](https://github.com/tlrobinson/WebSaver)  
[liquidx/webviewscreensaver](https://github.com/liquidx/webviewscreensaver)  

Local html & pipes
------------------
### websocketd based, see:
[https://medium.com/@joewalnes/tail-f-to-the-web-browser-b933d9056cc](https://medium.com/@joewalnes/tail-f-to-the-web-browser-b933d9056cc)

### websocketd server side

    websocketd --port 1234 tail -f ~/projects/google/chromium/src/out/Release/.ninja_log


Plugin Architecture
-------------------

    ~/Library/Screen Savers
    .qtz screen savers
    /System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background -module icoon

TODO:
-----
 - Play/Stop on Desktop button
 - Link to site label
 - Make the presentation videos and embedd them to GH README.md
 - To think about sites list and easy selection
 - To disable or implement Refresh UI
 - To add preprocess local html files in comments to prelaunch app or so (for security reason file:// scheme only)
     <!-- @command line with arguments@ -->
 - To add WebPreferences (setWebGLEnabled:YES, etOfflineWebApplicationCacheEnabled:YES)
 - Installed Application icons animation/sliding (get image(icon) url for app name/bundle/etc)

Footnotes
---------
[Source code](https://github.com/okertanov/Icoon)  
[Donate link](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=SWJM4VCFA6DD2&lc=LV&item_name=Oleh%20Kertanov%20%28Icoon%29&item_number=Icoon&currency_code=EUR&bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHosted)  

