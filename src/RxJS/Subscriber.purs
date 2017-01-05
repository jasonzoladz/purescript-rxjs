module RxJS.Subscriber
        (Subscriber)
        where

import Prelude (Unit)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (Error)

type Subscriber a
  = { next      :: forall e. a -> Eff e Unit
    , error     :: forall e. Error -> Eff e Unit
    , completed :: forall e. Unit -> Eff e Unit
    }
