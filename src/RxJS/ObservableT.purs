module RxJS.Observable.Trans where

import RxJS.Observable as Observable
import Control.Alt (class Alt)
import Control.Alternative (class Alternative, class Apply)
import Control.Applicative (class Applicative)
import Control.Monad (class Monad)
import Control.Monad.Eff (Eff, runPure)
import Control.Monad.Eff.Exception (Error)
import Control.Monad.Eff.Unsafe (unsafePerformEff)
import Control.MonadPlus (class MonadPlus)
import Control.MonadZero (class MonadZero)
import Control.Plus (class Plus, empty)
import DOM (DOM)
import DOM.Event.Event (Event)
import DOM.Event.Types (EventTarget, EventType)
import Data.Monoid (class Monoid)
import Data.Foldable (class Foldable)
import Data.Unit (unit)
import Data.Tuple (Tuple(..), fst, snd)
import Prelude (class Bind, class Functor, class Semigroup, Unit, bind, flip, id, map, pure, (#), (<$>), (<*>))
import RxJS.Observable (Observable, RX, Request, Response)
import RxJS.Subscriber (Subscriber)
import RxJS.Scheduler (Scheduler)
import RxJS.Subscription (Subscription)


newtype ObservableT m a = ObservableT (m (Observable a))

type EffRx e a = Eff (rx :: RX | e) a

instance functorObservableT :: (Functor f) => Functor (ObservableT f) where
  map f (ObservableT fo) =
    ObservableT (map (map f) fo)

instance applyObservableT :: Apply f => Apply (ObservableT f) where
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



-- | An Observable of projected values from the most recent values from each input Observable.
-- | ![marble diagram](http://reactivex.io/documentation/operators/images/combineLatest.png)
combineLatest3 :: forall a b c d f. Apply f =>
  (a -> b -> c -> d) -> ObservableT f a -> ObservableT f b -> ObservableT f c -> ObservableT f d
combineLatest3 selector= applyObs3 (Observable.combineLatest3 selector)

-- | An Observable of projected values from the most recent values from each input Observable.
-- | ![marble diagram](http://reactivex.io/documentation/operators/images/combineLatest.png)
combineLatest :: forall a b c f. Apply f => (a -> b -> c) -> ObservableT f a -> ObservableT f b -> ObservableT f c
combineLatest selector = applyObs (Observable.combineLatest selector)

merge :: forall a f. Apply f => ObservableT f a -> ObservableT f a -> ObservableT f a
merge = applyObs Observable.merge



fromObservable :: forall a f. Applicative f => Observable a -> ObservableT f a
fromObservable o = ObservableT (pure o)

liftF :: forall a f. Applicative f => f a -> ObservableT f a
liftF f = ObservableT (map pure f)


mergeAll_ :: forall a m. Monad m => ObservableT m (ObservableT m a) -> ObservableT m a
mergeAll_ (ObservableT outer) =
  let observable = Observable.create (\subscriber -> do
        let subscription =
              map (\inner -> unsafePerformEff (flattenHelper inner subscriber)) outer
        pure unit)
  in ObservableT (pure (unsafePerformEff observable))



throw :: forall a f. Applicative f => Error -> ObservableT f a
throw err = ObservableT (pure (Observable.throw err))


just :: forall a f. Applicative f => a -> ObservableT f a
just a = ObservableT (pure (Observable.just a))

ajax :: forall e. String -> ObservableT (Eff e) Response
ajax url =
  ObservableT (Observable.ajax url)

ajaxWithBody :: forall e. Request -> ObservableT (Eff e) Response
ajaxWithBody req =
  ObservableT (Observable.ajaxWithBody req)

_empty :: forall a f. Applicative f => ObservableT f a
_empty = ObservableT (pure empty)

never :: forall a f. Applicative f => ObservableT f a
never = ObservableT (pure Observable.never)

fromArray :: forall a f. Applicative f => Array a -> ObservableT f a
fromArray arr = ObservableT (pure (Observable.fromArray arr))

fromEvent :: forall e. EventTarget -> EventType -> ObservableT (Eff (dom :: DOM | e) ) Event
fromEvent target ev = ObservableT (Observable.fromEvent target ev)

interval :: forall f. Applicative f => Int -> ObservableT f Int
interval period = ObservableT (pure (Observable.interval period))

range :: forall f. Applicative f => Int -> Int -> ObservableT f Int
range r l = ObservableT (pure (Observable.range r l))

-- | Creates an Observable that, upon subscription, emits and infinite sequence of ascending integers,
-- | after a specified delay, every specified period.  Delay and period are in
-- | milliseconds.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/timer.png)
timer :: forall f. Applicative f => Int -> Int -> ObservableT f Int
timer dly period = ObservableT (pure (Observable.timer dly period))


create :: forall a e u. (Subscriber a -> Eff e u) -> ObservableT (Eff (rx:: RX | e)) a
create fn = ObservableT (Observable.create fn)

-- | Collects values from the first Observable into an Array, and emits that array only when
-- | second Observable emits.
-- | ![marble diagram](http://reactivex.io/documentation/operators/images/buffer1.png)
buffer :: forall a b f. Apply f => ObservableT f a -> ObservableT f b -> ObservableT f (Array a)
buffer = applyObs Observable.buffer

-- | Collects values from the past as an array, emits that array when
-- | its size (arg1) reaches the specified buffer size, and starts a new buffer.
-- | The new buffer starts with nth (arg2) element of the Observable counting
-- | from the beginning of the *last* buffer.
-- | ![marble diagram](http://reactivex.io/documentation/operators/images/buffer1.png)
bufferCount :: forall a f. Functor f => Int -> Int -> ObservableT f a -> ObservableT f (Array a)
bufferCount size offset = mapObs (Observable.bufferCount size offset)

-- | Collects values from the past as an array, and emits those arrays
-- | periodically in time.  The first argument is how long to fill the buffer.
-- | The second argument is specifies when to open the next buffer following an
-- | emission.  The third argument is the maximum size of any buffer.
bufferTime :: forall a f. Functor f => Int -> Int -> Int -> (ObservableT f a) -> (ObservableT f (Array a))
bufferTime time opens size = mapObs (Observable.bufferTime time opens size)

-- | Emits the given constant value on the output Observable every time
-- | the source Observable emits a value.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/map.png)
mapTo :: forall a b f. Functor f => b -> ObservableT f a -> ObservableT f b
mapTo b = mapObs (Observable.mapTo b)

-- | Puts the current value and previous value together as an array, and emits that.
-- | ![marble diagram](http://reactivex.io/rxjs/img/pairwise.png)
pairwise :: forall a f. Functor f => ObservableT f a -> ObservableT f (Tuple a a)
pairwise = mapObs Observable.pairwise

-- | Given a predicate function (arg1), and an Observable (arg2), it outputs a
-- | two element array of partitioned values
-- | (i.e., [ Observable valuesThatPassPredicate, Observable valuesThatFailPredicate ]).
-- | ![marble diagram](http://reactivex.io/rxjs/img/partition.png)
partition :: forall a f. Applicative f => (a -> Boolean) -> ObservableT f a -> Tuple (ObservableT f a) (ObservableT f a)
partition predicate (ObservableT src) =
  let partitioned = map (Observable.partition predicate) src
      firstT = ObservableT (map fst partitioned)
      secondT = ObservableT (map snd partitioned)
  in Tuple firstT secondT


mergeMap :: forall a b m. Monad m => ObservableT m a -> (a -> ObservableT m b) -> ObservableT m b
mergeMap ma f = mergeAll_ (map f ma)

scan :: forall a b f. Functor f => (a -> b -> b) -> b -> ObservableT f a -> ObservableT f b
scan reducer seed = mapObs (Observable.scan reducer seed)


-- | It's like delay, but passes only the most recent value from each burst of emissions.
debounceTime :: forall a f. Functor f => Int -> ObservableT f a -> ObservableT f a
debounceTime time = mapObs (Observable.debounceTime time)
-- | Returns an Observable that emits all items emitted by the source Observable
-- | that are distinct by comparison from previous items.
-- | ![marble diagram](http://reactivex.io/documentation/operators/images/distinct.png)
distinct :: forall a f. Functor f => ObservableT f a -> ObservableT f a
distinct = mapObs Observable.distinct

-- | Returns an Observable that emits all items emitted by the source Observable
-- | that are distinct by comparison from the previous item.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/distinctUntilChanged.key.png)
distinctUntilChanged :: forall a f. Functor f => ObservableT f a -> ObservableT f a
distinctUntilChanged = mapObs Observable.distinctUntilChanged

-- | Emits the single value at the specified index in a sequence of emissions
-- | from the source Observable.
elementAt :: forall a f. Functor f => Int -> ObservableT f a -> ObservableT f a
elementAt index = mapObs (Observable.elementAt index)

-- | Filter items emitted by the source Observable by only emitting those that
-- | satisfy a specified predicate.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/filter.png)
filter :: forall a f. Functor f => (a -> Boolean) -> ObservableT f a -> ObservableT f a
filter predicate = mapObs (Observable.filter predicate)

-- | Ignores all items emitted by the source Observable and only passes calls of complete or error.
-- | ![marble diagram](http://reactivex.io/rxjs/img/ignoreElements.png)
ignoreElements :: forall a f. Functor f => ObservableT f a -> ObservableT f a
ignoreElements = mapObs Observable.ignoreElements

-- | Returns an Observable that emits only the last item emitted by the source
-- | Observable that that satisfies the given predicate.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/last.png)
last :: forall a f. Functor f => (a -> Boolean) -> ObservableT f a -> ObservableT f a
last predicate = mapObs (Observable.last predicate)


-- | It's like sampleTime, but samples whenever the notifier Observable emits something.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/sample.o.png)
sample :: forall a b f. Apply f => ObservableT f b -> ObservableT f a -> ObservableT f a
sample = applyObs Observable.sample


-- | Periodically looks at the source Observable and emits whichever
-- | value it has most recently emitted since the previous sampling, unless the source has not emitted anything since the previous sampling.
sampleTime :: forall a f. Functor f => Int -> ObservableT f a -> ObservableT f a
sampleTime time = mapObs (Observable.sampleTime time)

-- | Returns an Observable that skips n items emitted by an Observable.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/skip.png)
skip :: forall a f. Functor f => Int -> ObservableT f a -> ObservableT f a
skip amount = mapObs (Observable.skip amount)

-- | Returns an Observable that skips items emitted by the source Observable until a second Observable emits an item.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/skipUntil.png)
skipUntil :: forall a b f. Apply f => ObservableT f b -> ObservableT f a -> ObservableT f a
skipUntil = applyObs Observable.skipUntil

-- | Returns an Observable that skips all items emitted
-- | by the source Observable as long as a specified condition holds true,
-- | but emits all further source items as soon as the condition becomes false.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/skipWhile.png)
skipWhile :: forall a f. Functor f => (a -> Boolean) -> ObservableT f a -> ObservableT f a
skipWhile predicate = mapObs (Observable.skipWhile predicate)

-- | Emits only the first n values emitted by the source Observable.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/take.png)
take :: forall a f. Functor f => Int -> ObservableT f a -> ObservableT f a
take amount = mapObs (Observable.take amount)

-- | Lets values pass until a second Observable emits something. Then, it completes.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/takeUntil.png" alt=""
takeUntil :: forall a b f. Apply f => ObservableT f b -> ObservableT f a -> ObservableT f a
takeUntil = applyObs Observable.takeUntil

-- | Emits values emitted by the source Observable so long as each value satisfies
-- | the given predicate, and then completes as soon as this predicate is not satisfied.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/takeWhile.png)
takeWhile :: forall a f. Functor f => (a -> Boolean) -> ObservableT f a -> ObservableT f a
takeWhile predicate = mapObs (Observable.takeWhile predicate)

-- | Ignores source values for duration milliseconds,
-- | then emits the most recent value from the source Observable, then repeats this process.
-- | ![marble diagram](http://reactivex.io/rxjs/img/auditTime.png)
auditTime :: forall a f. Functor f => Int -> ObservableT f a -> ObservableT f a
auditTime time = mapObs (Observable.auditTime time)


-- | Emits a value from the source Observable, then ignores subsequent source values
-- | for duration milliseconds, then repeats this process.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/throttleWithTimeout.png)
throttleTime :: forall a f. Functor f => Int -> ObservableT f a -> ObservableT f a
throttleTime time = mapObs (Observable.throttleTime time)


-- | Returns an Observable that emits the items in the given Foldable before
-- | it begins to emit items emitted by the source Observable.
startWithMany :: forall f a m. Foldable f => Functor m => f a -> ObservableT m a -> ObservableT m a
startWithMany xs = mapObs (Observable.startWithMany xs)

-- | Returns an Observable that emits the item given before
-- | it begins to emit items emitted by the source Observable.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/startWith.png)
startWith :: forall a f. Functor f => a -> ObservableT f a -> ObservableT f a
startWith a = mapObs (Observable.startWith a)

-- | Combines each value from the source Observables using a project function to
-- | determine the value to be emitted on the output Observable.
-- | ![marble diagram](https://raw.github.com/wiki/ReactiveX/RxJava/images/rx-operators/withLatestFrom.png" alt="">
withLatestFrom :: forall a b c f. Apply f => (a -> b -> c) -> ObservableT f a -> ObservableT f b -> ObservableT f c
withLatestFrom selector = applyObs (Observable.withLatestFrom selector)


-- | Concatenates two Observables together by sequentially emitting their values, one Observable after the other.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/concat.png)
concat :: forall a f. Apply f => ObservableT f a -> ObservableT f a -> ObservableT f a
concat = applyObs Observable.concat

-- | If the source Observable calls error, this method will resubscribe to the
-- | source Observable n times rather than propagating the error call.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/retry.png)
retry :: forall a f. Functor f => Int -> ObservableT f a -> ObservableT f a
retry amount = mapObs (Observable.retry amount)

-- Utility Operators
-- | Time shifts each item by some specified amount of milliseconds.
-- | ![marble diagram](https://raw.githubusercontent.com/wiki/ReactiveX/RxJava/images/rx-operators/delay.png)
delay :: forall a f. Functor f => Int -> ObservableT f a -> ObservableT f a
delay ms = mapObs (Observable.delay ms)



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
defaultIfEmpty default = mapObs (Observable.defaultIfEmpty default)


-- | Determines whether all elements of an observable sequence satisfy a condition.
-- | Returns an observable sequence containing a single element determining whether all
-- | elements in the source sequence pass the test in the specified predicate.
every :: forall a f. Functor f => (a -> Boolean) -> ObservableT f a -> ObservableT f Boolean
every predicate = mapObs (Observable.every predicate)
-- | Tests whether this `Observable` emits no elements.
-- |
-- | returns an Observable emitting one single Boolean, which is `true` if this `Observable`
-- |         emits no elements, and `false` otherwise.
isEmpty :: forall a f. Functor f => ObservableT f a -> ObservableT f Boolean
isEmpty = mapObs Observable.isEmpty
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
share = mapObs Observable.share
-- | Returns an Observable that emits only the first item emitted by the source
-- | Observable that satisfies the given predicate.
first :: forall a f. Functor f => (a -> Boolean) -> ObservableT f a -> ObservableT f a
first predicate = mapObs (Observable.first predicate)

-- | Counts the number of emissions on the source and emits that number when the source completes.
count :: forall a f. Functor f => ObservableT f a -> ObservableT f Int
count = mapObs Observable.count
-- | Applies an accumulator function over the source Observable, and returns the accumulated
-- | result when the source completes, given a seed value.
reduce :: forall a b f. Functor f => (a -> b -> b) -> b -> ObservableT f a -> ObservableT f b
reduce accumulator seed = mapObs (Observable.reduce accumulator seed)

-- | Makes every `next` call run in the new Scheduler.
observeOn :: forall a f. Functor f => Scheduler -> ObservableT f a -> ObservableT f a
observeOn scheduler = mapObs (Observable.observeOn scheduler)

-- | Makes subscription happen on a given Scheduler.
subscribeOn :: forall a f. Functor f => Scheduler -> ObservableT f a -> ObservableT f a
subscribeOn scheduler = mapObs (Observable.subscribeOn scheduler)

subscribeNext :: forall a f e. Functor f => (a -> Eff e Unit) -> ObservableT f a -> f (EffRx e Subscription)
subscribeNext next (ObservableT fo) = map (Observable.subscribeNext next) fo

subscribe :: forall a f e. Functor f => Subscriber a -> ObservableT f a -> f (EffRx e Subscription)
subscribe subscriber (ObservableT fo) = map (Observable.subscribe subscriber) fo


applyObs :: forall a b c f. Apply f => (Observable a -> Observable b -> Observable c)
                             -> ObservableT f a
                             -> ObservableT f b
                             -> ObservableT f c
applyObs f (ObservableT fa) (ObservableT fb) =
  let fc = f <$> fa <*> fb
  in ObservableT fc

applyObs3 :: forall a b c d f. Apply f => (Observable a -> Observable b -> Observable c -> Observable d)
                             -> ObservableT f a
                             -> ObservableT f b
                             -> ObservableT f c
                             -> ObservableT f d
applyObs3 f (ObservableT fa) (ObservableT fb) (ObservableT fc) =
  let fd = f <$> fa <*> fb <*> fc
  in ObservableT fd

mapObs :: forall a b f. Functor f => (Observable a -> Observable b) -> ObservableT f a -> ObservableT f b
mapObs f (ObservableT fo) = ObservableT (map f fo)


flattenHelper :: forall a e m. Monad m => Observable (ObservableT m a) -> Subscriber a -> EffRx e Subscription
flattenHelper oeoa subscriber =
  oeoa # Observable.subscribeNext (\(ObservableT inner) -> subscribeToResult inner subscriber)

subscribeToResult :: forall a e m. Monad m => m (Observable a) -> Subscriber a -> Eff e Unit
subscribeToResult inner subscriber =
  let something = do
        innerObservable <- inner
        let eff = innerObservable # Observable.subscribeNext (\value -> subscriber.next value)
        pure (unsafePerformEff eff)
  in pure unit
