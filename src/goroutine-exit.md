# Wait for goroutines to exit

Given a goroutine spawned by the system,
there must be a way to wait for the goroutine to exit.
There are two popular ways to do this:

- Use a `sync.WaitGroup`.
  Do this if there are multiple goroutines that you want to wait for

    ```go
    var wg sync.WaitGroup
    for i := 0; i < N; i++ {
      wg.Add(1)
      go func() {
        defer wg.Done()
        // ...
      }()
    }

    // To wait for all to finish:
    wg.Wait()
    ```

- Add another `chan struct{}` that the goroutine closes when it's done.
  Do this if there's only one goroutine.

    ```go
    done := make(chan struct{})
    go func() {
      defer close(done)
      // ...
    }()

    // To wait for the goroutine to finish:
    <-done
    ```
