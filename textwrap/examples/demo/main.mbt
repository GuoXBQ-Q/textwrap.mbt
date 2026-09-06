///|
/// Demo of the textwrap toolkit.
/// Run with `moon run textwrap/examples/demo` from the repository root.
fn main {
  let text = "The quick brown fox jumps over the lazy dog and keeps running far away"
  println("== wrap(width=24) ==")
  for line in @textwrap.wrap(text, width=24) {
    println(line)
  }
  println("== CJK wrap(width=12) ==")
  for
    line in @textwrap.wrap(
      "中文 混排 文本 的 换行 示例",
      width=12,
      cjk=true,
    ) {
    println(line)
  }
  println("== fill(width=20) ==")
  println(@textwrap.fill(text, width=20))
  println("== indent(prefix=\"> \") ==")
  println(@textwrap.indent("first line\nsecond line", prefix="> "))
  println("== truncate(width=20) ==")
  println(@textwrap.truncate(text, width=20))
}
