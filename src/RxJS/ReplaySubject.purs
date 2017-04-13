module RxJS.ReplaySubject
  ( ReplaySubject(..)
  , observeOn
  , subscribeOn
  , subscribe
  , subscribeNext
  , just
  , next
  , send
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


import RxJS.Scheduler (Scheduler)
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

foreign import data ReplaySubject :: Type -> Type

instance functorReplaySubject :: Functor ReplaySubject where
  map = _map

instance applyReplaySubject :: Apply ReplaySubject where
  apply = combineLatest id

instance applicativeReplaySubject :: Applicative ReplaySubject where
  pure = just

instance bindReplaySubject :: Bind ReplaySubject where
  bind = mergeMap

instance monadReplaySubject :: Monad ReplaySubject

-- | NOTE: The semigroup instance uses `merge` NOT `concat`.
instance semigroupReplaySubject :: Semigroup (ReplaySubject a) where
  append = merge

instance altReplaySubject :: Alt ReplaySubject where
  alt = merge

instance plusReplaySubject :: Plus ReplaySubject where
  empty = _empty unit

instance alternativeReplaySubject :: Alternative ReplaySubject

instance monadZeroReplaySubject :: MonadZero ReplaySubject

instance monadPlusReplaySubject :: MonadPlus ReplaySubject

-- Scheduling

-- | Makes every `next` call run in the new Scheduler.
foreign import observeOn :: forall a. Scheduler -> ReplaySubject a -> ReplaySubject a

-- | Makes subscription happen on a given Scheduler.
foreign import subscribeOn :: forall a. Scheduler -> ReplaySubject a -> ReplaySubject a

-- Subscription

-- | Subscribing to an ReplaySubject is like calling a function, providing
-- | `next`, `error` and `completed` effects to which the data will be delivered.
foreign import subscribe :: forall a e. Subscriber a -> ReplaySubject a ->  Eff (|e) Subscription

foreign import subscribeObservableTo :: forall a e. Observable a -> ReplaySubject a -> Eff (|e) Subscription

-- Subscribe to an ReplaySubject, supplying only the `next` function.
foreign import subscribeNext
  :: forall a e. (a -> Eff (|e) Unit)
  -> ReplaySubject a
  -> Eff (|e) Subscription


-- Creation Operator

-- | Creates an ReplaySubject that emits the value specify,
-- | and then emits a complete notification.  An alias for `of`.
foreign import just :: forall a. a -> ReplaySubject a

foreign import _empty :: forall a. Unit -> ReplaySubject a

-- ReplaySubject Operators

-- | Send a new value to a ReplaySubject
foreign import next :: forall a e. a -> ReplaySubject a -> Eff e Unit

-- | An alias for next
send :: forall a e. a -> ReplaySubject a -> Eff e Unit
send = next

-- | Create an Observable from a ReplaySubject
foreign import asObservable :: forall a. ReplaySubject a -> Observable a


-- Transformation Operators

-- | Collects values from the first ReplaySubject into an Array, and emits that array only when
-- | second ReplaySubject emits.
foreign import buffer :: forall a b. ReplaySubject a -> ReplaySubject b -> ReplaySubject (Array a)

-- | Collects values from the past as an array, emits that array when
-- | its size (arg1) reaches the specified buffer size, and starts a new buffer.
-- | The new buffer starts with nth (arg2) element of the ReplaySubject counting
-- | from the beginning of the *last* buffer.
foreign import bufferCount :: forall a. Int -> Int -> ReplaySubject a -> ReplaySubject (Array a)

-- | Collects values from the past as an array, and emits those arrays
-- | periodically in time.  The first argument is how long to fill the buffer.
-- | The second argument is specifies when to open the next buffer following an
-- | emission.  The third argument is the maximum size of any buffer.
bufferTime :: forall a. Int -> Int -> Int -> (ReplaySubject a) -> (ReplaySubject (Array a))
bufferTime = runFn4 bufferTimeImpl

foreign import bufferTimeImpl :: forall a. Fn4 Int Int Int (ReplaySubject a) (ReplaySubject (Array a))

-- | Collects values from the source ReplaySubject (arg1) as an array. Starts collecting only when
-- | the opening (arg2) ReplaySubject emits, and calls the closingSelector function (arg3) to get an ReplaySubject
-- | that decides when to close the buffer.  Another buffer opens when the
-- | opening ReplaySubject emits its next value.
bufferToggle
  :: forall a b c. (ReplaySubject a)
  -> (ReplaySubject b)
  -> (b -> ReplaySubject c)
  -> (ReplaySubject (Array a))
bufferToggle = runFn3 bufferToggleImpl


foreign import bufferToggleImpl
  :: forall a b c. Fn3 (ReplaySubject a) (ReplaySubject b) (b -> ReplaySubject c) (ReplaySubject (Array a))

-- | Collects values from the past as an array. When it starts collecting values,
-- | it calls a function that returns an ReplaySubject that emits to close the
-- | buffer and restart collecting.
foreign import bufferWhen :: forall a b. ReplaySubject a -> (a -> ReplaySubject b) -> ReplaySubject (Array a)

-- | Equivalent to mergeMap (a.k.a, `>>=`) EXCEPT that, unlike mergeMap,
-- | the next bind will not run until the ReplaySubject generated by the projection function (arg2)
-- | completes.  That is, composition is sequential, not concurrent.
-- | Warning: if source values arrive endlessly and faster than their corresponding
-- | inner ReplaySubjects can complete, it will result in memory issues as inner
-- | ReplaySubjects amass in an unbounded buffer waiting for their turn to be subscribed to.
foreign import concatMap :: forall a b. ReplaySubject a -> (a -> ReplaySubject b) -> ReplaySubject b

-- | The type signature explains it best.  Warning: Like `concatMap`, composition is sequential.
foreign import concatMapTo
  :: forall a b c. ReplaySubject a -> ReplaySubject b -> (a -> b -> ReplaySubject c) -> ReplaySubject c

-- | It's Like concatMap (a.k.a, `>>=`) EXCEPT that it ignores every new projected
-- | ReplaySubject if the previous projected ReplaySubject has not yet completed.
foreign import exhaustMap :: forall a b. ReplaySubject a -> (a -> ReplaySubject b) -> ReplaySubject b

-- | It's similar to mergeMap, but applies the projection function to every source
-- | value as well as every output value. It's recursive.
foreign import expand :: forall a. ReplaySubject a -> (a -> ReplaySubject a) -> ReplaySubject a

-- | Groups the items emitted by an ReplaySubject (arg2) according to the value
-- | returned by the grouping function (arg1).  Each group becomes its own
-- | ReplaySubject.
foreign import groupBy :: forall a b. (a -> b) -> ReplaySubject a -> ReplaySubject (ReplaySubject a)

foreign import _map :: forall a b. (a -> b) -> ReplaySubject a -> ReplaySubject b

-- | Emits the given constant value on the output ReplaySubject every time
-- | the source ReplaySubject emits a value.
foreign import mapTo :: forall a b. b -> ReplaySubject a -> ReplaySubject b

-- | Maps each value to an ReplaySubject, then flattens all of these ReplaySubjects
-- | using mergeAll.  It's just monadic `bind`.
foreign import mergeMap :: forall a b. ReplaySubject a -> (a -> ReplaySubject b) -> ReplaySubject b

-- | Maps each value of the ReplaySubject (arg1) to the same inner ReplaySubject (arg2),
-- | then flattens the result.
foreign import mergeMapTo :: forall a b. ReplaySubject a -> ReplaySubject b -> ReplaySubject b

-- | Puts the current value and previous value together as an array, and emits that.
foreign import pairwise :: forall a. ReplaySubject a -> ReplaySubject (Array a)

-- | Given a predicate function (arg1), and an ReplaySubject (arg2), it outputs a
-- | two element array of partitioned values
-- | (i.e., [ ReplaySubject valuesThatPassPredicate, ReplaySubject valuesThatFailPredicate ]).
foreign import partition :: forall a. (a -> Boolean) -> ReplaySubject a -> Array (ReplaySubject a)

-- | Given an accumulator function (arg1), an initial value (arg2), and
-- | a source ReplaySubject (arg3), it returns an ReplaySubject that emits the current
-- | accumlation whenever the source emits a value.
foreign import scan :: forall a b. (a -> b -> b) -> b -> ReplaySubject a -> ReplaySubject b

-- | Projects each source value to an ReplaySubject which is merged in the output
-- | ReplaySubject, emitting values only from the most recently projected ReplaySubject.
foreign import switchMap :: forall a b. ReplaySubject a -> (a -> ReplaySubject b) -> ReplaySubject b

-- | It's like switchMap, but maps each value to the same inner ReplaySubject.
foreign import switchMapTo :: forall a b. ReplaySubject a -> ReplaySubject b -> ReplaySubject b

-- | It's like buffer, but emits a nested ReplaySubject instead of an array.
foreign import window :: forall a b. ReplaySubject a -> ReplaySubject b -> ReplaySubject (ReplaySubject a)

-- | It's like bufferCount, but emits a nested ReplaySubject instead of an array.
foreign import windowCount :: forall a. Int -> Int -> ReplaySubject a -> ReplaySubject (ReplaySubject a)

-- | It's like bufferTime, but emits a nested ReplaySubject instead of an array,
-- | and it doesn't take a maximum size parameter.  arg1 is how long to
-- | buffer items into a new ReplaySubject, arg2 is the when the next buffer should begin,
-- | and arg3 is the source ReplaySubject.
foreign import windowTime :: forall a. Int -> Int -> ReplaySubject a -> ReplaySubject (ReplaySubject a)

-- | It's like bufferToggle, but emits a nested ReplaySubject instead of an array.
windowToggle
  :: forall a b c. (ReplaySubject a)
  -> (ReplaySubject b)
  -> (b -> ReplaySubject c)
  -> (ReplaySubject (Array a))
windowToggle = runFn3 windowToggleImpl

foreign import windowToggleImpl
  :: forall a b c. Fn3 (ReplaySubject a) (ReplaySubject b) (b -> ReplaySubject c) (ReplaySubject (Array a))

-- | It's like bufferWhen, but emits a nested ReplaySubject instead of an array.
foreign import windowWhen :: forall a b. ReplaySubject a -> ReplaySubject b -> ReplaySubject (ReplaySubject a)

-- Filtering Operators

-- | It's like auditTime, but the silencing duration is determined by a second ReplaySubject.
foreign import audit :: forall a b. ReplaySubject a -> (a -> ReplaySubject b) -> ReplaySubject a

-- | Ignores source values for duration milliseconds,
-- | then emits the most recent value from the source ReplaySubject, then repeats this process.
foreign import auditTime :: forall a. Int -> ReplaySubject a -> ReplaySubject a

-- | It's like debounceTime, but the time span of emission silence is determined
-- | by a second ReplaySubject.  Allows for a variable debounce rate.
foreign import debounce :: forall a. ReplaySubject a -> (a -> ReplaySubject Int) -> ReplaySubject a

-- | It's like delay, but passes only the most recent value from each burst of emissions.
foreign import debounceTime :: forall a. Int -> ReplaySubject a -> ReplaySubject a

-- | Returns an ReplaySubject that emits all items emitted by the source ReplaySubject
-- | that are distinct by comparison from previous items.
foreign import distinct :: forall a. ReplaySubject a -> ReplaySubject a

-- | Returns an ReplaySubject that emits all items emitted by the source ReplaySubject
-- | that are distinct by comparison from the previous item.
foreign import distinctUntilChanged :: forall a. ReplaySubject a -> ReplaySubject a

-- | Emits the single value at the specified index in a sequence of emissions
-- | from the source ReplaySubject.
foreign import elementAt :: forall a. ReplaySubject a -> Int -> ReplaySubject a

-- | Filter items emitted by the source ReplaySubject by only emitting those that
-- | satisfy a specified predicate.
foreign import filter :: forall a. (a -> Boolean) -> ReplaySubject a -> ReplaySubject a

-- | Ignores all items emitted by the source ReplaySubject and only passes calls of complete or error.
foreign import ignoreElements :: forall a. ReplaySubject a -> ReplaySubject a

-- | Returns an ReplaySubject that emits only the last item emitted by the source ReplaySubject.
foreign import last :: forall a. ReplaySubject a -> ReplaySubject a

-- | It's like sampleTime, but samples whenever the notifier ReplaySubject emits something.
foreign import sample :: forall a b. ReplaySubject a -> ReplaySubject b -> ReplaySubject a

-- | Periodically looks at the source ReplaySubject and emits whichever
-- | value it has most recently emitted since the previous sampling, unless the source has not emitted anything since the previous sampling.
foreign import sampleTime :: forall a. Int -> ReplaySubject a -> ReplaySubject a

-- | Returns an ReplaySubject that skips n items emitted by an ReplaySubject.
foreign import skip :: forall a. Int -> ReplaySubject a -> ReplaySubject a

-- | Returns an ReplaySubject that skips items emitted by the source ReplaySubject until a second ReplaySubject emits an item.
foreign import skipUntil :: forall a b. ReplaySubject a -> ReplaySubject b -> ReplaySubject a

-- | Returns an ReplaySubject that skips all items emitted
-- | by the source ReplaySubject as long as a specified condition holds true,
-- | but emits all further source items as soon as the condition becomes false.
foreign import skipWhile :: forall a. (a -> Boolean) -> ReplaySubject a -> ReplaySubject a

-- | Emits only the first n values emitted by the source ReplaySubject.
foreign import take :: forall a. Int -> ReplaySubject a -> ReplaySubject a

-- | Lets values pass until a second ReplaySubject emits something. Then, it completes.
foreign import takeUntil :: forall a b. ReplaySubject a -> ReplaySubject b -> ReplaySubject a

-- | Emits values emitted by the source ReplaySubject so long as each value satisfies
-- | the given predicate, and then completes as soon as this predicate is not satisfied.
foreign import takeWhile :: forall a. (a -> Boolean) -> ReplaySubject a -> ReplaySubject a

-- | It's like throttleTime, but the silencing duration is determined by a second ReplaySubject.
foreign import throttle :: forall a b. ReplaySubject a -> (a -> ReplaySubject b) -> ReplaySubject a

-- | Emits a value from the source ReplaySubject, then ignores subsequent source values
-- | for duration milliseconds, then repeats this process.
foreign import throttleTime :: forall a. Int -> ReplaySubject a -> ReplaySubject a


-- Combination Operators

-- | An ReplaySubject of projected values from the most recent values from each input ReplaySubject.
foreign import combineLatest
  :: forall a b c. (a -> b -> c) -> ReplaySubject a -> ReplaySubject b -> ReplaySubject c

-- | Concatenates two ReplaySubjects together by sequentially emitting their values, one ReplaySubject after the other.
foreign import concat :: forall a. ReplaySubject a -> ReplaySubject a -> ReplaySubject a

-- | Converts a higher-order ReplaySubject into a first-order ReplaySubject by concatenating the inner ReplaySubjects in order.
foreign import concatAll :: forall a. ReplaySubject (ReplaySubject a) -> ReplaySubject a

-- | Flattens an ReplaySubject-of-ReplaySubjects by dropping the next inner ReplaySubjects
-- | while the current inner is still executing.
foreign import exhaust :: forall a. ReplaySubject (ReplaySubject a) -> ReplaySubject a

-- | Creates an output ReplaySubject which concurrently emits all values from each input ReplaySubject.
foreign import merge :: forall a. ReplaySubject a -> ReplaySubject a -> ReplaySubject a

-- | Converts a higher-order ReplaySubject into a first-order ReplaySubject
-- | which concurrently delivers all values that are emitted on the inner ReplaySubjects.
foreign import mergeAll :: forall a. ReplaySubject (ReplaySubject a) -> ReplaySubject a

-- | Returns an ReplaySubject that mirrors the first source ReplaySubject to emit an
-- | item from the array of ReplaySubjects.
foreign import race :: forall a. Array (ReplaySubject a) -> ReplaySubject a

-- | Returns an ReplaySubject that emits the items in the given Array before
-- | it begins to emit items emitted by the source ReplaySubject.
foreign import startWith :: forall a. Array a -> ReplaySubject a -> ReplaySubject a

-- | Combines each value from the source ReplaySubjects using a project function to
-- | determine the value to be emitted on the output ReplaySubject.
foreign import withLatestFrom
  :: forall a b c. (a -> b -> c) -> ReplaySubject a -> ReplaySubject b -> ReplaySubject c

-- | Waits for each ReplaySubject to emit a value. Once this occurs, all values
-- | with the corresponding index will be emitted. This will continue until at
-- | least one inner ReplaySubject completes.
foreign import zip :: forall a. Array (ReplaySubject a) -> ReplaySubject (Array a)

-- Error Handling Operators

foreign import catch :: forall a. (ReplaySubject a) -> (Error -> ReplaySubject a) -> (ReplaySubject a)

-- | If the source ReplaySubject calls error, this method will resubscribe to the
-- | source ReplaySubject n times rather than propagating the error call.
foreign import retry :: forall a. Int -> ReplaySubject a -> ReplaySubject a

-- Utility Operators

-- | Time shifts each item by some specified amount of milliseconds.
foreign import delay :: forall a. Int -> ReplaySubject a -> ReplaySubject a

-- | Delays the emission of items from the source ReplaySubject by a given time
-- | span determined by the emissions of another ReplaySubject.
foreign import delayWhen :: forall a b. ReplaySubject a -> (a -> ReplaySubject b) -> ReplaySubject a

foreign import dematerialize :: forall a. ReplaySubject (Notification a) -> ReplaySubject a

foreign import _materialize
  :: forall a.
     Fn4
     (ReplaySubject a)
     (a -> Notification a)
     (Error -> Notification a)
     (Notification a)
     (ReplaySubject (Notification a))

materialize :: forall a. ReplaySubject a -> ReplaySubject (Notification a)
materialize ob = runFn4 _materialize ob OnNext OnError OnComplete
-- | Performs the effect on each value of the ReplaySubject.  An alias for `do`.
-- | Useful for testing (transparently performing an effect outside of a subscription).

foreign import performEach :: forall a e. ReplaySubject a -> (a -> Eff (|e) Unit) -> Eff (|e) (ReplaySubject a)

foreign import toArray :: forall a. ReplaySubject a -> ReplaySubject (Array a)

-- Aggregate Operators

-- | Counts the number of emissions on the source and emits that number when the source completes.
foreign import count :: forall a. ReplaySubject a -> ReplaySubject Int

-- | Applies an accumulator function over the source, and returns the accumulated
-- | result when the source completes, given a seed value.
foreign import reduce :: forall a b. (a -> b -> b) -> b -> ReplaySubject a -> ReplaySubject b

-- Helper Functions

  -- | Run a source's effects
foreign import unwrap :: forall a e. ReplaySubject (Eff e a) -> Eff e (ReplaySubject a)
