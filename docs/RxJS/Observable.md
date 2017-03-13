## Module RxJS.Observable

#### `Observable`

``` purescript
data Observable :: Type -> Type
```

*Note*: A couple operators are not wrapped (namely, `bindCallback`, `bindNodeCallback`) because RxJS
implementation details prevent giving the operators an "honest" PureScript type.
However, such operators are replaced easily using `Aff` with the `AsyncSubject` module.
Please see [RxJS Version 5.* documentation](http://reactivex.io/rxjs/) for
additional details on proper usage of the library.

##### Instances
``` purescript
Monoid (Observable a)
Functor Observable
Apply Observable
Applicative Observable
Bind Observable
Monad Observable
Semigroup (Observable a)
Alt Observable
Plus Observable
Alternative Observable
MonadZero Observable
MonadPlus Observable
MonadError Error Observable
(Arbitrary a) => Arbitrary (Observable a)
```

#### `observeOn`

``` purescript
observeOn :: forall a. Scheduler -> Observable a -> Observable a
```

Makes every `next` call run in the new Scheduler.

#### `subscribeOn`

``` purescript
subscribeOn :: forall a. Scheduler -> Observable a -> Observable a
```

Makes subscription happen on a given Scheduler.

#### `subscribe`

``` purescript
subscribe :: forall a e. Subscriber a -> Observable a -> Eff e Subscription
```

Subscribing to an Observable is like calling a function, providing
`next`, `error` and `completed` effects to which the data will be delivered.

#### `subscribeNext`

``` purescript
subscribeNext :: forall a e. (a -> Eff e Unit) -> Observable a -> Eff e Subscription
```

#### `Response`

``` purescript
type Response = { body :: String, status :: Int, responseType :: String }
```

#### `Request`

``` purescript
type Request = { url :: String, "data" :: String, timeout :: Int, headers :: StrMap String, crossDomain :: Boolean, responseType :: String, method :: String }
```

#### `ajax`

``` purescript
ajax :: forall e. String -> Eff e (Observable Response)
```

#### `ajaxWithBody`

``` purescript
ajaxWithBody :: forall e. Request -> Eff e (Observable Response)
```

#### `fromArray`

``` purescript
fromArray :: forall a. Array a -> Observable a
```

Creates an Observable from an Array.
<img width="640" height="315" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/from.png" alt="" />

#### `fromEvent`

``` purescript
fromEvent :: forall e. EventTarget -> EventType -> Eff e (Observable Event)
```

Creates an Observable that emits events of the specified type coming from the given event target.

#### `interval`

``` purescript
interval :: Int -> Observable Int
```

Returns an Observable that emits an infinite sequence of ascending
integers, with a constant interval of time of your choosing between those
emissions.
<img width="640" height="195" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/interval.png" alt="" />

#### `just`

``` purescript
just :: forall a. a -> Observable a
```

Creates an Observable that emits the value specify,
and then emits a complete notification.  An alias for `of`.
<img width="640" height="315" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/from.png" alt="" />

#### `never`

``` purescript
never :: forall a. Observable a
```

Creates an Observable that emits no items.  Subscriptions it must be
disposed manually.
<img width="640" height="185" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/never.png" alt="" />

#### `range`

``` purescript
range :: Int -> Int -> Observable Int
```

The range operator emits a range of sequential integers, in order, where
you select the start of the range and its length
<img src="http://reactivex.io/rxjs/img/range.png" width="640" height="195">

#### `throw`

``` purescript
throw :: forall a. Error -> Observable a
```

Creates an Observable that immediately sends an error notification.

#### `timer`

``` purescript
timer :: Int -> Int -> Observable Int
```

Creates an Observable that, upon subscription, emits and infinite sequence of ascending integers,
after a specified delay, every specified period.  Delay and period are in
milliseconds.
<img width="640" height="200" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/timer.png" alt="" />

#### `buffer`

``` purescript
buffer :: forall a b. Observable a -> Observable b -> Observable (Array a)
```

Collects values from the first Observable into an Array, and emits that array only when
second Observable emits.
<img src="http://reactivex.io/documentation/operators/images/buffer1.png"  width="640" height="315">

#### `bufferCount`

``` purescript
bufferCount :: forall a. Int -> Int -> Observable a -> Observable (Array a)
```

Collects values from the past as an array, emits that array when
its size (arg1) reaches the specified buffer size, and starts a new buffer.
The new buffer starts with nth (arg2) element of the Observable counting
from the beginning of the *last* buffer.
<img src="http://reactivex.io/documentation/operators/images/buffer1.png"  width="640" height="315">

#### `bufferToggle`

``` purescript
bufferToggle :: forall a b c. (Observable a) -> (Observable b) -> (b -> Observable c) -> (Observable (Array a))
```

Collects values from the source Observable (arg1) as an array. Starts collecting only when
the opening (arg2) Observable emits, and calls the closingSelector function (arg3) to get an Observable
that decides when to close the buffer.  Another buffer opens when the
opening Observable emits its next value.
<img src="http://reactivex.io/documentation/operators/images/buffer2.png"  width="640" height="315">

#### `bufferWhen`

``` purescript
bufferWhen :: forall a b. Observable a -> (a -> Observable b) -> Observable (Array a)
```

Collects values from the past as an array. When it starts collecting values,
it calls a function that returns an Observable that emits to close the
buffer and restart collecting.
<img src="http://reactivex.io/documentation/operators/images/buffer1.png"  width="640" height="315">

#### `concatMap`

``` purescript
concatMap :: forall a b. Observable a -> (a -> Observable b) -> Observable b
```

Equivalent to mergeMap (a.k.a, `>>=`) EXCEPT that, unlike mergeMap,
the next bind will not run until the Observable generated by the projection function (arg2)
completes.  That is, composition is sequential, not concurrent.
Warning: if source values arrive endlessly and faster than their corresponding
inner Observables can complete, it will result in memory issues as inner
Observables amass in an unbounded buffer waiting for their turn to be subscribed to.
<img width="640" height="305" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/concatMap.png" alt="" />

#### `concatMapTo`

``` purescript
concatMapTo :: forall a b c. Observable a -> Observable b -> (a -> b -> Observable c) -> Observable c
```

The type signature explains it best.  Warning: Like `concatMap`, composition is sequential.
<img width="640" height="305" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/concatMap.png" alt="" />

#### `exhaustMap`

``` purescript
exhaustMap :: forall a b. Observable a -> (a -> Observable b) -> Observable b
```

It's Like concatMap (a.k.a, `>>=`) EXCEPT that it ignores every new projected
Observable if the previous projected Observable has not yet completed.
<img width="640" height="310" src="http://reactivex.io/rxjs/img/exhaustMap.png" alt="" />

#### `expand`

``` purescript
expand :: forall a. Observable a -> (a -> Observable a) -> Observable a
```

It's similar to mergeMap, but applies the projection function to every source
value as well as every output value. It's recursive.

#### `groupBy`

``` purescript
groupBy :: forall a b. (a -> b) -> Observable a -> Observable (Observable a)
```

Groups the items emitted by an Observable (arg2) according to the value
returned by the grouping function (arg1).  Each group becomes its own
Observable.
<img width="640" height="360" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/groupBy.png" alt="" />

#### `mapTo`

``` purescript
mapTo :: forall a b. b -> Observable a -> Observable b
```

Emits the given constant value on the output Observable every time
the source Observable emits a value.
img width="640" height="305" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/map.png" alt="" />

#### `mergeMap`

``` purescript
mergeMap :: forall a b. Observable a -> (a -> Observable b) -> Observable b
```

Maps each value to an Observable, then flattens all of these Observables
using mergeAll.  It's just monadic `bind`.
<img width="640" height="380" src="http://reactivex.io/documentation/operators/images/flatMap.c.png" alt="" />

#### `mergeMapTo`

``` purescript
mergeMapTo :: forall a b. Observable a -> Observable b -> Observable b
```

Maps each value of the Observable (arg1) to the same inner Observable (arg2),
then flattens the result.
 <img width="640" height="380" src="http://reactivex.io/documentation/operators/images/flatMap.c.png" alt="" />

#### `pairwise`

``` purescript
pairwise :: forall a. Observable a -> Observable (Array a)
```

Puts the current value and previous value together as an array, and emits that.
<img width="640" height="510" src="http://reactivex.io/rxjs/img/pairwise.png" alt="" />

#### `partition`

``` purescript
partition :: forall a. (a -> Boolean) -> Observable a -> Array (Observable a)
```

Given a predicate function (arg1), and an Observable (arg2), it outputs a
two element array of partitioned values
(i.e., [ Observable valuesThatPassPredicate, Observable valuesThatFailPredicate ]).
<img width="640" height="325" src="http://reactivex.io/rxjs/img/partition.png" alt="" />

#### `scan`

``` purescript
scan :: forall a b. (a -> b -> b) -> b -> Observable a -> Observable b
```

Given an accumulator function (arg1), an initial value (arg2), and
a source Observable (arg3), it returns an Observable that emits the current
accumlation whenever the source emits a value.
<img width="640" height="320" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/scanSeed.png" alt="" />

#### `switchMap`

``` purescript
switchMap :: forall a b. Observable a -> (a -> Observable b) -> Observable b
```

Projects each source value to an Observable which is merged in the output
Observable, emitting values only from the most recently projected Observable.
<img width="640" height="350" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/switchMap.png" alt="" />

#### `switchMapTo`

``` purescript
switchMapTo :: forall a b. Observable a -> Observable b -> Observable b
```

It's like switchMap, but maps each value to the same inner Observable.
<img width="640" height="350" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/switchMap.png" alt="" />

#### `window`

``` purescript
window :: forall a b. Observable a -> Observable b -> Observable (Observable a)
```

It's like buffer, but emits a nested Observable instead of an array.
<img width="640" height="475" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/window8.png" alt="" />

#### `windowCount`

``` purescript
windowCount :: forall a. Int -> Int -> Observable a -> Observable (Observable a)
```

It's like bufferCount, but emits a nested Observable instead of an array.

#### `windowTime`

``` purescript
windowTime :: forall a. Int -> Int -> Observable a -> Observable (Observable a)
```

It's like bufferTime, but emits a nested Observable instead of an array,
and it doesn't take a maximum size parameter.  arg1 is how long to
buffer items into a new Observable, arg2 is the when the next buffer should begin,
and arg3 is the source Observable.

#### `windowToggle`

``` purescript
windowToggle :: forall a b c. (Observable a) -> (Observable b) -> (b -> Observable c) -> (Observable (Array a))
```

It's like bufferToggle, but emits a nested Observable instead of an array.

#### `windowWhen`

``` purescript
windowWhen :: forall a b. Observable a -> Observable b -> Observable (Observable a)
```

It's like bufferWhen, but emits a nested Observable instead of an array.

#### `audit`

``` purescript
audit :: forall a b. Observable a -> (a -> Observable b) -> Observable a
```

It's like auditTime, but the silencing duration is determined by a second Observable.
<img src="http://reactivex.io/rxjs/img/audit.png"  width="640" height="315">

#### `auditTime`

``` purescript
auditTime :: forall a. Int -> Observable a -> Observable a
```

Ignores source values for duration milliseconds,
then emits the most recent value from the source Observable, then repeats this process.
<img src="http://reactivex.io/rxjs/img/auditTime.png"  width="640" height="315">

#### `debounce`

``` purescript
debounce :: forall a. Observable a -> (a -> Observable Int) -> Observable a
```

It's like debounceTime, but the time span of emission silence is determined
by a second Observable.  Allows for a variable debounce rate.
<img width="640" height="425" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/debounce.f.png" alt="" />

#### `debounceTime`

``` purescript
debounceTime :: forall a. Int -> Observable a -> Observable a
```

It's like delay, but passes only the most recent value from each burst of emissions.

#### `distinct`

``` purescript
distinct :: forall a. Observable a -> Observable a
```

Returns an Observable that emits all items emitted by the source Observable
that are distinct by comparison from previous items.
<img width="640" height="310" src="http://reactivex.io/documentation/operators/images/distinct.png" alt="" />

#### `distinctUntilChanged`

``` purescript
distinctUntilChanged :: forall a. Observable a -> Observable a
```

Returns an Observable that emits all items emitted by the source Observable
that are distinct by comparison from the previous item.
<img width="640" height="310" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/distinctUntilChanged.key.png" alt="" />

#### `elementAt`

``` purescript
elementAt :: forall a. Observable a -> Int -> Observable a
```

Emits the single value at the specified index in a sequence of emissions
from the source Observable.

#### `filter`

``` purescript
filter :: forall a. (a -> Boolean) -> Observable a -> Observable a
```

Filter items emitted by the source Observable by only emitting those that
satisfy a specified predicate.
<img width="640" height="310" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/filter.png" alt="" />

#### `ignoreElements`

``` purescript
ignoreElements :: forall a. Observable a -> Observable a
```

Ignores all items emitted by the source Observable and only passes calls of complete or error.
<img width="640" height="310" src="http://reactivex.io/rxjs/img/ignoreElements.png" alt="" />

#### `last`

``` purescript
last :: forall a. Observable a -> (a -> Boolean) -> Observable a
```

Returns an Observable that emits only the last item emitted by the source
Observable that that satisfies the given predicate.
<img width="640" height="305" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/last.png" alt="" />

#### `sample`

``` purescript
sample :: forall a b. Observable a -> Observable b -> Observable a
```

It's like sampleTime, but samples whenever the notifier Observable emits something.
<img width="640" height="305" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/sample.o.png" alt="" />

#### `sampleTime`

``` purescript
sampleTime :: forall a. Int -> Observable a -> Observable a
```

Periodically looks at the source Observable and emits whichever
value it has most recently emitted since the previous sampling, unless the source has not emitted anything since the previous sampling.

#### `skip`

``` purescript
skip :: forall a. Int -> Observable a -> Observable a
```

Returns an Observable that skips n items emitted by an Observable.
<img width="640" height="305" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/skip.png" alt="" />

#### `skipUntil`

``` purescript
skipUntil :: forall a b. Observable a -> Observable b -> Observable a
```

Returns an Observable that skips items emitted by the source Observable until a second Observable emits an item.
<img width="640" height="375" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/skipUntil.png" alt="" />

#### `skipWhile`

``` purescript
skipWhile :: forall a. (a -> Boolean) -> Observable a -> Observable a
```

Returns an Observable that skips all items emitted
by the source Observable as long as a specified condition holds true,
but emits all further source items as soon as the condition becomes false.
<img width="640" height="305" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/skipWhile.png" alt="" />

#### `take`

``` purescript
take :: forall a. Int -> Observable a -> Observable a
```

Emits only the first n values emitted by the source Observable.
<img width="640" height="305" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/take.png" alt="" />

#### `takeUntil`

``` purescript
takeUntil :: forall a b. Observable a -> Observable b -> Observable a
```

Lets values pass until a second Observable emits something. Then, it completes.
<img width="640" height="380" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/takeUntil.png" alt=""

#### `takeWhile`

``` purescript
takeWhile :: forall a. (a -> Boolean) -> Observable a -> Observable a
```

Emits values emitted by the source Observable so long as each value satisfies
the given predicate, and then completes as soon as this predicate is not satisfied.

#### `throttle`

``` purescript
throttle :: forall a b. Observable a -> (a -> Observable b) -> Observable a
```

It's like throttleTime, but the silencing duration is determined by a second Observable.
<img src="http://reactivex.io/rxjs/img/throttle.png" width="640" height="195">

#### `throttleTime`

``` purescript
throttleTime :: forall a. Int -> Observable a -> Observable a
```

Emits a value from the source Observable, then ignores subsequent source values
for duration milliseconds, then repeats this process.
<img width="640" height="305" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/throttleWithTimeout.png" alt="" />

#### `combineLatest`

``` purescript
combineLatest :: forall a b c. (a -> b -> c) -> Observable a -> Observable b -> Observable c
```

An Observable of projected values from the most recent values from each input Observable.
<img width="640" height="410" src="http://reactivex.io/documentation/operators/images/combineLatest.png" alt="" />

#### `combineLatest3`

``` purescript
combineLatest3 :: forall a b c d. (a -> b -> c -> d) -> Observable a -> Observable b -> Observable c -> Observable d
```

#### `concat`

``` purescript
concat :: forall a. Observable a -> Observable a -> Observable a
```

Concatenates two Observables together by sequentially emitting their values, one Observable after the other.
<img width="640" height="380" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/concat.png" alt="" />

#### `concatAll`

``` purescript
concatAll :: forall a. Observable (Observable a) -> Observable a
```

Converts a higher-order Observable into a first-order Observable by concatenating the inner Observables in order.
<img width="640" height="380" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/concat.png" alt="" />

#### `exhaust`

``` purescript
exhaust :: forall a. Observable (Observable a) -> Observable a
```

Flattens an Observable-of-Observables by dropping the next inner Observables
while the current inner is still executing.
<img width="640" height="310" src="http://reactivex.io/rxjs/img/exhaust.png" alt="" />

#### `merge`

``` purescript
merge :: forall a. Observable a -> Observable a -> Observable a
```

Creates an output Observable which concurrently emits all values from each input Observable.
<img width="640" height="380" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/merge.png" alt="" />

#### `mergeAll`

``` purescript
mergeAll :: forall a. Observable (Observable a) -> Observable a
```

Converts a higher-order Observable into a first-order Observable
which concurrently delivers all values that are emitted on the inner Observables.
<img width="640" height="380" src="http://reactivex.io/documentation/operators/images/mergeAll.png" alt="" />

#### `race`

``` purescript
race :: forall a. Array (Observable a) -> Observable a
```

Returns an Observable that mirrors the first source Observable to emit an
item from the array of Observables.

#### `startWithMany`

``` purescript
startWithMany :: forall f a. Foldable f => f a -> Observable a -> Observable a
```

Returns an Observable that emits the items in the given Foldable before
it begins to emit items emitted by the source Observable.

#### `startWith`

``` purescript
startWith :: forall a. a -> Observable a -> Observable a
```

Returns an Observable that emits the item given before
it begins to emit items emitted by the source Observable.
<img width="640" height="315" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/startWith.png" alt="" />

#### `withLatestFrom`

``` purescript
withLatestFrom :: forall a b c. (a -> b -> c) -> Observable a -> Observable b -> Observable c
```

Combines each value from the source Observables using a project function to
determine the value to be emitted on the output Observable.
<img width="640" height="380" src="https://raw.github.com/wiki/ReactiveX/RxJava/images/rx-operators/withLatestFrom.png" alt="">

#### `zip`

``` purescript
zip :: forall a. Array (Observable a) -> Observable (Array a)
```

Waits for each Observable to emit a value. Once this occurs, all values
with the corresponding index will be emitted. This will continue until at
least one inner observable completes.
<img width="640" height="380" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/zip.i.png" alt="" />

#### `catch`

``` purescript
catch :: forall a. (Observable a) -> (Error -> Observable a) -> (Observable a)
```

<img width="640" height="310" src="http://reactivex.io/documentation/operators/images/catch.js.png" alt="" />

#### `retry`

``` purescript
retry :: forall a. Int -> Observable a -> Observable a
```

If the source Observable calls error, this method will resubscribe to the
source Observable n times rather than propagating the error call.
<img width="640" height="315" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/retry.png" alt="" />

#### `delay`

``` purescript
delay :: forall a. Int -> Observable a -> Observable a
```

Time shifts each item by some specified amount of milliseconds.
<img width="640" height="310" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/delay.png" alt="" />

#### `delayWhen`

``` purescript
delayWhen :: forall a b. Observable a -> (a -> Observable b) -> Observable a
```

Delays the emission of items from the source Observable by a given time
span determined by the emissions of another Observable.
<img width="640" height="450" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/delay.o.png" alt="" />

#### `dematerialize`

``` purescript
dematerialize :: forall a. Observable (Notification a) -> Observable a
```

Returns an Observable that reverses the effect of `materialize` by
`Notification` objects emitted by the source Observable into the items
or notifications they represent.
<img width="640" height="335" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/dematerialize.png" alt="" />

#### `materialize`

``` purescript
materialize :: forall a. Observable a -> Observable (Notification a)
```

Turns all of the notifications from a source Observable into onNext emissions,
and marks them with their original notification types within `Notification` objects.
<img width="640" height="315" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/materialize.png" alt="" />

#### `performEach`

``` purescript
performEach :: forall a e. Observable a -> (a -> Eff e Unit) -> Eff e (Observable a)
```

Performs the effect on each value of the Observable.  An alias for `do`.
Useful for testing (transparently performing an effect outside of a subscription).

#### `toArray`

``` purescript
toArray :: forall a. Observable a -> Observable (Array a)
```

Returns an Observable that emits a single item, a list composed of all the items emitted by the source Observable.
<img width="640" height="305" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/toList.png" alt="" />

#### `defaultIfEmpty`

``` purescript
defaultIfEmpty :: forall a. Observable a -> a -> Observable a
```

Returns an Observable that emits the items emitted by the source Observable or a specified default item
if the source Observable is empty.

<img width="640" height="305" src="http://reactivex.io/documentation/operators/images/defaultIfEmpty.c.png" alt="" />

takes a defaultValue which is the item to emit if the source Observable emits no items.

returns an Observable that emits either the specified default item if the source Observable emits no
        items, or the items emitted by the source Observable

#### `every`

``` purescript
every :: forall a. Observable a -> (a -> Boolean) -> Observable Boolean
```

Determines whether all elements of an observable sequence satisfy a condition.
Returns an observable sequence containing a single element determining whether all
elements in the source sequence pass the test in the specified predicate.

#### `isEmpty`

``` purescript
isEmpty :: forall a. Observable a -> Observable Boolean
```

Tests whether this `Observable` emits no elements.

returns an Observable emitting one single Boolean, which is `true` if this `Observable`
        emits no elements, and `false` otherwise.

#### `share`

``` purescript
share :: forall a. Observable a -> Observable a
```

Returns a new Observable that multicasts (shares) the original Observable. As long a
there is more than 1 Subscriber, this Observable will be subscribed and emitting data.
When all subscribers have unsubscribed it will unsubscribe from the source Observable.

This is an alias for `publish().refCount()`

<img width="640" height="510" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/publishRefCount.png" alt="" />

returns an Observable that upon connection causes the source Observable to emit items to its Subscribers

#### `first`

``` purescript
first :: forall a. Observable a -> (a -> Boolean) -> Observable a
```

Returns an Observable that emits only the first item emitted by the source
Observable that satisfies the given predicate.

#### `count`

``` purescript
count :: forall a. Observable a -> Observable Int
```

Counts the number of emissions on the source and emits that number when the source completes.

#### `reduce`

``` purescript
reduce :: forall a b. (a -> b -> b) -> b -> Observable a -> Observable b
```

Applies an accumulator function over the source Observable, and returns the accumulated
result when the source completes, given a seed value.

#### `unwrap`

``` purescript
unwrap :: forall a e. Observable (Eff e a) -> Eff e (Observable a)
```

Run an Observable of effects


