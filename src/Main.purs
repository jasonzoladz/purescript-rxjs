module Main where

import Prelude
import RxJS.Observable
import RxJS.Subscriber
import Control.Monad.Aff
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (CONSOLE, log, logShow)
import Data.Foldable (traverse_)
import Debug.Trace (traceAnyM)

--main :: forall e. Eff (console :: CONSOLE | e) Unit
main = do
  let ob2 = delay 1000 $ fromArray [5, 6, 7, 8]
  let ob1 = delay 500 (fromArray [1,2,3,4])

  let obs =  race [ ob1, ob2 ]
  subscribeNext (\_ -> log "Starting ob1") ob1
  subscribeNext (\_ -> log "Starting ob2") ob2
  subscribeNext  (\v -> logShow v) obs
