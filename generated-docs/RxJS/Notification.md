## Module RxJS.Notification

#### `Notification`

``` purescript
data Notification a
  = OnError Error
  | OnNext a
  | OnComplete
```

##### Instances
``` purescript
(Show a) => Show (Notification a)
```


