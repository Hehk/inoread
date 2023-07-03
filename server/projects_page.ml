open Template
open Tyxml.Html

type project = { name : string; link : string; description : string }

let active_projects =
  [
    {
      name = "Falcon Resume";
      link = "https://falconresume.com";
      description =
        "A website for creating resumes using conversation with an AI.";
    };
    {
      name = "This Website";
      link = "https://inoread.com";
      description = "A website built with Ocaml and Dream.";
    };
  ]

let previous_projects =
  [
    {
      name = "Austin Run Groups";
      link = "https://austinrungroups.com";
      description =
        "A website for finding running groups in Austin, TX. Built with \
         Next.js, Tailwind CSS, and Google Sheets.";
    };
  ]

let project_to_html { name; link; description } =
  let name = Tag.link ~href:link [ txt name ] in
  let description = Tag.p [ txt description ] in
  Tyxml.Html.li [ name; description ]

let previous_projects_section =
  let list = previous_projects |> List.map project_to_html |> ul in
  [ Tag.h2 [ txt "Previous Projects" ]; list ]

let active_projects_section =
  let list = active_projects |> List.map project_to_html |> ul in
  [ Tag.h2 [ txt "Active Projects" ]; list ]

let content () =
  Template.centered (active_projects_section @ previous_projects_section)
