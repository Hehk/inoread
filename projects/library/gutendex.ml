open Lwt
open Cohttp_lwt_unix
open Cohttp
open Core

let base_uri = "https://gutendex.com"

let search query =
  let uri = Uri.of_string (base_uri ^ "/books/?search=" ^ query) in
  Printf.printf "Uri: %s\n" (Uri.to_string uri);
  Client.get uri >>= fun (_, body) ->
  body |> Cohttp_lwt.Body.to_string >>= fun body ->
  let result = Gutendex_j.books_of_string body in
  Lwt.return result

let get_epub_url (book : Gutendex_t.book) =
  let open Option.Let_syntax in
  let is_epub (format, _) =
    String.is_substring ~substring:"application/epub+zip" format
  in
  book.formats |> List.find ~f:is_epub >>| snd

let rec http_get_and_follow ~max_redirects uri =
  let open Lwt.Syntax in
  let* ans = Cohttp_lwt_unix.Client.get uri in
  follow_redirect ~max_redirects uri ans

and follow_redirect ~max_redirects request_uri (response, body) =
  let open Lwt.Syntax in
  let status = Response.status response in
  (* The unconsumed body would otherwise leak memory *)
  let* () =
    if not @@ phys_equal status `OK then Cohttp_lwt.Body.drain_body body
    else Lwt.return_unit
  in
  match status with
  | `OK -> Lwt.return (response, body)
  | `Permanent_redirect | `Moved_permanently ->
      handle_redirect ~permanent:true ~max_redirects request_uri response
  | `Found | `Temporary_redirect ->
      handle_redirect ~permanent:false ~max_redirects request_uri response
  | `Not_found | `Gone -> Lwt.fail_with "Not found"
  | status ->
      Lwt.fail_with
        (Printf.sprintf "Unhandled status: %s"
           (Cohttp.Code.string_of_status status))

and handle_redirect ~permanent ~max_redirects request_uri response =
  if max_redirects <= 0 then Lwt.fail_with "Too many redirects"
  else
    let headers = Response.headers response in
    let location = Header.get headers "location" in
    match location with
    | None -> Lwt.fail_with "Redirection without Location header"
    | Some url ->
        let open Lwt.Syntax in
        let uri = Uri.of_string url in
        let* () =
          if permanent then
            Logs_lwt.warn (fun m ->
                m "Permanent redirection from %s to %s"
                  (Uri.to_string request_uri)
                  url)
          else Lwt.return_unit
        in
        http_get_and_follow uri ~max_redirects:(max_redirects - 1)

let create_epub_directory () =
  let open Lwt.Syntax in
  let root_dir = "dist" in
  let epub_dir = "dist/epubs" in
  let* assets_exists = Lwt_unix.file_exists root_dir in
  let* _ =
    match assets_exists with
    | true -> Lwt.return_unit
    | false -> Lwt_unix.mkdir root_dir 0o755
  in
  let* epub_directory_exists = Lwt_unix.file_exists epub_dir in
  let* _ = match epub_directory_exists with
  | true -> Lwt.return_unit
  | false -> Lwt_unix.mkdir epub_dir 0o755
  in
  epub_dir |> Lwt.return


let get_epub (book : Gutendex_t.book) =
  let open Lwt.Syntax in
  let url = get_epub_url book in
  match url with
  | None -> Lwt.return_none
  | Some url ->
      let filename = Int.to_string book.id ^ ".epub" in
      let uri = Uri.of_string url in
      http_get_and_follow ~max_redirects:3 uri >>= fun (_, body) ->
      let stream = body |> Cohttp_lwt.Body.to_stream in
      let* epub_dir = create_epub_directory () in
      let filename = epub_dir ^ "/" ^ filename in
      Lwt_io.with_file ~mode:Lwt_io.output filename (fun output_channel ->
          Lwt_stream.iter_s (Lwt_io.write output_channel) stream)
      >>= fun () -> Lwt.return_some filename

