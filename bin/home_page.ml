let about =
  [
    "Hoi! I am a software engineer based in Austin, TX. I am current a \
     founding engineer at Pineway and previous an engineer at Superhuman.";
    "Right now I am writing go and typescript in the streets and ocaml in the \
     sheets.";
  ]

let content () =
  let open Tyxml.Html in
  let about =
    about |> List.map (fun x -> Template.Tag.p [ txt x ])
  in
  Template.centered @@ about @ Projects_page.active_projects_section
