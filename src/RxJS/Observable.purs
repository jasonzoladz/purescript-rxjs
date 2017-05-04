module RxJS.Observable
  ( ObservableT()
  , Observable
  , observeOn
  , subscribeOn
  , subscribe
  , subscribeNext
  , fromArray
  , fromEvent
  , interval
  , just
  , create
  , every
  , never
  , range
  , throw
  , timer
  , buffer
  , bufferCount
  , bufferTime
  , bufferWhen
  , concatMap
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
  , audit
  , ajax
  , ajaxUrl
  , auditTime
  , debounce
  , debounceTime
  , distinct
  , distinctUntilChanged
  , elementAt
  , filter
  , ignoreElements
  , first
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
  , toArray
  , count
  , reduce
  , Response
  , Request
  )
  where

import Control.Monad.Eff.Uncurried
import Control.Alt (class Alt)
import Control.Alternative (class Alternative)
import Control.Comonad (class Comonad, extract)
import Control.Monad.Eff (Eff, kind Effect)
import Control.Monad.Eff.Exception (Error)
import Control.Monad.Eff.Unsafe (unsafePerformEff)
import Control.Monad.Error.Class (class MonadThrow, class MonadError)
import Control.MonadPlus (class MonadPlus)
import Control.MonadZero (class MonadZero)
import Control.Plus (class Plus)
import DOM (DOM)
import DOM.Event.Types (Event, EventType(..), EventTarget)
import Data.Array.Partial (head, last) as Array
import Data.Foldable (foldr, class Foldable)
import Data.Function.Uncurried (Fn2, Fn3, Fn4, runFn2, runFn3, runFn4)
import Data.Identity (Identity)
import Data.Monoid (class Monoid)
import Data.StrMap (StrMap, empty)
import Data.Tuple (Tuple(..), fst, snd)
import Partial.Unsafe (unsafePartial)
import Prelude (class Applicative, class Apply, class Bind, class Functor, class Monad, class Semigroup, Unit, bind, id, map, pure, unit, (#), ($), (<$>), (<*>), (<<<), (>>>))
import RxJS.Notification (Notification(OnComplete, OnError, OnNext))
import RxJS.Scheduler (Scheduler)
import RxJS.Subscriber (Subscriber)
import RxJS.Subscription (Subscription)
import Test.QuickCheck (class Arbitrary, arbitrary)
import Test.QuickCheck.Gen (arrayOf)

foreign import data ObservableImpl :: Type -> Type

instance monoidObservableImpl :: Monoid (ObservableImpl a) where
  mempty = _empty_

instance functorObservableImpl :: Functor ObservableImpl where
  map = _map_

instance applyObservableImpl :: Apply ObservableImpl where
  apply = combineLatest_ id

instance applicativeObservableImpl :: Applicative ObservableImpl where
  pure = just_

instance bindObservableImpl :: Bind ObservableImpl where
  bind = mergeMap_

instance monadObservableImpl :: Monad ObservableImpl

instance semigroupObservableImpl :: Semigroup (ObservableImpl a) where
  append = merge_

instance altObservableImpl :: Alt ObservableImpl where
  alt = merge_

instance plusObservableImpl :: Plus ObservableImpl where
  empty = _empty_

instance alternativeObservableImpl :: Alternative ObservableImpl

instance monadZeroObservableImpl :: MonadZero ObservableImpl

instance monadPlusObservableImpl :: MonadPlus ObservableImpl

instance monadErrorObservableImpl :: MonadError Error ObservableImpl where
  catchError = catch_

instance monadThrowObservableImpl :: MonadThrow Error ObservableImpl where
  throwError = throw_

instance arbitraryObservableImpl :: Arbitrary a => Arbitrary (ObservableImpl a) where
  arbitrary = fromArray_ <$> (arrayOf arbitrary)


foreign import observeOn_ :: forall a. Scheduler -> ObservableImpl a -> ObservableImpl a

foreign import subscribeOn_ :: forall a. Scheduler -> ObservableImpl a -> ObservableImpl a

-- Subscription

foreign import subscribe_ :: forall a e. Subscriber a -> ObservableImpl a ->  Eff e Subscription

foreign import subscribeNext_ :: forall a e u. (a -> Eff e u) -> ObservableImpl a -> Eff e Subscription


-- Creation Operators


type Response =
  { body :: String
  , status :: Int
  , responseType :: String
  }

type Request =
  { url :: String
  , body :: String
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
  , body : body
  , timeout : 0
  , headers : empty
  , crossDomain : false
  , responseType : ""
  , method : method
  }


foreign import ajax_ :: forall e. String -> Eff e (ObservableImpl Response)
foreign import ajaxWithBody_ :: forall e. Request -> Eff e (ObservableImpl Response)
foreign import _empty_ :: forall a. ObservableImpl a
foreign import fromArray_ :: forall a. Array a -> ObservableImpl a
foreign import fromEventImpl_ :: forall e. EffFn2 e EventTarget String (ObservableImpl Event)
foreign import interval_ :: Int -> ObservableImpl Int
foreign import just_ :: forall a. a -> ObservableImpl a
foreign import create_ :: forall a e u. (Subscriber a -> Eff e u) -> Eff e (ObservableImpl a)
foreign import never_ :: forall a. ObservableImpl a
foreign import rangeImpl_ :: Fn2 Int Int (ObservableImpl Int)
foreign import throw_ :: forall a. Error -> ObservableImpl a
foreign import timerImpl_ :: Fn2 Int Int (ObservableImpl Int)
foreign import buffer_ :: forall a b. ObservableImpl b -> ObservableImpl a -> ObservableImpl (Array a)
foreign import bufferCount_ :: forall a. Int -> Int -> ObservableImpl a -> ObservableImpl (Array a)
foreign import bufferTimeImpl_ :: forall a. Fn4 Int Int Int (ObservableImpl a) (ObservableImpl (Array a))
foreign import bufferToggleImpl_
  :: forall a b c. Fn3 (ObservableImpl a) (ObservableImpl b) (b -> ObservableImpl c) (ObservableImpl (Array a))
foreign import bufferWhen_ :: forall a b. (a -> ObservableImpl b) -> ObservableImpl a -> ObservableImpl (Array a)
foreign import concatMap_ :: forall a b. (a -> ObservableImpl b) -> ObservableImpl a -> ObservableImpl b
foreign import exhaustMap_ :: forall a b. (a -> ObservableImpl b) -> ObservableImpl a -> ObservableImpl b
foreign import expand_ :: forall a. (a -> ObservableImpl a) -> ObservableImpl a -> ObservableImpl a
foreign import groupBy_ :: forall a b. (a -> b) -> ObservableImpl a -> ObservableImpl (ObservableImpl a)
foreign import _map_ :: forall a b. (a -> b) -> ObservableImpl a -> ObservableImpl b
foreign import mapTo_ :: forall a b. b -> ObservableImpl a -> ObservableImpl b
foreign import mergeMap_ :: forall a b. ObservableImpl a -> (a -> ObservableImpl b) -> ObservableImpl b
foreign import mergeMapTo_ :: forall a b. ObservableImpl a -> ObservableImpl b -> ObservableImpl b
foreign import pairwiseImpl_ :: forall a. ObservableImpl a -> ObservableImpl (Array a)
foreign import partitionImpl_ :: forall a. (a -> Boolean) -> ObservableImpl a -> Array (ObservableImpl a)
foreign import scan_ :: forall a b. (a -> b -> b) -> b -> ObservableImpl a -> ObservableImpl b
foreign import switchMap_ :: forall a b. (a -> ObservableImpl b) -> ObservableImpl a -> ObservableImpl b
foreign import switchMapTo_ :: forall a b. ObservableImpl b -> ObservableImpl a -> ObservableImpl b
foreign import window_ :: forall a b. ObservableImpl b -> ObservableImpl a -> ObservableImpl (ObservableImpl a)
foreign import windowCount_ :: forall a. Int -> Int -> ObservableImpl a -> ObservableImpl (ObservableImpl a)
foreign import windowTime_ :: forall a. Int -> Int -> ObservableImpl a -> ObservableImpl (ObservableImpl a)
foreign import audit_ :: forall a b. (a -> ObservableImpl b) -> ObservableImpl a -> ObservableImpl a
foreign import auditTime_ :: forall a. Int -> ObservableImpl a -> ObservableImpl a
foreign import debounce_ :: forall a. (a -> ObservableImpl Int) -> ObservableImpl a -> ObservableImpl a
foreign import debounceTime_ :: forall a. Int -> ObservableImpl a -> ObservableImpl a
foreign import distinct_ :: forall a. ObservableImpl a -> ObservableImpl a
foreign import distinctUntilChanged_ :: forall a. ObservableImpl a -> ObservableImpl a
foreign import elementAt_ :: forall a. Int -> ObservableImpl a -> ObservableImpl a
foreign import filter_ :: forall a. (a -> Boolean) -> ObservableImpl a -> ObservableImpl a
foreign import ignoreElements_ :: forall a. ObservableImpl a -> ObservableImpl a
foreign import last_ :: forall a. (a -> Boolean) ->  ObservableImpl a -> ObservableImpl a
foreign import sample_ :: forall a b. ObservableImpl b -> ObservableImpl a -> ObservableImpl a
foreign import sampleTime_ :: forall a. Int -> ObservableImpl a -> ObservableImpl a
foreign import skip_ :: forall a. Int -> ObservableImpl a -> ObservableImpl a
foreign import skipUntil_ :: forall a b. ObservableImpl b -> ObservableImpl a -> ObservableImpl a
foreign import skipWhile_ :: forall a. (a -> Boolean) -> ObservableImpl a -> ObservableImpl a
foreign import take_ :: forall a. Int -> ObservableImpl a -> ObservableImpl a
foreign import takeUntil_ :: forall a b. ObservableImpl b -> ObservableImpl a -> ObservableImpl a
foreign import takeWhile_ :: forall a. (a -> Boolean) -> ObservableImpl a -> ObservableImpl a
foreign import throttle_ :: forall a b. (a -> ObservableImpl b) -> ObservableImpl a -> ObservableImpl a
foreign import throttleTime_ :: forall a. Int -> ObservableImpl a -> ObservableImpl a
foreign import combineLatest_
  :: forall a b c. (a -> b -> c) -> ObservableImpl a -> ObservableImpl b -> ObservableImpl c
foreign import combineLatest3_
  :: forall a b c d. (a -> b -> c -> d) -> ObservableImpl a -> ObservableImpl b -> ObservableImpl c -> ObservableImpl d
foreign import concat_ :: forall a. ObservableImpl a -> ObservableImpl a -> ObservableImpl a
foreign import concatAll_ :: forall a. ObservableImpl (ObservableImpl a) -> ObservableImpl a
foreign import exhaust_ :: forall a. ObservableImpl (ObservableImpl a) -> ObservableImpl a
foreign import merge_ :: forall a. ObservableImpl a -> ObservableImpl a -> ObservableImpl a
foreign import mergeAll_ :: forall a. ObservableImpl (ObservableImpl a) -> ObservableImpl a
foreign import race_ :: forall a. Array (ObservableImpl a) -> ObservableImpl a
foreign import startWith_ :: forall a. a -> ObservableImpl a -> ObservableImpl a
foreign import withLatestFrom_
  :: forall a b c. (a -> b -> c) -> ObservableImpl b -> ObservableImpl a -> ObservableImpl c
foreign import zip_ :: forall a. Array (ObservableImpl a) -> ObservableImpl (Array a)
foreign import catch_ :: forall a. ObservableImpl a -> (Error -> ObservableImpl a) -> ObservableImpl a
foreign import retry_ :: forall a. Int -> ObservableImpl a -> ObservableImpl a
foreign import delay_ :: forall a. Int -> ObservableImpl a -> ObservableImpl a
foreign import delayWhen_ :: forall a b. (a -> ObservableImpl b) -> ObservableImpl a -> ObservableImpl a
foreign import dematerialize_ :: forall a. ObservableImpl (Notification a) -> ObservableImpl a
foreign import materializeImpl
  :: forall a.
     Fn4
     (ObservableImpl a)
     (a -> Notification a)
     (Error -> Notification a)
     (Notification a)
     (ObservableImpl (Notification a))
foreign import toArray_ :: forall a. ObservableImpl a -> ObservableImpl (Array a)
foreign import defaultIfEmpty_ :: forall a. a -> ObservableImpl a -> ObservableImpl a
foreign import every_ :: forall a. (a -> Boolean) -> ObservableImpl a -> ObservableImpl Boolean
foreign import isEmpty_ :: forall a. ObservableImpl a -> ObservableImpl Boolean
foreign import share_ :: forall a. ObservableImpl a -> ObservableImpl a
foreign import first_ :: forall a. (a -> Boolean) -> ObservableImpl a -> ObservableImpl a
foreign import count_ :: forall a. ObservableImpl a -> ObservableImpl Int
foreign import reduce_ :: forall a b. (a -> b -> b) -> b -> ObservableImpl a -> ObservableImpl b
foreign import unwrap_ :: forall a e. ObservableImpl (Eff e a) -> Eff e (ObservableImpl a)

--- ObservableT

newtype ObservableT m a = ObservableT (m (ObservableImpl a))
type Observable a = ObservableT Identity a

liftT :: forall a. ObservableImpl a -> Observable a
liftT = ObservableT <<< pure

runObservableT :: forall m a. ObservableT m a -> m (ObservableImpl a)
runObservableT (ObservableT m) = m


instance functorObservableT :: (Functor f) => Functor (ObservableT f) where
  map f (ObservableT fo) =
    ObservableT (map (map f) fo)

instance combineInnerervableT :: Apply f => Apply (ObservableT f) where
  apply = combineLatest id

instance applicativeObservableT :: Applicative f => Applicative (ObservableT f) where
  pure = just

instance semigroupObservableT :: Apply f => Semigroup (ObservableT f a) where
  append = merge

instance monoidObservableT :: Applicative f => Monoid (ObservableT f a) where
  mempty = _empty

instance altObservableT :: Apply f => Alt (ObservableT f) where
  alt = merge

instance plusObservableT :: Applicative f => Plus (ObservableT f) where
  empty = _empty

instance bindObservableT :: Monad m => Bind (ObservableT m) where
  bind = mergeMap

instance monadObservableT :: Monad m => Monad (ObservableT m)

instance alternativeObservableT :: Monad m => Alternative (ObservableT m)

instance monadZeroObservableT :: Monad m => MonadZero (ObservableT m)

instance monadPlusObservableT :: Monad m => MonadPlus (ObservableT m)


combineInner :: forall a b c f. Apply f => (ObservableImpl a -> ObservableImpl b -> ObservableImpl c)
                             -> ObservableT f a
                             -> ObservableT f b
                             -> ObservableT f c
combineInner f (ObservableT fa) (ObservableT fb) =
  let fc = f <$> fa <*> fb
  in ObservableT fc

combineInner3 :: forall a b c d f. Apply f => (ObservableImpl a -> ObservableImpl b -> ObservableImpl c -> ObservableImpl d)
                             -> ObservableT f a
                             -> ObservableT f b
                             -> ObservableT f c
                             -> ObservableT f d
combineInner3 f (ObservableT fa) (ObservableT fb) (ObservableT fc) =
  let fd = f <$> fa <*> fb <*> fc
  in ObservableT fd

mapInner :: forall a b f. Functor f => (ObservableImpl a -> ObservableImpl b) -> ObservableT f a -> ObservableT f b
mapInner f (ObservableT fo) = ObservableT (map f fo)


flattenHelper :: forall a e m. Monad m => ObservableImpl (ObservableT m a) -> Subscriber a -> Eff e Subscription
flattenHelper oeoa subscriber =
  oeoa # subscribeNext_ (\(ObservableT inner) -> subscribeToResult inner subscriber)

subscribeToResult :: forall a e m. Monad m => m (ObservableImpl a) -> Subscriber a -> Eff e Unit
subscribeToResult inner subscriber =
  let something = do
        innerObservable <- inner
        let eff = innerObservable # subscribeNext_ (\value -> subscriber.next value)
        pure (unsafePerformEff eff)
  in pure unit


-- Public api:



-- | An Observable of projected values from the most recent values from each input Observable.
-- | ![marble diagram](http://reactivex.io/documentation/operators/images/combineLatest.png)
combineLatest3 :: forall a b c d f. Apply f =>
  (a -> b -> c -> d) -> ObservableT f a -> ObservableT f b -> ObservableT f c -> ObservableT f d
combineLatest3 selector = combineInner3 (combineLatest3_ selector)

-- | An Observable of projected values from the most recent values from each input
-- | ![marble diagram](http://reactivex.io/documentation/operators/images/combineLatest.png)
combineLatest :: forall a b c f. Apply f => (a -> b -> c) -> ObservableT f a -> ObservableT f b -> ObservableT f c
combineLatest selector = combineInner (combineLatest_ selector)

-- | Creates an output ObservableImpl which concurrently emits all values from each input ObservableImpl.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/merge.png)
merge :: forall a f. Apply f => ObservableT f a -> ObservableT f a -> ObservableT f a
merge = combineInner merge_


fromObservable :: forall a f. Applicative f => ObservableImpl a -> ObservableT f a
fromObservable o = ObservableT (pure o)

liftF :: forall a f. Applicative f => f a -> ObservableT f a
liftF f = ObservableT (map pure f)


_mergeAll :: forall a m. Monad m => ObservableT m (ObservableT m a) -> ObservableT m a
_mergeAll (ObservableT outer) =
  let observable = create_ (\subscriber -> do
        let subscription =
              map (\inner -> unsafePerformEff (flattenHelper inner subscriber)) outer
        pure unit)
  in ObservableT (pure (unsafePerformEff observable))


--join_ :: forall a m. Monad m => ObservableT m (ObservableT m a) -> ObservableT m a


-- | Creates an ObservableImpl that immediately sends an error notification.
throw :: forall a f. Applicative f => Error -> ObservableT f a
throw err = ObservableT (pure (throw_ err))


-- | Creates an ObservableImpl that emits the value specify,
-- | and then emits a complete notification.  An alias for `of`.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/from.png)
just :: forall a f. Applicative f => a -> ObservableT f a
just a = ObservableT (pure (just_ a))

ajaxUrl :: forall e. String -> ObservableT (Eff e) Response
ajaxUrl url =
  ObservableT (ajax_ url)

ajax :: forall e. Request -> ObservableT (Eff e) Response
ajax req =
  ObservableT (ajaxWithBody_ req)

_empty :: forall a f. Applicative f => ObservableT f a
_empty = ObservableT (pure _empty_)

-- | Creates an ObservableImpl that emits no items.  Subscriptions it must be
-- | disposed manually.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/never.png)
never :: forall a f. Applicative f => ObservableT f a
never = ObservableT (pure never_)

-- | Creates an ObservableImpl from an Array.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/from.png)
fromArray :: forall a f. Applicative f => Array a -> ObservableT f a
fromArray arr = ObservableT (pure (fromArray_ arr))

-- | Creates an ObservableImpl that emits events of the specified type coming from the given event target.
fromEvent :: forall e. EventTarget -> EventType -> ObservableT (Eff (dom :: DOM | e) ) Event
fromEvent target (EventType str) = ObservableT $ runEffFn2 fromEventImpl_ target str

-- | Returns an ObservableImpl that emits an infinite sequence of ascending
-- | integers, with a constant interval of time of your choosing between those
-- | emissions.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/interval.png)
interval :: forall f. Applicative f => Int -> ObservableT f Int
interval period = ObservableT (pure (interval_ period))

-- | The range operator emits a range of sequential integers, in order, where
-- | you select the start of the range and its length
-- | ![marble diagram](http://reactivex.io/rxjs/img/range.png)
range :: forall f. Applicative f => Int -> Int -> ObservableT f Int
range r l = ObservableT (pure (runFn2 rangeImpl_ r l))

-- | Creates an Observable that, upon subscription, emits and infinite sequence of ascending integers,
-- | after a specified delay, every specified period.  Delay and period are in
-- | milliseconds.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/timer.png)
timer :: forall f. Applicative f => Int -> Int -> ObservableT f Int
timer dly period = ObservableT (pure (runFn2 timerImpl_ dly period))


create :: forall a e u. (Subscriber a -> Eff e u) -> ObservableT (Eff e) a
create fn = ObservableT (create_ fn)

-- | Collects values from the first Observable into an Array, and emits that array only when
-- | second Observable emits.
-- | ![marble diagram](http://reactivex.io/documentation/operators/images/buffer1.png)
buffer :: forall a b f. Apply f => ObservableT f b -> ObservableT f a -> ObservableT f (Array a)
buffer = combineInner buffer_

-- | Collects values from the past as an array, emits that array when
-- | its size (arg1) reaches the specified buffer size, and starts a new buffer.
-- | The new buffer starts with nth (arg2) element of the Observable counting
-- | from the beginning of the *last* buffer.
-- | ![marble diagram](http://reactivex.io/documentation/operators/images/buffer1.png)
bufferCount :: forall a f. Functor f => Int -> Int -> ObservableT f a -> ObservableT f (Array a)
bufferCount size offset = mapInner (bufferCount_ size offset)

-- | Collects values from the past as an array, and emits those arrays
-- | periodically in time.  The first argument is how long to fill the buffer.
-- | The second argument is specifies when to open the next buffer following an
-- | emission.  The third argument is the maximum size of any buffer.
bufferTime :: forall a f. Functor f => Int -> Int -> Int -> (ObservableT f a) -> (ObservableT f (Array a))
bufferTime time opens size = mapInner (runFn4 bufferTimeImpl_ time opens size)

-- | Emits the given constant value on the output Observable every time
-- | the source Observable emits a value.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/map.png)
mapTo :: forall a b f. Functor f => b -> ObservableT f a -> ObservableT f b
mapTo b = mapInner (mapTo_ b)

-- | Puts the current value and previous value together as an array, and emits that.
-- | ![marble diagram](http://reactivex.io/rxjs/img/pairwise.png)
pairwise :: forall a f. Functor f => ObservableT f a -> ObservableT f (Tuple a a)
pairwise src =
  let arrays = mapInner pairwiseImpl_ src
      toTuple arr = unsafePartial (Tuple (Array.head arr) (Array.last arr))
  in map toTuple arrays

-- | Given a predicate function (arg1), and an Observable (arg2), it outputs a
-- | two element array of partitioned values
-- | (i.e., [ Observable valuesThatPassPredicate, Observable valuesThatFailPredicate ]).
-- | ![marble diagram](http://reactivex.io/rxjs/img/partition.png)
partition :: forall a f. Applicative f => (a -> Boolean) -> ObservableT f a -> Tuple (ObservableT f a) (ObservableT f a)
partition predicate (ObservableT src) =
  let toTuple arr = unsafePartial (Tuple (Array.head arr) (Array.last arr))
      partitioned = map ((partitionImpl_ predicate) >>> toTuple) src
      firstT = ObservableT (map fst partitioned)
      secondT = ObservableT (map snd partitioned)
  in Tuple firstT secondT


-- | Maps each value to an Observable, then flattens all of these Observables
-- | using mergeAll.  It's just monadic `bind`.
-- | ![marble diagram](http://reactivex.io/documentation/operators/images/flatMap.c.png)
mergeMap :: forall a b m. Monad m => ObservableT m a -> (a -> ObservableT m b) -> ObservableT m b
mergeMap ma f = join_ (map f ma)

-- | Maps each value of the ObservableImpl (arg1) to the same inner ObservableImpl (arg2),
-- | then flattens the result.
-- | ![marble diagram](http://reactivex.io/documentation/operators/images/flatMap.c.png)
mergeMapTo :: forall a b m. Apply m => ObservableT m a -> ObservableT m b -> ObservableT m b
mergeMapTo = combineInner mergeMapTo_

-- | Given an accumulator function (arg1), an initial value (arg2), and
-- | a source ObservableImpl (arg3), it returns an ObservableImpl that emits the current
-- | accumlation whenever the source emits a value.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/scanSeed.png)
scan :: forall a b f. Functor f => (a -> b -> b) -> b -> ObservableT f a -> ObservableT f b
scan reducer seed = mapInner (scan_ reducer seed)


-- | It's like delay, but passes only the most recent value from each burst of emissions.
debounceTime :: forall a f. Functor f => Int -> ObservableT f a -> ObservableT f a
debounceTime time = mapInner (debounceTime_ time)
-- | Returns an Observable that emits all items emitted by the source Observable
-- | that are distinct by comparison from previous items.
-- | ![marble diagram](http://reactivex.io/documentation/operators/images/distinct.png)
distinct :: forall a f. Functor f => ObservableT f a -> ObservableT f a
distinct = mapInner distinct_

-- | Returns an Observable that emits all items emitted by the source Observable
-- | that are distinct by comparison from the previous item.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/distinctUntilChanged.key.png)
distinctUntilChanged :: forall a f. Functor f => ObservableT f a -> ObservableT f a
distinctUntilChanged = mapInner distinctUntilChanged_

-- | Emits the single value at the specified index in a sequence of emissions
-- | from the source
elementAt :: forall a f. Functor f => Int -> ObservableT f a -> ObservableT f a
elementAt index = mapInner (elementAt_ index)

-- | Filter items emitted by the source Observable by only emitting those that
-- | satisfy a specified predicate.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/filter.png)
filter :: forall a f. Functor f => (a -> Boolean) -> ObservableT f a -> ObservableT f a
filter predicate = mapInner (filter_ predicate)

-- | Ignores all items emitted by the source Observable and only passes calls of complete or error.
-- | ![marble diagram](http://reactivex.io/rxjs/img/ignoreElements.png)
ignoreElements :: forall a f. Functor f => ObservableT f a -> ObservableT f a
ignoreElements = mapInner ignoreElements_

-- | Returns an Observable that emits only the last item emitted by the source
-- | Observable that that satisfies the given predicate.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/last.png)
last :: forall a f. Functor f => (a -> Boolean) -> ObservableT f a -> ObservableT f a
last predicate = mapInner (last_ predicate)


-- | It's like sampleTime, but samples whenever the notifier Observable emits something.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/sample.o.png)
sample :: forall a b f. Apply f => ObservableT f b -> ObservableT f a -> ObservableT f a
sample = combineInner sample_


-- | Periodically looks at the source Observable and emits whichever
-- | value it has most recently emitted since the previous sampling, unless the source has not emitted anything since the previous sampling.
sampleTime :: forall a f. Functor f => Int -> ObservableT f a -> ObservableT f a
sampleTime time = mapInner (sampleTime_ time)

-- | Returns an Observable that skips n items emitted by an
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/skip.png)
skip :: forall a f. Functor f => Int -> ObservableT f a -> ObservableT f a
skip amount = mapInner (skip_ amount)

-- | Returns an Observable that skips items emitted by the source Observable until a second Observable emits an item.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/skipUntil.png)
skipUntil :: forall a b f. Apply f => ObservableT f b -> ObservableT f a -> ObservableT f a
skipUntil = combineInner skipUntil_

-- | Returns an Observable that skips all items emitted
-- | by the source Observable as long as a specified condition holds true,
-- | but emits all further source items as soon as the condition becomes false.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/skipWhile.png)
skipWhile :: forall a f. Functor f => (a -> Boolean) -> ObservableT f a -> ObservableT f a
skipWhile predicate = mapInner (skipWhile_ predicate)

-- | Emits only the first n values emitted by the source
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/take.png)
take :: forall a f. Functor f => Int -> ObservableT f a -> ObservableT f a
take amount = mapInner (take_ amount)

-- | Lets values pass until a second Observable emits something. Then, it completes.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/takeUntil.png" alt=""
takeUntil :: forall a b f. Apply f => ObservableT f b -> ObservableT f a -> ObservableT f a
takeUntil = combineInner takeUntil_

-- | Emits values emitted by the source Observable so long as each value satisfies
-- | the given predicate, and then completes as soon as this predicate is not satisfied.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/takeWhile.png)
takeWhile :: forall a f. Functor f => (a -> Boolean) -> ObservableT f a -> ObservableT f a
takeWhile predicate = mapInner (takeWhile_ predicate)

-- | Ignores source values for duration milliseconds,
-- | then emits the most recent value from the source Observable, then repeats this process.
-- | ![marble diagram](http://reactivex.io/rxjs/img/auditTime.png)
auditTime :: forall a f. Functor f => Int -> ObservableT f a -> ObservableT f a
auditTime time = mapInner (auditTime_ time)


-- | Emits a value from the source Observable, then ignores subsequent source values
-- | for duration milliseconds, then repeats this process.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/throttleWithTimeout.png)
throttleTime :: forall a f. Functor f => Int -> ObservableT f a -> ObservableT f a
throttleTime time = mapInner (throttleTime_ time)


-- | Returns an Observable that emits the items in the given Foldable before
-- | it begins to emit items emitted by the source Observable.
startWithMany :: forall f a m. Foldable f => Functor m => f a -> ObservableT m a -> ObservableT m a
startWithMany xs obs =
  foldr (\cur acc -> startWith cur acc) obs xs

-- | Returns an Observable that emits the item given before
-- | it begins to emit items emitted by the source Observable.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/startWith.png)
startWith :: forall a f. Functor f => a -> ObservableT f a -> ObservableT f a
startWith a = mapInner (startWith_ a)

-- | Combines each value from the source Observables using a project function to
-- | determine the value to be emitted on the output
-- | ![marble diagram](https://raw.github.com/wiki/ReactiveX/RxJava/images/rx-operators/withLatestFrom.png" alt="">
withLatestFrom :: forall a b c f. Apply f => (a -> b -> c) -> ObservableT f b -> ObservableT f a -> ObservableT f c
withLatestFrom selector = combineInner (withLatestFrom_ selector)


-- | Concatenates two Observables together by sequentially emitting their values, one Observable after the other.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/concat.png)
concat :: forall a f. Apply f => ObservableT f a -> ObservableT f a -> ObservableT f a
concat = combineInner concat_

-- | It's like switchMap, but maps each value to the same inner ObservableImpl.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/switchMap.png)
switchMapTo :: forall a b f. Apply f => ObservableT f b -> ObservableT f a -> ObservableT f b
switchMapTo = combineInner switchMapTo_

-- | If the source Observable calls error, this method will resubscribe to the
-- | source Observable n times rather than propagating the error call.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/retry.png)
retry :: forall a f. Functor f => Int -> ObservableT f a -> ObservableT f a
retry amount = mapInner (retry_ amount)

-- Utility Operators
-- | Time shifts each item by some specified amount of milliseconds.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/delay.png)
delay :: forall a f. Functor f => Int -> ObservableT f a -> ObservableT f a
delay ms = mapInner (delay_ ms)



-- | Returns an Observable that emits the items emitted by the source Observable or a specified default item
-- | if the source Observable is empty.
-- |
-- | ![marble diagram](http://reactivex.io/documentation/operators/images/defaultIfEmpty.c.png)
-- |
-- | takes a defaultValue which is the item to emit if the source Observable emits no items.
-- |
-- | returns an Observable that emits either the specified default item if the source Observable emits no
-- |         items, or the items emitted by the source Observable
defaultIfEmpty :: forall a f. Functor f => a -> ObservableT f a -> ObservableT f a
defaultIfEmpty default = mapInner (defaultIfEmpty_ default)


-- | Determines whether all elements of an observable sequence satisfy a condition.
-- | Returns an observable sequence containing a single element determining whether all
-- | elements in the source sequence pass the test in the specified predicate.
every :: forall a f. Functor f => (a -> Boolean) -> ObservableT f a -> ObservableT f Boolean
every predicate = mapInner (every_ predicate)
-- | Tests whether this `Observable` emits no elements.
-- |
-- | returns an Observable emitting one single Boolean, which is `true` if this `Observable`
-- |         emits no elements, and `false` otherwise.
isEmpty :: forall a f. Functor f => ObservableT f a -> ObservableT f Boolean
isEmpty = mapInner isEmpty_

-- | Returns a new Observable that multicasts (shares) the original Observable. As long a
-- | there is more than 1 Subscriber, this Observable will be subscribed and emitting data.
-- | When all subscribers have unsubscribed it will unsubscribe from the source Observable.
-- |
-- | This is an alias for `publish().refCount()`
-- |
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/publishRefCount.png)
-- |
-- | returns an Observable that upon connection causes the source Observable to emit items to its Subscribers
share :: forall a f. Functor f => ObservableT f a -> ObservableT f a
share = mapInner share_

-- | Returns an Observable that emits only the first item emitted by the source
-- | Observable that satisfies the given predicate.
first :: forall a f. Functor f => (a -> Boolean) -> ObservableT f a -> ObservableT f a
first predicate = mapInner (first_ predicate)

-- | Counts the number of emissions on the source and emits that number when the source completes.
count :: forall a f. Functor f => ObservableT f a -> ObservableT f Int
count = mapInner count_
-- | Applies an accumulator function over the source Observable, and returns the accumulated
-- | result when the source completes, given a seed value.
reduce :: forall a b f. Functor f => (a -> b -> b) -> b -> ObservableT f a -> ObservableT f b
reduce accumulator seed = mapInner (reduce_ accumulator seed)

-- | Makes every `next` call run in the new Scheduler.
observeOn :: forall a f. Functor f => Scheduler -> ObservableT f a -> ObservableT f a
observeOn scheduler = mapInner (observeOn_ scheduler)

-- | Makes subscription happen on a given Scheduler.
subscribeOn :: forall a f. Functor f => Scheduler -> ObservableT f a -> ObservableT f a
subscribeOn scheduler = mapInner (subscribeOn_ scheduler)

-- Subscribe to an ObservableImpl, supplying only the `next` function.
subscribeNext :: forall a f e u. Functor f => (a -> Eff e u) -> ObservableT f a -> f (Eff e Subscription)
subscribeNext next (ObservableT fo) = map (subscribeNext_ next) fo

--foreign import subscribeNext_' :: forall a e u. (a -> Eff e u) -> ObservableImpl a -> Eff e Subscription

create' :: forall a e u. (Subscriber a -> Eff e u) -> ObservableT (Eff e) a
create' fn = ObservableT (create_ fn)

--foreign import bind' :: forall m a b. Monad m => m a -> (a -> m b) -> m b
--foreign import join' :: forall m a. Monad m => m (m a) -> m a

-- create -> Eff e (Observable a)
-- subscribeToOuter -> m (Eff e Subscription)
-- inner :: a


{-
outer :: m (ObservableImpl (m (ObservableImpl a)))
-}
join_ :: forall m a. Monad m => ObservableT m (ObservableT m a) -> ObservableT m a
join_ outer = create(\observer ->
  pure (outer # subscribeNext (\monadOfInner ->
    pure (monadOfInner # subscribeNext(\value ->
      observer.next value
    ) # map unsafePerformEff)
  ) # map unsafePerformEff)
) # runObservableT # unsafePerformEff # pure # ObservableT


-- | Subscribing to an ObservableImpl is like calling a function, providing
-- | `next`, `error` and `completed` effects to which the data will be delivered.
subscribe :: forall a f e. Functor f => Subscriber a -> ObservableT f a -> f (Eff e Subscription)
subscribe subscriber (ObservableT fo) = map (subscribe_ subscriber) fo

-- | Returns an ObservableImpl that reverses the effect of `materialize` by
-- | `Notification` objects emitted by the source ObservableImpl into the items
-- | or notifications they represent.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/dematerialize.png)
dematerialize :: forall a f. Functor f => ObservableT f (Notification a) -> ObservableT f a
dematerialize = mapInner (\o -> dematerialize_ o)

-- | Turns all of the notifications from a source ObservableImpl into onNext emissions,
-- | and marks them with their original notification types within `Notification` objects.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/materialize.png)
materialize :: forall a f. Functor f => ObservableT f a -> ObservableT f (Notification a)
materialize = mapInner (\o -> runFn4 materializeImpl o OnNext OnError OnComplete)


-- | Returns an ObservableImpl that emits a single item, a list composed of all the items emitted by the source ObservableImpl.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/toList.png)
toArray :: forall a f. Functor f => ObservableT f a -> ObservableT f (Array a)
toArray = mapInner toArray_

--Observable only

unwrapInnerFn :: forall a b c. Comonad c => (a -> ObservableT c b) -> a -> ObservableImpl b
unwrapInnerFn fn a = unwrapId (fn a)

unwrapId :: forall a c. Comonad c => ObservableT c a -> ObservableImpl a
unwrapId = runObservableT >>> extract



-- | Collects values from the source ObservableImpl (arg1) as an array. Starts collecting only when
-- | the opening (arg2) ObservableImpl emits, and calls the closingSelector function (arg3) to get an ObservableImpl
-- | that decides when to close the buffer.  Another buffer opens when the
-- | opening ObservableImpl emits its next value.
-- | ![marble diagram](http://reactivex.io/documentation/operators/images/buffer2.png)
bufferToggle
  :: forall a b c. Observable a
  -> Observable b
  -> (b -> Observable c)
  -> Observable (Array a)
bufferToggle as bs f = liftT (runFn3 bufferToggleImpl_ (unwrapId as) (unwrapId bs) (unwrapInnerFn f))


-- | It's like auditTime, but the silencing duration is determined by a second ObservableImpl.
-- | ![marble diagram](http://reactivex.io/rxjs/img/audit.png)
audit :: forall a b. (a -> Observable b) -> Observable a -> Observable a
audit fn as = liftT $ audit_ (unwrapInnerFn fn) (unwrapId as)


-- | It's like debounceTime, but the time span of emission silence is determined
-- | by a second ObservableImpl.  Allows for a variable debounce rate.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/debounce.f.png)
debounce :: forall a. (a -> Observable Int) -> Observable a -> Observable a
debounce fn as = liftT $ debounce_ (unwrapInnerFn fn) (unwrapId as)

-- | Collects values from the past as an array. When it starts collecting values,
-- | it calls a function that returns an ObservableImpl that emits to close the
-- | buffer and restart collecting.
-- | ![marble diagram](http://reactivex.io/documentation/operators/images/buffer1.png)
bufferWhen :: forall a b. (a -> Observable b) -> Observable a -> Observable (Array a)
bufferWhen fn as = liftT $ bufferWhen_ (unwrapInnerFn fn) (unwrapId as)


-- | Equivalent to mergeMap (a.k.a, `>>=`) EXCEPT that, unlike mergeMap,
-- | the next bind will not run until the ObservableImpl generated by the projection function (arg2)
-- | completes.  That is, composition is sequential, not concurrent.
-- | Warning: if source values arrive endlessly and faster than their corresponding
-- | inner ObservableImpls can complete, it will result in memory issues as inner
-- | ObservableImpls amass in an unbounded buffer waiting for their turn to be subscribed to.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/concatMap.png)
concatMap :: forall a b. (a -> Observable b) -> Observable a -> Observable b
concatMap fn as = liftT $ concatMap_ (unwrapInnerFn fn) (unwrapId as)



-- | It's Like concatMap (a.k.a, `>>=`) EXCEPT that it ignores every new projected
-- | ObservableImpl if the previous projected ObservableImpl has not yet completed.
-- | ![marble diagram](http://reactivex.io/rxjs/img/exhaustMap.png)
exhaustMap :: forall a b. (a -> Observable b) -> Observable a -> Observable b
exhaustMap fn as = liftT $ exhaustMap_ (unwrapInnerFn fn) (unwrapId as)


-- | It's similar to mergeMap, but applies the projection function to every source
-- | value as well as every output value. It's recursive.
expand :: forall a. (a -> Observable a) -> Observable a -> Observable a
expand fn as = liftT $ expand_ (unwrapInnerFn fn) (unwrapId as)

-- | Groups the items emitted by an ObservableImpl (arg2) according to the value
-- | returned by the grouping function (arg1).  Each group becomes its own
-- | ObservableImpl.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/groupBy.png)
groupBy :: forall a b. (a -> b) -> Observable a -> Observable (Observable a)
groupBy fn as = map liftT (liftT $ groupBy_ fn (unwrapId as))


-- | Projects each source value to an ObservableImpl which is merged in the output
-- | ObservableImpl, emitting values only from the most recently projected ObservableImpl.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/switchMap.png)
switchMap :: forall a b. (a -> Observable b) -> Observable a -> Observable b
switchMap f as = liftT $ switchMap_ (unwrapInnerFn f) (unwrapId as)

-- | Delays the emission of items from the source ObservableImpl by a given time
-- | span determined by the emissions of another ObservableImpl.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/delay.o.png)
delayWhen :: forall a b. (a -> Observable b) -> Observable a -> Observable a
delayWhen f as = liftT $ delayWhen_ (unwrapInnerFn f) (unwrapId as)

-- | Converts a higher-order ObservableImpl into a first-order ObservableImpl by concatenating the inner ObservableImpls in order.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/concat.png)
concatAll :: forall a. Observable (Observable a) -> Observable a
concatAll ho = liftT $ concatAll_ (unwrapId (map unwrapId ho))

-- | Converts a higher-order ObservableImpl into a first-order ObservableImpl
-- | which concurrently delivers all values that are emitted on the inner ObservableImpls.
-- | ![marble diagram](http://reactivex.io/documentation/operators/images/mergeAll.png)
mergeAll :: forall a. Observable (Observable a) -> Observable a
mergeAll ho = liftT $ mergeAll_ (unwrapId (map unwrapId ho))

-- | Returns an ObservableImpl that mirrors the first source ObservableImpl to emit an
-- | item from the array of ObservableImpls.
race :: forall a. Array (Observable a) -> Observable a
race arr = liftT $ race_ (map unwrapId arr)

-- | Flattens an Observable-of-Observable by dropping the next inner Observables
-- | while the current inner is still executing.
-- | ![marble diagram](http://reactivex.io/rxjs/img/exhaust.png)
exhaust :: forall a. Observable (Observable a) -> Observable a
exhaust ho = liftT $ exhaust_ (unwrapId (map unwrapId ho))

-- | It's like buffer, but emits a nested ObservableImpl instead of an array.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/window8.png)
window :: forall a b. Observable b -> Observable a -> Observable (Observable a)
window bs as = map liftT (liftT $ window_ (unwrapId bs) (unwrapId as))


-- | It's like bufferCount, but emits a nested ObservableImpl instead of an array.
windowCount :: forall a. Int -> Int -> Observable a -> Observable (Observable a)
windowCount size offset as = map liftT (liftT $ windowCount_ size offset (unwrapId as))

-- | It's like bufferTime, but emits a nested ObservableImpl instead of an array,
-- | and it doesn't take a maximum size parameter.  arg1 is how long to
-- | buffer items into a new ObservableImpl, arg2 is the when the next buffer should begin,
-- | and arg3 is the source ObservableImpl.
windowTime :: forall a. Int -> Int -> Observable a -> Observable (Observable a)
windowTime time opens as = map liftT (liftT $ windowTime_ time opens (unwrapId as))


-- | It's like throttleTime, but the silencing duration is determined by a second ObservableImpl.
-- | ![marble diagram](http://reactivex.io/rxjs/img/throttle.png)
throttle :: forall a b. (a -> Observable b) -> Observable a -> Observable a
throttle f as = liftT $ throttle_ (unwrapInnerFn f) (unwrapId as)

-- | Waits for each ObservableImpl to emit a value. Once this occurs, all values
-- | with the corresponding index will be emitted. This will continue until at
-- | least one inner ObservableImpl completes.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/zip.i.png)
zip :: forall a. Array (Observable a) -> Observable (Array a)
zip arr = liftT $ zip_ (map unwrapId arr)

-- Error Handling Operators
-- | ![marble diagram](http://reactivex.io/documentation/operators/images/catch.js.png)
catch :: forall a. Observable a -> (Error -> Observable a) -> Observable a
catch as f = liftT $ catch_ (unwrapId as) (unwrapInnerFn f)
