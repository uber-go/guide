# Don't fire-and-forget goroutines

Goroutines are lightweight, but they're not free:
at minimum, they cost memory for their stack and CPU to be scheduled.
While these costs are small for typical uses of goroutines,
they can cause significant performance issues
when spawned in large numbers without controlled lifetimes.
Goroutines with unmanaged lifetimes can also cause other issues
like preventing unused objects from being garbage collected
and holding onto resources that are otherwise no longer used.

Therefore, do not leak goroutines in production code.
Use [go.uber.org/goleak](https://pkg.go.dev/go.uber.org/goleak)
to test for goroutine leaks inside packages that may spawn goroutines.

In general, every goroutine:

- must have a predictable time at which it will stop running; or
- there must be a way to signal to the goroutine that it should stop

In both cases, there must be a way code to block and wait for the goroutine to
finish.

For example:

<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
go func() {
  for {
    flush()
    time.Sleep(delay)
  }
}()
```

</td><td>

```go
var (
  stop = make(chan struct{}) // tells the goroutine to stop
  done = make(chan struct{}) // tells us that the goroutine exited
)
go func() {
  defer close(done)

  ticker := time.NewTicker(delay)
  defer ticker.Stop()
  for {
    select {
    case <-ticker.C:
      flush()
    case <-stop:
      return
    }
  }
}()

// Elsewhere...
close(stop)  // signal the goroutine to stop
<-done       // and wait for it to exit
```

</td></tr>
<tr><td>

There's no way to stop this goroutine.
This will run until the application exits.

</td><td>

This goroutine can be stopped with `close(stop)`,
and we can wait for it to exit with `<-done`.

</td></tr>
</tbody></table>
