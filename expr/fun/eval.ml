open Ast

exception RuntimeError of string

type value =
  | VInt of int
  | VFun of string * expression * env

and env = (string * value) list

let rec eval env = function
  | Const c -> VInt c

  | Var v ->
    (try List.assoc v env
     with Not_found -> raise (RuntimeError ("Unbound variable " ^ v)))

  | Uminus e ->
    (match eval env e with
     | VInt n -> VInt (-n)
     | VFun _ -> raise (RuntimeError "Cannot apply unary minus to a function"))

  | Binop (op, e1, e2) ->
    (match eval env e2 with
     | VFun _ -> raise (RuntimeError "Cannot use a function as operand")
     | VInt v2 ->
       (match op with
        | BinOp.Bdiv | BinOp.Bmod when v2 = 0 ->
          raise (RuntimeError "Division by zero")
        | _ ->
          (match eval env e1 with
           | VFun _ -> raise (RuntimeError "Cannot use a function as operand")
           | VInt v1 -> VInt ((BinOp.eval op) v1 v2))))

  | Fun (x, e) ->
    VFun (x, e, env)

  | App (e1, e2) ->
    (match eval env e1 with
     | VInt _ -> raise (RuntimeError "Cannot apply a non-function")
     | VFun (x, body, fun_env) ->
       let v2 = eval env e2 in
       eval ((x, v2) :: fun_env) body)