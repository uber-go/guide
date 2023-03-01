# No goroutines in `init()`

`init()` functions should not spawn goroutines.
See also [Avoid init()](init.md).

If a package has need of a background goroutine,
it must expose an object that is responsible for managing a goroutine's
lifetime.
The object must provide a method (`Close`, `Stop`, `Shutdown`, etc)
that signals the background goroutine to stop, and waits for it to exit.

<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
func init() {
  go doWork()
}

func doWork() {
  for {
    // ...
  }
}
```

</td><td>

```go
type Worker struct{ /* ... */ }

func NewWorker(...) *Worker {
  w := &Worker{
    stop: make(chan struct{}),
    done: make(chan struct{}),
    // ...
  }
  go w.doWork()
}

func (w *Worker) doWork() {
  defer close(w.done)
  for {
    // ...
    case <-w.stop:
      return
  }
}

// Shutdown tells the worker to stop
// and waits until it has finished.
func (w *Worker) Shutdown() {
  close(w.stop)
  <-w.done
}
```

</td></tr>
<tr><td>

Spawns a background goroutine unconditionally when the user exports this package.
The user has no control over the goroutine or a means of stopping it.

</td><td>

Spawns the worker only if the user requests it.
Provides a means of shutting down the worker so that the user can free up
resources used by the worker.

Note that you should use `WaitGroup`s if the worker manages multiple
goroutines.
See [Wait for goroutines to exit](goroutine-exit.md).

</td></tr>
</tbody></table>
