///|
/// The Unicode version that the line break tables target. The generated
/// tables are built from UCD `LineBreak.txt` 16.0.0.
pub let unicode_version : (Int, Int, Int) = (16, 0, 0)

///|
/// The class of a line break opportunity reported by `linebreaks`.
///
/// `Allowed` is part of the public API from day one but is only produced
/// once the pair-table state machine lands; the skeleton emits mandatory
/// breaks only, hence the unused-constructor exemption below.
#warnings("-unused_constructor")
pub enum BreakOpportunity {
  Mandatory
  Allowed
} derive(Eq, Debug)

///|
/// Locate line break opportunities in `text` (UAX #14).
///
/// Positions are UTF-16 code unit indices into `text`; a break at position
/// `i` means a line may end immediately before index `i`. There is always
/// at least one mandatory break at the end of text.
///
/// This skeleton recognizes mandatory breaks only (LB4/LB5: after BK, LF,
/// and CR, keeping CRLF together). Wrapping at `Allowed` opportunities
/// requires the pair-table state machine generated from UCD
/// `LineBreak.txt`, which is the next milestone.
///
/// # Example
/// ```mbt check
/// test {
///   debug_inspect(
///     linebreaks("a b\nc").to_array(),
///     content=(
///       #|[(4, Mandatory), (5, Mandatory)]
///     ),
///   )
/// }
/// ```
pub fn linebreaks(text : String) -> Iter[(Int, BreakOpportunity)] {
  let len = text.length()
  let breaks : Array[(Int, BreakOpportunity)] = []
  for i = 0; i < len; {
    if text[i] == '\r' {
      if i + 1 < len && text[i + 1] == '\n' {
        breaks.push((i + 2, Mandatory))
        continue i + 2
      }
      breaks.push((i + 1, Mandatory))
      continue i + 1
    } else if text[i] == '\n' {
      breaks.push((i + 1, Mandatory))
      continue i + 1
    } else {
      continue i + 1
    }
  } nobreak {
    breaks.push((len, Mandatory))
  }
  breaks.iter()
}
