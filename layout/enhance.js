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
  }

  initializeScrollDetection() {
    var scrollSensitiveContainers = document.getElementsByClassName('scroll-up-detection-with-threshold');
    Array.prototype.forEach.call(scrollSensitiveContainers, function(container) {
      new SapiensHabitatScrollDetector(container);
    })
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
