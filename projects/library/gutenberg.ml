open Core

let command =
  Command.basic
    ~summary:"A tool to grab and parse epub files from Project Gutenberg"
    Command.Param.(
      map (anon ("url" %: string)) ~f:(fun url () -> print_endline url))

let () = Command_unix.run command
