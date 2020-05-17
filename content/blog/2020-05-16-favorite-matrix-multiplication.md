---
date: 2020-05-12
title: "Favorite matrix multiplication"
summary: "linear algebra is cool"
tags: ["cmu", "useful"]
toc: true
---

Just some quick random beginner-level thoughts on matrix multiplication.

## Foreword

I must have written this down at least 20 times while I was at CMU. It reassures me that I'm pushing numbers around correctly.

\\[
\begin{pmatrix}
1 & 2 \\\\
3 & 4
\end{pmatrix}
\begin{pmatrix}
5 & 6 \\\\
7 & 8
\end{pmatrix}
\=
\begin{pmatrix}
19 & 22 \\\\
43 & 50
\end{pmatrix}
\\]

That was computed in the standard way,
\\[
\begin{pmatrix}
1 & 2 \\\\
3 & 4
\end{pmatrix}
\begin{pmatrix}
\color{red}{5} & \color{blue}{6} \\\\
\color{red}{7} & \color{blue}{8}
\end{pmatrix}
\=
\begin{pmatrix}
1 \cdot \color{red}{5} + 2 \cdot \color{red}{7} & 1 \cdot \color{blue}{6} + 2 \cdot \color{blue}{8} \\\\
3 \cdot \color{red}{5} + 4 \cdot \color{red}{7} & 3 \cdot \color{blue}{6} + 4 \cdot \color{blue}{8}
\end{pmatrix}
\\]

Which is a really tedious way of doing things, right? Too many multiplications and additions. Here are a few more ways to see the same thing.

## Result in left's column space

\\[
\begin{pmatrix}
\color{red}{1} & \color{blue}{2} \\\\
\color{red}{3} & \color{blue}{4}
\end{pmatrix}
\begin{pmatrix}
\color{green}{5} & 6 \\\\
\color{green}{7} & 8
\end{pmatrix}
\=
\begin{pmatrix}
\color{green}{19} & 22 \\\\
\color{green}{43} & 50
\end{pmatrix}
\\]

To get the first column of the result,
\\[
\begin{pmatrix}
\color{green}{19} \\\\
\color{green}{43}
\end{pmatrix}
\=
\color{green}{5} \cdot
\begin{pmatrix}
\color{red}{1} \\\\
\color{red}{3}
\end{pmatrix}
+
\color{green}{7} \cdot
\begin{pmatrix}
\color{blue}{2} \\\\
\color{blue}{4}
\end{pmatrix}
\\]

Similarly, to get the second column of the result,
\\[
\begin{pmatrix}
22 \\\\
50
\end{pmatrix}
\=
6 \cdot
\begin{pmatrix}
\color{red}{1} \\\\
\color{red}{3}
\end{pmatrix}
+
8 \cdot
\begin{pmatrix}
\color{blue}{2} \\\\
\color{blue}{4}
\end{pmatrix}
\\]

But by looking at it this way, it becomes immediately obvious that the resulting matrix is always in the column space of the left matrix.

## Result in right's row space

\\[
\begin{pmatrix}
\color{green}{1} & \color{green}{2} \\\\
3 & 4
\end{pmatrix}
\begin{pmatrix}
\color{red}{5} & \color{red}{6} \\\\
\color{blue}{7} & \color{blue}{8}
\end{pmatrix}
\=
\begin{pmatrix}
\color{green}{19} & \color{green}{22} \\\\
43 & 50
\end{pmatrix}
\\]

To get the first row of the result,
\\[
\begin{pmatrix}
\color{green}{19} & \color{green}{22}
\end{pmatrix}
\=
\color{green}{1} \cdot
\begin{pmatrix}
\color{red}{5} & \color{red}{6}
\end{pmatrix}
+
\color{green}{2} \cdot
\begin{pmatrix}
\color{blue}{7} & \color{blue}{8}
\end{pmatrix}
\\]
And to get the second row of the result,
\\[
\begin{pmatrix}
43 & 50
\end{pmatrix}
\=
3 \cdot
\begin{pmatrix}
\color{red}{5} & \color{red}{6}
\end{pmatrix}
+
4 \cdot
\begin{pmatrix}
\color{blue}{7} & \color{blue}{8}
\end{pmatrix}
\\]

And now by looking at it this way, it becomes immediately obvious that the resulting matrix is always in the row space of the right matrix.

## Other thoughts

- Linear algebra is probably my favorite field of math. There are so many ways to interpret something, and it really rewards dwelling on stuff.
- Why is this true? It was proved as a homework problem in 21-242, so I suppose I shouldn't type it up, but [Strang's book](https://math.mit.edu/~gs/learningfromdata/) chapter I.2 proves it as well. That book and [18.065](https://ocw.mit.edu/courses/mathematics/18-065-matrix-methods-in-data-analysis-signal-processing-and-machine-learning-spring-2018/) in general is a conceptual goldmine as a second course in working with matrices.
- Additionally, that course talks about many more useful perspectives (decompositions) of matrices. For example, the singular value decomposition can be used to get rid of the less useful parts of an image. Possible TODO for future site updates, embed JavaScript simulations for playing with image SVD compression. Showing all the common decompositions with color annotations and useful applications actually seems like a pretty nice thing in general to build, possible winter break project?
- The approximate matrix product and sketching stuff in [15-859](http://www.cs.cmu.edu/~dwoodruf/teaching/15859-fall19/index.html) stuff is one of my favorite "things I wish I understood better" that I've encountered in CMU. Woodruff is great, would strongly recommend the course.
