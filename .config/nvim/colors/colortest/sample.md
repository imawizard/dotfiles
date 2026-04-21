<!--
Markdown test file — exercises @markup.* treesitter captures.
See README.md in this directory.
-->

# Heading level 1 <!-- @markup.heading.1 -->

## Heading level 2 <!-- @markup.heading.2 -->

### Heading level 3 <!-- @markup.heading.3 -->

#### Heading level 4 <!-- @markup.heading.4 -->

##### Heading level 5 <!-- @markup.heading.5 -->

###### Heading level 6 <!-- @markup.heading.6 -->

---

## Emphasis

**Bold text**                            <!-- @markup.strong -->

*Italic text*                            <!-- @markup.italic -->

~~Strikethrough text~~                   <!-- @markup.strikethrough -->

Some markdown flavors: <u>underline</u>  <!-- @markup.underline (only with injection) -->

---

## Quotes

> This is a blockquote.                  <!-- @markup.quote -->
> It can span multiple lines.
>
> > Nested quotes work too.

---

## Links

Inline link: [click here](https://example.com)  <!-- @markup.link (text) + @markup.link.url (target) -->

Autolink: <https://example.com>                 <!-- @markup.link.url -->

Reference: [ref][1]                              <!-- @markup.link / @markup.link.label -->

[1]: https://example.com                         <!-- @markup.link.url -->

---

## Lists

- Unordered bullet                        <!-- @markup.list -->
- Another bullet
- Third bullet

1. Ordered item                           <!-- @markup.list -->
2. Second item
3. Third item

- [x] Checked task                        <!-- @markup.list.checked -->
- [ ] Unchecked task                      <!-- @markup.list.unchecked -->
- [x] Another done task

---

## Code

Here is `inline code`.                    <!-- @markup.raw -->

A fenced code block:

```python
def hello():                              # @markup.raw.block
    print("world")
```

    # Indented code block is also raw     <!-- @markup.raw.block -->

---

## Math

Inline math: $x^2 + y^2 = z^2$            <!-- @markup.math -->

Block math:

$$
\int_0^\infty e^{-x^2} \, dx = \frac{\sqrt{\pi}}{2}
$$
<!-- @markup.math -->

---

## Comments in markdown

<!-- This is a comment                    @comment -->
