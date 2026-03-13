open Ast
open Printf

type value =
  | VInt of int
  | VSeq of command list

let string_of_value = function
  | VInt n -> string_of_int n
  | VSeq cmds -> "(" ^ string_of_commands cmds ^ ")"

let string_of_stack stack =
  sprintf "[%s]" (String.concat ";" (List.map string_of_value stack))

let string_of_state (cmds,stack) =
  (match cmds with
   | [] -> "no command"
   | cmd::_ -> sprintf "executing %s" (string_of_command cmd)) ^
  (sprintf " with stack %s" (string_of_stack stack))

(* Question 4.2 + open Ast
open Printf

type value =
  | VInt of int
  | VSeq of command list

let string_of_value = function
  | VInt n -> string_of_int n
  | VSeq cmds -> "(" ^ string_of_commands cmds ^ ")"

let string_of_stack stack =
  sprintf "[%s]" (String.concat ";" (List.map string_of_value stack))

let string_of_state (cmds,stack) =
  (match cmds with
   | [] -> "no command"
   | cmd::_ -> sprintf "executing %s" (string_of_command cmd)) ^
  (sprintf " with stack %s" (string_of_stack stack))

(* Question 4.2 + Extensions Question 9.3 *)
let step state =
  match state with

  | [], _ -> Error("Nothing to step",state)

  (* Division by 0 *)
  | Div :: q, VInt v1 :: VInt 0 :: stack -> Error("Division by 0", state)
  | Rem :: q, VInt v1 :: VInt 0 :: stack -> Error("Division by 0", state)

  (* Valid configurations *)
  | Push n :: q , stack ->
      Ok (q, VInt n :: stack)

  | Pop :: q, _ :: stack ->
      Ok (q, stack)

  | Swap :: q, v1 :: v2 :: stack ->
      Ok (q, v2 :: v1 :: stack)

  | Add :: q, VInt v1 :: VInt v2 :: stack ->
      Ok (q, VInt (v1 + v2) :: stack)

  | Sub :: q, VInt v1 :: VInt v2 :: stack ->
      Ok (q, VInt (v1 - v2) :: stack)

  | Mul :: q, VInt v1 :: VInt v2 :: stack ->
      Ok (q, VInt (v1 * v2) :: stack)

  | Div :: q, VInt v1 :: VInt v2 :: stack ->
      Ok (q, VInt (v1 / v2) :: stack)

  | Rem :: q, VInt v1 :: VInt v2 :: stack ->
      Ok (q, VInt (v1 mod v2) :: stack)

  (* Sequence *)
  | Seq cmds :: q, stack ->
      Ok (q, VSeq cmds :: stack)

  (* Exec *)
  | Exec :: q, VSeq cmds :: stack ->
      Ok (cmds @ q, stack)

  (* Get *)
  | Get :: q, VInt i :: stack ->
      if i < List.length stack then
        Ok (q, List.nth stack i :: stack)
      else
        Error("Index out of bounds", state)

  (* Not enough elements in stack *)
  | command :: q, stack ->
      Error("Stack underflow", state)

let eval_program (numargs, cmds) args =

  let rec execute = function
    | [], [] -> Ok None
    | [], VInt v :: _ -> Ok (Some v)
    | [], _ -> Ok None
    | state ->
        begin
          match step state with
          | Ok s -> execute s
          | Error e -> Error e
        end
  in

  if numargs = List.length args then
    let initial_stack = List.map (fun n -> VInt n) args in
    match execute (cmds, initial_stack) with
    | Ok None -> printf "No result\n"
    | Ok (Some result) -> printf "= %i\n" result
    | Error(msg,s) -> printf "Raised error %s in state %s\n" msg (string_of_state s)
  else
    printf "Raised error \nMismatch between expected and actual number of args\n"xtensions Question 9.3 *)
let step state =
  match state with

  | [], _ -> Error("Nothing to step",state)

  (* Division by 0 *)
  | Div :: q, VInt v1 :: VInt 0 :: stack -> Error("Division by 0", state)
  | Rem :: q, VInt v1 :: VInt 0 :: stack -> Error("Division by 0", state)

  (* Valid configurations *)
  | Push n :: q , stack ->
      Ok (q, VInt n :: stack)

  | Pop :: q, _ :: stack ->
      Ok (q, stack)

  | Swap :: q, v1 :: v2 :: stack ->
      Ok (q, v2 :: v1 :: stack)

  | Add :: q, VInt v1 :: VInt v2 :: stack ->
      Ok (q, VInt (v1 + v2) :: stack)

  | Sub :: q, VInt v1 :: VInt v2 :: stack ->
      Ok (q, VInt (v1 - v2) :: stack)

  | Mul :: q, VInt v1 :: VInt v2 :: stack ->
      Ok (q, VInt (v1 * v2) :: stack)

  | Div :: q, VInt v1 :: VInt v2 :: stack ->
      Ok (q, VInt (v1 / v2) :: stack)

  | Rem :: q, VInt v1 :: VInt v2 :: stack ->
      Ok (q, VInt (v1 mod v2) :: stack)

  (* Sequence *)
  | Seq cmds :: q, stack ->
      Ok (q, VSeq cmds :: stack)

  (* Exec *)
  | Exec :: q, VSeq cmds :: stack ->
      Ok (cmds @ q, stack)

  (* Get *)
  | Get :: q, VInt i :: stack ->
      if i < List.length stack then
        Ok (q, List.nth stack i :: stack)
      else
        Error("Index out of bounds", state)

  (* Not enough elements in stack *)
  | command :: q, stack ->
      Error("Stack underflow", state)

let eval_program (numargs, cmds) args =

  let rec execute = function
    | [], [] -> Ok None
    | [], VInt v :: _ -> Ok (Some v)
    | [], _ -> Ok None
    | state ->
        begin
          match step state with
          | Ok s -> execute s
          | Error e -> Error e
        end
  in

  if numargs = List.length args then
    let initial_stack = List.map (fun n -> VInt n) args in
    match execute (cmds, initial_stack) with
    | Ok None -> printf "No result\n"
    | Ok (Some result) -> printf "= %i\n" result
    | Error(msg,s) -> printf "Raised error %s in state %s\n" msg (string_of_state s)
  else
    printf "Raised error \nMismatch between expected and actual number of args\n"