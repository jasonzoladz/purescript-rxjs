## Module RxJS.Subscription

#### `Subscription`

``` purescript
data Subscription :: *
```

When you subscribe, you get back a Subscription, which represents the
ongoing execution.

#### `unsubscribe`

``` purescript
unsubscribe :: forall e. Subscription -> Eff e Unit
```

Call unsubscribe() to cancel the execution.


