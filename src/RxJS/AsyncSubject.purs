module RxJS.AsyncSubject
  ( AsyncSubject(..)
  , observeOn
  , subscribeOn
  , subscribe
  , subscribeNext
  , just
  , asObservable
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

import RxJS.Scheduler
import Control.Alt (class Alt)
import Control.Alternative (class Alternative)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (Error)
import Control.MonadPlus (class MonadPlus)
import Control.MonadZero (class MonadZero)
import Control.Plus (class Plus)
import Data.Function.Uncurried (Fn3, Fn4, runFn3, runFn4)
import Prelude (class Semigroup, class Monad, class Bind, class Applicative, class Apply, class Functor, Unit, id, unit)
import RxJS.Notification (Notification(OnComplete, OnError, OnNext))
import RxJS.Observable (Observable)
import RxJS.Subscriber (Subscriber)
import RxJS.Subscription (Subscription)

-- | Please see [RxJS Version 5.* documentation](http://reactivex.io/rxjs/) for
-- | additional details on proper usage of the library.


foreign import data AsyncSubject :: * -> *

instance functorAsyncSubject :: Functor AsyncSubject where
  map = _map

instance applyAsyncSubject :: Apply AsyncSubject where
  apply = combineLatest id

instance applicativeAsyncSubject :: Applicative AsyncSubject where
  pure = just

instance bindAsyncSubject :: Bind AsyncSubject where
  bind = mergeMap

instance monadAsyncSubject :: Monad AsyncSubject

-- | NOTE: The semigroup instance uses `merge` NOT `concat`.
instance semigroupAsyncSubject :: Semigroup (AsyncSubject a) where
  append = merge

instance altAsyncSubject :: Alt AsyncSubject where
  alt = merge

instance plusAsyncSubject :: Plus AsyncSubject where
  empty = _empty unit

instance alternativeAsyncSubject :: Alternative AsyncSubject

instance monadZeroAsyncSubject :: MonadZero AsyncSubject

instance monadPlusAsyncSubject :: MonadPlus AsyncSubject

-- Scheduling

-- | Makes every `next` call run in the new Scheduler.
foreign import observeOn :: forall a. Scheduler -> AsyncSubject a -> AsyncSubject a

-- | Makes subscription happen on a given Scheduler.
foreign import subscribeOn :: forall a. Scheduler -> AsyncSubject a -> AsyncSubject a

-- Subscription

-- | Subscribing to an AsyncSubject is like calling a function, providing
-- | `next`, `error` and `completed` effects to which the data will be delivered.
foreign import subscribe :: forall a e. Subscriber a -> AsyncSubject a ->  Eff (|e) Subscription

foreign import subscribeObservableTo :: forall a e. Observable a -> AsyncSubject a -> Eff (|e) Subscription

-- Subscribe to an AsyncSubject, supplying only the `next` function.
foreign import subscribeNext
  :: forall a e. (a -> Eff (|e) Unit)
  -> AsyncSubject a
  -> Eff (|e) Subscription


-- Creation Operators

foreign import _empty :: forall a. Unit -> AsyncSubject a

-- | Creates an AsyncSubject that emits the value specify,
-- | and then emits a complete notification.  An alias for `of`.
foreign import just :: forall a. a -> AsyncSubject a

-- AsyncSubject Operators

-- | Create an Observable from a AsyncSubject
foreign import asObservable :: forall a. AsyncSubject a -> Observable a


-- Transformation Operators

-- | Collects values from the first AsyncSubject into an Array, and emits that array only when
-- | second AsyncSubject emits.
foreign import buffer :: forall a b. AsyncSubject a -> AsyncSubject b -> AsyncSubject (Array a)

-- | Collects values from the past as an array, emits that array when
-- | its size (arg1) reaches the specified buffer size, and starts a new buffer.
-- | The new buffer starts with nth (arg2) element of the AsyncSubject counting
-- | from the beginning of the *last* buffer.
foreign import bufferCount :: forall a. Int -> Int -> AsyncSubject a -> AsyncSubject (Array a)

-- | Collects values from the past as an array, and emits those arrays
-- | periodically in time.  The first argument is how long to fill the buffer.
-- | The second argument is specifies when to open the next buffer following an
-- | emission.  The third argument is the maximum size of any buffer.
bufferTime :: forall a. Int -> Int -> Int -> (AsyncSubject a) -> (AsyncSubject (Array a))
bufferTime = runFn4 bufferTimeImpl

foreign import bufferTimeImpl :: forall a. Fn4 Int Int Int (AsyncSubject a) (AsyncSubject (Array a))

-- | Collects values from the source AsyncSubject (arg1) as an array. Starts collecting only when
-- | the opening (arg2) AsyncSubject emits, and calls the closingSelector function (arg3) to get an AsyncSubject
-- | that decides when to close the buffer.  Another buffer opens when the
-- | opening AsyncSubject emits its next value.
bufferToggle
  :: forall a b c. (AsyncSubject a)
  -> (AsyncSubject b)
  -> (b -> AsyncSubject c)
  -> (AsyncSubject (Array a))
bufferToggle = runFn3 bufferToggleImpl


foreign import bufferToggleImpl
  :: forall a b c. Fn3 (AsyncSubject a) (AsyncSubject b) (b -> AsyncSubject c) (AsyncSubject (Array a))

-- | Collects values from the past as an array. When it starts collecting values,
-- | it calls a function that returns an AsyncSubject that emits to close the
-- | buffer and restart collecting.
foreign import bufferWhen :: forall a b. AsyncSubject a -> (a -> AsyncSubject b) -> AsyncSubject (Array a)

-- | Equivalent to mergeMap (a.k.a, `>>=`) EXCEPT that, unlike mergeMap,
-- | the next bind will not run until the AsyncSubject generated by the projection function (arg2)
-- | completes.  That is, composition is sequential, not concurrent.
-- | Warning: if source values arrive endlessly and faster than their corresponding
-- | inner AsyncSubjects can complete, it will result in memory issues as inner
-- | AsyncSubjects amass in an unbounded buffer waiting for their turn to be subscribed to.
foreign import concatMap :: forall a b. AsyncSubject a -> (a -> AsyncSubject b) -> AsyncSubject b

-- | The type signature explains it best.  Warning: Like `concatMap`, composition is sequential.
foreign import concatMapTo
  :: forall a b c. AsyncSubject a -> AsyncSubject b -> (a -> b -> AsyncSubject c) -> AsyncSubject c

-- | It's Like concatMap (a.k.a, `>>=`) EXCEPT that it ignores every new projected
-- | AsyncSubject if the previous projected AsyncSubject has not yet completed.
foreign import exhaustMap :: forall a b. AsyncSubject a -> (a -> AsyncSubject b) -> AsyncSubject b

-- | It's similar to mergeMap, but applies the projection function to every source
-- | value as well as every output value. It's recursive.
foreign import expand :: forall a. AsyncSubject a -> (a -> AsyncSubject a) -> AsyncSubject a

-- | Groups the items emitted by an AsyncSubject (arg2) according to the value
-- | returned by the grouping function (arg1).  Each group becomes its own
-- | AsyncSubject.
foreign import groupBy :: forall a b. (a -> b) -> AsyncSubject a -> AsyncSubject (AsyncSubject a)

foreign import _map :: forall a b. (a -> b) -> AsyncSubject a -> AsyncSubject b

-- | Emits the given constant value on the output AsyncSubject every time
-- | the source AsyncSubject emits a value.
foreign import mapTo :: forall a b. b -> AsyncSubject a -> AsyncSubject b

-- | Maps each value to an AsyncSubject, then flattens all of these AsyncSubjects
-- | using mergeAll.  It's just monadic `bind`.
foreign import mergeMap :: forall a b. AsyncSubject a -> (a -> AsyncSubject b) -> AsyncSubject b

-- | Maps each value of the AsyncSubject (arg1) to the same inner AsyncSubject (arg2),
-- | then flattens the result.
foreign import mergeMapTo :: forall a b. AsyncSubject a -> AsyncSubject b -> AsyncSubject b

-- | Puts the current value and previous value together as an array, and emits that.
foreign import pairwise :: forall a. AsyncSubject a -> AsyncSubject (Array a)

-- | Given a predicate function (arg1), and an AsyncSubject (arg2), it outputs a
-- | two element array of partitioned values
-- | (i.e., [ AsyncSubject valuesThatPassPredicate, AsyncSubject valuesThatFailPredicate ]).
foreign import partition :: forall a. (a -> Boolean) -> AsyncSubject a -> Array (AsyncSubject a)

-- | Given an accumulator function (arg1), an initial value (arg2), and
-- | a source AsyncSubject (arg3), it returns an AsyncSubject that emits the current
-- | accumlation whenever the source emits a value.
foreign import scan :: forall a b. (a -> b -> b) -> b -> AsyncSubject a -> AsyncSubject b

-- | Projects each source value to an AsyncSubject which is merged in the output
-- | AsyncSubject, emitting values only from the most recently projected AsyncSubject.
foreign import switchMap :: forall a b. AsyncSubject a -> (a -> AsyncSubject b) -> AsyncSubject b

-- | It's like switchMap, but maps each value to the same inner AsyncSubject.
foreign import switchMapTo :: forall a b. AsyncSubject a -> AsyncSubject b -> AsyncSubject b

-- | It's like buffer, but emits a nested AsyncSubject instead of an array.
foreign import window :: forall a b. AsyncSubject a -> AsyncSubject b -> AsyncSubject (AsyncSubject a)

-- | It's like bufferCount, but emits a nested AsyncSubject instead of an array.
foreign import windowCount :: forall a. Int -> Int -> AsyncSubject a -> AsyncSubject (AsyncSubject a)

-- | It's like bufferTime, but emits a nested AsyncSubject instead of an array,
-- | and it doesn't take a maximum size parameter.  arg1 is how long to
-- | buffer items into a new AsyncSubject, arg2 is the when the next buffer should begin,
-- | and arg3 is the source AsyncSubject.
foreign import windowTime :: forall a. Int -> Int -> AsyncSubject a -> AsyncSubject (AsyncSubject a)

-- | It's like bufferToggle, but emits a nested AsyncSubject instead of an array.
windowToggle
  :: forall a b c. (AsyncSubject a)
  -> (AsyncSubject b)
  -> (b -> AsyncSubject c)
  -> (AsyncSubject (Array a))
windowToggle = runFn3 windowToggleImpl

foreign import windowToggleImpl
  :: forall a b c. Fn3 (AsyncSubject a) (AsyncSubject b) (b -> AsyncSubject c) (AsyncSubject (Array a))

-- | It's like bufferWhen, but emits a nested AsyncSubject instead of an array.
foreign import windowWhen :: forall a b. AsyncSubject a -> AsyncSubject b -> AsyncSubject (AsyncSubject a)

-- Filtering Operators

-- | It's like auditTime, but the silencing duration is determined by a second AsyncSubject.
foreign import audit :: forall a b. AsyncSubject a -> (a -> AsyncSubject b) -> AsyncSubject a

-- | Ignores source values for duration milliseconds,
-- | then emits the most recent value from the source AsyncSubject, then repeats this process.
foreign import auditTime :: forall a. Int -> AsyncSubject a -> AsyncSubject a

-- | It's like debounceTime, but the time span of emission silence is determined
-- | by a second AsyncSubject.  Allows for a variable debounce rate.
foreign import debounce :: forall a. AsyncSubject a -> (a -> AsyncSubject Int) -> AsyncSubject a

-- | It's like delay, but passes only the most recent value from each burst of emissions.
foreign import debounceTime :: forall a. Int -> AsyncSubject a -> AsyncSubject a

-- | Returns an AsyncSubject that emits all items emitted by the source AsyncSubject
-- | that are distinct by comparison from previous items.
foreign import distinct :: forall a. AsyncSubject a -> AsyncSubject a

-- | Returns an AsyncSubject that emits all items emitted by the source AsyncSubject
-- | that are distinct by comparison from the previous item.
foreign import distinctUntilChanged :: forall a. AsyncSubject a -> AsyncSubject a

-- | Emits the single value at the specified index in a sequence of emissions
-- | from the source AsyncSubject.
foreign import elementAt :: forall a. AsyncSubject a -> Int -> AsyncSubject a

-- | Filter items emitted by the source AsyncSubject by only emitting those that
-- | satisfy a specified predicate.
foreign import filter :: forall a. (a -> Boolean) -> AsyncSubject a -> AsyncSubject a

-- | Ignores all items emitted by the source AsyncSubject and only passes calls of complete or error.
foreign import ignoreElements :: forall a. AsyncSubject a -> AsyncSubject a

-- | Returns an AsyncSubject that emits only the last item emitted by the source AsyncSubject.
foreign import last :: forall a. AsyncSubject a -> AsyncSubject a

-- | It's like sampleTime, but samples whenever the notifier AsyncSubject emits something.
foreign import sample :: forall a b. AsyncSubject a -> AsyncSubject b -> AsyncSubject a

-- | Periodically looks at the source AsyncSubject and emits whichever
-- | value it has most recently emitted since the previous sampling, unless the source has not emitted anything since the previous sampling.
foreign import sampleTime :: forall a. Int -> AsyncSubject a -> AsyncSubject a

-- | Returns an AsyncSubject that skips n items emitted by an AsyncSubject.
foreign import skip :: forall a. Int -> AsyncSubject a -> AsyncSubject a

-- | Returns an AsyncSubject that skips items emitted by the source AsyncSubject until a second AsyncSubject emits an item.
foreign import skipUntil :: forall a b. AsyncSubject a -> AsyncSubject b -> AsyncSubject a

-- | Returns an AsyncSubject that skips all items emitted
-- | by the source AsyncSubject as long as a specified condition holds true,
-- | but emits all further source items as soon as the condition becomes false.
foreign import skipWhile :: forall a. (a -> Boolean) -> AsyncSubject a -> AsyncSubject a

-- | Emits only the first n values emitted by the source AsyncSubject.
foreign import take :: forall a. Int -> AsyncSubject a -> AsyncSubject a

-- | Lets values pass until a second AsyncSubject emits something. Then, it completes.
foreign import takeUntil :: forall a b. AsyncSubject a -> AsyncSubject b -> AsyncSubject a

-- | Emits values emitted by the source AsyncSubject so long as each value satisfies
-- | the given predicate, and then completes as soon as this predicate is not satisfied.
foreign import takeWhile :: forall a. (a -> Boolean) -> AsyncSubject a -> AsyncSubject a

-- | It's like throttleTime, but the silencing duration is determined by a second AsyncSubject.
foreign import throttle :: forall a b. AsyncSubject a -> (a -> AsyncSubject b) -> AsyncSubject a

-- | Emits a value from the source AsyncSubject, then ignores subsequent source values
-- | for duration milliseconds, then repeats this process.
foreign import throttleTime :: forall a. Int -> AsyncSubject a -> AsyncSubject a


-- Combination Operators

-- | An AsyncSubject of projected values from the most recent values from each input AsyncSubject.
foreign import combineLatest
  :: forall a b c. (a -> b -> c) -> AsyncSubject a -> AsyncSubject b -> AsyncSubject c

-- | Concatenates two AsyncSubjects together by sequentially emitting their values, one AsyncSubject after the other.
foreign import concat :: forall a. AsyncSubject a -> AsyncSubject a -> AsyncSubject a

-- | Converts a higher-order AsyncSubject into a first-order AsyncSubject by concatenating the inner AsyncSubjects in order.
foreign import concatAll :: forall a. AsyncSubject (AsyncSubject a) -> AsyncSubject a

-- | Flattens an AsyncSubject-of-AsyncSubjects by dropping the next inner AsyncSubjects
-- | while the current inner is still executing.
foreign import exhaust :: forall a. AsyncSubject (AsyncSubject a) -> AsyncSubject a

-- | Creates an output AsyncSubject which concurrently emits all values from each input AsyncSubject.
foreign import merge :: forall a. AsyncSubject a -> AsyncSubject a -> AsyncSubject a

-- | Converts a higher-order AsyncSubject into a first-order AsyncSubject
-- | which concurrently delivers all values that are emitted on the inner AsyncSubjects.
foreign import mergeAll :: forall a. AsyncSubject (AsyncSubject a) -> AsyncSubject a

-- | Returns an AsyncSubject that mirrors the first source AsyncSubject to emit an
-- | item from the array of AsyncSubjects.
foreign import race :: forall a. Array (AsyncSubject a) -> AsyncSubject a

-- | Returns an AsyncSubject that emits the items in the given Array before
-- | it begins to emit items emitted by the source AsyncSubject.
foreign import startWith :: forall a. Array a -> AsyncSubject a -> AsyncSubject a

-- | Combines each value from the source AsyncSubjects using a project function to
-- | determine the value to be emitted on the output AsyncSubject.
foreign import withLatestFrom
  :: forall a b c. (a -> b -> c) -> AsyncSubject a -> AsyncSubject b -> AsyncSubject c

-- | Waits for each AsyncSubject to emit a value. Once this occurs, all values
-- | with the corresponding index will be emitted. This will continue until at
-- | least one inner AsyncSubject completes.
foreign import zip :: forall a. Array (AsyncSubject a) -> AsyncSubject (Array a)

-- Error Handling Operators

foreign import catch :: forall a. (AsyncSubject a) -> (Error -> AsyncSubject a) -> (AsyncSubject a)

-- | If the source AsyncSubject calls error, this method will resubscribe to the
-- | source AsyncSubject n times rather than propagating the error call.
foreign import retry :: forall a. Int -> AsyncSubject a -> AsyncSubject a

-- Utility Operators

-- | Time shifts each item by some specified amount of milliseconds.
foreign import delay :: forall a. Int -> AsyncSubject a -> AsyncSubject a

-- | Delays the emission of items from the source AsyncSubject by a given time
-- | span determined by the emissions of another AsyncSubject.
foreign import delayWhen :: forall a b. AsyncSubject a -> (a -> AsyncSubject b) -> AsyncSubject a

foreign import dematerialize :: forall a. AsyncSubject (Notification a) -> AsyncSubject a

foreign import _materialize
  :: forall a.
     Fn4
     (AsyncSubject a)
     (a -> Notification a)
     (Error -> Notification a)
     (Notification a)
     (AsyncSubject (Notification a))

materialize :: forall a. AsyncSubject a -> AsyncSubject (Notification a)
materialize ob = runFn4 _materialize ob OnNext OnError OnComplete
-- | Performs the effect on each value of the AsyncSubject.  An alias for `do`.
-- | Useful for testing (transparently performing an effect outside of a subscription).

foreign import performEach :: forall a e. AsyncSubject a -> (a -> Eff (|e) Unit) -> Eff (|e) (AsyncSubject a)

foreign import toArray :: forall a. AsyncSubject a -> AsyncSubject (Array a)

-- Aggregate Operators

-- | Counts the number of emissions on the source and emits that number when the source completes.
foreign import count :: forall a. AsyncSubject a -> AsyncSubject Int

-- | Applies an accumulator function over the source, and returns the accumulated
-- | result when the source completes, given a seed value.
foreign import reduce :: forall a b. (a -> b -> b) -> b -> AsyncSubject a -> AsyncSubject b

-- Helper Functions

  -- | Run a source's effects
foreign import unwrap :: forall a e. AsyncSubject (Eff e a) -> Eff e (AsyncSubject a)
