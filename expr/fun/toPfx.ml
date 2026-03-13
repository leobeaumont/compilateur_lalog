open Ast
open BasicPfx.Ast
open BinOp

let shift env =
  List.map (fun (x, d) -> (x, d + 1)) env

let rec generate_aux env = function
  | Const n ->
      [Push n]

  | Var x ->
      let depth =
        try List.assoc x env
        with Not_found -> failwith ("Unbound variable: " ^ x)
      in
      [Push depth; Get]

  | Binop (op, e1, e2) ->
      let c1 = generate_aux env e1 in
      let c2 = generate_aux (shift env) e2 in
      let op_cmds =
        match op with
        | Badd -> [Add]
        | Bsub -> [Swap; Sub]
        | Bmul -> [Mul]
        | Bdiv -> [Swap; Div]
        | Bmod -> [Swap; Rem]
      in
      c1 @ c2 @ op_cmds

  | Uminus e ->
      generate_aux env e @ [Push (-1); Mul]

  | Fun (x, e) ->
      let body = generate_aux ((x, 0) :: shift env) e in
      [Seq body]

  | App (e1, e2) ->
      let c2 = generate_aux env e2 in
      let c1 = generate_aux (shift env) e1 in
      c2 @ c1 @ [Exec; Swap; Pop]

let generate expr = generate_aux [] expr