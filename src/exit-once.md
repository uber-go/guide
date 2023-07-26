# Exit Once

If possible, prefer to call `os.Exit` or `log.Fatal` **at most once** in your
`main()`. If there are multiple error scenarios that halt program execution,
put that logic under a separate function and return errors from it.

This has the effect of shortening your `main()` function and putting all key
business logic into a separate, testable function.

<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
package main

func main() {
  args := os.Args[1:]
  if len(args) != 1 {
    log.Fatal("missing file")
  }
  name := args[0]

  f, err := os.Open(name)
  if err != nil {
    log.Fatal(err)
  }
  defer f.Close()

  // If we call log.Fatal after this line,
  // f.Close will not be called.

  b, err := io.ReadAll(f)
  if err != nil {
    log.Fatal(err)
  }

  // ...
}
```

</td><td>

```go
package main

func main() {
  if err := run(); err != nil {
    log.Fatal(err)
  }
}

func run() error {
  args := os.Args[1:]
  if len(args) != 1 {
    return errors.New("missing file")
  }
  name := args[0]

  f, err := os.Open(name)
  if err != nil {
    return err
  }
  defer f.Close()

  b, err := io.ReadAll(f)
  if err != nil {
    return err
  }

  // ...
}
```

</td></tr>
</tbody></table>

The example above uses `log.Fatal`, but the guidance also applies to
`os.Exit` or any library code that calls `os.Exit`.

```go
func main() {
  if err := run(); err != nil {
    fmt.Fprintln(os.Stderr, err)
    os.Exit(1)
  }
}
```

You may alter the signature of `run()` to fit your needs.
For example, if your program must exit with specific exit codes for failures,
`run()` may return the exit code instead of an error.
This allows unit tests to verify this behavior directly as well.

```go
func main() {
  os.Exit(run(args))
}

func run() (exitCode int) {
  // ...
}
```

More generally, note that the `run()` function used in these examples
is not intended to be prescriptive.
There's flexibility in the name, signature, and setup of the `run()` function.
Among other things, you may:

- accept unparsed command line arguments (e.g., `run(os.Args[1:])`)
- parse command line arguments in `main()` and pass them onto `run`
- use a custom error type to carry the exit code back to `main()`
- put business logic in a different layer of abstraction from `package main`

This guidance only requires that there's a single place in your `main()`
responsible for actually exiting the process.
