# Avoid `init()`

Avoid `init()` where possible. When `init()` is unavoidable or desirable, code
should attempt to:

1. Be completely deterministic, regardless of program environment or invocation.
2. Avoid depending on the ordering or side-effects of other `init()` functions.
   While `init()` ordering is well-known, code can change, and thus
   relationships between `init()` functions can make code brittle and
   error-prone.
3. Avoid accessing or manipulating global or environment state, such as machine
   information, environment variables, working directory, program
   arguments/inputs, etc.
4. Avoid I/O, including both filesystem, network, and system calls.

Code that cannot satisfy these requirements likely belongs as a helper to be
called as part of `main()` (or elsewhere in a program's lifecycle), or be
written as part of `main()` itself. In particular, libraries that are intended
to be used by other programs should take special care to be completely
deterministic and not perform "init magic".

<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
type Foo struct {
    // ...
}

var _defaultFoo Foo

func init() {
    _defaultFoo = Foo{
        // ...
    }
}
```

</td><td>

```go
var _defaultFoo = Foo{
    // ...
}

// or, better, for testability:

var _defaultFoo = defaultFoo()

func defaultFoo() Foo {
    return Foo{
        // ...
    }
}
```

</td></tr>
<tr><td>

```go
type Config struct {
    // ...
}

var _config Config

func init() {
    // Bad: based on current directory
    cwd, _ := os.Getwd()

    // Bad: I/O
    raw, _ := os.ReadFile(
        path.Join(cwd, "config", "config.yaml"),
    )

    yaml.Unmarshal(raw, &_config)
}
```

</td><td>

```go
type Config struct {
    // ...
}

func loadConfig() Config {
    cwd, err := os.Getwd()
    // handle err

    raw, err := os.ReadFile(
        path.Join(cwd, "config", "config.yaml"),
    )
    // handle err

    var config Config
    yaml.Unmarshal(raw, &config)

    return config
}
```

</td></tr>
</tbody></table>

Considering the above, some situations in which `init()` may be preferable or
necessary might include:

- Complex expressions that cannot be represented as single assignments.
- Pluggable hooks, such as `database/sql` dialects, encoding type registries, etc.
- Optimizations to [Google Cloud Functions] and other forms of deterministic
  precomputation.

  [Google Cloud Functions]: https://cloud.google.com/functions/docs/bestpractices/tips#use_global_variables_to_reuse_objects_in_future_invocations
