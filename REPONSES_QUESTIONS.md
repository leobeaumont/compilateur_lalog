# Beaumont Léo et Chouki Mouad
## Exercice 1
### What is a stack? What are the operations that you usually execute on a stack?
Une pile est une structure de donnée dans laquelle la donnée peut être empillée. On ne peut ajouter/lire/retirer une donnée que sur le sommet de la pile. Les opérations classiques sur une pile sont:
- empiler (stack): permet d'ajouter un élément sur la pile.
- dépiler (pop): permet de retirer et de rendre la valeur de l'élément au sommet de la pile.
## Exercice 2
### Detail in the same way the execution of 0 push 12 push 7 swap sub
Les instructions se lisent mot par mot de gauche à droite. Voici ce que fait le programme étape par étape:
1) 0: indique que le programme prend 0 arguments, la pile est donc initialement vide.
2) push 12: l'opération push prend un argument qui est simplement la prochaine donnée sur la pile. Dans ce cas le programme va empiler 12. La pile est: || 12 -> .
3) push 7: de même, cette opération empile 7. La pile est: || 12, 7 -> .
4) swap: cette opération inverse les deux éléments au sommet de la pile. La pile devient alors: || 7, 12 -> .
5) sub: cette opération va dépiler le premier élément de la pile et lui soustraire le second élément de la pile (qui est lui aussi dépilé). Le résultat de cette soustraction est ensuite empilé. Au final la pile est: || 5 -> .
## Exercice 3
### 3.1 Explain using plain words the semantics of programs
1) Cette sémantique stipule que si le nombre d'arguments donné au programme est différent de celui prévu, le programme doit produire une erreur.
2) Cette sémantique stipule que si une paire `instructions X stack` se réduit récursivement en une erreur. Alors le programme correspondant doit produire une erreur.
3) Cette sémantique stipule que si une paire `instructions X stack` se réduit récursivement en une paire `ensemble vide X stack` avec un élément v au sommet de la pile. Alors le programme correspondant doit rendre l'élément v.
### 3.2 A case is still missing, spot it out and give the corresponding rule
Le cas manquant est celui où le programme termine ses instructions et que sa pile est vide. Il n'a alors aucune valeur à rendre. Il va donc produire une erreur. La sémantique correspondante est la suivante:
$$ \frac{Q, v_1 :: \dots :: v_n :: \emptyset \rightarrow \emptyset, \emptyset}{v_1, \dots, v_n \Vdash n, Q \Rightarrow ERR} $$
### 3.3 Give the rules describing the small step semantics for instruction sequences. Beware to cover all cases of runtime errors
1) push
$$ \frac{n \notin \mathbb{Z}}{push \, n.Q, S \rightarrow ERR} $$
$$ \frac{}{push \, n.Q, S \rightarrow Q, n :: S} $$
2) pop
$$ \frac{}{pop.Q, \emptyset \rightarrow ERR} $$
$$ \frac{}{pop.Q, v :: S \rightarrow Q, S} $$
3) swap
$$ \frac{\# S < 2}{swap.Q, S \rightarrow ERR} $$
$$ \frac{}{swap.Q, v_1 :: v_2 :: S \rightarrow Q, v_2 :: v_1 :: S} $$
4) add
$$ \frac{\#S < 2}{add.Q, S \rightarrow ERR} $$
$$ \frac{}{add.Q, v_1 :: v_2 :: S \rightarrow Q, (v_1 + v_2) ::S} $$
5) sub
$$ \frac{\#S < 2}{sub.Q, S \rightarrow ERR} $$
$$ \frac{}{sub.Q, v_1 :: v_2 :: S \rightarrow Q, (v_1 - v_2) :: S} $$
6) mul
$$ \frac{\#S < 2}{mul.Q, S \rightarrow ERR} $$
$$ \frac{}{mul.Q, v_1 :: v_2 :: S \rightarrow Q, (v_1 * v_2) :: S} $$
7) div
$$ \frac{\#S < 2}{div.Q, S \rightarrow ERR} $$
$$ \frac{v_2 = 0}{div.Q, v_1 :: v_2 :: S \rightarrow ERR} $$
$$ \frac{}{div.Q, v_1 :: v_2 :: S \rightarrow Q, (v_1 // v_2) :: S} $$
8) rem
$$ \frac{\#S < 2}{rem.Q, S \rightarrow ERR} $$
$$ \frac{v_2 = 0}{rem.Q, v_1 :: v_2 :: S \rightarrow ERR} $$
$$ \frac{}{rem.Q, v_1 :: v_2 :: S \rightarrow Q, (v_1 \% v_2) :: S} $$
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
A FAIRE
