open Core

let command =
  Command.basic
    ~summary:"A tool to grab and parse epub files from Project Gutenberg"
    Command.Param.(
      map (anon ("url" %: string)) ~f:(fun url () -> 
        let books = url |> Gutendex.search |> Lwt_main.run in
        let first_book = books.results |> List.hd_exn in
        first_book |> Gutendex_j.string_of_book |> print_endline;
        first_book.formats |> List.map ~f:(fun format ->
          let (format, url) = format in
          format ^ ": " ^ url
        ) |> String.concat ~sep:"\n" |> print_endline;
      )
    )

let () = Command_unix.run command
