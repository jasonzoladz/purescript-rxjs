/* global exports */
"use strict";

// module RxJS.ReplaySubject

var Rx = require('rxjs');

/**** Scheduling ****/

exports.observeOn = function(s){
  return function(obs){
    return obs.observeOn(s);
  };
}

exports.subscribeOn = function(s){
  return function(obs){
    return obs.subscribeOn(s);
  };
}

/**** Subscription ****/

exports.subscribe = function(sub){
  return function(obs) {
    return function(){
      return obs.subscribe(
        function(val){ sub.next(val)();},
        function(err){ sub.error(err)();},
        function(){sub.complete()();}
        );
    };
  };
}

exports.subscribeNext = function (eff){
  return function(obs){
    return function(){
      obs.subscribe(
        function(val){return eff(val)();}
      );
    };
  };
}

/**** Creation Operator ****/

exports._empty = function (){
  return new Rx.ReplaySubject();
}

exports.just = function(val){
  return new Rx.ReplaySubject(val);
}

/**** ReplaySubject Operators ****/

exports.asObservable = function(rs){
  return bs.asObservable();
}

exports.next = function(val){
  return function(rs){
    return function(){
      rs.next(val);
    };
  };
}


/**** Transformation Operators ****/

exports.buffer = function(obs1){
  return function(obs2){
    return obs1.buffer(obs2);
  };
}

exports.bufferCount = function(maxSize){
  return function(startNewAt){
    return function(obs){
      return obs.bufferCount(maxSize, startNewAt);
    };
  };
}

exports.bufferTimeImpl = function(timespan, creationInterval, maxSize, obs){
  return obs.bufferTime(timespan, creationInterval, maxSize);
}

exports.bufferToggleImpl = function(obs, openings, closingSelector){
  return obs.bufferToggle(openings, closingSelector);
}

exports.bufferWhen = function(obs){
  return function(closing){
    return obs.bufferWhen(closing);
  };
}

exports.concatMap = function(obs){
  return function(f){
    return obs.concatMap(f);
  };
}

exports.concatMapTo = function(obs1){
  return function(obs2){
    return function(f){
      return obs1.concatMapTo(obs2, function(a, b){
        return f(a)(b);
      });
    };
  };
}

exports.exhaustMap = function(obs){
  return function(f){
    return obs.exhaustMap(f);
  };
}

exports.expand = function(obs){
  return function(f){
    return obs.expand(f);
  };
}

exports.groupBy = function(f){
  return function(obs){
    return obs.groupBy(f);
  };
}

exports._map = function(f){
  return function(obs){
    return obs.map(f);
  };
}

exports.mapTo = function(val){
  return function(obs1){
    return obs1.mapTo(val);
  };
}

exports.mergeMap = function(obs){
  return function(f){
    return obs.mergeMap(f);
  };
}


exports.mergeMapTo = function(obs1){
  return function(obs2){
    return obs1.mergeMapTo(obs2);
  };
}

exports.pairwise = function(obs){
  return obs.pairwise();
}

exports.partition = function(pred){
  return function(obs){
    return obs.partition(pred);
  };
}

exports.scan = function scan(f) {
  return function(seed) {
    return function(ob) {
      return ob.scan(function(acc, value) {
        return f(value)(acc);
      }, seed);
    };
  };
}

exports.switchMap = function(obs){
  return function(f){
    return obs.switchMap(f);
  };
}

exports.switchMapTo = function(obs1){
  return function(obs2){
    return obs1.switchMapTo(obs2);
  };
}

exports.window = function(obs1){
  return function(obs2){
    return obs1.window(obs2);
  };
}

exports.windowCount = function(maxSize){
  return function(startNewAt){
    return function(obs){
      return obs.windowCount(maxSize, startNewAt);
    };
  };
}

exports.windowTime = function(timeSpan){
  return function(startNewAt){
    return function(obs){
      return obs.windowTime(timeSpan, startNewAt);
    };
  };
}

exports.windowToggleImpl = function(obs, openings, closingSelector){
  return obs.windowToggle(openings, closingSelector);
}

exports.windowWhen = function(obs){
  return function(closing){
    return obs.windowWhen(closing);
  };
}

/**** Filtering Operators ****/

exports.audit = function(obs){
  return function(f){
    return obs.audit(f);
  };
}

exports.auditTime = function(ms){
  return function(obs){
    return obs.auditTime(ms);
  };
}

exports.debounce = function (ob) {
  return function(f) {
    return ob.debounce(f);
  };
}

exports.debounceTime = function(ms) {
  return function(obs){
    return obs.debounceTime(ms);
  };
}

exports.distinct = function (ob){
  return ob.distinct();
}

exports.distinctUntilChanged = function (ob){
  return ob.distinctUntilChanged();
}

exports.elementAt = function(obs){
  return function(i){
    return obs.elementAt(i);
  };
}

exports.filter = function (p){
  return function(ob){
    return ob.filter(p);
  };
}

exports.first = function (p){
  return function(ob){
    return ob.first(p);
  };
}

exports.ignoreElements = function(obs){
  return obs.ignoreElements();
}

exports.last = function (ob){
    return ob.last();
}

exports.sample = function(obs1){
  return function(obs2){
    return obs1.sample(obs2);
  };
}

exports.sampleTime = function(ms){
  return function(obs){
    return obs.sampleTime(ms);
  };
}

exports.skip = function(n){
  return function(obs){
    return obs.skip(n);
  };
}

exports.skipUntil = function(obs1){
  return function(obs2){
    return obs1.skipUntil(obs2);
  };
}

exports.skipWhile = function (p){
  return function(obs){
    return obs.skipWhile(p);
  };
}

exports.take = function (n) {
  return function(ob) {
    return ob.take(n);
  };
}

exports.takeUntil = function (other) {
  return function(ob) {
    return ob.takeUntil(other);
  };
}

exports.takeWhile = function (p){
  return function(obs){
    return obs.takeWhile(p);
  };
}

exports.throttle = function(obs){
  return function(f){
    return obs.throttle(f);
  };
}

exports.throttleTime = function(obs){
  return function(ms){
    return obs.throttleTime(ms);
  };
}

/**** Combination Operators ****/

exports.combineLatest = function (f) {
  return function(ob1) {
    return function(ob2) {
      return ob1.combineLatest(ob2, function (x, y) {
        return f(x)(y);
      });
    };
  };
}

exports.concat = function (obs1) {
  return function(obs2) {
    return obs1.concat(obs1);
  };
}

exports.concatAll = function (obsobs){
  return obsobs.concatAll();
}

exports.exhaust = function (obsobs){
  return obsobs.exhaust();
}

exports.merge = function (ob) {
  return function(other) {
    return ob.merge(other);
  };
}

exports.mergeAll = function (obsobs){
  return obsobs.mergeAll();
}

exports.race = function(arrOfObs){
  return Rx.ReplaySubject.race.apply(this, arrOfObs);
}

exports.startWith = function (start) {
  return function(ob) {
    return ob.startWith(start);
  };
}


exports.withLatestFrom = function (f) {
  return function (ob1) {
    return function (ob2) {
      return ob1.withLatestFrom(ob2, function(x, y) {
        return f(x)(y);
      })
    };
  };
}

exports.zip = function(arrOfObs){
  return Rx.ReplaySubject.zip.apply(this, arrOfObs);
}

/**** Error Handling Operators ****/

exports.catch = function(obs){
  return function(f){
    return obs.catch(f);
  };
}

exports.retry = function(nTimes){
  return function(obs){
    return obs.retry(nTimes);
  };
}


/**** Utility Operators ****/

exports.delay = function (ms){
  return function(ob){
    return ob.delay(ms);
  };
}

exports.delayWhen = function(obs1){
  return function(f){
    return obs1.delayWhen(f);
  };
}

exports._materialize = function (ob, Next, Error, Complete) {
  return ob.materialize().map(function(x) {
    switch (x.kind) {
      case 'N': return Next(x.value);
      case 'E': return Error(x.error);
      case 'C': return Complete;
    }
  });
}

exports.dematerialize = function (ob) {
  return ob.map(function(a) {
    switch (a.constructor.name) {
      case "OnNext": return Rx.Notification.createNext(a.value0);
      case "OnError": return Rx.Notification.createError(a.value0);
      case "OnComplete": return Rx.Notification.createComplete();
    }
  }).dematerialize();
}

exports.performEach = function(obs){
  return function(f){
    return function(){
      return obs.do(function(val){
        f(val)();
      });
    };
  };
}

exports.scheduleOn = function(obs){
  return function(scheduler){
    return obs.scheduleOn(scheduler);
  };
}
exports.toArray = function(obs){
  return obs.toArray();
}

/**** Conditional and Boolean Operators ****/

exports.defaultIfEmpty = function(obs){
  return function(val){
    return obs.defaultIfEmpty(val);
  };
}

exports.every = function(pred){
  return function(obs){
    return obs.every(pred);
  };
}

exports.isEmpty = function(obs){
  return obs.isEmpty();
}

/**** Aggregate Operators ****/

exports.count = function(obs){
  return obs.count();
}


exports.reduce = function (f){
  return function(seed){
    return function(ob){
      return ob.reduce(function (x, y) {
        return f(x)(y);
      }, seed);
    };
  };
}

/**** Helpers ****/

exports.unwrap = function (obs) {
  return function() {
    return obs.map(function(eff) {
      return eff();
    });
  };
}
