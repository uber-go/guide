# Avoid Using Built-In Names

The Go [language specification] outlines several built-in,
[predeclared identifiers] that should not be used as names within Go programs.

Depending on context, reusing these identifiers as names will either shadow
the original within the current lexical scope (and any nested scopes) or make
affected code confusing. In the best case, the compiler will complain; in the
worst case, such code may introduce latent, hard-to-grep bugs.

  [language specification]: https://go.dev/ref/spec
  [predeclared identifiers]: https://go.dev/ref/spec#Predeclared_identifiers

<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
var error string
// `error` shadows the builtin

// or

func handleErrorMessage(error string) {
    // `error` shadows the builtin
}
```

</td><td>

```go
var errorMessage string
// `error` refers to the builtin

// or

func handleErrorMessage(msg string) {
    // `error` refers to the builtin
}
```

</td></tr>
<tr><td>

```go
type Foo struct {
    // While these fields technically don't
    // constitute shadowing, grepping for
    // `error` or `string` strings is now
    // ambiguous.
    error  error
    string string
}

func (f Foo) Error() error {
    // `error` and `f.error` are
    // visually similar
    return f.error
}

func (f Foo) String() string {
    // `string` and `f.string` are
    // visually similar
    return f.string
}
```

</td><td>

```go
type Foo struct {
    // `error` and `string` strings are
    // now unambiguous.
    err error
    str string
}

func (f Foo) Error() error {
    return f.err
}

func (f Foo) String() string {
    return f.str
}
```

</td></tr>
</tbody></table>

Note that the compiler will not generate errors when using predeclared
identifiers, but tools such as `go vet` should correctly point out these and
other cases of shadowing.
