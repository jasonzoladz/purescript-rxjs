/* global exports */
"use strict";

// module RxJS.Scheduler

var Rx = require('rxjs');

exports.queue = Rx.Scheduler.queue;
exports.asap = Rx.Scheduler.asap;
exports.async = Rx.Scheduler.async;
exports.animationFrame = Rx.Scheduler.animationFrame;
