module Test.Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)

import Test.Unit
import Test.Unit.Assert
import Test.Unit.Main
import Test.Unit.Console
import Test.Unit.QuickCheck
import Control.Monad.Aff.AVar

import RxJS.Observable as O

-- main :: forall e. Eff (console :: CONSOLE, testOutput :: TESTOUTPUT, avar :: AVAR | e) Unit
main = log "You should write some tests."
