# Don't Panic

Code running in production must avoid panics. Panics are a major source of
[cascading failures]. If an error occurs, the function must return an error and
allow the caller to decide how to handle it.

  [cascading failures]: https://en.wikipedia.org/wiki/Cascading_failure

<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
func run(args []string) {
  if len(args) == 0 {
    panic("an argument is required")
  }
  // ...
}

func main() {
  run(os.Args[1:])
}
```

</td><td>

```go
func run(args []string) error {
  if len(args) == 0 {
    return errors.New("an argument is required")
  }
  // ...
  return nil
}

func main() {
  if err := run(os.Args[1:]); err != nil {
    fmt.Fprintln(os.Stderr, err)
    os.Exit(1)
  }
}
```

</td></tr>
</tbody></table>

Panic/recover is not an error handling strategy. A program must panic only when
something irrecoverable happens such as a nil dereference. An exception to this is
program initialization: bad things at program startup that should abort the
program may cause panic.

```go
var _statusTemplate = template.Must(template.New("name").Parse("_statusHTML"))
```

Even in tests, prefer `t.Fatal` or `t.FailNow` over panics to ensure that the
test is marked as failed.

<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
// func TestFoo(t *testing.T)

f, err := os.CreateTemp("", "test")
if err != nil {
  panic("failed to set up test")
}
```

</td><td>

```go
// func TestFoo(t *testing.T)

f, err := os.CreateTemp("", "test")
if err != nil {
  t.Fatal("failed to set up test")
}
```

</td></tr>
</tbody></table>
