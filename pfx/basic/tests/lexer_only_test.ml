open BasicPfx
open Lexer
open Parser

let rec examine_all lexbuf =
  let tok = token lexbuf in
  Lexer.print_token tok;
  print_string " ";
  match tok with
  | EOF -> ()
  | _ -> examine_all lexbuf

let compile file =
  print_string ("File "^file^" is being treated!\n");
  try
    let input_file = open_in file in
    let lexbuf = Lexing.from_channel input_file in
    examine_all lexbuf;
    print_newline ();
    close_in input_file
  with Sys_error _ ->
    print_endline ("Can't find file '" ^ file ^ "'")

let _ = Arg.parse [] compile ""