///|
test "mandatory break after LF and at end of text" {
  debug_inspect(
    @linebreak.linebreaks("a\nb").to_array(),
    content=(
      #|[(2, Mandatory), (3, Mandatory)]
    ),
  )
}

///|
test "CRLF is kept together as one mandatory break" {
  debug_inspect(
    @linebreak.linebreaks("a\r\nb\r\n").to_array(),
    content=(
      #|[(3, Mandatory), (6, Mandatory), (6, Mandatory)]
    ),
  )
}

///|
test "lone CR is a mandatory break" {
  debug_inspect(
    @linebreak.linebreaks("a\rb").to_array(),
    content=(
      #|[(2, Mandatory), (3, Mandatory)]
    ),
  )
}

///|
test "empty text has the end-of-text break" {
  debug_inspect(
    @linebreak.linebreaks("").to_array(),
    content=(
      #|[(0, Mandatory)]
    ),
  )
}

///|
test "unicode version is exposed" {
  inspect(@linebreak.unicode_version.0, content="16")
  inspect(@linebreak.unicode_version.1, content="0")
}
