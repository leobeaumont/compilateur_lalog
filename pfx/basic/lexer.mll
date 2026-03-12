{
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

let mk_int nb =
  try INT (int_of_string nb)
  with Failure _ -> failwith (Printf.sprintf "Illegal integer '%s': " nb)
}

let newline = (['\n' '\r'] | "\r\n")
let blank = [' ' '\014' '\t' '\012']
let digit = ['0'-'9']
let number = digit+

rule token = parse
  | newline+         { Location.incr_line lexbuf; token lexbuf }
  | blank+           { token lexbuf }
  | eof              { EOF }

  | number as nb     { mk_int nb }

  | "add"            { ADD }
  | "sub"            { SUB }
  | "mul"            { MUL }
  | "div"            { DIV }
  | "rem"            { REM }
  | "pop"            { POP }
  | "swap"           { SWAP }
    
  | _ as c {
    let loc = Location.curr lexbuf in
    raise (Location.Error (Printf.sprintf "Illegal character '%c'" c, loc))
  }

{
let rec examine_all lexbuf =
  let result = token lexbuf in
  print_token result;
  print_string " ";
  match result with
  | EOF -> ()
  | _   -> examine_all lexbuf

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
}