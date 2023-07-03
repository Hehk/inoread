let html_to_string html = Format.asprintf "%a" (Tyxml.Html.pp ()) html

let () =
  Dream.run ~interface:"0.0.0.0" ~port:8080 @@ Dream.logger
  @@ Dream.router
       [
         Dream.get "/" (fun _ ->
             [ Home_page.content () ]
             |> Template.main_layout |> html_to_string |> Dream.html);
         Dream.get "/projects" (fun _ ->
             [ Projects_page.content () ]
             |> Template.main_layout |> html_to_string |> Dream.html);
         Dream.get "/dist/**" (Dream.static "./dist");
       ]
