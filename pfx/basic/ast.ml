type command =
  | Push of int
  | Pop
  | Swap
  | Add
  | Sub
  | Mul
  | Div
  | Rem
  | Exec
  | Get
  | Append
  | Seq of command list

type program = int * command list

let rec string_of_command = function
  | Push n   -> "push " ^ string_of_int n
  | Pop      -> "pop"
  | Swap     -> "swap"
  | Add      -> "add"
  | Sub      -> "sub"
  | Mul      -> "mul"
  | Div      -> "div"
  | Rem      -> "rem"
  | Exec     -> "exec"
  | Get      -> "get"
  | Append   -> "append"
  | Seq cmds -> "(" ^ string_of_commands cmds ^ ")"

and string_of_commands cmds =
  String.concat " " (List.map string_of_command cmds)

let string_of_program (args, cmds) =
  Printf.sprintf "%i args: %s\n" args (string_of_commands cmds)