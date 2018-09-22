module RxJS.Notification where

import Prelude

import Effect.Exception (Error, message)


data Notification a = OnError Error | OnNext a | OnComplete

instance showNotification :: (Show a) => Show (Notification a) where
  show (OnNext v) = "(OnNext " <> show v <> ")"
  show (OnError err) = "(OnError " <> message err <> ")"
  show (OnComplete) = "(OnComplete)"
