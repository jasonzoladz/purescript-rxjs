module RxJS.BehaviorSubject
  ( BehaviorSubject()
  , observeOn
  , subscribeOn
  , subscribe
  , subscribeNext
  , just
  , next
  , send
  , asObservable
  , getValue
  , buffer
  , bufferCount
  , bufferToggle
  , bufferWhen
  , concatMap
  , concatMapTo
  , exhaustMap
  , expand
  , groupBy
  , mapTo
  , mergeMap
  , mergeMapTo
  , pairwise
  , partition
  , scan
  , switchMap
  , switchMapTo
  , window
  , windowCount
  , windowTime
  , windowToggle
  , windowWhen
  , audit
  , auditTime
  , debounce
  , debounceTime
  , distinct
  , distinctUntilChanged
  , elementAt
  , filter
  , ignoreElements
  , last
  , sample
  , sampleTime
  , skip
  , skipUntil
  , skipWhile
  , take
  , takeUntil
  , takeWhile
  , throttle
  , throttleTime
  , combineLatest
  , concat
  , concatAll
  , exhaust
  , merge
  , mergeAll
  , race
  , startWith
  , withLatestFrom
  , zip
  , catch
  , retry
  , delay
  , delayWhen
  , dematerialize
  , materialize
  , performEach
  , toArray
  , count
  ) where

import RxJS.Scheduler (Scheduler)
import Control.Alt (class Alt)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (Error)
import Data.Function.Uncurried (Fn3, Fn4, runFn3, runFn4)
import Prelude (class Semigroup, class Monad, class Bind, class Applicative, class Apply, class Functor, Unit, id)
import RxJS.Notification (Notification(OnComplete, OnError, OnNext))
import RxJS.Observable (Observable)
import RxJS.Subscriber (Subscriber)
import RxJS.Subscription (Subscription)

-- | Please see [RxJS Version 5.* documentation](http://reactivex.io/rxjs/) for
-- | additional details on proper usage of the library.

foreign import data BehaviorSubject :: Type -> Type

instance functorBehaviorSubject :: Functor BehaviorSubject where
  map = _map

instance applyBehaviorSubject :: Apply BehaviorSubject where
  apply = combineLatest id

instance applicativeBehaviorSubject :: Applicative BehaviorSubject where
  pure = just

instance bindBehaviorSubject :: Bind BehaviorSubject where
  bind = mergeMap

instance monadBehaviorSubject :: Monad BehaviorSubject

-- | NOTE: The semigroup instance uses `merge` NOT `concat`.
instance semigroupBehaviorSubject :: Semigroup (BehaviorSubject a) where
  append = merge

instance altBehaviorSubject :: Alt BehaviorSubject where
  alt = merge

-- Scheduling

-- | Makes every `next` call run in the new Scheduler.
foreign import observeOn :: forall a. Scheduler -> BehaviorSubject a -> BehaviorSubject a

-- | Makes subscription happen on a given Scheduler.
foreign import subscribeOn :: forall a. Scheduler -> BehaviorSubject a -> BehaviorSubject a


-- Subscription

-- | Subscribing to an BehaviorSubject is like calling a function, providing
-- | `next`, `error` and `completed` effects to which the data will be delivered.
foreign import subscribe :: forall a e. Subscriber a -> BehaviorSubject a ->  Eff (|e) Subscription

foreign import subscribeObservableTo :: forall a e. Observable a -> BehaviorSubject a -> Eff (|e) Subscription

-- Subscribe to an BehaviorSubject, supplying only the `next` function.
foreign import subscribeNext
  :: forall a e. (a -> Eff (|e) Unit)
  -> BehaviorSubject a
  -> Eff (|e) Subscription


-- Creation Operator

-- | Creates an BehaviorSubject that emits the value specify,
-- | and then emits a complete notification.  An alias for `of`.
foreign import just :: forall a. a -> BehaviorSubject a

-- BehaviorSubject Operators

-- | Send a new value to a BehaviorSubject
foreign import next :: forall a e. a -> BehaviorSubject a -> Eff e Unit

-- | An alias for next
send :: forall a e. a -> BehaviorSubject a -> Eff e Unit
send = next

-- | Create an Observable from a BehaviorSubject
foreign import asObservable :: forall a. BehaviorSubject a -> Observable a

-- | Obtain the current value of a BehaviorSubject
foreign import getValue :: forall a e. BehaviorSubject a -> Eff e a

-- Transformation Operators

-- | Collects values from the first BehaviorSubject into an Array, and emits that array only when
-- | second BehaviorSubject emits.
foreign import buffer :: forall a b. BehaviorSubject a -> BehaviorSubject b -> BehaviorSubject (Array a)

-- | Collects values from the past as an array, emits that array when
-- | its size (arg1) reaches the specified buffer size, and starts a new buffer.
-- | The new buffer starts with nth (arg2) element of the BehaviorSubject counting
-- | from the beginning of the *last* buffer.
foreign import bufferCount :: forall a. Int -> Int -> BehaviorSubject a -> BehaviorSubject (Array a)

-- | Collects values from the past as an array, and emits those arrays
-- | periodically in time.  The first argument is how long to fill the buffer.
-- | The second argument is specifies when to open the next buffer following an
-- | emission.  The third argument is the maximum size of any buffer.
bufferTime :: forall a. Int -> Int -> Int -> (BehaviorSubject a) -> (BehaviorSubject (Array a))
bufferTime = runFn4 bufferTimeImpl

foreign import bufferTimeImpl :: forall a. Fn4 Int Int Int (BehaviorSubject a) (BehaviorSubject (Array a))

-- | Collects values from the source BehaviorSubject (arg1) as an array. Starts collecting only when
-- | the opening (arg2) BehaviorSubject emits, and calls the closingSelector function (arg3) to get an BehaviorSubject
-- | that decides when to close the buffer.  Another buffer opens when the
-- | opening BehaviorSubject emits its next value.
bufferToggle
  :: forall a b c. (BehaviorSubject a)
  -> (BehaviorSubject b)
  -> (b -> BehaviorSubject c)
  -> (BehaviorSubject (Array a))
bufferToggle = runFn3 bufferToggleImpl


foreign import bufferToggleImpl
  :: forall a b c. Fn3 (BehaviorSubject a) (BehaviorSubject b) (b -> BehaviorSubject c) (BehaviorSubject (Array a))

-- | Collects values from the past as an array. When it starts collecting values,
-- | it calls a function that returns an BehaviorSubject that emits to close the
-- | buffer and restart collecting.
foreign import bufferWhen :: forall a b. BehaviorSubject a -> (a -> BehaviorSubject b) -> BehaviorSubject (Array a)

-- | Equivalent to mergeMap (a.k.a, `>>=`) EXCEPT that, unlike mergeMap,
-- | the next bind will not run until the BehaviorSubject generated by the projection function (arg2)
-- | completes.  That is, composition is sequential, not concurrent.
-- | Warning: if source values arrive endlessly and faster than their corresponding
-- | inner BehaviorSubjects can complete, it will result in memory issues as inner
-- | BehaviorSubjects amass in an unbounded buffer waiting for their turn to be subscribed to.
foreign import concatMap :: forall a b. BehaviorSubject a -> (a -> BehaviorSubject b) -> BehaviorSubject b

-- | The type signature explains it best.  Warning: Like `concatMap`, composition is sequential.
foreign import concatMapTo
  :: forall a b c. BehaviorSubject a -> BehaviorSubject b -> (a -> b -> BehaviorSubject c) -> BehaviorSubject c

-- | It's Like concatMap (a.k.a, `>>=`) EXCEPT that it ignores every new projected
-- | BehaviorSubject if the previous projected BehaviorSubject has not yet completed.
foreign import exhaustMap :: forall a b. BehaviorSubject a -> (a -> BehaviorSubject b) -> BehaviorSubject b

-- | It's similar to mergeMap, but applies the projection function to every source
-- | value as well as every output value. It's recursive.
foreign import expand :: forall a. BehaviorSubject a -> (a -> BehaviorSubject a) -> BehaviorSubject a

-- | Groups the items emitted by an BehaviorSubject (arg2) according to the value
-- | returned by the grouping function (arg1).  Each group becomes its own
-- | BehaviorSubject.
foreign import groupBy :: forall a b. (a -> b) -> BehaviorSubject a -> BehaviorSubject (BehaviorSubject a)

foreign import _map :: forall a b. (a -> b) -> BehaviorSubject a -> BehaviorSubject b

-- | Emits the given constant value on the output BehaviorSubject every time
-- | the source BehaviorSubject emits a value.
foreign import mapTo :: forall a b. b -> BehaviorSubject a -> BehaviorSubject b

-- | Maps each value to an BehaviorSubject, then flattens all of these BehaviorSubjects
-- | using mergeAll.  It's just monadic `bind`.
foreign import mergeMap :: forall a b. BehaviorSubject a -> (a -> BehaviorSubject b) -> BehaviorSubject b

-- | Maps each value of the BehaviorSubject (arg1) to the same inner BehaviorSubject (arg2),
-- | then flattens the result.
foreign import mergeMapTo :: forall a b. BehaviorSubject a -> BehaviorSubject b -> BehaviorSubject b

-- | Puts the current value and previous value together as an array, and emits that.
foreign import pairwise :: forall a. BehaviorSubject a -> BehaviorSubject (Array a)

-- | Given a predicate function (arg1), and an BehaviorSubject (arg2), it outputs a
-- | two element array of partitioned values
-- | (i.e., [ BehaviorSubject valuesThatPassPredicate, BehaviorSubject valuesThatFailPredicate ]).
foreign import partition :: forall a. (a -> Boolean) -> BehaviorSubject a -> Array (BehaviorSubject a)

-- | Given an accumulator function (arg1), an initial value (arg2), and
-- | a source BehaviorSubject (arg3), it returns an BehaviorSubject that emits the current
-- | accumlation whenever the source emits a value.
foreign import scan :: forall a b. (a -> b -> b) -> b -> BehaviorSubject a -> BehaviorSubject b

-- | Projects each source value to an BehaviorSubject which is merged in the output
-- | BehaviorSubject, emitting values only from the most recently projected BehaviorSubject.
foreign import switchMap :: forall a b. BehaviorSubject a -> (a -> BehaviorSubject b) -> BehaviorSubject b

-- | It's like switchMap, but maps each value to the same inner BehaviorSubject.
foreign import switchMapTo :: forall a b. BehaviorSubject a -> BehaviorSubject b -> BehaviorSubject b

-- | It's like buffer, but emits a nested BehaviorSubject instead of an array.
foreign import window :: forall a b. BehaviorSubject a -> BehaviorSubject b -> BehaviorSubject (BehaviorSubject a)

-- | It's like bufferCount, but emits a nested BehaviorSubject instead of an array.
foreign import windowCount :: forall a. Int -> Int -> BehaviorSubject a -> BehaviorSubject (BehaviorSubject a)

-- | It's like bufferTime, but emits a nested BehaviorSubject instead of an array,
-- | and it doesn't take a maximum size parameter.  arg1 is how long to
-- | buffer items into a new BehaviorSubject, arg2 is the when the next buffer should begin,
-- | and arg3 is the source BehaviorSubject.
foreign import windowTime :: forall a. Int -> Int -> BehaviorSubject a -> BehaviorSubject (BehaviorSubject a)

-- | It's like bufferToggle, but emits a nested BehaviorSubject instead of an array.
windowToggle
  :: forall a b c. (BehaviorSubject a)
  -> (BehaviorSubject b)
  -> (b -> BehaviorSubject c)
  -> (BehaviorSubject (Array a))
windowToggle = runFn3 windowToggleImpl

foreign import windowToggleImpl
  :: forall a b c. Fn3 (BehaviorSubject a) (BehaviorSubject b) (b -> BehaviorSubject c) (BehaviorSubject (Array a))

-- | It's like bufferWhen, but emits a nested BehaviorSubject instead of an array.
foreign import windowWhen :: forall a b. BehaviorSubject a -> BehaviorSubject b -> BehaviorSubject (BehaviorSubject a)

-- Filtering Operators

-- | It's like auditTime, but the silencing duration is determined by a second BehaviorSubject.
foreign import audit :: forall a b. BehaviorSubject a -> (a -> BehaviorSubject b) -> BehaviorSubject a

-- | Ignores source values for duration milliseconds,
-- | then emits the most recent value from the source BehaviorSubject, then repeats this process.
foreign import auditTime :: forall a. Int -> BehaviorSubject a -> BehaviorSubject a

-- | It's like debounceTime, but the time span of emission silence is determined
-- | by a second BehaviorSubject.  Allows for a variable debounce rate.
foreign import debounce :: forall a. BehaviorSubject a -> (a -> BehaviorSubject Int) -> BehaviorSubject a

-- | It's like delay, but passes only the most recent value from each burst of emissions.
foreign import debounceTime :: forall a. Int -> BehaviorSubject a -> BehaviorSubject a

-- | Returns an BehaviorSubject that emits all items emitted by the source BehaviorSubject
-- | that are distinct by comparison from previous items.
foreign import distinct :: forall a. BehaviorSubject a -> BehaviorSubject a

-- | Returns an BehaviorSubject that emits all items emitted by the source BehaviorSubject
-- | that are distinct by comparison from the previous item.
foreign import distinctUntilChanged :: forall a. BehaviorSubject a -> BehaviorSubject a

-- | Emits the single value at the specified index in a sequence of emissions
-- | from the source BehaviorSubject.
foreign import elementAt :: forall a. BehaviorSubject a -> Int -> BehaviorSubject a

-- | Filter items emitted by the source BehaviorSubject by only emitting those that
-- | satisfy a specified predicate.
foreign import filter :: forall a. (a -> Boolean) -> BehaviorSubject a -> BehaviorSubject a

-- | Ignores all items emitted by the source BehaviorSubject and only passes calls of complete or error.
foreign import ignoreElements :: forall a. BehaviorSubject a -> BehaviorSubject a

-- | Returns an BehaviorSubject that emits only the last item emitted by the source BehaviorSubject.
foreign import last :: forall a. BehaviorSubject a -> BehaviorSubject a

-- | It's like sampleTime, but samples whenever the notifier BehaviorSubject emits something.
foreign import sample :: forall a b. BehaviorSubject a -> BehaviorSubject b -> BehaviorSubject a

-- | Periodically looks at the source BehaviorSubject and emits whichever
-- | value it has most recently emitted since the previous sampling, unless the source has not emitted anything since the previous sampling.
foreign import sampleTime :: forall a. Int -> BehaviorSubject a -> BehaviorSubject a

-- | Returns an BehaviorSubject that skips n items emitted by an BehaviorSubject.
foreign import skip :: forall a. Int -> BehaviorSubject a -> BehaviorSubject a

-- | Returns an BehaviorSubject that skips items emitted by the source BehaviorSubject until a second BehaviorSubject emits an item.
foreign import skipUntil :: forall a b. BehaviorSubject a -> BehaviorSubject b -> BehaviorSubject a

-- | Returns an BehaviorSubject that skips all items emitted
-- | by the source BehaviorSubject as long as a specified condition holds true,
-- | but emits all further source items as soon as the condition becomes false.
foreign import skipWhile :: forall a. (a -> Boolean) -> BehaviorSubject a -> BehaviorSubject a

-- | Emits only the first n values emitted by the source BehaviorSubject.
foreign import take :: forall a. Int -> BehaviorSubject a -> BehaviorSubject a

-- | Lets values pass until a second BehaviorSubject emits something. Then, it completes.
foreign import takeUntil :: forall a b. BehaviorSubject a -> BehaviorSubject b -> BehaviorSubject a

-- | Emits values emitted by the source BehaviorSubject so long as each value satisfies
-- | the given predicate, and then completes as soon as this predicate is not satisfied.
foreign import takeWhile :: forall a. (a -> Boolean) -> BehaviorSubject a -> BehaviorSubject a

-- | It's like throttleTime, but the silencing duration is determined by a second BehaviorSubject.
foreign import throttle :: forall a b. BehaviorSubject a -> (a -> BehaviorSubject b) -> BehaviorSubject a

-- | Emits a value from the source BehaviorSubject, then ignores subsequent source values
-- | for duration milliseconds, then repeats this process.
foreign import throttleTime :: forall a. Int -> BehaviorSubject a -> BehaviorSubject a


-- Combination Operators

-- | An BehaviorSubject of projected values from the most recent values from each input BehaviorSubject.
foreign import combineLatest
  :: forall a b c. (a -> b -> c) -> BehaviorSubject a -> BehaviorSubject b -> BehaviorSubject c

-- | Concatenates two BehaviorSubjects together by sequentially emitting their values, one BehaviorSubject after the other.
foreign import concat :: forall a. BehaviorSubject a -> BehaviorSubject a -> BehaviorSubject a

-- | Converts a higher-order BehaviorSubject into a first-order BehaviorSubject by concatenating the inner BehaviorSubjects in order.
foreign import concatAll :: forall a. BehaviorSubject (BehaviorSubject a) -> BehaviorSubject a

-- | Flattens an BehaviorSubject-of-BehaviorSubjects by dropping the next inner BehaviorSubjects
-- | while the current inner is still executing.
foreign import exhaust :: forall a. BehaviorSubject (BehaviorSubject a) -> BehaviorSubject a

-- | Creates an output BehaviorSubject which concurrently emits all values from each input BehaviorSubject.
foreign import merge :: forall a. BehaviorSubject a -> BehaviorSubject a -> BehaviorSubject a

-- | Converts a higher-order BehaviorSubject into a first-order BehaviorSubject
-- | which concurrently delivers all values that are emitted on the inner BehaviorSubjects.
foreign import mergeAll :: forall a. BehaviorSubject (BehaviorSubject a) -> BehaviorSubject a

-- | Returns an BehaviorSubject that mirrors the first source BehaviorSubject to emit an
-- | item from the array of BehaviorSubjects.
foreign import race :: forall a. Array (BehaviorSubject a) -> BehaviorSubject a

-- | Returns an BehaviorSubject that emits the items in the given Array before
-- | it begins to emit items emitted by the source BehaviorSubject.
foreign import startWith :: forall a. Array a -> BehaviorSubject a -> BehaviorSubject a

-- | Combines each value from the source BehaviorSubjects using a project function to
-- | determine the value to be emitted on the output BehaviorSubject.
foreign import withLatestFrom
  :: forall a b c. (a -> b -> c) -> BehaviorSubject a -> BehaviorSubject b -> BehaviorSubject c

-- | Waits for each BehaviorSubject to emit a value. Once this occurs, all values
-- | with the corresponding index will be emitted. This will continue until at
-- | least one inner BehaviorSubject completes.
foreign import zip :: forall a. Array (BehaviorSubject a) -> BehaviorSubject (Array a)

-- Error Handling Operators

foreign import catch :: forall a. (BehaviorSubject a) -> (Error -> BehaviorSubject a) -> (BehaviorSubject a)

-- | If the source BehaviorSubject calls error, this method will resubscribe to the
-- | source BehaviorSubject n times rather than propagating the error call.
foreign import retry :: forall a. Int -> BehaviorSubject a -> BehaviorSubject a

-- Utility Operators

-- | Time shifts each item by some specified amount of milliseconds.
foreign import delay :: forall a. Int -> BehaviorSubject a -> BehaviorSubject a

-- | Delays the emission of items from the source BehaviorSubject by a given time
-- | span determined by the emissions of another BehaviorSubject.
foreign import delayWhen :: forall a b. BehaviorSubject a -> (a -> BehaviorSubject b) -> BehaviorSubject a

foreign import dematerialize :: forall a. BehaviorSubject (Notification a) -> BehaviorSubject a

foreign import _materialize
  :: forall a.
     Fn4
     (BehaviorSubject a)
     (a -> Notification a)
     (Error -> Notification a)
     (Notification a)
     (BehaviorSubject (Notification a))

materialize :: forall a. BehaviorSubject a -> BehaviorSubject (Notification a)
materialize ob = runFn4 _materialize ob OnNext OnError OnComplete
-- | Performs the effect on each value of the BehaviorSubject.  An alias for `do`.
-- | Useful for testing (transparently performing an effect outside of a subscription).

foreign import performEach :: forall a e. BehaviorSubject a -> (a -> Eff (|e) Unit) -> Eff (|e) (BehaviorSubject a)

foreign import toArray :: forall a. BehaviorSubject a -> BehaviorSubject (Array a)

-- | Returns a BehaviorSubject that emits the items emitted by the source BehaviorSubject or a specified default item
-- | if the source BehaviorSubject is empty.
-- |
-- | ![marble diagram](http://reactivex.io/documentation/operators/images/defaultIfEmpty.c.png)
-- |
-- | takes a defaultValue which is the item to emit if the source BehaviorSubject emits no items.
-- |
-- | returns a BehaviorSubject that emits either the specified default item if the source BehaviorSubject emits no
-- |         items, or the items emitted by the source BehaviorSubject
foreign import defaultIfEmpty :: forall a. BehaviorSubject a -> a -> BehaviorSubject a

-- | Determines whether all elements of a BehaviorSubject satisfy a condition.
-- | Returns a BehaviorSubject containing a single element determining whether all
-- | elements in the source BehaviorSubject pass the test in the specified predicate.
foreign import every :: forall a. BehaviorSubject a -> (a -> Boolean) -> BehaviorSubject Boolean

-- | Tests whether this `BehaviorSubject` emits no elements.
-- |
-- | returns a BehaviorSubject emitting one single Boolean, which is `true` if this `BehaviorSubject`
-- |         emits no elements, and `false` otherwise.
foreign import isEmpty :: forall a. BehaviorSubject a -> BehaviorSubject Boolean

-- | Returns a BehaviorSubject that emits only the first item emitted by the source
-- | BehaviorSubject that satisfies the given predicate.
foreign import first :: forall a. BehaviorSubject a -> (a -> Boolean) -> BehaviorSubject a


-- Aggregate Operators

-- | Counts the number of emissions on the source and emits that number when the source completes.
foreign import count :: forall a. BehaviorSubject a -> BehaviorSubject Int

-- | Applies an accumulator function over the source, and returns the accumulated
-- | result when the source completes, given a seed value.
foreign import reduce :: forall a b. (a -> b -> b) -> b -> BehaviorSubject a -> BehaviorSubject b

-- Helper Functions

  -- | Run a source's effects
foreign import unwrap :: forall a e. BehaviorSubject (Eff e a) -> Eff e (BehaviorSubject a)
