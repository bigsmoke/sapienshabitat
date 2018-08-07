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
  }

  initializeScrollDetection() {
    var scrollSensitiveContainers = document.getElementsByClassName('js-scroll-up-detection-with-threshold');
    Array.prototype.forEach.call(scrollSensitiveContainers, function(container) {
      new SapiensHabitatScrollDetector(container);
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
      if (link.getAttribute('href') == '/') {
        var file_href = '../index/page.html5';
      } else {
        var file_href = '..' + link.getAttribute('href') + 'page.html5';
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
