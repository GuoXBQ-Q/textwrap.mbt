///|
/// Split `text` into paragraphs at the mandatory line break positions
/// reported by `@linebreak` (UAX #14 LB4/LB5).
fn split_paragraphs(text : String) -> Array[String] {
  let pieces : Array[String] = []
  let mut start = 0
  @linebreak.linebreaks(text).each(pair => {
    let (pos, kind) = pair
    if kind is Mandatory {
      pieces.push(strip_trailing_newline(text[start:pos].to_owned()))
      start = pos
    }
  })
  pieces
}

///|
fn strip_trailing_newline(s : String) -> String {
  let n = s.length()
  if n >= 2 && s[n - 2] == '\r' && s[n - 1] == '\n' {
    s[:n - 2].to_owned()
  } else if n >= 1 && (s[n - 1] == '\n' || s[n - 1] == '\r') {
    s[:n - 1].to_owned()
  } else {
    s
  }
}

///|
/// Wrap `text` to fit within `width` display columns using the greedy
/// strategy.
///
/// Paragraphs are split at UAX #14 mandatory break positions; words within
/// a paragraph are separated by U+0020. Display width is measured with UAX
/// #11 via `moonbit-community/unicodewidth`; set `cjk` to treat ambiguous
/// width characters as wide.
///
/// Words wider than `width` currently overflow the line; wrapping at UAX
/// #14 `Allowed` opportunities, long-word breaking, and grapheme-safe
/// splitting are on the roadmap.
///
/// # Example
/// ```mbt check
/// test {
///   debug_inspect(
///     wrap("The quick brown fox", width=13),
///     content=(
///       #|["The quick", "brown fox"]
///     ),
///   )
/// }
/// ```
pub fn wrap(text : String, width~ : Int, cjk? : Bool = false) -> Array[String] {
  let out : Array[String] = []
  for para in split_paragraphs(text) {
    wrap_paragraph(para, width, cjk, out)
  }
  out
}

///|
fn wrap_paragraph(
  para : String,
  width : Int,
  cjk : Bool,
  out : Array[String],
) -> Unit {
  let mut current = StringBuilder()
  let mut current_width = 0
  let mut first_word = true
  for word in para.split(" ") {
    if word.length() == 0 {
      continue
    }
    let word_width = @unicodewidth.str_width(word, cjk~)
    if first_word {
      current <+ "\{word}"
      current_width = word_width
      first_word = false
    } else if current_width + 1 + word_width <= width {
      current <+ " \{word}"
      current_width += 1 + word_width
    } else {
      out.push(current.to_string())
      current = StringBuilder()
      current <+ "\{word}"
      current_width = word_width
    }
  }
  out.push(current.to_string())
}

///|
/// Wrap `text` to `width` display columns and join the resulting lines
/// with newlines.
pub fn fill(text : String, width~ : Int, cjk? : Bool = false) -> String {
  let sb = StringBuilder()
  let mut first = true
  for line in wrap(text, width~, cjk~) {
    if first {
      first = false
    } else {
      sb <+ "\n"
    }
    sb <+ "\{line}"
  }
  sb.to_string()
}

///|
/// Prefix every line of `text` with `prefix`.
pub fn indent(text : String, prefix? : String = "  ") -> String {
  let sb = StringBuilder()
  let mut first = true
  for line in text.split("\n") {
    if first {
      first = false
    } else {
      sb <+ "\n"
    }
    sb <+ "\{prefix}"
    sb <+ "\{line}"
  }
  sb.to_string()
}

///|
/// Truncate `text` so that its display width fits within `width`,
/// appending `ellipsis` when content is dropped. Text that already fits is
/// returned unchanged.
pub fn truncate(
  text : String,
  width~ : Int,
  ellipsis? : String = "...",
  cjk? : Bool = false,
) -> String {
  if @unicodewidth.str_width(text[:], cjk~) <= width {
    return text
  }
  let limit = width - @unicodewidth.str_width(ellipsis[:], cjk~)
  let sb = StringBuilder()
  let mut used = 0
  if limit > 0 {
    for c in text {
      guard @unicodewidth.char_width(c, cjk~) is Some(w) else { break }
      if used + w > limit {
        break
      }
      sb.write_char(c)
      used += w
    }
  }
  sb <+ "\{ellipsis}"
  sb.to_string()
}
