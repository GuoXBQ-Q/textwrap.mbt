///|
test "wrap greedy ascii" {
  debug_inspect(
    @textwrap.wrap("The quick brown fox jumps over the lazy dog", width=15),
    content=(
      #|["The quick brown", "fox jumps over", "the lazy dog"]
    ),
  )
}

///|
test "wrap respects mandatory paragraph breaks" {
  debug_inspect(
    @textwrap.wrap("one two\nthree four", width=40),
    content=(
      #|["one two", "three four"]
    ),
  )
}

///|
test "wrap measures CJK double width" {
  debug_inspect(
    @textwrap.wrap("中文 混排 文本", width=6, cjk=true),
    content=(
      #|["中文", "混排", "文本"]
    ),
  )
}

///|
test "fill joins wrapped lines" {
  inspect(
    @textwrap.fill("aaa bbb ccc", width=7),
    content=(
      #|aaa bbb
      #|ccc
    ),
  )
}

///|
test "indent prefixes every line" {
  inspect(
    @textwrap.indent("a\nb", prefix="> "),
    content=(
      #|> a
      #|> b
    ),
  )
}

///|
test "truncate keeps fitting text unchanged" {
  inspect(@textwrap.truncate("hello", width=10), content="hello")
}

///|
test "truncate appends ellipsis" {
  inspect(
    @textwrap.truncate("hello world", width=8),
    content=(
      #|hello...
    ),
  )
}

///|
test "truncate handles wide chars" {
  inspect(
    @textwrap.truncate("中文文本示例", width=9, cjk=true),
    content=(
      #|中文文...
    ),
  )
}
