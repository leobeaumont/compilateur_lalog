(* Exception that may be raised on error at run time by the function eval *)
exception RuntimeError of string

(* A value is either an integer or a function *)
type value =
  | VInt of int
  | VFun of string * Ast.expression * env

and env = (string * value) list

(* Function that evaluates an expression in a given environment *)
val eval : env -> Ast.expression -> value