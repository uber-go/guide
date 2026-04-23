# Format Strings Using `%q`

Whenever formatting messages that contain a string component via `fmt`, use `%q` instead of `%s`. This will wrap the specified string in quotes, helping it stand out from the rest of the error message. More importantly, if the string is empty, it will provide a more helpful error message.

<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
fmt.Errrof("file %s not found", filename)
// Prints the following:
// file myfile.go not found
//
// Or if the string is empty:
// file not found
```

</td><td>

```go
fmt.Errrof("file %q not found", filename)
// Prints the following:
// file "myfile.go" not found
//
// Or if the string is empty:
// file "" not found
```

</td></tr>
</tbody></table>

This advice applies more generally to other contexts when reporting user-specified data, such as logging invalid usernames:

```go
log.Printf("User %q does not exist", username)
// User "no_name" does not exist
```
