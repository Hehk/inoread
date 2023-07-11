open Core

let command =
  Command.basic
    ~summary:"A tool to grab and parse epub files from Project Gutenberg"
    Command.Param.(
      map
        (anon ("book" %: string))
        ~f:(fun url () ->
          let books = url |> Gutendex.search |> Lwt_main.run in
          let first_book = books.results |> List.hd_exn in
          print_endline first_book.title;
          let filename = Gutendex.get_epub first_book |> Lwt_main.run in
          match filename with
          | None -> print_endline "No epub found"
          | Some filename -> print_endline filename))

let () = Command_unix.run command
