module RxJS.Subscription
  ( Subscription(..)
  , unsubscribe
  ) where

import Prelude (Unit)
import Control.Monad.Eff (Eff)

-- | When you subscribe, you get back a Subscription, which represents the
-- | ongoing execution.
foreign import data Subscription :: Type

-- | Call unsubscribe() to cancel the execution.
foreign import unsubscribe :: forall e. Subscription -> Eff e Unit
