module Test.Main where

import Prelude
import Test.Unit.QuickCheck
import RxJS.Observable
import Control.Monad.Aff.AVar (AVAR)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Eff.Exception (error)
import Control.MonadPlus (empty)
import Data.String (length)
import Test.Unit (suite, test)
import Test.Unit.Assert (assert, expectFailure)
import Test.Unit.Console (TESTOUTPUT)
import Test.Unit.Main (exit, runTest)

main :: forall e. Eff (console :: CONSOLE, testOutput :: TESTOUTPUT, avar :: AVAR | e) Unit
main = do
  runTest do
    suite "observable creation methods" do
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
    suite "observable operators" do
      test "audit" do
        liftEff ((audit observable (\x -> observable3)) # subObservable)
      test "auditTime" do
        liftEff ((auditTime 200 observable) # subObservable)
      test "bufferCount" do
        liftEff ((bufferCount 2 1 observable) # subObservable)
      test "combineLatest" do
        liftEff ((combineLatest (\acc cur -> acc) observable observable2) # subObservable)
      test "concat" do
        liftEff ((concat observable observable3) # subObservable)
      test "concatAll" do
        liftEff ((concatAll higherOrder) # subObservable)
      test "concatMap" do
        liftEff ((concatMap observable (\n -> just n)) # subObservable)
      test "count" do
        liftEff ((count observable) # subObservable)
      test "debounce" do
        liftEff ((debounce observable3 (\x -> observable)) # subObservable)
      test "debounceTime" do
        liftEff ((debounceTime 1000 observable) # subObservable)
      test "defaultIfEmpty" do
        liftEff ((defaultIfEmpty observable 0) # subObservable)
      test "delay" do
        liftEff ((delay 200 observable) # subObservable)
      test "delayWhen" do
        liftEff ((delayWhen observable (\x -> observable2)) # subObservable)
      test "distinct" do
        liftEff ((distinct observable) # subObservable)
      test "distinctUntilChanged" do
        liftEff ((distinctUntilChanged observable) # subObservable)
      test "exhaust" do
        liftEff ((exhaust higherOrder) # subObservable)
      test "exhaustMap" do
        liftEff ((exhaustMap observable (\x -> observable3)) # subObservable)
      test "elementAt" do
        liftEff ((elementAt observable 2) # subObservable)
      test "expand" do
        liftEff ((expand observable (\x -> if (x < 3) then just (x + 1) else empty)) # subObservable)
      test "filter" do
        liftEff ((filter (_ > 2) observable) # subObservable)
      test "groupBy" do
        liftEff ((groupBy length observable2) # subObservable)
      test "ignoreElements" do
        liftEff ((ignoreElements observable) # subObservable)
      test "map" do
        liftEff ((map length observable2) # subObservable)
      test "mapTo" do
        liftEff ((mapTo "A" observable) # subObservable)
      test "merge" do
        liftEff ((merge observable observable3) # subObservable)
      test "mergeAll" do
        liftEff ((mergeAll higherOrder) # subObservable)
      test "mergeMap" do
        liftEff ((mergeMap observable (\a -> observable3)) # subObservable)
      test "mergeMapTo" do
        liftEff ((mergeMapTo observable observable3) # subObservable)
      test "race" do
        liftEff ((race [observable, observable3]) # subObservable)
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
      test "skip" do
        liftEff ((skip 2 observable) # subObservable)
      test "skipUntil" do
        liftEff ((skipUntil observable observable2) # subObservable)
      test "skipWhile" do
        liftEff ((skipWhile (_ < 2) observable) # subObservable)
      test "startWith" do
        liftEff ((startWith 0 observable) # subObservable)
      test "switchMap" do
        liftEff ((switchMap observable (\x -> observable2)) # subObservable)
      test "switchMapTo" do
        liftEff ((switchMapTo observable2 observable) # subObservable)
      test "take" do
        liftEff ((take 3 observable) # subObservable)
      test "takeWhile" do
        liftEff ((takeWhile (_ < 4) observable) # subObservable)
      test "takeUntil" do
        liftEff ((takeUntil observable observable3) # subObservable)
      test "throttle" do
        liftEff ((throttle observable (\x -> observable3)) # subObservable)
      test "throttleTime" do
        liftEff ((throttleTime 200 observable) # subObservable)
      test "window" do
        liftEff ((window observable observable2) # subObservable)
      test "windowCount" do
        liftEff ((windowCount 1 1 observable) # subObservable)
      test "windowTime" do
        liftEff ((windowTime 100 100 observable) # subObservable)
      test "windowWhen" do
        liftEff ((windowWhen observable3 observable) # subObservable)
      test "windowToggle" do
        liftEff ((windowToggle observable observable2 (\x -> observable3)) # subObservable)
      test "withLatestFrom" do
        liftEff ((withLatestFrom (\a b -> a) observable observable2) # subObservable)
      test "zip" do
        liftEff ((zip [observable, observable3]) # subObservable)
  (exit 0)


observable :: Observable Int
observable = fromArray [1,2,3,4,5,6]

observable2 :: Observable String
observable2 = fromArray ["h","e","ll","o"]

observable3 :: Observable Int
observable3 = fromArray [6,5,4,3,2,1]

higherOrder :: Observable (Observable String)
higherOrder = just observable2

subObservable :: forall a e. Observable a -> Eff e Unit
subObservable obs = do
    sub <- obs # subscribeNext noop
    pure unit

noop :: forall a e. a -> Eff e Unit
noop a = pure unit
