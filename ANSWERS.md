### Answers to expl and math questions


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