module Test.Main where

import RxJS.Observable

import Control.MonadPlus (empty)
import Data.String (length)
import Effect (Effect)
import Effect.Class (liftEffect)
import Prelude (Unit, bind, const, map, pure, unit, (#), (+), (<), (>), discard)
import Test.Unit (suite, test)
import Test.Unit.Main (exit, runTest)

main :: Effect Unit
main = do
  runTest do
    suite "observable creation methods" do
      test "interval" do
        liftEffect ((interval 200 # take 2) # subObservable)
      test "timer" do
        liftEffect ((timer 200 100 # take 2) # subObservable)
      test "never" do
        liftEffect ((never) # subObservable)
      test "empty" do
        liftEffect ((empty) # subObservable)
      test "range" do
        liftEffect ((range 0 5) # subObservable)
      test "fromArray" do
        liftEffect ((fromArray [1,2,3,4,5]) # subObservable)
      test "just" do
        liftEffect ((just "Hello World!") # subObservable)
    suite "observable operators" do
      test "audit" do
        liftEffect ((audit observable (\x -> observable3)) # subObservable)
      test "auditTime" do
        liftEffect ((auditTime 200 observable) # subObservable)
      test "bufferCount" do
        liftEffect ((bufferCount 2 1 observable) # subObservable)
      test "combineLatest" do
        liftEffect ((combineLatest (\acc cur -> acc) observable observable2) # subObservable)
      test "concat" do
        liftEffect ((concat observable observable3) # subObservable)
      test "concatAll" do
        liftEffect ((concatAll higherOrder) # subObservable)
      test "concatMap" do
        liftEffect ((concatMap observable (\n -> just n)) # subObservable)
      test "count" do
        liftEffect ((count observable) # subObservable)
      test "debounce" do
        liftEffect ((debounce observable3 (\x -> observable)) # subObservable)
      test "debounceTime" do
        liftEffect ((debounceTime 1000 observable) # subObservable)
      test "defaultIfEmpty" do
        liftEffect ((defaultIfEmpty observable 0) # subObservable)
      test "delay" do
        liftEffect ((delay 200 observable) # subObservable)
      test "delayWhen" do
        liftEffect ((delayWhen observable (\x -> observable2)) # subObservable)
      test "distinct" do
        liftEffect ((distinct observable) # subObservable)
      test "distinctUntilChanged" do
        liftEffect ((distinctUntilChanged observable) # subObservable)
      test "exhaust" do
        liftEffect ((exhaust higherOrder) # subObservable)
      test "exhaustMap" do
        liftEffect ((exhaustMap observable (\x -> observable3)) # subObservable)
      test "elementAt" do
        liftEffect ((elementAt observable 2) # subObservable)
      test "expand" do
        liftEffect ((expand observable (\x -> if (x < 3) then just (x + 1) else empty)) # subObservable)
      test "every" do
        liftEffect ((every observable (_ > 3) # subObservable))
      test "filter" do
        liftEffect ((filter (_ > 2) observable) # subObservable)
      test "groupBy" do
        liftEffect ((groupBy length observable2) # subObservable)
      test "ignoreElements" do
        liftEffect ((ignoreElements observable) # subObservable)
      test "isEmpty" do
        liftEffect ((isEmpty observable) # subObservable)
      test "first" do
        liftEffect ((first observable (const true) # subObservable))
      test "last" do
        liftEffect ((last observable (const true) # subObservable))
      test "map" do
        liftEffect ((map length observable2) # subObservable)
      test "mapTo" do
        liftEffect ((mapTo "A" observable) # subObservable)
      test "merge" do
        liftEffect ((merge observable observable3) # subObservable)
      test "mergeAll" do
        liftEffect ((mergeAll higherOrder) # subObservable)
      test "mergeMap" do
        liftEffect ((mergeMap observable (\a -> observable3)) # subObservable)
      test "mergeMapTo" do
        liftEffect ((mergeMapTo observable observable3) # subObservable)
      test "race" do
        liftEffect ((race [observable, observable3]) # subObservable)
      test "reduce" do
        liftEffect ((reduce (\acc cur -> acc) 0 observable) # subObservable)
      test "scan" do
        liftEffect ((scan (\acc cur -> acc) 0 observable) # subObservable)
      test "retry" do
        liftEffect ((retry 10 observable) # subObservable)
      test "sample" do
        liftEffect ((sample observable observable2) # subObservable)
      test "sampleTime" do
        liftEffect ((sampleTime 1000 observable) # subObservable)
      test "share" do
        liftEffect ((share observable) # subObservable)
      test "skip" do
        liftEffect ((skip 2 observable) # subObservable)
      test "skipUntil" do
        liftEffect ((skipUntil observable observable2) # subObservable)
      test "skipWhile" do
        liftEffect ((skipWhile (_ < 2) observable) # subObservable)
      test "startWith" do
        liftEffect ((startWith 0 observable) # subObservable)
      test "switchMap" do
        liftEffect ((switchMap observable (\x -> observable2)) # subObservable)
      test "switchMapTo" do
        liftEffect ((switchMapTo observable2 observable) # subObservable)
      test "take" do
        liftEffect ((take 3 observable) # subObservable)
      test "takeWhile" do
        liftEffect ((takeWhile (_ < 4) observable) # subObservable)
      test "takeUntil" do
        liftEffect ((takeUntil observable observable3) # subObservable)
      test "throttle" do
        liftEffect ((throttle observable (\x -> observable3)) # subObservable)
      test "throttleTime" do
        liftEffect ((throttleTime 200 observable) # subObservable)
      test "window" do
        liftEffect ((window observable observable2) # subObservable)
      test "windowCount" do
        liftEffect ((windowCount 1 1 observable) # subObservable)
      test "windowTime" do
        liftEffect ((windowTime 100 100 observable) # subObservable)
      test "windowWhen" do
        liftEffect ((windowWhen observable3 observable) # subObservable)
      test "windowToggle" do
        liftEffect ((windowToggle observable observable2 (\x -> observable3)) # subObservable)
      test "withLatestFrom" do
        liftEffect ((withLatestFrom (\a b -> a) observable observable2) # subObservable)
      test "zip" do
        liftEffect ((zip [observable, observable3]) # subObservable)
  (exit 0)


observable :: Observable Int
observable = fromArray [1,2,3,4,5,6]

observable2 :: Observable String
observable2 = fromArray ["h","e","ll","o"]

observable3 :: Observable Int
observable3 = fromArray [6,5,4,3,2,1]

higherOrder :: Observable (Observable String)
higherOrder = just observable2

subObservable :: forall a. Observable a -> Effect Unit
subObservable obs = do
    sub <- obs # subscribeNext noop
    pure unit

noop :: forall a. a -> Effect Unit
noop a = pure unit
