open Lwt
open Cohttp
open Cohttp_lwt_unix

let base_uri = "https://gutendex.com/"

let search query =
  let uri = Uri.of_string (base_uri ^ "/books?search=" ^ query) in
  let headers = Header.init_with "User-Agent" "ocaml" in
  Client.get ~headers uri >>= fun (resp, body) ->
  let code = resp |> Response.status |> Code.code_of_status in
  Printf.printf "Response code: %d\n" code;
  Printf.printf "Headers: %s\n" (resp |> Response.headers |> Header.to_string);
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  Printf.printf "Body of length: %d\n" (String.length body);
  body
