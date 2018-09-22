module RxJS.Subscription
  ( Subscription(..)
  , unsubscribe
  ) where

import Effect (Effect)
import Prelude (Unit)

-- | When you subscribe, you get back a Subscription, which represents the
-- | ongoing execution.
foreign import data Subscription :: Type

-- | Call unsubscribe() to cancel the execution.
foreign import unsubscribe :: Subscription -> Effect Unit
