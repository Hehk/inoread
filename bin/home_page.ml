let about =
  [
    "Hoi! I am currently a founding engineer at Throne and I was previously an \
     engineer at Superhuman.";
    "Right now, I am writing a bunch of Swift for iOS and Python to train \
     machine learning models to pay the bills. Outside of work, I write mostly \
     OCaml to do anything that looks interesting";
    "While touching grass, I am trying to move from conversation to fluent in \
     Dutch, learning the piano, and running enough that I am always a little \
     tired.";
  ]

let content () =
  let open Tyxml.Html in
  let about = about |> List.map (fun x -> Template.Tag.p [ txt x ]) in
  Template.centered @@ about @ Projects_page.active_projects_section
