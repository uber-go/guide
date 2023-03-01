# Zero-value Mutexes are Valid

The zero-value of `sync.Mutex` and `sync.RWMutex` is valid, so you almost
never need a pointer to a mutex.

<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
mu := new(sync.Mutex)
mu.Lock()
```

</td><td>

```go
var mu sync.Mutex
mu.Lock()
```

</td></tr>
</tbody></table>

If you use a struct by pointer, then the mutex should be a non-pointer field on
it. Do not embed the mutex on the struct, even if the struct is not exported.

<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
type SMap struct {
  sync.Mutex

  data map[string]string
}

func NewSMap() *SMap {
  return &SMap{
    data: make(map[string]string),
  }
}

func (m *SMap) Get(k string) string {
  m.Lock()
  defer m.Unlock()

  return m.data[k]
}
```

</td><td>

```go
type SMap struct {
  mu sync.Mutex

  data map[string]string
}

func NewSMap() *SMap {
  return &SMap{
    data: make(map[string]string),
  }
}

func (m *SMap) Get(k string) string {
  m.mu.Lock()
  defer m.mu.Unlock()

  return m.data[k]
}
```

</td></tr>

<tr><td>

The `Mutex` field, and the `Lock` and `Unlock` methods are unintentionally part
of the exported API of `SMap`.

</td><td>

The mutex and its methods are implementation details of `SMap` hidden from its
callers.

</td></tr>
</tbody></table>
