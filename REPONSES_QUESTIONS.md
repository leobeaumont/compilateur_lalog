# Beaumont Léo et Chouki Mouad
## Exercice 1

**What is a stack? What are the operations that you usually execute on a stack?**

Une stack (ou pile) est une structure de données qui suit le principe **LIFO (Last In First Out)**, c’est-à-dire que le dernier élément ajouté est le premier à être retiré.

Les éléments ne peuvent être manipulés qu’au **sommet de la pile**. On ne peut pas accéder directement aux éléments situés plus profondément sans retirer ceux qui sont au-dessus.

Les opérations les plus courantes sur une pile sont :

- **push** : ajoute un élément au sommet de la pile ;
- **pop** : retire l’élément situé au sommet de la pile ;
- **peek** (ou **top**) : permet de lire l’élément au sommet sans le retirer ;
- **swap** : échange les deux éléments situés au sommet de la pile.

## Exercice 2

**Detail in the same way the execution of 0 push 12 push 7 swap sub.**

Le schéma suivant illustre les différentes étapes de l'exécution :

![Execution de la pile](images/steps.png)

## Exercice 3

### 3.1 Explain using plain words the semantics of programs.

La sémantique d’un programme décrit comment un programme Pfx est exécuté à partir d’une liste de paramètres.

Un programme est défini par deux éléments :  
- un entier n qui représente le nombre d’arguments attendus par le programme,  
- une séquence d’instructions Q.

Les arguments v1, ..., vn sont empilés dans la pile avant l’exécution du programme.

Les règles données décrivent les différents résultats possibles de l’exécution :

1. Si le nombre d’arguments fournis est différent du nombre d’arguments attendus par le programme, alors l’exécution produit une erreur.

2. Si le nombre d’arguments est correct mais que l’exécution des instructions mène à une erreur pendant le calcul, alors le résultat du programme est également une erreur.

3. Si l’exécution des instructions se termine correctement, la pile contient une valeur v au sommet. Cette valeur est alors le résultat final du programme.


### 3.2 A case is still missing, spot it out and give the corresponding rule.

Un cas n’est pas couvert par les règles données : lorsque l’exécution du programme se termine sans erreur mais que la pile finale est vide. Dans cette situation, aucune valeur ne peut être retournée comme résultat du programme.

Ce cas doit donc produire une erreur.

La règle correspondante peut être écrite comme suit :

$$ \frac{Q, v_1 :: \dots :: v_n :: \emptyset \rightarrow^* \emptyset, \emptyset}{v_1, \dots, v_n \Vdash n, Q \Rightarrow ERR} $$

## Exercice 3

### 3.3 Give the rules describing the small step semantics for instruction sequences. Beware to cover all cases of runtime errors.

Les règles suivantes décrivent la sémantique opérationnelle en petits pas des instructions du langage Pfx.  
Chaque règle décrit comment une instruction transforme la pile et la séquence d’instructions restante.

**Push**

$$
push\ n . Q , S \rightarrow Q , n :: S
$$

**Pop**

$$
pop . Q , n :: S \rightarrow Q , S
$$

**Swap**

$$
swap . Q , n_1 :: n_2 :: S \rightarrow Q , n_2 :: n_1 :: S
$$

**Add**

$$
add . Q , n_1 :: n_2 :: S \rightarrow Q , (n_2 + n_1) :: S
$$

**Sub**

$$
sub . Q , n_1 :: n_2 :: S \rightarrow Q , (n_2 - n_1) :: S
$$

**Mul**

$$
mul . Q , n_1 :: n_2 :: S \rightarrow Q , (n_2 \times n_1) :: S
$$

**Div**

$$
\frac{n_1 \neq 0}{div . Q , n_1 :: n_2 :: S \rightarrow Q , (n_2 / n_1) :: S}
$$

**Rem**

$$
\frac{n_1 \neq 0}{rem . Q , n_1 :: n_2 :: S \rightarrow Q , (n_2 \bmod n_1) :: S}
$$

**Erreurs d'exécution**

Les erreurs d'exécution se produisent lorsque la pile ne contient pas suffisamment d'éléments pour exécuter l'instruction ou lorsque l'on tente une division par zéro.

**Pop sur pile vide**

$$
pop . Q , \emptyset \rightarrow Err
$$

**Swap avec moins de deux éléments**

$$
swap . Q , n :: \emptyset \rightarrow Err
$$

$$
swap . Q , \emptyset \rightarrow Err
$$

**Opérations arithmétiques avec moins de deux éléments**

$$
op . Q , \emptyset \rightarrow Err
$$

$$
op . Q , n :: \emptyset \rightarrow Err
$$

où $op \in \{add, sub, mul, div, rem\}$.

**Division ou reste par zéro**

$$
div . Q , 0 :: n :: S \rightarrow Err
$$

$$
rem . Q , 0 :: n :: S \rightarrow Err
$$
## Exercice 4
### 4.1 Propose the OCaml code for a type command describing the Pfx instructions. It should be in the file pfx/basic/ast.ml
```oCaml
type command =
  | Push of int
  | Pop
  | Swap
  | Add
  | Sub
  | Mul
  | Div
  | Rem
```
Le type commande défini chaque instruction possible. Il y a un cas particulier pour l'instruction `push` qui prend un `int` en argument, on ajoute donc `of int` pour le préciser. On vient également compléter la déclaration de type dans le fichier `pfx/basic/ast.mli`. On vient également compléter la fonction `string_of_command` qui associe à chaque instruction sa notation en texte. Pour cela on utilise le pattern matching. Le seul cas particulier est le `push` pour lequel on doit transformer son argument en `string` en utilisant `string_of_int` et la concaténation de `string`.
### 4.2 Write an OCaml function step that implements the small step reduction you defined above on Pfx instructions. It should be in the file pfx/basic/eval.ml
```oCaml
let step state =
  match state with
  | [], _ -> Error("Nothing to step",state)
  (* Division by 0 *)
  | Div :: q, v1 :: 0 :: stack -> Error("Division by 0", state)
  | Rem :: q, v1 :: 0 :: stack -> Error("Division by 0", state)
  (* Valid configurations *)
  | Push n :: q , stack          -> Ok (q, n :: stack)
  | Pop :: q, v :: stack         -> Ok (q, stack)
  | Swap :: q, v1 :: v2 :: stack -> Ok (q, v2 :: v1 :: stack)
  | Add :: q, v1 :: v2 :: stack  -> Ok (q, (v1 + v2) :: stack)
  | Sub :: q, v1 :: v2 :: stack  -> Ok (q, (v1 - v2) :: stack)
  | Mul :: q, v1 :: v2 :: stack  -> Ok (q, (v1 * v2) :: stack)
  | Div :: q, v1 :: v2 :: stack  -> Ok (q, (v1 / v2) :: stack)
  | Rem :: q, v1 :: v2 :: stack  -> Ok (q, (v1 mod v2) :: stack)
  (* Not enough elements in stack *)
  | command :: q, stack -> Error("Stack underflow", state)
  ```
Pour l'implémentation de la fonction `step` nous utilisons le pattern matching. Une propriété intéressante du pattern matching en oCaml est que l'ordre d'apparation de chaque `case` dans le code détermine l'ordre dans lequel le matching est effectué. Nous pouvons donc utiliser cela pour dans un premier temps tester les cas d'erreurs comme la division par 0 ou l'absence d'instruction. Après s'être assuré que la commande ne mène pas à une erreur, nous poursuivons avec les cas valides des instructions (`push`, `pop`, `swap`, `add`, `sub`, `mul`, `div` et `rem`), qui effectuent chacune l'opération qui leur est associée sur la pile. Si auncune erreur et aucun pattern valide n'est matché alors il ne reste plus que le cas où il n'y a pas assez d'éléments dans la pile pour réaliser l'instruction, on renvoit donc une erreur sans se préoccuper de l'instruction.
## Exercice 5
### 5.1 Propose a compilation schema of Expr in Pfx. Give its formal description. Notice that with the current definition of Pfx, we cannot implement variables.
La compilation d’une expression du langage `Expr` vers le langage `Pfx` consiste à transformer l’arbre syntaxique de l’expression en une séquence d’instructions pour la machine à pile Pfx.  
L’objectif est que l’exécution de cette séquence d’instructions laisse la valeur de l’expression au sommet de la pile.

On note cette traduction :
$$
\llbracket e \rrbracket
$$
qui représente la séquence d’instructions Pfx générée à partir de l’expression $e$.

Les règles de compilation sont les suivantes.

**Constante**

$$
\llbracket Const(n) \rrbracket = push\ n
$$

**Addition**

$$
\llbracket Binop(Badd, e_1, e_2) \rrbracket =
\llbracket e_2 \rrbracket \;
\llbracket e_1 \rrbracket \;
add
$$

**Soustraction**

$$
\llbracket Binop(Bsub, e_1, e_2) \rrbracket =
\llbracket e_2 \rrbracket \;
\llbracket e_1 \rrbracket \;
sub
$$

**Multiplication**

$$
\llbracket Binop(Bmul, e_1, e_2) \rrbracket =
\llbracket e_2 \rrbracket \;
\llbracket e_1 \rrbracket \;
mul
$$

**Division**

$$
\llbracket Binop(Bdiv, e_1, e_2) \rrbracket =
\llbracket e_2 \rrbracket \;
\llbracket e_1 \rrbracket \;
div
$$

**Modulo**

$$
\llbracket Binop(Bmod, e_1, e_2) \rrbracket =
\llbracket e_2 \rrbracket \;
\llbracket e_1 \rrbracket \;
rem
$$

**Moins unaire**

$$
\llbracket Uminus(e) \rrbracket =
\llbracket e \rrbracket \;
push\ (-1) \;
mul
$$

Les variables ne peuvent pas être compilées dans cette version du langage Pfx, car la machine à pile ne possède pas de mécanisme pour stocker ou accéder à des variables. Leur implémentation est donc reportée à un exercice ultérieur.
### 5.2 Define a function generate implementing the semantics you defined in previous question. It should be in the file expr/basic/toPfx.ml
```oCaml
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
```
La fonction `generate` traite les différents cas du langage `Expr` en suivant la logique définie dans la question `5.1`.

On commence par traiter le cas `Const n` qui correspond simplement à pousser `n` sur la pile.

Dans le cas d'une opération binaire (`Binop`), elle se décompose en trois éléments: l'opération `op` et les deux expressions `e1` et `e2` sur lesquelles l'opération est appliquée. Dans ce cas on appelle récursivement `generate` sur les expressions `e1` et `e2` pour terminer leur traitement. Ensuite on concatène le traitement de `e2`, puis le traitement de `e1` et enfin l'opération `op`. L'ordre est important car nous voulons que `e1` se trouve au sommet de la pile avec `e2` juste en dessous, suivi de l'opération `op` pour que les opérations non commutatives comme la soustractions fassent bien `e1 - e2` et non `e2 - e1`.

Pour `Uminus` qui permet d'obtenir l'opposé d'une expression `e`, on appelle récursivement `generate` pour finir le traitement de `e`. On concatène le traitement de `e` avec l'instruction `push -1` et l'opération `mul`. Concrètement cela permet de multiplier l'expression `e` par -1 et donc d'obtenir son opposé.

## Exercice 6

### 6.1 Write a lexer for the Pfx stack machine language. Complete the provided lexer.mll of pfx/basic.

```ocaml
rule token = parse
  | newline+         { token lexbuf }
  | blank+           { token lexbuf }
  | eof              { EOF }

  | number as nb     { mk_int nb }

  | "add"            { ADD }
  | "sub"            { SUB }
  | "mul"            { MUL }
  | "div"            { DIV }
  | "rem"            { REM }
  | "pop"            { POP }
  | "swap"           { SWAP }

  | _ as c           { failwith (Printf.sprintf "Illegal character '%c': " c) }
```

Le fichier `lexer.mll` définit un analyseur lexical pour le langage `Pfx` en utilisant l’outil `ocamllex`. Le rôle du lexer est de transformer une suite de caractères lue dans un fichier `.pfx` en une suite de tokens qui seront ensuite utilisés par le parser.

Les premières règles permettent d’ignorer certains caractères qui ne sont pas significatifs pour l’analyse syntaxique. Les règles `newline+` et `blank+` correspondent respectivement aux retours à la ligne et aux espaces. Dans ces cas, le lexer appelle récursivement la fonction `token` afin de continuer l’analyse sans produire de token.

La règle `eof` correspond à la fin du fichier et produit le token `EOF`.

La règle `number as nb` permet de reconnaître une suite de chiffres représentant un entier. La chaîne correspondante est convertie en entier grâce à la fonction `mk_int`, qui produit un token `INT`.

Les règles suivantes reconnaissent les différentes instructions du langage `Pfx`. Chaque mot clé du langage est associé à un token correspondant : `add`, `sub`, `mul`, `div`, `rem`, `pop` et `swap`.

Enfin, la dernière règle capture tout caractère qui ne correspond à aucune règle précédente. Dans ce cas, une exception est levée indiquant qu’un caractère illégal a été rencontré dans le fichier source.

---

### 6.2 Reuse this code to be able to parse a file containing a Pfx program and prints all the tokens encountered in the process.

```ocaml
let rec examine_all lexbuf =
  let result = token lexbuf in
  print_token result;
  print_string " ";
  match result with
  | EOF -> ()
  | _   -> examine_all lexbuf
```

La fonction `examine_all` permet de tester le fonctionnement du lexer en affichant tous les tokens reconnus dans un fichier `.pfx`.

Elle prend en argument un `lexbuf`, qui est une structure utilisée par le lexer pour lire le flux de caractères provenant du fichier d’entrée.

À chaque appel, la fonction appelle `token lexbuf` afin d’obtenir le prochain token reconnu par le lexer. Ce token est ensuite affiché grâce à la fonction `print_token`. Après l’affichage, un espace est ajouté afin de rendre la sortie plus lisible.

La fonction examine ensuite le token obtenu. Si le token est `EOF`, cela signifie que la fin du fichier a été atteinte et la fonction s’arrête. Sinon, elle s’appelle récursivement afin d’analyser le reste du fichier.

Cette fonction permet donc de parcourir entièrement un fichier source et d’afficher tous les tokens générés par le lexer. Elle constitue un moyen simple de vérifier que l’analyse lexicale du langage `Pfx` fonctionne correctement avant de connecter le lexer au parser.