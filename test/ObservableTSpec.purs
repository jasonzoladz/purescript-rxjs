module ObservableTSpec (observableTOperatorSpec, observableTCreationSpec) where

import RxJS.Observable
import Control.Bind (join)
import Control.Monad.Aff.AVar (AVAR)
import Control.Monad.Eff (Eff)
import Control.Comonad (extract)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.MonadPlus (empty)
import Data.String (length)
import Data.Identity (Identity)
import Prelude (Unit, bind, const, map, pure, unit, (#), (<), (>), discard)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Console (TESTOUTPUT)


observableTCreationSpec :: forall e. TestSuite (console :: CONSOLE, testOutput :: TESTOUTPUT, avar :: AVAR | e)
observableTCreationSpec =
  suite "observableT creation methods" do
    test "interval" do
      liftEff ((interval 200 # take 2) # subObservable)
    test "timer" do
      liftEff ((timer 200 100 # take 2) # subObservable)
    test "never" do
      liftEff ((never) # subObservable)
    test "empty" do
      liftEff ((empty) # subObservable)
    test "range" do
      liftEff ((range 0 5) # subObservable)
    test "fromArray" do
      liftEff ((fromArray [1,2,3,4,5]) # subObservable)
    test "just" do
      liftEff ((just "Hello World!") # subObservable)
    test "create" do
      liftEff ((create (\observer -> observer.next 34)) # subCreation)

observableTOperatorSpec :: forall e. TestSuite (console :: CONSOLE, testOutput :: TESTOUTPUT, avar :: AVAR | e)
observableTOperatorSpec =
  suite "observableT operators" do
    test "auditTime" do
      liftEff ((auditTime 200 observable) # subObservable)
    test "bufferCount" do
      liftEff ((bufferCount 2 1 observable) # subObservable)
    test "combineLatest" do
      liftEff ((combineLatest (\acc cur -> acc) observable observable2) # subObservable)
    test "concat" do
      liftEff ((concat observable observable3) # subObservable)
    test "count" do
      liftEff ((count observable) # subObservable)
    test "debounceTime" do
      liftEff ((debounceTime 1000 observable) # subObservable)
    test "defaultIfEmpty" do
      liftEff ((defaultIfEmpty 0 observable) # subObservable)
    test "delay" do
      liftEff ((delay 200 observable) # subObservable)
    test "distinct" do
      liftEff ((distinct observable) # subObservable)
    test "distinctUntilChanged" do
      liftEff ((distinctUntilChanged observable) # subObservable)
    test "elementAt" do
      liftEff ((elementAt 2 observable) # subObservable)
    test "every" do
      liftEff ((every (_ > 3) observable # subObservable))
    test "filter" do
      liftEff ((filter (_ > 2) observable) # subObservable)
    test "ignoreElements" do
      liftEff ((ignoreElements observable) # subObservable)
    test "isEmpty" do
      liftEff ((isEmpty observable) # subObservable)
    test "first" do
      liftEff ((first (const true) observable # subObservable))
    test "last" do
      liftEff ((last (const true) observable # subObservable))
    test "map" do
      liftEff ((map length observable2) # subObservable)
    test "mapTo" do
      liftEff ((mapTo "A" observable) # subObservable)
    test "merge" do
      liftEff ((merge observable observable3) # subObservable)
    --test "mergeAll" do
      --liftEff ((mergeAll_ higherOrder) # subObservable)
    --test "mergeMap" do
      --liftEff ((mergeMap observable (\a -> observable3)) # subObservable)
    test "reduce" do
      liftEff ((reduce (\acc cur -> acc) 0 observable) # subObservable)
    test "scan" do
      liftEff ((scan (\acc cur -> acc) 0 observable) # subObservable)
    test "retry" do
      liftEff ((retry 10 observable) # subObservable)
    test "sample" do
      liftEff ((sample observable observable2) # subObservable)
    test "sampleTime" do
      liftEff ((sampleTime 1000 observable) # subObservable)
    test "share" do
      liftEff ((share observable) # subObservable)
    test "skip" do
      liftEff ((skip 2 observable) # subObservable)
    test "skipUntil" do
      liftEff ((skipUntil observable observable2) # subObservable)
    test "skipWhile" do
      liftEff ((skipWhile (_ < 2) observable) # subObservable)
    test "startWith" do
      liftEff ((startWith 0 observable) # subObservable)
    test "take" do
      liftEff ((take 3 observable) # subObservable)
    test "takeWhile" do
      liftEff ((takeWhile (_ < 4) observable) # subObservable)
    test "takeUntil" do
      liftEff ((takeUntil observable observable3) # subObservable)
    test "throttleTime" do
      liftEff ((throttleTime 200 observable) # subObservable)
    test "withLatestFrom" do
      liftEff ((withLatestFrom (\a b -> a) observable observable2) # subObservable)


observable :: ObservableT Identity Int
observable = fromArray [1,2,3,4,5,6]

observable2 :: ObservableT Identity String
observable2 = fromArray ["h","e","ll","o"]

observable3 :: ObservableT Identity Int
observable3 = fromArray [6,5,4,3,2,1]

higherOrder :: ObservableT Identity (ObservableT Identity String)
higherOrder = just observable2

subCreation :: forall a e. ObservableT (Eff e) a -> Eff e Unit
subCreation obs = do
  sub <- join (obs # subscribeNext noop)
  pure unit

subObservable :: forall a e. ObservableT Identity a -> Eff e Unit
subObservable obs = do
    sub <- extract (obs # subscribeNext noop)
    pure unit

noop :: forall a e. a -> Eff e Unit
noop a = pure unit
