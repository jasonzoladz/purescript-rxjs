module Test.Main where

import Control.Monad.Aff.AVar (AVAR)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import ObservableSpec (observableOperatorSpec, observableCreationSpec)
import ObservableTSpec  (observableTOperatorSpec, observableTCreationSpec)
import Prelude (Unit, discard)
import Test.Unit.Console (TESTOUTPUT)
import Test.Unit.Main (exit, runTest)

main :: forall e. Eff (console :: CONSOLE, testOutput :: TESTOUTPUT, avar :: AVAR | e) Unit
main = do
  runTest do
    observableOperatorSpec
    observableCreationSpec
    observableTOperatorSpec
    observableTCreationSpec
  (exit 0)
