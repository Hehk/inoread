open Lwt
open Cohttp_lwt_unix

let base_uri = "https://gutendex.com"

let search query =
  let uri = Uri.of_string (base_uri ^ "/books/?search=" ^ query) in
  Printf.printf "Uri: %s\n" (Uri.to_string uri);
  Client.get uri >>= fun (_, body) ->
  body |> Cohttp_lwt.Body.to_string >>= fun body ->
    let result = Gutendex_j.books_of_string body in
    Lwt.return result
