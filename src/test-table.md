# Test Tables

Use table-driven tests with [subtests] to avoid duplicating code when the core
test logic is repetitive.

  [subtests]: https://blog.golang.org/subtests

<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
// func TestSplitHostPort(t *testing.T)

host, port, err := net.SplitHostPort("192.0.2.0:8000")
require.NoError(t, err)
assert.Equal(t, "192.0.2.0", host)
assert.Equal(t, "8000", port)

host, port, err = net.SplitHostPort("192.0.2.0:http")
require.NoError(t, err)
assert.Equal(t, "192.0.2.0", host)
assert.Equal(t, "http", port)

host, port, err = net.SplitHostPort(":8000")
require.NoError(t, err)
assert.Equal(t, "", host)
assert.Equal(t, "8000", port)

host, port, err = net.SplitHostPort("1:8")
require.NoError(t, err)
assert.Equal(t, "1", host)
assert.Equal(t, "8", port)
```

</td><td>

```go
// func TestSplitHostPort(t *testing.T)

tests := []struct{
  give     string
  wantHost string
  wantPort string
}{
  {
    give:     "192.0.2.0:8000",
    wantHost: "192.0.2.0",
    wantPort: "8000",
  },
  {
    give:     "192.0.2.0:http",
    wantHost: "192.0.2.0",
    wantPort: "http",
  },
  {
    give:     ":8000",
    wantHost: "",
    wantPort: "8000",
  },
  {
    give:     "1:8",
    wantHost: "1",
    wantPort: "8",
  },
}

for _, tt := range tests {
  t.Run(tt.give, func(t *testing.T) {
    host, port, err := net.SplitHostPort(tt.give)
    require.NoError(t, err)
    assert.Equal(t, tt.wantHost, host)
    assert.Equal(t, tt.wantPort, port)
  })
}
```

</td></tr>
</tbody></table>

Test tables make it easier to add context to error messages, reduce duplicate
logic, and add new test cases.

We follow the convention that the slice of structs is referred to as `tests`
and each test case `tt`. Further, we encourage explicating the input and output
values for each test case with `give` and `want` prefixes.

```go
tests := []struct{
  give     string
  wantHost string
  wantPort string
}{
  // ...
}

for _, tt := range tests {
  // ...
}
```

Parallel tests, like some specialized loops (for example, those that spawn
goroutines or capture references as part of the loop body),
must take care to explicitly assign loop variables within the loop's scope to
ensure that they hold the expected values.

```go
tests := []struct{
  give string
  // ...
}{
  // ...
}

for _, tt := range tests {
  tt := tt // for t.Parallel
  t.Run(tt.give, func(t *testing.T) {
    t.Parallel()
    // ...
  })
}
```

In the example above, we must declare a `tt` variable scoped to the loop
iteration because of the use of `t.Parallel()` below.
If we do not do that, most or all tests will receive an unexpected value for
`tt`, or a value that changes as they're running.

<!-- TODO: Explain how to use _test packages. -->
