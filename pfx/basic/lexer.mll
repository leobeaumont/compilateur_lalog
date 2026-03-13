{
open Parser
open Utils
open Location

let mk_int nb =
  try INT (int_of_string nb)
  with Failure _ -> failwith (Printf.sprintf "Illegal integer '%s': " nb)
}

let newline = (['\n' '\r'] | "\r\n")
let blank = [' ' '\014' '\t' '\012']
let digit = ['0'-'9']
let number = digit+

rule token = parse
  | newline+ { Location.incr_line lexbuf; token lexbuf }
  | blank+   { token lexbuf }
  | eof      { EOF }

  | number as nb { mk_int nb }

  | "add"  { ADD }
  | "sub"  { SUB }
  | "mul"  { MUL }
  | "div"  { DIV }
  | "rem"  { REM }
  | "pop"  { POP }
  | "swap" { SWAP }

  | "exec" { EXEC }
  | "get"  { GET }

  | "(" { LPAR }
  | ")" { RPAR }

  | _ as c {
      let loc = Location.curr lexbuf in
      raise (Location.Error (Printf.sprintf "Illegal character '%c'" c, loc))
  }