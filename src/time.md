# Use `"time"` to handle time

Time is complicated. Incorrect assumptions often made about time include the
following.

1. A day has 24 hours
2. An hour has 60 minutes
3. A week has 7 days
4. A year has 365 days
5. [And a lot more](https://infiniteundo.com/post/25326999628/falsehoods-programmers-believe-about-time)

For example, *1* means that adding 24 hours to a time instant will not always
yield a new calendar day.

Therefore, always use the [`"time"`] package when dealing with time because it
helps deal with these incorrect assumptions in a safer, more accurate manner.

  [`"time"`]: https://pkg.go.dev/time

## Use `time.Time` for instants of time

Use [`time.Time`] when dealing with instants of time, and the methods on
`time.Time` when comparing, adding, or subtracting time.

  [`time.Time`]: https://pkg.go.dev/time#Time

<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
func isActive(now, start, stop int) bool {
  return start <= now && now < stop
}
```

</td><td>

```go
func isActive(now, start, stop time.Time) bool {
  return (start.Before(now) || start.Equal(now)) && now.Before(stop)
}
```

</td></tr>
</tbody></table>

## Use `time.Duration` for periods of time

Use [`time.Duration`] when dealing with periods of time.

  [`time.Duration`]: https://pkg.go.dev/time#Duration

<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
func poll(delay int) {
  for {
    // ...
    time.Sleep(time.Duration(delay) * time.Millisecond)
  }
}

poll(10) // was it seconds or milliseconds?
```

</td><td>

```go
func poll(delay time.Duration) {
  for {
    // ...
    time.Sleep(delay)
  }
}

poll(10*time.Second)
```

</td></tr>
</tbody></table>

Going back to the example of adding 24 hours to a time instant, the method we
use to add time depends on intent. If we want the same time of the day, but on
the next calendar day, we should use [`Time.AddDate`]. However, if we want an
instant of time guaranteed to be 24 hours after the previous time, we should
use [`Time.Add`].

  [`Time.AddDate`]: https://pkg.go.dev/time#Time.AddDate
  [`Time.Add`]: https://pkg.go.dev/time#Time.Add

```go
newDay := t.AddDate(0 /* years */, 0 /* months */, 1 /* days */)
maybeNewDay := t.Add(24 * time.Hour)
```

## Use `time.Time` and `time.Duration` with external systems

Use `time.Duration` and `time.Time` in interactions with external systems when
possible. For example:

- Command-line flags: [`flag`] supports `time.Duration` via
  [`time.ParseDuration`]
- JSON: [`encoding/json`] supports encoding `time.Time` as an [RFC 3339]
  string via its [`UnmarshalJSON` method]
- SQL: [`database/sql`] supports converting `DATETIME` or `TIMESTAMP` columns
  into `time.Time` and back if the underlying driver supports it
- YAML: [`gopkg.in/yaml.v2`] supports `time.Time` as an [RFC 3339] string, and
  `time.Duration` via [`time.ParseDuration`].

  [`flag`]: https://pkg.go.dev/flag
  [`time.ParseDuration`]: https://pkg.go.dev/time#ParseDuration
  [`encoding/json`]: https://pkg.go.dev/encoding/json
  [RFC 3339]: https://tools.ietf.org/html/rfc3339
  [`UnmarshalJSON` method]: https://pkg.go.dev/time#Time.UnmarshalJSON
  [`database/sql`]: https://pkg.go.dev/database/sql
  [`gopkg.in/yaml.v2`]: https://pkg.go.dev/gopkg.in/yaml.v2

When it is not possible to use `time.Duration` in these interactions, use
`int` or `float64` and include the unit in the name of the field.

For example, since `encoding/json` does not support `time.Duration`, the unit
is included in the name of the field.

<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
// {"interval": 2}
type Config struct {
  Interval int `json:"interval"`
}
```

</td><td>

```go
// {"intervalMillis": 2000}
type Config struct {
  IntervalMillis int `json:"intervalMillis"`
}
```

</td></tr>
</tbody></table>

When it is not possible to use `time.Time` in these interactions, unless an
alternative is agreed upon, use `string` and format timestamps as defined in
[RFC 3339]. This format is used by default by [`Time.UnmarshalText`] and is
available for use in `Time.Format` and `time.Parse` via [`time.RFC3339`].

  [`Time.UnmarshalText`]: https://pkg.go.dev/time#Time.UnmarshalText
  [`time.RFC3339`]: https://pkg.go.dev/time#RFC3339

Although this tends to not be a problem in practice, keep in mind that the
`"time"` package does not support parsing timestamps with leap seconds
([8728]), nor does it account for leap seconds in calculations ([15190]). If
you compare two instants of time, the difference will not include the leap
seconds that may have occurred between those two instants.

  [8728]: https://github.com/golang/go/issues/8728
  [15190]: https://github.com/golang/go/issues/15190
