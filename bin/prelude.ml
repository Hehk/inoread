(* Code being share around, at some point this should be cleaned up *)

let html_to_string html = Format.asprintf "%a" (Tyxml.Html.pp_elt ()) html

let html_list_to_string html =
  html |> List.map html_to_string |> String.concat ""
