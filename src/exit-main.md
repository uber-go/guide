# Exit in Main

Go programs use [`os.Exit`] or [`log.Fatal*`] to exit immediately. (Panicking
is not a good way to exit programs, please [don't panic](panic.md).)

  [`os.Exit`]: https://pkg.go.dev/os#Exit
  [`log.Fatal*`]: https://pkg.go.dev/log#Fatal

Call one of `os.Exit` or `log.Fatal*` **only in `main()`**. All other
functions should return errors to signal failure.

<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
func main() {
  body := readFile(path)
  fmt.Println(body)
}

func readFile(path string) string {
  f, err := os.Open(path)
  if err != nil {
    log.Fatal(err)
  }

  b, err := io.ReadAll(f)
  if err != nil {
    log.Fatal(err)
  }

  return string(b)
}
```

</td><td>

```go
func main() {
  body, err := readFile(path)
  if err != nil {
    log.Fatal(err)
  }
  fmt.Println(body)
}

func readFile(path string) (string, error) {
  f, err := os.Open(path)
  if err != nil {
    return "", err
  }

  b, err := io.ReadAll(f)
  if err != nil {
    return "", err
  }

  return string(b), nil
}
```

</td></tr>
</tbody></table>

Rationale: Programs with multiple functions that exit present a few issues:

- Non-obvious control flow: Any function can exit the program so it becomes
  difficult to reason about the control flow.
- Difficult to test: A function that exits the program will also exit the test
  calling it. This makes the function difficult to test and introduces risk of
  skipping other tests that have not yet been run by `go test`.
- Skipped cleanup: When a function exits the program, it skips function calls
  enqueued with `defer` statements. This adds risk of skipping important
  cleanup tasks.
