open Ast
open BasicPfx.Ast
open BinOp

let rec generate = function
  | Const n ->
      [Push n]

  | Binop (op, e1, e2) ->
      let c1 = generate e1 in
      let c2 = generate e2 in
      let op_cmd =
        match op with
        | Badd -> Add
        | Bsub -> Sub
        | Bmul -> Mul
        | Bdiv -> Div
        | Bmod -> Rem
      in
      c2 @ c1 @ [op_cmd]

  | Uminus e ->
      generate e @ [Push (-1); Mul]

  | Var _ ->
      failwith "Not yet supported"
