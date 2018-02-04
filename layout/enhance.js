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
    var scrollSensitiveContainers = document.getElementsByClassName('scroll-up-detection-with-threshold');
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
      this.scrollUpThresholdDelta = this.scrollSensitiveElement.dataset["scroll-up-threshold-delta"];
    }
    catch (e)
    {
      throw "data-scroll-up-threshold-threshold-delta attribute is missing.";
    }
    this.scrollSensitiveElement.onscroll = this.handleScrollEvent.bind(this);
    this.scrolledRecently = false;
    setInterval(this.resetScrollState.bind(this), 250);
  }

  /**
   * For optimization purposes, handleScrollEvent() just sets a boolean,
   * which is then checked by resetScrollState().
   */
  handleScrollEvent() {
    this.scrolledRecently = true;
  }

  resetScrollState() {
    if (this.scrolledRecently) {
      this.hasScrolled();
      this.scrolledRecently = false;
    }
  }

  hasScrolled() {
    var scrollTop  = window.pageYOffset || document.documentElement.scrollTop
    if (Math.abs(this.lastScrollTop - scrollTop) < this.scrollUpThresholdDelta) {
      // Don't do anything if we're below the threshold;
      // tiny movements shouldn't trigger the scroll-up behaviour.
      return; 
    }
    if (scrollTop > this.lastScrollTop) {
      this.scrollSensitiveElement.classList.remove('scrolled-up');
    }
    else {
      this.scrollSensitiveElement.classList.add('scrolled-up');
    }
    this.lastScrollTop = scrollTop;
  }
};

var state;
document.addEventListener("DOMContentLoaded", function(event) {
  state = new SapiensHabitatEnhancements();
});

// vim: set expandtab shiftwidth=2 tabstop=2 softtabstop=2:
