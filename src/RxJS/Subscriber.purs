module RxJS.Subscriber
        (Subscriber)
        where

import Effect (Effect)
import Effect.Exception (Error)
import Prelude (Unit)

type Subscriber a
  = { next      :: a -> Effect Unit
    , error     :: Error -> Effect Unit
    , completed :: Unit -> Effect Unit
    }