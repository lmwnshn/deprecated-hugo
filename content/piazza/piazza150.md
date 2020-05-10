---
date: 2018-05-31
title: "150 Piazza"
summary: "Some questions from 150 Piazza."
tags: ["piazza-150"]
toc: true
---

## Continuation-passing style (CPS)

Various questions related to continuation-passing style.

---

### Is this function CPS?

If it helps to think about CPS, I like drawing a "where does the computer go" picture.

![fact1](/include/piazza/150cps-fact1.png)

In CPS: only forward! never back!

![fact2](/include/piazza/150cps-fact2.png)

Draw out where your function is going and if your arrows are all pointing forward you’re probably fine, CPS-wise.

---

### factCPS - renaming in traces for clarity

**Original trace by Jacob**

Given the following `factCPS` function,

```sml
(* factCPS : int -> (int -> 'a) -> 'a
 * REQUIRES: n>=0
 * ENSURES: factCPS n s == s(n!)
 *)
fun factCPS 0 s = s 1
  | factCPS n s = factCPS (n-1) (fn res => s(n*res))
```

Jacob wrote a trace for `factCPS 3 s`

```sml
factCPS 3 s
  ==> factCPS 2 (fn res => s(3*res))
  ==> factCPS 1 (fn res' => (fn res => s(3*res)) (2 * res'))
  ==> factCPS 0 (fn res'' => (fn res' => (fn res => s(3*res)) (2 * res')) (1 * res''))
  ==> (fn res'' => (fn res' => (fn res => s(3*res)) (2 * res')) (1 * res'')) (1)
  ==> (fn res' => (fn res => s(3*res)) (2 * res')) (1 * 1)
  ==> (fn res' => (fn res => s(3*res)) (2 * res')) 1
  ==> (fn res => s(3*res)) (2 * 1)
  ==> (fn res => s(3*res)) 2
  ==> s(3*2)
  ==> s(6)
```

**Renaming suggestion**

You can also rewrite it in this way, which clearly exposes a pattern and helps you keep track of continuations.

```sml
factCPS 3 s                                 s0 = s
  ==> factCPS 2 (fn res => s0 (3*res))      s1 = (fn res => s0 (3*res))
  ==> factCPS 1 (fn res => s1 (2*res))      s2 = (fn res => s1 (2*res))
  ==> factCPS 0 (fn res => s2 (1*res))      s3 = (fn res => s2 (1*res))
  ==> s3 1
  ==  (fn res => s2 (1*res)) 1
  ==> s2 (1*1)
  ==> s2 1
  ==  (fn res => s1 (2*res)) 1
  ==> s1 (2*1)
  ==> s1 2
  ==  (fn res => s0 (3*res)) 2
  ==> s0 (3*2)
  ==> s0 6
  ==  s 6
```

---

### searchPath CPS trace

In lab, someone requested a draft CPS evaluation trace for a slightly more complicated function.

Some notes:

- You might think that explicitly defining these `s1` `s2` `k1` `k2` ... is very tedious, but there is usually a very nice pattern to them that helps you avoid mistakes.
  - `s1 = (fn res => s (LEFT::res))`
  - `s2 = (fn res => s1 (LEFT::res))`
  - `k1 = (fn () => searchPath p R1 (fn res => s (RIGHT::res)) k)`
  - `k2 = (fn () => searchPath p Empty (fn res => s1 (RIGHT::res)) k1)`
- Tracing is still very painful. Unless we ask you to trace it, you may want to consider appealing to your intuition. That said, tracing can support and complement your intuition.
  - For example, my intuition says you call the failure continuation every time you bounce right.
  - And if you know how many layers in you went, you can use this predictable pattern to extract the continuation at any node directly.
  - But everyone has different intuition and there’s no one right way of thinking about it
- Technically I should show the expansion of `p 1`, `p 2`, `p 3` but I think you all can do that.

The main thing is to keep track of your changing continuations.

```sml
datatype direction = LEFT | RIGHT
(* searchPath : ('a -> bool) -> 'a tree -> (direction list -> 'b) -> (unit -> 'b) -> 'b *)
fun searchPath p Empty s k = k ()
  | searchPath p (Node(L,x,R)) s k = if p x then s [] else
          searchPath p L (fn res => s(LEFT::res)) (fn () => searchPath p R (fn res => s(RIGHT::res)) k)


(*
    Let T be the following tree
            1
        2       3
*)

searchPath (fn x => x = 3) (Node(Node(Empty, 2, Empty), 1, Node(Empty, 3, Empty))) SOME (fn () => NONE)

==

    letting
        p = (fn x => x = 3)
        T = (Node(Node(Empty, 2, Empty), 1, Node(Empty, 3, Empty)))
        s = SOME
        k = (fn () => NONE)

    searchPath p T s k

==
    letting
        from T = (Node(Node(Empty, 2, Empty), 1, Node(Empty, 3, Empty)))
            L1 = Node(Empty, 2, Empty)
            x = 1
            R1 = Node(Empty, 3, Empty)

    if p 1 then s [] else
    searchPath p L1 (fn res => s (LEFT::res)) (fn () => searchPath p R1 (fn res => s (RIGHT::res)) k)
==
    if false then s [] else
    searchPath p L1 (fn res => s (LEFT::res)) (fn () => searchPath p R1 (fn res => s (RIGHT::res)) k)
==
    searchPath p L1 (fn res => s (LEFT::res)) (fn () => searchPath p R1 (fn res => s (RIGHT::res)) k)
==
    searchPath p (Node(Empty, 2, Empty)) (fn res => s(LEFT::res)) (fn () => searchPath p R1 (fn res => s(RIGHT::res)) k)
==
    letting
        s1 = (fn res => s(LEFT::res))
        k1 = (fn () => searchPath p R1 (fn res => s (RIGHT::res)) k)

    searchPath p (Node(Empty, 2, Empty)) s1 k1
==
    if p 2 then s1 [] else
    searchPath p Empty (fn res => s1 (LEFT::res)) (fn () => searchPath p Empty (fn res => s1 (RIGHT::res)) k1)
==
    if false then s1 [] else
    searchPath p Empty (fn res => s1 (LEFT::res)) (fn () => searchPath p Empty (fn res => s1(RIGHT::res)) k1)
==
    searchPath p Empty (fn res => s1 (LEFT::res)) (fn () => searchPath p Empty (fn res => s1(RIGHT::res)) k1)
==
    letting
        s2 = (fn res => s1 (LEFT::res))
        k2 = (fn () => searchPath p Empty (fn res => s1 (RIGHT::res)) k1)

    searchPath p Empty s2 k2
==
    k2 ()
==
    (fn () => searchPath p Empty (fn res => s1 (RIGHT::res)) k1) ()
==
    searchPath p Empty (fn res => s1 (RIGHT::res)) k1
==
    k1 ()
==
    (fn () => searchPath p R1 (fn res => s (RIGHT::res)) k) ()
==
    searchPath p R1 (fn res => s (RIGHT::res)) k
==
    letting
        s3 = (fn res => s (RIGHT::res))

    searchPath p (Node(Empty, 3, Empty)) s3 k
==
    if p 3 then s3 [] else
    searchPath p Empty (fn res => s3 (LEFT::res)) (fn () => searchPath p Empty (fn res => s3 (RIGHT::res)) k)
==
    if true then s3 [] else
    searchPath p Empty (fn res => s3 (LEFT::res)) (fn () => searchPath p Empty (fn res => s3 (RIGHT::res)) k)
==
    s3 []
==
    (fn res => s (RIGHT::res)) []
==
    s (RIGHT::[])
==
    s [RIGHT]
==
    SOME [RIGHT]
```

---

### Mutual recursion in Stream.tabulate

N.B. I personally have issues with my answer to this question, but it appears to have helped people, so well...

**Original question (edited)**

I’m having a little difficulty reasoning about `Stream.tabulate`

```sml
fun tabulate f = delay (fn () => tabulate' f)
  and tabulate' f = Cons(f(0), tabulate (fn i => f(i+1)))
```

Why does it feel like it is `f(0)` `f(1)` `f(1)` `f(1)`... instead of `f(0)`, `f(1)`, `f(2)`, `f(3)`...? I think I can understand using natural language saying that every time tabulate gets called the `i` is already increased by one, but I guess I just don’t know how to step through the code?

**Answer (edited)**

Good morning!

I like to think of our mutually recursive functions as a ping pong ball bouncing around, though I'm not sure that's very relevant here.

But it's kind of like CPS, where we are modifying the function `f` each time. So all the `tabulate'` calls are using different `f`'s.

Let’s step through the tabulate!

If you call `tabulate f`, your first element is from `tabulate' f`, which is just `f(0)`, like you said.

What will the rest of your elements be?

It'll be the result of `tabulate (different f)` where this `(different f)` is some sneaky looking monkey that will add one to whatever number you give it.

So in particular, when `tabulate (different f)` is called, it will end up getting `f(1)`.

So far, I think, you are ok until here.

Now let's think about what you get for the REST of the stream.

This time, it'll be the result of `tabulate (yet another f)`, where `(yet another f)` is some cat that adds one, before passing it to the monkey that adds one.

You’re wrapping the wrapped function! It might look something like this,

```sml
(fn j => (fn i => f (i+1)) (j+1)) (* functions are burritos *)
```

(when working recursively, I personally find it helpful to think of functions as creatures doing things instead of just saying function all the time - sorry if it doesn’t help or made it more confusing)

In particular, two things that I think may be helpful to highlight:

I think you accept that we can wrap the `f` function with `(fn i => f (i+1))`. Well, nothing is stopping you from wrapping this wrapper function! So it's like `(fn j => (fn i => f (i+1)) (j+1))`.

The Cons cells are really just "one element, and something that will give me the rest of the elements". So in particular, each cell only cares about itself and its neighbor. Sure, you can get from the first cell to the 2190821903213th cell, but the first cell is only "directly connected to" the second cell. So there’s no reason that the first cell gets to tell everyone that they have to do `f(1)`, `f(1)`, ... and so on. It’s not the same function and not the same `i`. You only get to tell the person next to you what you want.

---

## Alpha-Beta

### Alpha-Beta hack for exam speed

**Original 150 alpha-beta table by Jeanne**

150 has an alpha-beta table, courtesy of Jeanne:

```
| Player |  v≤α   |  α<v<β   |  v≥β   |
|-------------------------------------|
| Minnie | Prune  | Update β | Ignore |
| Maxie  | Ignore | Update α | Prune  |
```
**The hack**

For conceptual understanding, you should rely on the table. But in exam conditions, these two rules produce the same results faster:

- no take-backs
  - bounds are attached to edges
  - write down the bound as you go down the edge
  - never modify the bound once you have it written down

- just update
  - maxie always updates left bound as max(left, x)
  - minnie always updates right bound as min(right, x)
  - if you end up writing an invalid bound like (7,5) or in general (a,b) where a > b then you should have pruned
