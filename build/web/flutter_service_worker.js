'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"version.json": "c22323acc7e78f28cd920bf76b99fe0a",
"splash/img/silhouette-x1.png": "e3242c0ca1f60bbadca0036071b11112",
"splash/img/silhouette-x2.png": "97ce5bcaba29eb49be88e8a897215943",
"splash/img/icon-rounded-x2.png": "eb355fd7d316f33e720563dac93f3a4a",
"splash/img/icon-rounded-x1.png": "2ad6f85fa9541e8558140978f9870e51",
"index.html": "ff5cbf240d9baf9499b6281ccd9f4296",
"/": "ff5cbf240d9baf9499b6281ccd9f4296",
"main.dart.js": "e161995cf093a9a16da0eb61b0454cb0",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"favicon.png": "5c6a056701943e3ae9840aabf0beb04d",
"icons/icon-rounded-x1.png": "2ad6f85fa9541e8558140978f9870e51",
"manifest.json": "8b969aabebf047005889153b6e56ef08",
"assets/AssetManifest.json": "4623ccfab7d1b70f70e14558e35be1ac",
"assets/NOTICES": "1c3227bf9b02f9989b64aca2506edf5e",
"assets/FontManifest.json": "ef5fdda17a0bc8947bbb3f70ecf8c0fc",
"assets/packages/youtube_player_iframe/assets/player.html": "dc7a0426386dc6fd0e4187079900aea8",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/AssetManifest.bin": "5b0aa298d69bef32331a437695ddc45d",
"assets/fonts/MaterialIcons-Regular.otf": "1c07d8b740baaf57ef7fe410fdbd21d7",
"assets/assets/images/crypto/quirky-money-and-bank-card-exchange-1.png": "9e7b1e72999486ca2ae27b3c09864f07",
"assets/assets/images/crypto/foreground-right.png": "b831a1754a6cfb3eb594490646b00df7",
"assets/assets/images/crypto/quirky-safe-deposit-with-banknotes-and-coins-1.png": "86abf7bbe290417088dfb74cd7ad4aaa",
"assets/assets/images/crypto/bonny-dollar-bitcoin-and-crypto-currency-symbols-1.png": "9d464a043cbddbab648270440f1db696",
"assets/assets/images/crypto/sun.png": "1dcad2ff8640449c6bcba414eb58b19e",
"assets/assets/images/crypto/quirky-key-opening-a-lock-1.png": "23b3acb33933f1307dca8c107fdc5f1f",
"assets/assets/images/crypto/foreground-left.png": "ec90c0a2a926ee92ac39f635da2d34e5",
"assets/assets/images/chatbot/quirky-phone-in-a-hand-1.png": "40cc8c07490eb78c2c035e8cef90ba3b",
"assets/assets/images/chatbot/foreground-right.png": "1a33c3a12acfd41bf8b7c3d5ae5a9de8",
"assets/assets/images/chatbot/sun.png": "1a51fc9976458cd488f844562b703372",
"assets/assets/images/chatbot/quirky-twenty-four-hours-service-1.png": "6de0c4702e5a1dc5c1ad245a57b59e6b",
"assets/assets/images/chatbot/quirky-customer-support-1.png": "f06d982ca5edda52c4fb092ef10e04af",
"assets/assets/images/chatbot/foreground-left.png": "09fbd92c957503dbd2af2d065e27d8ab",
"assets/assets/images/_common/ribbon-end.png": "40abc4410227b2dde97717de03e9bd14",
"assets/assets/images/_common/silhouette.png": "94f1a31e553b7d6ebcf2c5796c7ea8e7",
"assets/assets/images/_common/2.0x/ribbon-end.png": "2c881aad21ecfc4372f291e857a0bbd3",
"assets/assets/images/_common/2.0x/arrow-indicator.png": "c68045c18c69a8b4777bd85db5d4392c",
"assets/assets/images/_common/2.0x/cloud-white.png": "e0ab9f3509b5c8634ad098d33ca40655",
"assets/assets/images/_common/compass-full.svg": "667a747d3e2f8a3a54ee1dc49765e223",
"assets/assets/images/_common/particle-21x23.png": "96151712075e558b0bd2115c79622bb4",
"assets/assets/images/_common/3.0x/ribbon-end.png": "a4a44a57a19abe6970b40509fb6c581e",
"assets/assets/images/_common/google-play-badge.png": "faf732f09f86b1a970250f53f846e35c",
"assets/assets/images/_common/airplane.png": "74f6ee74b78123f8aea3c2bca0f66e7c",
"assets/assets/images/_common/arrow-indicator.png": "86effe7d272dc513f0265888c3864b5b",
"assets/assets/images/_common/icons/icon-search.png": "d1f5a263fefd17b818847cf3aa9e3b79",
"assets/assets/images/_common/icons/icon-close.png": "1ff103377a2db28c0e9f3d64c15b26f3",
"assets/assets/images/_common/icons/icon-zoom-out.png": "5b3d7e3b80018fb0461f58fbf3de4717",
"assets/assets/images/_common/icons/2.0x/icon-search.png": "96b7a3990f14c4c6ade825d617404936",
"assets/assets/images/_common/icons/2.0x/icon-close.png": "cdcea3f1c122337e951145ec95a7abd1",
"assets/assets/images/_common/icons/2.0x/icon-zoom-out.png": "d0afae9abf8feb98de48ec349daccc3f",
"assets/assets/images/_common/icons/2.0x/icon-collection.png": "a3540caaff9c9cf1b1cc37b9cec1cdcd",
"assets/assets/images/_common/icons/2.0x/icon-share-android.png": "890e5db7c59b52a8dd02d8329c4942cb",
"assets/assets/images/_common/icons/2.0x/icon-share-ios.png": "77b51dfe6b8e1b849fc9180a5a46507a",
"assets/assets/images/_common/icons/2.0x/icon-info.png": "b6727ab80ab1914c460126d623d64b90",
"assets/assets/images/_common/icons/2.0x/icon-wallpaper.png": "fd04de6d9226d03fbf6a3bc68c65029b",
"assets/assets/images/_common/icons/2.0x/icon-close-large.png": "5770c80cc114fd37a655095b86960bfd",
"assets/assets/images/_common/icons/2.0x/icon-expand.png": "defe38b67f27f43fc2dfa7f4c093f327",
"assets/assets/images/_common/icons/2.0x/icon-timeline.png": "01caa97453d580b5b9b4be044a3162b6",
"assets/assets/images/_common/icons/2.0x/icon-fullscreen-exit.png": "86679cbc06bef05e3a85ee4c506ce6bc",
"assets/assets/images/_common/icons/2.0x/icon-reset-location.png": "fab9dcdde21ac0f83d5f5f31b2e2ac95",
"assets/assets/images/_common/icons/2.0x/icon-prev.png": "0414fe5692150506800017bae9281594",
"assets/assets/images/_common/icons/2.0x/icon-zoom-in.png": "3dd15e7c6d79b934fdfd76f7f43a6bc9",
"assets/assets/images/_common/icons/2.0x/icon-menu.png": "96e6bbe555c64170f9d95ef234b9eaa3",
"assets/assets/images/_common/icons/2.0x/icon-next-large.png": "2cabe8b135c0c28c82ba73e1c230edaf",
"assets/assets/images/_common/icons/2.0x/icon-fullscreen.png": "bfb69399a9a4b5307c00ce5a6d25f1dc",
"assets/assets/images/_common/icons/2.0x/icon-north.png": "fd2bd6ed7ef8854415d3d6921a34d472",
"assets/assets/images/_common/icons/2.0x/icon-download.png": "51be5e1637d748a015c9512ded511750",
"assets/assets/images/_common/icons/icon-collection.png": "3ebf11972b52eea0cf72c49ab7c796f5",
"assets/assets/images/_common/icons/icon-share-android.png": "8cbdf5df77919be58b5cb1992876fb6e",
"assets/assets/images/_common/icons/icon-share-ios.png": "fcf1cad03b98f36574b53656aa5f61cb",
"assets/assets/images/_common/icons/icon-info.png": "094d7f20d04efce55fc83777e575f2e0",
"assets/assets/images/_common/icons/icon-wallpaper.png": "ff9a41dabbae89d80468e328b7f1a687",
"assets/assets/images/_common/icons/icon-close-large.png": "cd29d10d2ba9900d13a43fbd89050e11",
"assets/assets/images/_common/icons/3.0x/icon-search.png": "39ecc01cfb979e4ac49872b9a0d6eeb1",
"assets/assets/images/_common/icons/3.0x/icon-close.png": "9f050c1ed49d5758d1c0f73c45b320d2",
"assets/assets/images/_common/icons/3.0x/icon-zoom-out.png": "4cb1384d05d574c10bda71a556324e27",
"assets/assets/images/_common/icons/3.0x/icon-collection.png": "f2b6238a689c73071bb027d7f7cd8de1",
"assets/assets/images/_common/icons/3.0x/icon-share-android.png": "de70a67979973643cfb60c7928c964ba",
"assets/assets/images/_common/icons/3.0x/icon-share-ios.png": "5d12ed020e5487802ab51719d69b07da",
"assets/assets/images/_common/icons/3.0x/icon-info.png": "524fe01403bf365870fa654e8e7d2ff2",
"assets/assets/images/_common/icons/3.0x/icon-wallpaper.png": "cd7d037baecdd572a0ca7faea234e58f",
"assets/assets/images/_common/icons/3.0x/icon-close-large.png": "ca63636ba9ddfc307c6818ef28e5a24e",
"assets/assets/images/_common/icons/3.0x/icon-expand.png": "19344b54a1fb163e1bf2baf27350343b",
"assets/assets/images/_common/icons/3.0x/icon-timeline.png": "67aba904dcd474349d451b20ecd9d191",
"assets/assets/images/_common/icons/3.0x/icon-fullscreen-exit.png": "0da2826215e3d5c1a105f2df34b769ec",
"assets/assets/images/_common/icons/3.0x/icon-reset-location.png": "44815e759181126f00d4a58cc1ac1160",
"assets/assets/images/_common/icons/3.0x/icon-prev.png": "af6d07f1f1090d660339c348186f888c",
"assets/assets/images/_common/icons/3.0x/icon-zoom-in.png": "57247a06dd946e0df625a53308b8be2c",
"assets/assets/images/_common/icons/3.0x/icon-menu.png": "c2c9b16f6995a0aad582eaa95380a133",
"assets/assets/images/_common/icons/3.0x/icon-next-large.png": "97a78148e3ac96cc9134979277adce70",
"assets/assets/images/_common/icons/3.0x/icon-fullscreen.png": "0564840e6255fbe67d8dcb67b64e714a",
"assets/assets/images/_common/icons/3.0x/icon-north.png": "cd9d83e3de69a62d9726de681e723fa6",
"assets/assets/images/_common/icons/3.0x/icon-download.png": "1a91ec4a4a75061fe754356eb3ffd8b3",
"assets/assets/images/_common/icons/icon-expand.png": "b8974048206fc6efbc73a0abdf13a449",
"assets/assets/images/_common/icons/icon-timeline.png": "26ab5639d5ca9e83566579786953bfb3",
"assets/assets/images/_common/icons/icon-fullscreen-exit.png": "38eacad39f8535b7c240b7bf6b07e323",
"assets/assets/images/_common/icons/icon-reset-location.png": "59c8fae6866a9dcaded0eb5e9be5cb63",
"assets/assets/images/_common/icons/icon-prev.png": "63a70fb29b956a823ddf1914e58247ed",
"assets/assets/images/_common/icons/app-icon.png": "d854e51c6b128f0b8bd95bcc42980853",
"assets/assets/images/_common/icons/icon-zoom-in.png": "7d489db878a376dbfd3d4c156aa392f8",
"assets/assets/images/_common/icons/icon-menu.png": "af9582b0525958e7a6133022d03c5de9",
"assets/assets/images/_common/icons/icon-next-large.png": "b76fc181a19ad60d086029cea98cdb86",
"assets/assets/images/_common/icons/icon-fullscreen.png": "1f7197f059506f648a7a7eb1bd7f29b7",
"assets/assets/images/_common/icons/icon-north.png": "edf5f44bf4450a4eb74c29bf5c17041b",
"assets/assets/images/_common/icons/icon-download.png": "ae5aa3901c495b0b2eb6818a40af813b",
"assets/assets/images/_common/mobile.png": "4c8240e4536f1092e345a3de6cf1f225",
"assets/assets/images/_common/texture/speckles-white.png": "82f0a75e002cf96eb40c2f97fc94abb5",
"assets/assets/images/_common/texture/2.0x/roller-2-white.gif": "1d1f55481a4628535892ef9ca91de341",
"assets/assets/images/_common/texture/2.0x/roller-1-white.gif": "22f97f97335ced0f1daa457409a4669a",
"assets/assets/images/_common/texture/roller-2-white.gif": "9d814dce58f268775a0f5d314f284864",
"assets/assets/images/_common/texture/3.0x/roller-2-white.gif": "ad0e2b9634e1ea9b0954eb148f2ef6d0",
"assets/assets/images/_common/texture/3.0x/roller-1-white.gif": "6ec0a73e5c900bacb3e2cd9ea9620d46",
"assets/assets/images/_common/texture/roller-1-white.gif": "cd9e16772bb272d40eb879d13654fc9a",
"assets/assets/images/_common/cloud-white.png": "8017b6193607fa5b8198b0a30b1a45bf",
"assets/assets/images/_common/cloud-white.svg": "5493d3bb3b54e706295831e6157b1e24",
"assets/assets/images/_common/app-store-badge.png": "4b20d647f5a05fc1d3c17cbefea9beb1",
"assets/assets/images/others/quirky-calendar-with-notes-1.png": "c9ecb118a97fe46e6b56af1bb21a7282",
"assets/assets/images/others/foreground-front.png": "227b63b6c7a590ea59f4dd899fa2851a",
"assets/assets/images/others/quirky-t-shirt-and-stack-of-clothes-1.png": "3a1b283aa5b069037b84e4ed627b882d",
"assets/assets/images/others/foreground-back.png": "b0fcbdec460331c147582110ea243aa4",
"assets/assets/images/others/quirky-wrench-and-screwdriver-1.png": "535f0d7a40e88f86d8cda2cef78fd303",
"assets/assets/images/others/sun.png": "9bf4cb2186774e03bb92480b50b39257",
"assets/assets/images/software/quirky-blue-smartphone.png": "7d95d6a29454ed2b6ad282bd0573a67a",
"assets/assets/images/software/quirky-programming-on-a-laptop-1.png": "587f2672e0ce06271c9509193a28504e",
"assets/assets/images/software/quirky-drawing-on-a-tablet-1.png": "18aeb34505d23b59b241940624b62f36",
"assets/assets/images/software/quirky-cloud-storage-1.png": "37b738c35086d6e9ce692840bcb59a2b",
"assets/assets/images/software/foreground-right.png": "88702a9ded9f2590307736fc09171446",
"assets/assets/images/software/quirky-laptop-with-graphs.png": "9db1454b35fd907be2a33cb9182608fe",
"assets/assets/images/software/top-left.png": "f73dee1f6fb7dd84980ec527e866e55a",
"assets/assets/images/software/top-right.png": "90512e51805246697a1a833bfa8ed587",
"assets/assets/images/software/sun.png": "9bf4cb2186774e03bb92480b50b39257",
"assets/assets/images/software/foreground-left.png": "b16279dca822b336aa74d889720f6fa3",
"assets/assets/images/marketing/quirky-clip-board-with-analytics-1.png": "d3d97ab4989ac55f4e58b77943692b16",
"assets/assets/images/marketing/foreground-right.png": "bed086d529622db50fc7785ef44a35be",
"assets/assets/images/marketing/quirky-megaphone.png": "064a768f297045f5cddcc343162ea280",
"assets/assets/images/marketing/sun.png": "1dcad2ff8640449c6bcba414eb58b19e",
"assets/assets/images/marketing/quirky-rocket-start-up-1.png": "86e45ef324a4d4e41c5fde30beda814e",
"assets/assets/images/marketing/foreground-left.png": "db2cf80c1d170f5e80a0294de86f9004",
"assets/assets/fonts/CinzelDecorative-Black.ttf": "9a2d88fdd78655d13ff1c93e62b998da",
"assets/assets/fonts/Raleway-Medium.ttf": "2ec8557460d3a2cd7340b16ac84fce32",
"assets/assets/fonts/Raleway-ExtraBold.ttf": "c9503ab0f939e9d37fcfb59b25acf8b3",
"assets/assets/fonts/CinzelDecorative-Bold.ttf": "a388d4f6e855b334da95b975bb30bf4d",
"assets/assets/fonts/Raleway-Regular.ttf": "75b4247fdd3b97d0e3b8e07b115673c2",
"assets/assets/fonts/TenorSans-Regular.ttf": "d827fd7095587fad48ecc82ac81d0207",
"assets/assets/fonts/B612Mono-Regular.ttf": "e530c08e772267a7520925f975e4d685",
"assets/assets/fonts/MaShanZheng-Regular.ttf": "dca1fc11a8c2b012170b0de12c13d788",
"assets/assets/fonts/Raleway-Italic.ttf": "f73026bcd64e5a5265ab616e5083cd48",
"assets/assets/fonts/YesevaOne-Regular.ttf": "5567d0bf3fe8eba4f85fbc611e8ff1ff",
"assets/assets/fonts/CinzelDecorative-Regular.ttf": "82162fab2e5b2e53e84c1f6762f33012",
"assets/assets/fonts/Raleway-Bold.ttf": "7802d8b27fcb19893ce6b38c0789268e",
"canvaskit/skwasm.js": "95f16c6690f955a45b2317496983dbe9",
"canvaskit/skwasm.wasm": "d1fde2560be92c0b07ad9cf9acb10d05",
"canvaskit/chromium/canvaskit.js": "ffb2bb6484d5689d91f393b60664d530",
"canvaskit/chromium/canvaskit.wasm": "393ec8fb05d94036734f8104fa550a67",
"canvaskit/canvaskit.js": "5caccb235fad20e9b72ea6da5a0094e6",
"canvaskit/canvaskit.wasm": "d9f69e0f428f695dc3d66b3a83a4aa8e",
"canvaskit/skwasm.worker.js": "51253d3321b11ddb8d73fa8aa87d3b15"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
