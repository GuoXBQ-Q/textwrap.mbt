///|
/// Print every line break opportunity found in the sample text.
/// Run with `moon run linebreak/examples/basic` from the repository root.
fn main {
  let text =
    #|MoonBit wraps text with UAX #14.
    #|Paragraph two starts here.
  @linebreak.linebreaks(text).each(pair => {
    let (pos, kind) = pair
    let label = match kind {
      Mandatory => "Mandatory"
      Allowed => "Allowed"
    }
    println("break at \{pos} -> \{label}")
  })
}
