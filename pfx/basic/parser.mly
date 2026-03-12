%{
  (* Ocaml code here*)

%}

(**************
 * The tokens *
 **************)

(* enter tokens here, they should begin with %token *)
%token ADD SUB MUL DIV REM POP SWAP
%token <int> INT
%token EOF


(******************************
 * Entry points of the parser *
 ******************************)

(* enter your %start clause here *)
%start <Ast.program> program

%%

(*************
 * The rules *
 *************)

(* list all rules composing your grammar; obviously your entry point has to be present *)

program: i=INT EOF { i,[] }

%%
