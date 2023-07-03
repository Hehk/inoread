external document : Dom.document = "document" [@@bs.val]

external addEventListener :
  Dom.document -> string -> ('a Dom.event_like -> bool) -> bool -> unit
  = "addEventListener"
  [@@bs.send]

external body : Dom.htmlBodyElement = "document.body" [@@bs.val]
external keyboardEventToJsObj : Dom.keyboardEvent -> < .. > Js.t = "%identity"
external bodyToJsObj : Dom.htmlBodyElement -> < .. > Js.t = "%identity"

let toggle_grid event =
  let event = keyboardEventToJsObj event in
  if event##code == "KeyG" && event##ctrlKey then
    let body = bodyToJsObj body in
    let _ = body##classList##toggle "grid" in
    true
  else true

let _ = addEventListener document "keydown" toggle_grid true
