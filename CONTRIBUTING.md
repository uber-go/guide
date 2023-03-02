# Contributing

Before making any changes,
please discuss your plans on GitHub
and get agreement on the general direction of the change.

## Making changes

- style.md is generated from the contents of the src/ folder.
  All changes must be made to files in the src/ folder.
- For new entries, create a new file with a short name
  (see [File names](#file-names)) and add it to [SUMMARY.md](src/SUMMARY.md).
  The file must have a single level 1 heading and any number of subsections.
- Use tables for side-by-side code samples.
- Link to other sections with their file names (`[..](foo.md)`).

## Writing style

### Line breaks

Use [semantic line breaks](https://sembr.org/) in your writing.
This keeps the Markdown files easily reviewable and editable.

### File names

Files in src/ follow a rough naming convention of:

    {subject}-{desc}.md

Where `{subject}` is the **singular form** of subject that the entry is about
(e.g `string`, `struct`, `time`, `var`, `error`)
and `{desc}` is a short one or two word description of the topic.
For subjects where their name is enough, the `-{desc}` may be omitted.

### Code samples

Use two spaces to indent code samples.
Horizontal space is limited in side-by-side samples.

### Side-by-side samples

Create side-by-side code samples with the following template:

~~~
<table>
<thead><tr><th>Bad</th><th>Good</th></tr></thead>
<tbody>
<tr><td>

```go
BAD CODE GOES HERE
```

</td><td>

```go
GOOD CODE GOES HERE
```

</td></tr>
</tbody></table>
~~~

The empty lines between the HTML tags and code samples are necessary.

If you need to add labels or descriptions below the code samples,
add another row before the `</tbody></table>` line.

~~~
<tr>
<td>DESCRIBE BAD CODE</td>
<td>DESCRIBE GOOD CODE</td>
</tr>
~~~
