module Test.Main where

import RxJS.Observable
import Control.Monad.Aff.AVar (AVAR)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.MonadPlus (empty)
import ObservableSpec (observableSpec, subObservable)
import Prelude (Unit, bind, (#))
import Test.Unit (suite, test)
import Test.Unit.Console (TESTOUTPUT)
import Test.Unit.Main (exit, runTest)

main :: forall e. Eff (console :: CONSOLE, testOutput :: TESTOUTPUT, avar :: AVAR, rx :: RX | e) Unit
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
    observableSpec
  (exit 0)
