open Base


let header () =
  <header class="container mx-auto max-w-3xl sm:grid sm:grid-cols-6 gap-4 pt-16 pb-14 px-4">
    <div class="flex flex-row justify-between col-span-4 col-start-2 -bl-2">
      <h1 class="text-black hover:text-black hover:underline underline-offset-2">
        <a href="/">I No Read</a> 
      </h1>
      <ul class="flex flex-row space-x-4">
        <li>
          <a href="/writing" class="text-black hover:text-black hover:underline underline-offset-2">Ideas</a>
        </li>
        <li>
          <a href="/projects" class="text-black hover:text-black hover:underline underline-offset-2">Projects</a>
        </li>
        </ul>
    </div>
  </header>

let grid =
  let column_class = "border-l border-r border-black/20" in
  let container_class =
    "absolute max-w-3xl px-4 sm:grid sm:grid-cols-6 gap-4 inset-0 mx-auto \
     pointer-events-none opacity-0 sub-grid"
  in
  <div class="<%s container_class %>">
    <div class="<%s column_class %>"></div> 
    <div class="<%s column_class %>"></div>
    <div class="<%s column_class %>"></div>
    <div class="<%s column_class %>"></div>
    <div class="<%s column_class %>"></div>
    <div class="<%s column_class %>"></div>
  </div>

let font_link = 
  let link = "https://fonts.googleapis.com/css2?family=EB+Garamond:wght@400&display=swap" in
  let alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890" in
  link ^ "&text=" ^ alphabet

let main_layout children =
  <html lang="en">
  <head>
    <title>I No Read</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script async src="/dist/grid.js"></script>
    <link rel="stylesheet" href="/dist/styles.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous">
    <link href="<%s font_link %>" rel="stylesheet">
  </head>
  <body>
    <%s header () %>
    <%s grid %>
    <main class="container mx-auto max-w-3xl px-4 pb-16 text-justify sm:grid sm:grid-cols-6 gap-4">
      <%s children %>
    </main>
  </html>

let centered children =
  <div class="col-span-4 col-start-2">
    <%s children %>
  </div>

module Tag = struct
  open Tyxml.Html

  let link ~href children =
    a
      ~a:
        [
          a_href href;
          a_class [ "-bl-2"; "mb-4"; "underline"; "underline-offset-2" ];
        ]
      children

  let p children = p ~a:[ a_class [ "text-black"; "-bl-2"; "mb-4" ] ] children

  let h2 children =
    h2
      ~a:[ a_class [ "text-2xl"; "mb-6"; "mt-6"; "first:mt-0"; "-bl-1" ] ]
      children
end
