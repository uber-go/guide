# Handle Errors Once

When a function receives an error from a caller,
it can handle it in a variety of different ways.
These include, but not are limited to:

- returning the error
- [wrapping the error](error-wrap.md) and returning that
- logging the error and returning nil
- logging the error and returning a different error
- logging the error and continuing running
- matching the error with `errors.Is` or `errors.As`
  and then handling the two error branches differently

In general, a function should handle an error only once.
It should not, for example, log the error and then return it again
because its callers will likely handle the error too.

As demonstrative examples, consider the following cases:

<table>
<thead><tr><th>Description</th><th>Code</th></tr></thead>
<tbody>
<tr><td>

**Bad**: Log the error and return it

Callers will likely handle the error as well--likely logging it before doing so
causing a lot of noise in the application logs.

</td><td>

```go
u, err := getUser(id)
if err != nil {
  // BAD: See description
  log.Printf("Could not get user %q: %v", id, err)
  return err
}
```

</td></tr>
<tr><td>

**Good**: Wrap the error and return it

Callers will be able to handle the error,
matching with `errors.Is` or `errors.As` for specific errors.

</td><td>

```go
u, err := getUser(id)
if err != nil {
  return fmt.Errorf("get user %q: %w", id, err)
}
```

</td></tr>
<tr><td>

**Good**: Log the error and degrade gracefully

If retrieving the value is not strictly necessary,
we can provide a degraded but unbroken experience
by using a fallback value.

</td><td>

```go
u, err := getUser(id)
if err != nil {
  log.Printf("Could not get user %q: %v", id, err)
  u = nil
}

```

</td></tr>
<tr><td>

**Good**: Match the error and degrade gracefully

If it's expected for retrieval to fail in specific cases,
match on that error case and degrade gracefully.

For all other cases, wrap the error and return it.
Callers will be able to add their own special handling
if necessary.

</td><td>

```go

u, err := getUser(id)
if err != nil {
  if !errors.Is(err, ErrNotFound) {
    return fmt.Errorf("get user %q: %w", id, err)
  }
  log.Printf("User %q does not exist", id)
  u = nil
}
```

</td></tr>
</tbody></table>
