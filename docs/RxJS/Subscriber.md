## Module RxJS.Subscriber

#### `Subscriber`

``` purescript
type Subscriber a = { "next" :: forall e. a -> Eff e Unit, "error" :: forall e. Error -> Eff e Unit, "completed" :: forall e. Unit -> Eff e Unit }
```


