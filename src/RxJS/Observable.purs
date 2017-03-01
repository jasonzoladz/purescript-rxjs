module RxJS.Observable
  ( Observable()
  , observeOn
  , subscribeOn
  , subscribe
  , subscribeNext
  , fromArray
  , fromEvent
  , interval
  , just
  , never
  , range
  , throw
  , timer
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
  , ajax
  , ajaxWithBody
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
  , isEmpty
  , sampleTime
  , share
  , skip
  , skipUntil
  , skipWhile
  , take
  , takeUntil
  , takeWhile
  , throttle
  , throttleTime
  , combineLatest
  , combineLatest3
  , concat
  , concatAll
  , exhaust
  , merge
  , mergeAll
  , race
  , startWith
  , startWithMany
  , withLatestFrom
  , zip
  , catch
  , retry
  , defaultIfEmpty
  , delay
  , delayWhen
  , dematerialize
  , materialize
  , performEach
  , toArray
  , count
  , reduce
  , unwrap
  , Response
  , Request
  )
  where

import Data.Function.Eff
import Control.Alt (class Alt)
import Control.Alternative (class Alternative)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (Error)
import Control.Monad.Error.Class (class MonadError)
import Control.MonadPlus (class MonadPlus)
import Control.MonadZero (class MonadZero)
import Control.Plus (class Plus)
import DOM.Event.Types (Event, EventType(..), EventTarget)
import Data.Foldable (foldr, class Foldable)
import Data.Function.Uncurried (Fn2, Fn3, Fn4, runFn2, runFn3, runFn4)
import Data.StrMap (StrMap, empty)
import Prelude (class Semigroup, class Monad, class Bind, class Applicative, class Apply, class Functor, Unit, id, (<$>))
import RxJS.Notification (Notification(OnComplete, OnError, OnNext))
import RxJS.Scheduler (Scheduler)
import RxJS.Subscriber (Subscriber)
import RxJS.Subscription (Subscription)
import Test.QuickCheck (class Arbitrary, arbitrary)
import Test.QuickCheck.Gen (arrayOf)

-- | *Note*: A couple operators are not wrapped (namely, `bindCallback`, `bindNodeCallback`) because RxJS
-- | implementation details prevent giving the operators an "honest" PureScript type.
-- | However, such operators are replaced easily using `Aff` with the `AsyncSubject` module.
-- | Please see [RxJS Version 5.* documentation](http://reactivex.io/rxjs/) for
-- | additional details on proper usage of the library.

foreign import data Observable :: * -> *

instance functorObservable :: Functor Observable where
  map = _map

instance applyObservable :: Apply Observable where
  apply = combineLatest id

instance applicativeObservable :: Applicative Observable where
  pure = just

instance bindObservable :: Bind Observable where
  bind = mergeMap

instance monadObservable :: Monad Observable

instance semigroupObservable :: Semigroup (Observable a) where
  append = concat

instance altObservable :: Alt Observable where
  alt = merge

instance plusObservable :: Plus Observable where
  empty = _empty

instance alternativeObservable :: Alternative Observable

instance monadZeroObservable :: MonadZero Observable

instance monadPlusObservable :: MonadPlus Observable

instance monadErrorObservable :: MonadError Error Observable where
  catchError = catch
  throwError = throw

instance arbitraryObservable :: Arbitrary a => Arbitrary (Observable a) where
  arbitrary = fromArray <$> (arrayOf arbitrary)

-- | Makes every `next` call run in the new Scheduler.
foreign import observeOn :: forall a. Scheduler -> Observable a -> Observable a

-- | Makes subscription happen on a given Scheduler.
foreign import subscribeOn :: forall a. Scheduler -> Observable a -> Observable a

-- Subscription

-- | Subscribing to an Observable is like calling a function, providing
-- | `next`, `error` and `completed` effects to which the data will be delivered.
foreign import subscribe :: forall a e. Subscriber a -> Observable a ->  Eff (|e) Subscription

-- Subscribe to an Observable, supplying only the `next` function.
foreign import subscribeNext
  :: forall a e. (a -> Eff (|e) Unit)
  -> Observable a
  -> Eff (|e) Subscription


-- Creation Operators


type Response =
  { body :: String
  , status :: Int
  , responseType :: String
  }

type Request =
  { url :: String
  , data :: String
  , timeout :: Int
  , headers :: StrMap String
  , crossDomain :: Boolean
  , responseType :: String
  , method :: String
  }

-- | Create a Request object with a given URL, Body and Method in that order
requestWithBody :: String -> String -> String -> Request
requestWithBody url body method =
  { url : url
  , data : body
  , timeout : 0
  , headers : empty
  , crossDomain : false
  , responseType : ""
  , method : method
  }


foreign import ajax :: forall e. String -> Eff e (Observable Response)

foreign import ajaxWithBody :: forall e. Request -> Eff e (Observable Response)

-- | An empty Observable that emits only the complete notification.
foreign import _empty :: forall a. Observable a

-- | Creates an Observable from an Array.
foreign import fromArray :: forall a. Array a -> Observable a

-- | Creates an Observable that emits events of the specified type coming from the given event target.
fromEvent :: forall e. EventTarget -> EventType -> Eff e (Observable Event)
fromEvent target (EventType str) = runEffFn2 fromEventImpl target str

foreign import fromEventImpl :: forall e. EffFn2 (|e) EventTarget String (Observable Event)

-- | Returns an Observable that emits an infinite sequence of ascending
-- | integers, with a constant interval of time of your choosing between those
-- | emissions.
foreign import interval :: Int -> Observable Int

-- | Creates an Observable that emits the value specify,
-- | and then emits a complete notification.  An alias for `of`.
foreign import just :: forall a. a -> Observable a

-- | Creates an Observable that emits no items.  Subscriptions it must be
-- | disposed manually.
foreign import never :: forall a. Observable a

-- | The range operator emits a range of sequential integers, in order, where
-- | you select the start of the range and its length
range :: Int -> Int -> Observable Int
range start length = runFn2 rangeImpl start length

foreign import rangeImpl :: Fn2 Int Int (Observable Int)

-- | Creates an Observable that immediately sends an error notification.
foreign import throw :: forall a. Error -> Observable a

-- | Creates an Observable that, upon subscription, emits and infinite sequence of ascending integers,
-- | after a specified delay, every specified period.  Delay and period are in
-- | milliseconds.
timer :: Int -> Int -> Observable Int
timer dly period = runFn2 timerImpl dly period

foreign import timerImpl :: Fn2 Int Int (Observable Int)

-- Transformation Operators
-- | Collects values from the first Observable into an Array, and emits that array only when
-- | second Observable emits.
foreign import buffer :: forall a b. Observable a -> Observable b -> Observable (Array a)

-- | Collects values from the past as an array, emits that array when
-- | its size (arg1) reaches the specified buffer size, and starts a new buffer.
-- | The new buffer starts with nth (arg2) element of the Observable counting
-- | from the beginning of the *last* buffer.
foreign import bufferCount :: forall a. Int -> Int -> Observable a -> Observable (Array a)

-- | Collects values from the past as an array, and emits those arrays
-- | periodically in time.  The first argument is how long to fill the buffer.
-- | The second argument is specifies when to open the next buffer following an
-- | emission.  The third argument is the maximum size of any buffer.
bufferTime :: forall a. Int -> Int -> Int -> (Observable a) -> (Observable (Array a))
bufferTime = runFn4 bufferTimeImpl

foreign import bufferTimeImpl :: forall a. Fn4 Int Int Int (Observable a) (Observable (Array a))

-- | Collects values from the source Observable (arg1) as an array. Starts collecting only when
-- | the opening (arg2) Observable emits, and calls the closingSelector function (arg3) to get an Observable
-- | that decides when to close the buffer.  Another buffer opens when the
-- | opening Observable emits its next value.
bufferToggle
  :: forall a b c. (Observable a)
  -> (Observable b)
  -> (b -> Observable c)
  -> (Observable (Array a))
bufferToggle = runFn3 bufferToggleImpl


foreign import bufferToggleImpl
  :: forall a b c. Fn3 (Observable a) (Observable b) (b -> Observable c) (Observable (Array a))

-- | Collects values from the past as an array. When it starts collecting values,
-- | it calls a function that returns an Observable that emits to close the
-- | buffer and restart collecting.
foreign import bufferWhen :: forall a b. Observable a -> (a -> Observable b) -> Observable (Array a)

-- | Equivalent to mergeMap (a.k.a, `>>=`) EXCEPT that, unlike mergeMap,
-- | the next bind will not run until the Observable generated by the projection function (arg2)
-- | completes.  That is, composition is sequential, not concurrent.
-- | Warning: if source values arrive endlessly and faster than their corresponding
-- | inner Observables can complete, it will result in memory issues as inner
-- | Observables amass in an unbounded buffer waiting for their turn to be subscribed to.
foreign import concatMap :: forall a b. Observable a -> (a -> Observable b) -> Observable b

-- | The type signature explains it best.  Warning: Like `concatMap`, composition is sequential.
foreign import concatMapTo
  :: forall a b c. Observable a -> Observable b -> (a -> b -> Observable c) -> Observable c

-- | It's Like concatMap (a.k.a, `>>=`) EXCEPT that it ignores every new projected
-- | Observable if the previous projected Observable has not yet completed.
foreign import exhaustMap :: forall a b. Observable a -> (a -> Observable b) -> Observable b

-- | It's similar to mergeMap, but applies the projection function to every source
-- | value as well as every output value. It's recursive.
foreign import expand :: forall a. Observable a -> (a -> Observable a) -> Observable a

-- | Groups the items emitted by an Observable (arg2) according to the value
-- | returned by the grouping function (arg1).  Each group becomes its own
-- | Observable.
foreign import groupBy :: forall a b. (a -> b) -> Observable a -> Observable (Observable a)

foreign import _map :: forall a b. (a -> b) -> Observable a -> Observable b

-- | Emits the given constant value on the output Observable every time
-- | the source Observable emits a value.
foreign import mapTo :: forall a b. b -> Observable a -> Observable b

-- | Maps each value to an Observable, then flattens all of these Observables
-- | using mergeAll.  It's just monadic `bind`.
foreign import mergeMap :: forall a b. Observable a -> (a -> Observable b) -> Observable b

-- | Maps each value of the Observable (arg1) to the same inner Observable (arg2),
-- | then flattens the result.
foreign import mergeMapTo :: forall a b. Observable a -> Observable b -> Observable b

-- | Puts the current value and previous value together as an array, and emits that.
foreign import pairwise :: forall a. Observable a -> Observable (Array a)

-- | Given a predicate function (arg1), and an Observable (arg2), it outputs a
-- | two element array of partitioned values
-- | (i.e., [ Observable valuesThatPassPredicate, Observable valuesThatFailPredicate ]).
foreign import partition :: forall a. (a -> Boolean) -> Observable a -> Array (Observable a)

-- | Given an accumulator function (arg1), an initial value (arg2), and
-- | a source Observable (arg3), it returns an Observable that emits the current
-- | accumlation whenever the source emits a value.
foreign import scan :: forall a b. (a -> b -> b) -> b -> Observable a -> Observable b

-- | Projects each source value to an Observable which is merged in the output
-- | Observable, emitting values only from the most recently projected Observable.
foreign import switchMap :: forall a b. Observable a -> (a -> Observable b) -> Observable b

-- | It's like switchMap, but maps each value to the same inner Observable.
foreign import switchMapTo :: forall a b. Observable a -> Observable b -> Observable b

-- | It's like buffer, but emits a nested Observable instead of an array.
foreign import window :: forall a b. Observable a -> Observable b -> Observable (Observable a)

-- | It's like bufferCount, but emits a nested Observable instead of an array.
foreign import windowCount :: forall a. Int -> Int -> Observable a -> Observable (Observable a)

-- | It's like bufferTime, but emits a nested Observable instead of an array,
-- | and it doesn't take a maximum size parameter.  arg1 is how long to
-- | buffer items into a new Observable, arg2 is the when the next buffer should begin,
-- | and arg3 is the source Observable.
foreign import windowTime :: forall a. Int -> Int -> Observable a -> Observable (Observable a)

-- | It's like bufferToggle, but emits a nested Observable instead of an array.
windowToggle
  :: forall a b c. (Observable a)
  -> (Observable b)
  -> (b -> Observable c)
  -> (Observable (Array a))
windowToggle = runFn3 windowToggleImpl

foreign import windowToggleImpl
  :: forall a b c. Fn3 (Observable a) (Observable b) (b -> Observable c) (Observable (Array a))

-- | It's like bufferWhen, but emits a nested Observable instead of an array.
foreign import windowWhen :: forall a b. Observable a -> Observable b -> Observable (Observable a)

-- Filtering Operators
-- | It's like auditTime, but the silencing duration is determined by a second Observable.
foreign import audit :: forall a b. Observable a -> (a -> Observable b) -> Observable a

-- | Ignores source values for duration milliseconds,
-- | then emits the most recent value from the source Observable, then repeats this process.
foreign import auditTime :: forall a. Int -> Observable a -> Observable a

-- | It's like debounceTime, but the time span of emission silence is determined
-- | by a second Observable.  Allows for a variable debounce rate.
foreign import debounce :: forall a. Observable a -> (a -> Observable Int) -> Observable a

-- | It's like delay, but passes only the most recent value from each burst of emissions.
foreign import debounceTime :: forall a. Int -> Observable a -> Observable a

-- | Returns an Observable that emits all items emitted by the source Observable
-- | that are distinct by comparison from previous items.
foreign import distinct :: forall a. Observable a -> Observable a

-- | Returns an Observable that emits all items emitted by the source Observable
-- | that are distinct by comparison from the previous item.
foreign import distinctUntilChanged :: forall a. Observable a -> Observable a

-- | Emits the single value at the specified index in a sequence of emissions
-- | from the source Observable.
foreign import elementAt :: forall a. Observable a -> Int -> Observable a

-- | Filter items emitted by the source Observable by only emitting those that
-- | satisfy a specified predicate.
foreign import filter :: forall a. (a -> Boolean) -> Observable a -> Observable a

-- | Ignores all items emitted by the source Observable and only passes calls of complete or error.
foreign import ignoreElements :: forall a. Observable a -> Observable a

-- | Returns an Observable that emits only the last item emitted by the source Observable.
foreign import last :: forall a. Observable a -> Observable a

-- | It's like sampleTime, but samples whenever the notifier Observable emits something.
foreign import sample :: forall a b. Observable a -> Observable b -> Observable a

-- | Periodically looks at the source Observable and emits whichever
-- | value it has most recently emitted since the previous sampling, unless the source has not emitted anything since the previous sampling.
foreign import sampleTime :: forall a. Int -> Observable a -> Observable a

-- | Returns an Observable that skips n items emitted by an Observable.
foreign import skip :: forall a. Int -> Observable a -> Observable a

-- | Returns an Observable that skips items emitted by the source Observable until a second Observable emits an item.
foreign import skipUntil :: forall a b. Observable a -> Observable b -> Observable a

-- | Returns an Observable that skips all items emitted
-- | by the source Observable as long as a specified condition holds true,
-- | but emits all further source items as soon as the condition becomes false.
foreign import skipWhile :: forall a. (a -> Boolean) -> Observable a -> Observable a

-- | Emits only the first n values emitted by the source Observable.
foreign import take :: forall a. Int -> Observable a -> Observable a

-- | Lets values pass until a second Observable emits something. Then, it completes.
foreign import takeUntil :: forall a b. Observable a -> Observable b -> Observable a

-- | Emits values emitted by the source Observable so long as each value satisfies
-- | the given predicate, and then completes as soon as this predicate is not satisfied.
foreign import takeWhile :: forall a. (a -> Boolean) -> Observable a -> Observable a

-- | It's like throttleTime, but the silencing duration is determined by a second Observable.
foreign import throttle :: forall a b. Observable a -> (a -> Observable b) -> Observable a

-- | Emits a value from the source Observable, then ignores subsequent source values
-- | for duration milliseconds, then repeats this process.
foreign import throttleTime :: forall a. Int -> Observable a -> Observable a


-- Combination Operators
-- | An Observable of projected values from the most recent values from each input Observable.
foreign import combineLatest
  :: forall a b c. (a -> b -> c) -> Observable a -> Observable b -> Observable c

foreign import combineLatest3
  :: forall a b c d. (a -> b -> c -> d) -> Observable a -> Observable b -> Observable c -> Observable d

-- | Concatenates two Observables together by sequentially emitting their values, one Observable after the other.
foreign import concat :: forall a. Observable a -> Observable a -> Observable a

-- | Converts a higher-order Observable into a first-order Observable by concatenating the inner Observables in order.
foreign import concatAll :: forall a. Observable (Observable a) -> Observable a

-- | Flattens an Observable-of-Observables by dropping the next inner Observables
-- | while the current inner is still executing.
foreign import exhaust :: forall a. Observable (Observable a) -> Observable a

-- | Creates an output Observable which concurrently emits all values from each input Observable.
foreign import merge :: forall a. Observable a -> Observable a -> Observable a

-- | Converts a higher-order Observable into a first-order Observable
-- | which concurrently delivers all values that are emitted on the inner Observables.
foreign import mergeAll :: forall a. Observable (Observable a) -> Observable a

-- | Returns an Observable that mirrors the first source Observable to emit an
-- | item from the array of Observables.
foreign import race :: forall a. Array (Observable a) -> Observable a

-- | Returns an Observable that emits the items in the given Foldable before
-- | it begins to emit items emitted by the source Observable.
startWithMany :: forall f a. Foldable f => f a -> Observable a -> Observable a
startWithMany xs obs =
  foldr (\cur acc -> startWith cur acc) obs xs

-- | Returns an Observable that emits the item given before
-- | it begins to emit items emitted by the source Observable.
foreign import startWith :: forall a. a -> Observable a -> Observable a

-- | Combines each value from the source Observables using a project function to
-- | determine the value to be emitted on the output Observable.
foreign import withLatestFrom
  :: forall a b c. (a -> b -> c) -> Observable a -> Observable b -> Observable c

-- | Waits for each Observable to emit a value. Once this occurs, all values
-- | with the corresponding index will be emitted. This will continue until at
-- | least one inner observable completes.
foreign import zip :: forall a. Array (Observable a) -> Observable (Array a)

-- Error Handling Operators
foreign import catch :: forall a. (Observable a) -> (Error -> Observable a) -> (Observable a)

-- | If the source Observable calls error, this method will resubscribe to the
-- | source Observable n times rather than propagating the error call.
foreign import retry :: forall a. Int -> Observable a -> Observable a

-- Utility Operators
-- | Time shifts each item by some specified amount of milliseconds.
foreign import delay :: forall a. Int -> Observable a -> Observable a

-- | Delays the emission of items from the source Observable by a given time
-- | span determined by the emissions of another Observable.
foreign import delayWhen :: forall a b. Observable a -> (a -> Observable b) -> Observable a

foreign import dematerialize :: forall a. Observable (Notification a) -> Observable a

foreign import _materialize
  :: forall a.
     Fn4
     (Observable a)
     (a -> Notification a)
     (Error -> Notification a)
     (Notification a)
     (Observable (Notification a))

materialize :: forall a. Observable a -> Observable (Notification a)
materialize ob = runFn4 _materialize ob OnNext OnError OnComplete
-- | Performs the effect on each value of the Observable.  An alias for `do`.
-- | Useful for testing (transparently performing an effect outside of a subscription).

foreign import performEach :: forall a e. Observable a -> (a -> Eff (|e) Unit) -> Eff (|e) (Observable a)

foreign import toArray :: forall a. Observable a -> Observable (Array a)



-- | Returns an Observable that emits the items emitted by the source Observable or a specified default item
-- | if the source Observable is empty.
-- |
-- | <img width="640" height="305" src="http://reactivex.io/documentation/operators/images/defaultIfEmpty.c.png" alt="" />
-- |
-- | takes a defaultValue which is the item to emit if the source Observable emits no items.
-- |
-- | returns an Observable that emits either the specified default item if the source Observable emits no
-- |         items, or the items emitted by the source Observable
foreign import defaultIfEmpty :: forall a. Observable a -> a -> Observable a

-- | Tests whether this `Observable` emits no elements.
-- |
-- | returns an Observable emitting one single Boolean, which is `true` if this `Observable`
-- |         emits no elements, and `false` otherwise.
foreign import isEmpty :: forall a. Observable a -> Observable Boolean
-- | Returns a new Observable that multicasts (shares) the original Observable. As long a
-- | there is more than 1 Subscriber, this Observable will be subscribed and emitting data.
-- | When all subscribers have unsubscribed it will unsubscribe from the source Observable.
-- |
-- | This is an alias for `publish().refCount()`
-- |
-- | <img width="640" height="510" src="https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/publishRefCount.png" alt="" />
-- |
-- | returns an Observable that upon connection causes the source Observable to emit items to its Subscribers
foreign import share :: forall a. Observable a -> Observable a

-- Aggregate Operators

-- | Counts the number of emissions on the source and emits that number when the source completes.
foreign import count :: forall a. Observable a -> Observable Int

-- | Applies an accumulator function over the source Observable, and returns the accumulated
-- | result when the source completes, given a seed value.
foreign import reduce :: forall a b. (a -> b -> b) -> b -> Observable a -> Observable b

-- Helper Functions

  -- | Run an Observable of effects
foreign import unwrap :: forall a e. Observable (Eff e a) -> Eff e (Observable a)
