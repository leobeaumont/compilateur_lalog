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
      let free_vars = List.filter (fun (v, _) -> v <> x) env in
      let free_env = List.mapi (fun i (v, _) -> (v, i)) free_vars in
      let x_depth = List.length free_vars in
      let full_env = (x, x_depth) :: free_env in
      let body = generate_aux full_env e in
      if free_vars = [] then
        [Seq (body @ [Swap; Pop])]
      else
        let inner = [Seq (body @ [Swap; Pop])] in
        List.fold_left
          (fun acc (_, d) -> [Push d; Get] @ acc @ [Swap; Append])
          inner
          free_vars

  | App (e1, e2) ->
      let c2 = generate_aux env e2 in
      let c1 = generate_aux (shift env) e1 in
      c2 @ c1 @ [Exec]
let generate expr = generate_aux [] expr