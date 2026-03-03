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
2) Cette sémantique stipule que si une paire instructions X stack se réduit récursivement en une erreur. Alors le programme correspondant doit produire une erreur.
3) Cette sémantique stipule que si une paire instructions X stack se réduit récursivement en une paire ensemble vide X stack avec un élément v au sommet. Alors le programme correspondant doit rendre l'élément v.