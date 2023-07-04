open Prelude

let about =
  [
    "Hoi! I am a software engineer based in Austin, TX. I am current a \
     founding engineer at Pineway and previous an engineer at Superhuman.";
    "I generally optimize for looking like an idiot and failing as fast as \
     possible. My projects below are a reflection of that.";
  ]

let content () =
  let open Tyxml.Html in
  let about = about |> List.map (fun x -> Template.Tag.p [ txt x ]) |> html_list_to_string in
  Template.centered (about ^ Projects_page.active_projects_section)
