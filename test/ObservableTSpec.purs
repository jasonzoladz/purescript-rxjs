module ObservableTSpec where

import RxJS.Observable.Trans
import RxJS.Observable (RX)
import Control.Monad.Aff.AVar (AVAR)
import Control.Monad.Eff (Eff)
import Control.Comonad (extract)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (CONSOLE)
import Data.String (length)
import Data.Identity (Identity)
import Prelude (Unit, bind, const, map, pure, unit, (#), (<), (>), discard)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Console (TESTOUTPUT)

observableTSpec :: forall e. TestSuite (console :: CONSOLE, testOutput :: TESTOUTPUT, avar :: AVAR, rx :: RX | e)
observableTSpec =
  suite "observableT operators" do

    test "combineLatest" do
      liftEff ((combineLatest (\acc cur -> acc) observable observable2) # subObservable)


observable :: ObservableT Identity Int
observable = fromArray [1,2,3,4,5,6]

observable2 :: ObservableT Identity String
observable2 = fromArray ["h","e","ll","o"]

observable3 :: ObservableT Identity Int
observable3 = fromArray [6,5,4,3,2,1]

higherOrder :: ObservableT Identity (ObservableT Identity String)
higherOrder = just observable2

subObservable :: forall a e. ObservableT Identity a -> Eff (rx :: RX | e) Unit
subObservable obs = do
    sub <- extract (obs # subscribeNext noop)
    pure unit

noop :: forall a e. a -> Eff e Unit
noop a = pure unit
