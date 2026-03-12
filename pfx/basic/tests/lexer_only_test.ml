open BasicPfx
open Lexer
open Parser
open Utils
open Location

let print_token = function
  | EOF -> print_string "EOF"
  | ADD -> print_string "ADD"
  | SUB -> print_string "SUB"
  | MUL -> print_string "MUL"
  | DIV -> print_string "DIV"
  | REM -> print_string "REM"
  | POP -> print_string "POP"
  | SWAP -> print_string "SWAP"
  | INT i -> Printf.printf "INT(%d)" i

let rec examine_all lexbuf =
  let tok = token lexbuf in
  print_token tok;
  print_string " ";
  match tok with
  | EOF -> ()
  | _ -> examine_all lexbuf

let compile file =
  print_string ("File "^file^" is being treated!\n");
  try
    let input_file = open_in file in
    let lexbuf = Lexing.from_channel input_file in
    Location.init lexbuf file;
    examine_all lexbuf;
    print_newline ();
    close_in input_file
  with Sys_error _ ->
    print_endline ("Can't find file '" ^ file ^ "'")

let _ = Arg.parse [] compile ""


(*
Pour tester le lexer seul exécuter les deux commandes suivantes:

dune build
dune exec ./pfx/basic/tests/lexer_only_test.exe -- pfx/basic/tests/ok_prog.pfx
*)