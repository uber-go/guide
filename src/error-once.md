# Handle Errors Once

When a function receives an error from a caller,
it can handle it in a variety of different ways
depending on what it knows about the error.

These include, but not are limited to:

- if the function contract defines specific errors,
  matching the error with `errors.Is` or `errors.As`
  and handling the branches differently
- if the error is recoverable,
  logging the error and degrading gracefully
- if the error represents a domain-specific failure condition,
  returning a well-defined error
- [wrapping the error](error-wrap.md) and returning it
- returning the error as-is

Regardless of how the error is handled, generally,
a function should handle an error only once.
It should not, for example, log the error and then return it again
because its callers will likely handle the error too.

As demonstrative examples, consider the following cases:

<table>
<thead><tr><th>Description</th><th>Code</th></tr></thead>
<tbody>
<tr><td>

**Bad**: Log the error and return it

Callers will likely handle the error as well--possibly similarly logging it.
Doing so causing a lot of noise in the application logs.

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

If the operation isn't strictly necessary,
we can provide a degraded but unbroken experience
by recovering from it.

</td><td>

```go
if err := emitMetrics(); err != nil {
  // Failure to write metrics should not
  // break the application.
  log.Printf("Could not emit metrics: %v", err)
}

```

</td></tr>
<tr><td>

**Good**: Match the error and degrade gracefully

If the function defines a specific error in its contract,
and the failure is recoverable,
match on that error case and degrade gracefully.

For all other cases, wrap the error and return it.
Callers will be able to add their own special handling
if necessary.

</td><td>

```go
tz, err := getUserTimeZone(id)
if err != nil {
  if errors.Is(err, ErrUserNotFound) {
    // User doesn't exist. Use UTC.
    tz = time.UTC
  } else {
    return fmt.Errorf("get user %q: %w", id, err)
  }
}
```

</td></tr>
</tbody></table>
