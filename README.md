# Andoiii's Tinier Projects 🐲

A collection of one-off thingys that aren't big enough to realllyy have its own repository. In other words, a collection of week-old, super niche, user-unfriendly programs.

## Projects List

- [Antiquated Quadratic Calculator](https://github.com/Andoiiii/Tinier-Projects#antiquated-quadratic-calculator)
- [Antiquated Connect 4](https://github.com/Andoiiii/Tinier-Projects#antiquated-connect-4)
- [Single Trig Expression Reducer](https://github.com/Andoiiii/Tinier-Projects#single-trigonometric-expression-reducer)
---

### Antiquated Quadratic Calculator
Created back in 2021 when Andoiii started to first go into coding, this is a VERY rough quadratic calculator. It looks like it comes straight out of 2004, 
and could definetly need some help when it comes to user experience, but it works and gets the job done (when applicable).

**Functionality**
- Graphical Interface
- Can handle complex and square roots (Displays i and √)

**Anti-Functionality**
- Integer Inputs only
- Does not simplify answer
- Cannot give answers in decimal form

**Things Used**
- Python
- Tkinter Module

### Antiquated Connect 4
Ever wanted a Connect 4 that you can play in the terminal? Well, this exists. Written in 2021 by a younger Andoiii.

**Functionality**
- Row Numbers so you can tell which column is which

**Anti-Functionality**
- Only has 2 Player Mode
- Board print... looks awful

**Things Used**
- Python

### Single Trigonometric Expression Reducer
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
