# 2023-05-09

- Test tables: Discourage tables with complex, branching test bodies.

# 2023-04-13

- Errors: Add guidance on handling errors only once.

# 2023-03-03

- Receivers and Interfaces: Clarify subtlety with pointer receivers and values.

# 2022-10-18

- Add guidance on managing goroutine lifecycles.

# 2022-03-30

- Add guidance on using field tags in marshaled structs.

# 2021-11-16

- Add guidance on use of `%w` vs `%v` with `fmt.Errorf`, and where to use
  `errors.New` or custom error types.

# 2021-11-12

- Add soft line length limit of 99 characters.

# 2021-04-19

- Programs should exit only in `main()`, preferably at most once.

# 2021-03-15

- Add guidance on omitting zero-value fields during struct initialization.
- Add guidance on `Foo{}` versus `var` form for initialization of empty
  structs.
- Add new section for Initializing Structs, moving relevant guidances into
  subsections of it.

# 2020-06-10

- Add guidance on avoiding `init()`.
- Add guidance to avoid using built-in names.
- Add reminder that nil slices are not always the same as empty slices.

# 2020-02-24

- Add guidance on verifying interface compliance with compile-time checks.

# 2020-01-30

- Recommend using the `time` package when dealing with time.

# 2020-01-25

- Add guidance against embedding types in public structs.

# 2019-12-17

- Functional Options: Recommend struct implementations of `Option` interface
  instead of capturing values with a closure.

# 2019-11-26

- Add guidance against mutating global variables.

# 2019-10-21

- Add section on remaining consistent with existing practices.
- Add guidance on map initialization and size hints.

# 2019-10-11

- Suggest succinct context for error messages.

# 2019-10-10

- Initial release.
