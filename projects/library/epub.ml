open Core

let ( let* ) o f = match o with None -> None | Some x -> f x
let meta_folder = "META-INF"
let content_folder = "OEBPS"
let ( % ) f g x = f (g x)

(* open Xml *)
type content_link = { filename : string; id : string }

module ContentMap = Hashtbl.Make (String)

let open_epub filename =
  let out = "/tmp/epub" in
  let cmd = Printf.sprintf "unzip -o %s -d %s" filename out in
  let _ = Sys_unix.command cmd in
  out

let tag = function Xml.Element (tag, _, _) -> tag | _ -> ""

let read_xml filename =
  let ic = In_channel.create filename in
  let xml = Xml.parse_in ic in
  In_channel.close ic;
  xml

let find_all_elements f xml =
  let rec find element =
    match element with
    | element when f element -> [ element ]
    | Xml.Element (_, _, children) -> List.concat_map children ~f:find
    | _ -> []
  in
  find xml

let find_element f xml =
  let rec find element =
    match element with
    | element when f element -> Some element
    | Xml.Element (_, _, children) -> List.find_map children ~f:find
    | _ -> None
  in
  find xml

let find_element_by_name name xml =
  let check_name = function
    | Xml.Element (n, _, _) when String.equal n name -> true
    | _ -> false
  in
  find_element check_name xml

let get_attr x key =
  match x with
  | Xml.Element (_, attr, _) ->
      let key = String.lowercase key in
      let test attr = attr |> fst |> String.lowercase |> String.equal key in
      let* attr = List.find ~f:test attr in
      Some (snd attr)
  | _ -> None

let get_content_path epub_path =
  let container_path = Filename.concat epub_path "META-INF/container.xml" in
  let container_xml = read_xml container_path in
  let* rootfiles = find_element_by_name "rootfiles" container_xml in
  let* rootfile = find_element_by_name "rootfile" rootfiles in
  get_attr rootfile "full-path"

let get_table_of_contents epub_path =
  let* content_path = get_content_path epub_path in
  let content_path = Filename.concat epub_path content_path in
  let content_xml = read_xml content_path in
  let* manifest = find_element_by_name "manifest" content_xml in
  let find_toc = function
    | Xml.Element ("item", attr, _) -> (
        let properties = get_attr (Xml.Element ("", attr, [])) "properties" in
        match properties with
        | Some properties ->
            let properties = String.split properties ~on:' ' in
            List.exists ~f:(String.equal "nav") properties
        | None -> false)
    | _ -> false
  in
  let* toc = find_element find_toc manifest in
  let* href = get_attr toc "href" in
  let toc_path = Filename.concat epub_path (content_folder ^ "/" ^ href) in
  Some toc_path

let get_content_links toc_path =
  let toc_xml = read_xml toc_path in
  let find_nav = function
    | Xml.Element ("nav", attr, _) -> (
        let properties = get_attr (Xml.Element ("", attr, [])) "epub:type" in
        match properties with
        | Some properties -> String.equal properties "toc"
        | None -> false)
    | _ -> false
  in
  let* navMap = find_element find_nav toc_xml in
  let is_section = function
    | Xml.Element ("a", attr, _) ->
        let href = get_attr (Xml.Element ("", attr, [])) "href" in
        Option.is_some href
    | _ -> false
  in
  let sections = find_all_elements is_section navMap in
  let content_links =
    sections
    |> List.map ~f:(fun x -> get_attr x "href")
    |> List.map ~f:(fun raw ->
           let* href = raw in
           let* file, id = String.lsplit2 href ~on:'#' in
           let filename = content_folder ^ "/" ^ file in
           Some (filename, id))
    |> List.filter_opt
    |> List.fold
         ~init:(Map.empty (module String))
         ~f:(fun acc href ->
           let filename, id = href in
           match Map.find acc filename with
           | Some ids -> Map.set acc ~key:filename ~data:(id :: ids)
           | None -> Map.set acc ~key:filename ~data:[ id ])
  in
  Some content_links

let get_content epub_path filename =
  let content_path = Filename.concat epub_path filename in
  let content_xml = read_xml content_path in
  let body = find_element_by_name "body" content_xml in
  match body with
  | None -> []
  | Some body ->
      let extract_text = function
        | Xml.Element ("p", _, children) ->
            children
            |> List.map ~f:(function Xml.PCData text -> Some text | _ -> None)
            |> List.filter_opt
        | _ -> []
      in
      body
      |> find_all_elements (String.equal "p" % tag)
      |> List.map ~f:extract_text |> List.concat
