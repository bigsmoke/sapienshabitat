/**
 * The JavaScript for sapienshabitat.com is meant to be:
 *    - for enhancements only (not for essential functionality);
 *    - encapsulated (within one or more objects);
 *    - independent of jQuery or other utility libraries;
 *    - fast (not greedy of battery power).
 */
class SapiensHabitatEnhancements {
  constructor() {
    this.initializeScrollDetection();
    this.initializeLocalLinkOverrides();
    this.initializeHorizontalInsertScrolling();
  }

  initializeScrollDetection() {
    var scrollSensitiveContainers = document.getElementsByClassName('js-scroll-up-detection-with-threshold');
    Array.prototype.forEach.call(scrollSensitiveContainers, function(container) {
      new SapiensHabitatScrollDetector(container);
    });
  }

  initializeHorizontalInsertScrolling() {
    let navEls = document.getElementsByClassName('js-insert__sibling-nav');

    Array.prototype.forEach.call(navEls, function(navEl) {
      let siblingList = navEl.querySelector('.js-insert__sibling-list');

      siblingList.addEventListener('wheel', (event) => {
        let initialX = siblingList.scrollLeft;

        // Scale all scroll values to something slow
        let deltaX = event.deltaX != 0 ? event.deltaX : event.deltaY;
        siblingList.scrollBy(deltaX, 0);

        let postX = siblingList.scrollLeft;

        if (initialX == 0 && deltaX < 0)
          return false;
        if (siblingList.offsetWidth == siblingList.scrollWidth - initialX && deltaX > 0)
          return false;

        event.stopPropagation();
        event.preventDefault();
      });

      Array.prototype.forEach.call(navEl.querySelectorAll('.js-insert__sibling-scroll'), function(triggerEl) {
        triggerEl.onclick = function(event) {
          let scrollDirection = 1;
          if (triggerEl.dataset.scrollDirection == 'left') {
            scrollDirection = -1;
          }
          siblingList.scrollBy(200 * scrollDirection, 0);
        };
      });
    });
  }

  /**
   * Because this is a purely static site, I can test it locally without a HTTP server.
   * This changes the links so that they work locally.
   */
  initializeLocalLinkOverrides() {
    if (window.location.protocol != 'file:') {
      return;
    }
    var internalLinks = document.querySelectorAll("a[href^='/']");
    Array.prototype.forEach.call(internalLinks, function(link) {
      let url = new URL(link.getAttribute('href'), window.location);
      if (link.getAttribute('href') == '/') {
        var file_href = '../index/page.html5';
      } else {
        console.log(url.pathname);
        var file_href = '..' + url.pathname + 'page.html5' + url.hash;
      }
      link.setAttribute('href', file_href);
    });
    var internalImages = document.querySelectorAll("img[src^='/']");
    Array.prototype.forEach.call(internalImages, function(img) {
      img.setAttribute('src', '..' + img.getAttribute('src'));
    });
  }
};


/**
 * Based on ideas from: https://medium.com/@mariusc23/hide-header-on-scroll-down-show-on-scroll-up-67bbaae9a78c 
 * But minus the jQuery and the global stuff.
 */
class SapiensHabitatScrollDetector {
  constructor(scrollSensitiveElement) {
    this.scrollSensitiveElement = scrollSensitiveElement;
    try
    {
      this.scrollUpThresholdPixelsPerSecond = parseInt(this.scrollSensitiveElement.dataset.scrollUpThresholdPixelsPerSecond);
      this.scrollUpThresholdMilliseconds = parseInt(this.scrollSensitiveElement.dataset.scrollUpThresholdMilliseconds);
    }
    catch (e)
    {
      throw "data-scroll-up-threshold-threshold-delta attribute is missing.";
    }
    this.scrollSensitiveElement.onscroll = this.handleScrollEvent.bind(this);
    this.startedScrolling = null;
    this.startScrollTop = null;
    this.scrolledUp = false;
    setInterval(this.checkScrollPosition.bind(this), 200);
  }

  handleScrollEvent() {
    if (this.startedScrolling === null) {
      this.startedScrolling = Date.now();
      this.startScrollTop = this.getScrollTop();
    }
  }

  checkScrollPosition() {
    if (this.startedScrolling === null) {
      return;
    }

    var millisecondsElapsed = Date.now() - this.startedScrolling;
    if (millisecondsElapsed < this.scrollUpThresholdMilliseconds) {
      return;
    }

    var scrolledUpPx = this.startScrollTop - this.getScrollTop();
    if (scrolledUpPx < 0) {
      this.scrollSensitiveElement.classList.remove('scrolled-up');
    }

    var scrolledUpPerSecond = scrolledUpPx / millisecondsElapsed * 1000;
    if (scrolledUpPerSecond > this.scrollUpThresholdPixelsPerSecond) {
      this.scrollSensitiveElement.classList.add('scrolled-up');
    }

    this.startedScrolling = null;
    this.startScrollTop = null;
  }

  getScrollTop() {
    return window.pageYOffset || document.documentElement.scrollTop;
  }
};

var state;
document.addEventListener("DOMContentLoaded", function(event) {
  state = new SapiensHabitatEnhancements();
});

// vim: set expandtab shiftwidth=2 tabstop=2 softtabstop=2:
