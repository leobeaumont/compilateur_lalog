%{
  open Ast
%}

(**************
 * The tokens *
 **************)

%token ADD SUB MUL DIV REM POP SWAP
%token EXEC GET APPEND PUSH
%token LPAR RPAR
%token <int> INT
%token EOF

(******************************
 * Entry points of the parser *
 ******************************)

%start <Ast.program> program

%%

(*************
 * The rules *
 *************)

program:
  i=INT cmds=commands EOF
    { (i, cmds) }

commands:
  | c=command cs=commands
      { c :: cs }
  |
      { [] }

command:
  | PUSH n=INT { Push n }
  | ADD        { Add }
  | SUB        { Sub }
  | MUL        { Mul }
  | DIV        { Div }
  | REM        { Rem }
  | POP        { Pop }
  | SWAP       { Swap }
  | EXEC       { Exec }
  | GET        { Get }
  | APPEND     { Append }
  | LPAR cmds=commands RPAR { Seq cmds }
  
%%