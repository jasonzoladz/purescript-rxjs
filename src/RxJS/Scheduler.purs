module RxJS.Scheduler where

foreign import data Scheduler :: *

foreign import queue :: Scheduler

foreign import asap :: Scheduler

foreign import async :: Scheduler

foreign import animationFrame :: Scheduler
