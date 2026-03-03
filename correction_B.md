## 1

M, R ⊢ bool true -> Sr1
M, R ⊢ bool false -> Sr0

M,R ⊢ Var x -> L(m x) R

M, Ra ⊢ f1 -> P1         M, Rb ⊢ f2 -> P2
___________________________________________
M, R ⊢ And (f1, f2) -> P1 @ P2
