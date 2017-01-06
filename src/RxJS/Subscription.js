/* global exports */
"use strict";

// module RxJS.Subscription

var Rx = require('rxjs');

exports.unsubscribe = function(sub){
  return function(){
    sub.unsubscribe();
  };
}
