# Single Trigonometric Expression Reducer
Type in `(sin-reduce n)` or `(cos-reduce n)` and it will rewrite the corresponding thing in solely terms of sin x and cos x!  
For instance, `(sin-reduce 4)` basically asks the computer to reduce sin 4x into a form with only sin x and cos x. Nifty but Niche.

**Functionality**
- Can take negative input like `(sin-reduce -4)`
- A Memoized Solution is provided in `RecursiveReducer.rkt` that uses Top-Down Memoization. 
- A WAY better solution using DeMoivre's Theorem is also provided in `DMTReducer.rkt`, being able to compute `(sin-reduce 10000)`
- Basic Trig Algebra System in the form of `TrigProd.rkt`

**Anti-Functionality**
- Glorified Pascal's Triangle Calculator
- Does not know what the Pythagorean Identity is and thus won't simplify like that
- 0 IRL use cases
 
**Things Used**
- Racket
