module RxJS.Scheduler
  ( Scheduler(..)
  , queue
  , asap
  , async
  , animationFrame  
  )
  where

-- | Please see [RxJS Version 5.* documentation](http://reactivex.io/rxjs/) for
-- | additional details on proper usage of the library.

foreign import data Scheduler :: *

foreign import queue :: Scheduler

foreign import asap :: Scheduler

foreign import async :: Scheduler

foreign import animationFrame :: Scheduler
