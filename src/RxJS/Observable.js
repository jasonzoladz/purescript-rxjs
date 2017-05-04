/* global exports */
"use strict";

// module RxJS.Observable
var Rx = require('rxjs/Rx');


function removeEff(fn) {
  return function(a){
    return fn(a)()
  }
}

/**** Scheduling ****/

exports.observeOn_ = function(s){
  return function(obs){
    return obs.observeOn(s);
  };
}

exports.subscribeOn_ = function(s){
  return function(obs){
    return obs.subscribeOn(s);
  };
}

/**** Subscription ****/
exports.subscribe_ = function(sub){
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

exports.subscribeNext_ = function(eff){
  return function(obs){
    return function(){
      return obs.subscribe(
        function(val){ eff(val)() }
      );
    };
  };
}


/**** Creation Operators ****/

exports.ajax_ = function(req) {
  return function() {
    return Rx.Observable.ajax(req)
      .map(function(res){
        var body = res.responseText || JSON.stringify(res.response)
        return {body: body, status: res.status, responseType: res.responseType}
      })
  }
}

exports.ajaxWithBody_ = exports.ajax;

exports._empty_ = Rx.Observable.empty();

exports.fromArray_ = Rx.Observable.from;

exports.fromEventImpl_ = Rx.Observable.fromEvent;

exports.interval_ = Rx.Observable.interval;

exports.just_ = Rx.Observable.of;

exports.never_ = Rx.Observable.never();

exports.rangeImpl_ = Rx.Observable.range;

exports.throw_ = Rx.Observable.throw;

exports.timerImpl_ = Rx.Observable.timer;

/**** Transformation Operators ****/

exports.buffer_ = function(obs1){
  return function(obs2){
    return obs1.buffer(obs2);
  };
}

exports.bufferCount_ = function(maxSize){
  return function(startNewAt){
    return function(obs){
      return obs.bufferCount(maxSize, startNewAt);
    };
  };
}

exports.bufferTimeImpl_ = function(timespan, creationInterval, maxSize, obs){
  return obs.bufferTime(timespan, creationInterval, maxSize);
}

exports.bufferToggleImpl_ = function(obs, openings, closingSelector){
  return obs.bufferToggle(openings, closingSelector);
}

exports.bufferWhen_ = function(closing){
  return function(obs){
    return obs.bufferWhen(closing);
  };
}

exports.concatMap_ = function(f){
  return function(obs){
    return obs.concatMap(f);
  };
}

exports.exhaustMap_ = function(f){
  return function(obs){
    return obs.exhaustMap(f);
  };
}

exports.expand_ = function(f){
  return function(obs){
    return obs.expand(f);
  };
}

exports.share_ = function(obs){
  return obs.share()
}

exports.groupBy_ = function(f){
  return function(obs){
    return obs.groupBy(f);
  };
}

exports._map_ = function(f){
  return function(obs){
    return obs.map(f);
  };
}

exports.mapTo_ = function(val){
  return function(obs1){
    return obs1.mapTo(val);
  };
}

exports.mergeMap_ = function(obs){
  return function(f){
    return obs.mergeMap(f);
  };
}


exports.mergeMapTo_ = function(obs1){
  return function(obs2){
    return obs1.mergeMapTo(obs2);
  };
}

exports.pairwiseImpl_ = function(obs){
  return obs.pairwise();
}

exports.partitionImpl_ = function(pred){
  return function(obs){
    return obs.partition(pred);
  };
}

exports.scan_ = function(f) {
  return function(seed) {
    return function(ob) {
      return ob.scan(function(acc, value) {
        return f(value)(acc);
      }, seed);
    };
  };
}

exports.switchMap_ = function(f){
  return function(obs){
    return obs.switchMap(f);
  };
}

exports.switchMapTo_ = function(obs2){
  return function(obs1){
    return obs1.switchMapTo(obs2);
  };
}

exports.window_ = function(obs2){
  return function(obs1){
    return obs1.window(obs2);
  };
}

exports.windowCount_ = function(maxSize){
  return function(startNewAt){
    return function(obs){
      return obs.windowCount(maxSize, startNewAt);
    };
  };
}

exports.windowTime_ = function(timeSpan){
  return function(startNewAt){
    return function(obs){
      return obs.windowTime(timeSpan, startNewAt);
    };
  };
}



/**** Filtering Operators ****/

exports.audit_ = function(f){
  return function(obs){
    return obs.audit(f);
  };
}

exports.auditTime_ = function(ms){
  return function(obs){
    return obs.auditTime(ms);
  };
}

exports.debounce_ = function(f) {
  return function(ob) {
    return ob.debounce(f);
  };
}

exports.debounceTime_ = function(ms) {
  return function(obs){
    return obs.debounceTime(ms);
  };
}

exports.distinct_ = function(ob){
  return ob.distinct();
}

exports.distinctUntilChanged_ = function(ob){
  return ob.distinctUntilChanged();
}

exports.elementAt_ = function(i){
  return function(obs){
    return obs.elementAt(i);
  };
}

exports.filter_ = function(p){
  return function(ob){
    return ob.filter(p);
  };
}

exports.first_ = function(p){
  return function(ob){
    return ob.first(p);
  };
}

exports.ignoreElements_ = function(obs){
  return obs.ignoreElements();
}

exports.last_ = function(p){
  return function(ob){
    return ob.last(p);
  };
}

exports.sample_ = function(obs2){
  return function(obs1){
    return obs1.sample(obs2);
  };
}

exports.sampleTime_ = function(ms){
  return function(obs){
    return obs.sampleTime(ms);
  };
}

exports.skip_ = function(n){
  return function(obs){
    return obs.skip(n);
  };
}

exports.skipUntil_ = function(obs2){
  return function(obs1){
    return obs1.skipUntil(obs2);
  };
}

exports.skipWhile_ = function(p){
  return function(obs){
    return obs.skipWhile(p);
  };
}

exports.take_ = function(n) {
  return function(ob) {
    return ob.take(n);
  };
}

exports.takeUntil_ = function(other) {
  return function(ob) {
    return ob.takeUntil(other);
  };
}

exports.takeWhile_ = function(obs2){
  return function(obs1){
    return obs1.takeWhile(obs2);
  };
}

exports.throttle_ = function(f){
  return function(obs){
    return obs.throttle(f);
  };
}

exports.throttleTime_ = function(ms){
  return function(obs){
    return obs.throttleTime(ms);
  };
}

/**** Combination Operators ****/

exports.combineLatest_ = function(f) {
  return function(ob1) {
    return function(ob2) {
      return ob1.combineLatest(ob2, function (x, y) {
        return f(x)(y);
      });
    };
  };
}

exports.combineLatest3_ = function(f){
  return function(obs1){
    return function(obs2){
      return function(obs3){
        return obs1.combineLatest(obs2, obs3, function(x,y,z){
          return f(x)(y)(z);
        });
      };
    };
  };
}

exports.concat_ = function(obs1) {
  return function(obs2) {
    return obs1.concat(obs2);
  };
}

exports.concatAll_ = function(obsobs){
  return obsobs.concatAll();
}

exports.exhaust_ = function(obsobs){
  return obsobs.exhaust();
}

exports.merge_ = function(ob) {
  return function(other) {
    return ob.merge(other);
  };
}

exports.mergeAll_ = function(obsobs){
  return obsobs.mergeAll();
}

exports.race_ = function(arrOfObs){
  return Rx.Observable.race.apply(this, arrOfObs);
}

exports.startWith_ = function(start) {
  return function(ob) {
    return ob.startWith(start);
  };
}

exports.withLatestFrom_ = function(f) {
  return function (ob2) {
    return function (ob1) {
      return ob1.withLatestFrom(ob2, function(x, y) {
        return f(x)(y);
      })
    };
  };
}

exports.zip_ = function(arrOfObs){
  return Rx.Observable.zip.apply(this, arrOfObs);
}

/**** Error Handling Operators ****/

exports.catch_ = function(obs){
  return function(f){
    return obs.catch(f);
  };
}

exports.retry_ = function(nTimes){
  return function(obs){
    return obs.retry(nTimes);
  };
}


/**** Utility Operators ****/

exports.delay_ = function(ms){
  return function(ob){
    return ob.delay(ms);
  };
}

exports.delayWhen_ = function(f){
  return function(obs1){
    return obs1.delayWhen(f);
  };
}

exports.materializeImpl = function(ob, Next, Error, Complete) {
  return ob.materialize().map(function(x) {
    switch (x.kind) {
      case 'N': return Next(x.value);
      case 'E': return Error(x.error);
      case 'C': return Complete;
    }
  });
}

exports.create_ = function(subscriberToEff) {
  return function() {
    return Rx.Observable.create(subscriberToObserverFn(subscriberToEff))
  }
}

function subscriberToObserverFn(subscriberFn){
  return removeEff(function(observer){
    var subscriber = observerToSubscriber(observer)
    return subscriberFn(subscriber)
  })
}

function observerToSubscriber(observer){
  return {
    next: function(a){
      return function(){observer.next(a)}
    },
    error: function(e){
      return function(){observer.error(e)}
    },
    completed: function(){
      return function(){observer.completed()}
    }

  }
}

exports.dematerialize_ = function(ob) {
  return ob.map(function(a) {
    switch (a.constructor.name) {
      case "OnNext": return Rx.Notification.createNext(a.value0);
      case "OnError": return Rx.Notification.createError(a.value0);
      case "OnComplete": return Rx.Notification.createComplete();
    }
  }).dematerialize();
}


exports.toArray_ = function(obs){
  return obs.toArray();
}

/**** Conditional and Boolean Operators ****/

exports.defaultIfEmpty_ = function(val){
  return function(obs){
    return obs.defaultIfEmpty(val);
  };
}

exports.every_ = function(pred){
  return function(obs){
    return obs.every(pred);
  };
}

exports.isEmpty_ = function(obs){
  return obs.isEmpty();
}

/**** Aggregate Operators ****/

exports.count_ = function(obs){
  return obs.count();
}


exports.reduce_ = function(f){
  return function(seed){
    return function(ob){
      return ob.reduce(function (x, y) {
        return f(x)(y);
      }, seed);
    };
  };
}


/**** Helpers ****/

exports.unwrap_ = function(obs) {
  return function() {
    return obs.map(function(eff) {
      return eff();
    });
  };
}
