/* global exports */
"use strict";

// module RxJS.Scheduler

var Rx = require('rxjs');

exports.queue = Rx.Scheduler.queue;
exports.asap = Rx.Scheduler.asap;
exports.async = Rx.Scheduler.async;
exports.animationFrame = Rx.Scheduler.animationFrame;


// exports.queue = function(){
//   return Rx.Scheduler.queue;
// }
//
// exports.asap = function(){
//   return Rx.Scheduler.asap;
// }
//
// exports.async = function(){
//   return Rx.Scheduler.async;
// }
//
// exports.animationFrame = function(){
//   return Rx.Scheduler.animationFrame;
// }
