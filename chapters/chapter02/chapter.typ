#import "@preview/theorion:0.4.0": *
#import cosmos.fancy: *
#show: show-theorion
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#import "../../lib.typ": *

// apply numbering up to h3
#show heading: it => {
  if (it.level > 3) {
    block(it.body)
  } else {
    block(counter(heading).display() + " " + it.body)
  }
}

= Random Variables and Probability Distributions
This chapter will introduce us to the concept of random variables. In the first sections we are going to define the concepts of *discrete* and *continuous* random variables and their characteristic functions. Then we will explore some of the most important and widely used probability distributions.

== Background
To start off, it's important to understand *what is* a random variable. To do so, let us look at the following definition.

#definition(title: "Random Variable")[
  A *random variable* is a *function* of an _outcome_ defined as:

  #math.equation(block: true, numbering: "1", $X = f(omega) \ X : Omega -> X(Omega) = Omega_X subset.eq bb(R)$)

  In other words, it is a _quantity that depends on a chance_.
]

The *domain* of a random variable is the _sample space_ of a random experiment $Omega$, while the *range*, also called the *support*, of the random variables is a subset of the real numbers $bb(R)$, and it correspond to the possible values the random variable can take. Interesting cases are $bb(R), bb(N), (0, infinity), (0,1)$.

Since random variables are functions, we may be interesed in studying their inverse. Following we give a definition of this concept.

#definition(title: "Generalized Inverse of a Random Variable")[
  Given a random variable $X: Omega -> Omega_X$, its *generalized inverse* is defined as:

  #math.equation(block: true, numbering: "(1)", $X^(-1)(x) = {omega in Omega : X(omega) = x}$)<eq:generalized_inverse>
]

#remark[The definition we gave of generalized inverse in @eq:generalized_inverse may allow to include more than one value, thus $X^(-1)$ is not necessarily a function.
]

When we defined probability, we said that given $Omega$ and $frak(M)(Omega)$, if $A in frak(M)(Omega)$, then its probability was defined as a function $bb(P) : frak(M)(Omega) -> [0,1]$.
Now, we have a random variable $X$ defined on $Omega$ which maps values of $Omega -> Omega_X subset bb(R)$. This means that if we take $A$ and compute $X(A)$, this will get mapped to $A_X = {x = X(omega) : omega in A} subset bb(R)$. So, formally, we can't find $prob(A_X)$ because $A_X in.not frak(M)(Omega)$, to do so, we need to define a new *sigma-algebra* which we say to be *induced by the r.v.*.

To obtain such sigma-algebra, we consider the original sigma algebra $frak(M)(Omega)$ and we apply the mapping $X$ to the experiment with sigma algebra $frak(M)(Omega)$ to obtain the induced one $frak(M)(Omega_X)$. We can now define the "new probability" as:

#math.equation(block: true, numbering: none, $bb(P)_X: frak(M)(Omega_X) -> [0,1]$)

If $B in frak(M)(Omega_X)$, that is, $B$ is an event for the random variable $X$ on the experiment with sample space $Omega$,  then $bb(P)_(X){B} = prob(X^(-1)(B))$, where $X^1(B) in frak(M)(Omega)$. In practice we often ignore this $X$ and we treat $bb(P)$ and $bb(P)_X$ as the same function. We can do this as long as we don't get confused.

#example-box("usage of different r.v.'s for the same experiment", [
  Suppose we conduct an experiment where we roll two dice and record the results in order. Let's try to define $Omega$ in this situation.

  #math.equation(
    block: true,
    numbering: none,
    $
      Omega = {(x_1, x_2) : x_1, x_2 in {1 .. 6}}
    $,
  )

  It's easy to see that $|Omega| = 36$. Now let's think of different random variables for this experiment:

  - $X ->$ the result of the first die roll: $X((x_1, x_2)) = x_1$, where $(x_1, x_2) in Omega, x in bb(R)$. It's easy to see that $Omega_X = {1, 2, 3, 4, 5, 6}$.
  - $L ->$ the sum of both dice: $L((x_1, x_2)) = x_1 + x_2$, where $(x_1, x_2) in Omega, L in bb(R)$. In this case, $Omega_L = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}$.

  Clearly, $X$ and $L$ are related in some way, indeed if we knew that $x=1$, we could limit the possible values of $L$ to ${2, 3, 4, 5, 6, 7}$. In informal terms, we say that $X$ contains information about $L$.


  Let's now try to explore the *sigma-algebra* induced by *$X$*, this will be given by the *power set* $frak(M)(Omega_X) = 2^(Omega_X)$, that is, all possible subsets of $Omega_X$. For example if we take the event $B = {2,3,4} in frak(M)(Omega_X)$. Let's try to think about the generalized inverse of $X$ for this event:

  #math.equation(
    block: true,
    numbering: none,
    $
      X^(-1)({2,3,4}) = {(2,x_2), (3,x_2), (4,x_2) : x_2 in {1 .. 6}} subset Omega
    $,
  )

  We can notice that $|X^(-1)({2,3,4})| = 18$; thus we can compute the probability of this event:

  #math.equation(
    block: true,
    numbering: none,
    $
      bb(P)_(X){B} = prob(X^(-1)(B)) = 18/36 = 1/2
    $,
  )

  Let's now try to explore the *sigma-algebra* induced by *$L$*, this will be given by the *power set* $frak(M)(Omega_L) = 2^(Omega_L)$, that is, all possible subsets of $Omega_L$. In this case $B$ is *also* an element of $frak(M)(Omega_L)$. We can ask ourselves what is the probability of this event according to the random variable $L$.

  First of all we'll need to compute the generalized inverse of $L$ for this event $L^(-1)(B)$:
  #math.equation(
    block: true,
    numbering: none,
    $
      L^(-1)({2,3,4}) = {(1,1), (1,2), (2,1), (1,3), (2,2), (3,1)} subset Omega
    $,
  )

  We can notice that $|L^(-1)({2,3,4})| = 6$; thus we can compute the probability of this event:

  #math.equation(
    block: true,
    numbering: none,
    $
      bb(P)_(L){B} = prob(L^(-1)(B)) = 6/36 = 1/6
    $,
  )

  #remark[In this example we notice how it is important *not to omit* the random variable when computing probabilities, as different random variables may induce different sigma-algebras and thus different probabilities for the same event $B$.
  ]
])

The previous example illustrated how a random variable should theoretically modify the sample space and the sigma-algebra that we would use to compute our probabilities. To clarify for one last time this matter, we show what writing $bb(P)_(X)[B]$ really translates to:

#math.equation(
  block: true,
  numbering: "(1)",
  $
    bb(P)_(X){B} = prob(X in B) = prob({omega in Omega : X(omega) in B})
  $,
)

Sometimes, if $B$ is a singleton, we may write $bb(P)_(X){X = x}$ instead of $bb(P)_(X){{x}}$ to indicate the same event, where $prob(X = x) <-> prob(omega in Omega: X(omega) = x)$.

== Discrete Random Variables and their Distributions
As already mentioned in the introduction, random variables can be classified in two main categories: *discrete* and *continuous*. In this section we are going to explore discrete random variables and their characteristic functions.

If a random variable $X$ can only take a *finite* or at most *countable* number of values, we call it a *discrete random variable*.

#definition(title: "Distribution of Discrete R.V.")[
  Given a *discrete random variable* $X$, the _collection_ of all the probabilities related to $X$ is called the *distribution* of $X$.

  The function

  #math.equation(block: true, $p_(X)(x) = prob(X = x)$)

  is called the *probability mass function*. The *cumulative distribution function* is defined as:

  #math.equation(block: true, $F_(X)(x) = prob(X <= x) = sum_(y <= x) P(y)$)

  The set of all possible values of $X$ is called the *support* of the distribution.
]

=== Random Variable Characterization
Suppose we toss a fair coin three times and we want to count the number of heads $X$ that we get. The cumulative distribution function and probability mass function of such a random variable are illustrated in @fig:0201.
#figure(
  image("images/01_pmf_cdf.png", width: 90%),
  caption: "Example of Probability Mass Function (PMF) and Cumulative Distribution Function (CDF) for a discrete random variable X representing the number of heads in three coin tosses.",
)<fig:0201>

#remark[Boh the *pmf* and the *cdf* are said two *characterize the distribution*, that is, they contain all the information we need about a random variable. This means that we may be given each one of them, for every event we can think of it's possible to compute its probability.
]

It is actually possible to define another function to fully characterize a random variable, called the *survival function*.

#definition(title: "Survival Function of Discrete R.V.")[
  Given a *discrete random variable* $X$, the *survival function* is defined as:

  #math.equation(block: true, $overline(F)_(X)(x) = S_(X)(x) = prob(X > x) = 1 - F(x)$)
]

To summarize, given a *discrete* random variable $X$, we have the following functions that fully characterize its distribution:

- Probability Mass Function: $p_(X)(x) = prob(X = x) forall x in bb(R)$
- Cumulative Distribution Function: $F_(X)(x) = prob(X <= x) forall x in bb(R)$
- Survival Function: $overline(F)_(X)(x) = prob(X > x) = 1-F(x) forall x in bb(R)$

=== Properties of PMF, CDF and Survival Function
Following we describe some important properties of the concepts and functions we have just defined. First of all, since all the functions we have defined are related to probabilities, they must satisfy the axioms in @def:03_probability.

Once an experiment is completed, and the outcome $omega in Omega$ is known, the random variable $X$ will take a specifica value $X(omega) = x$, therefore the collection of events ${[X = x] : x in bb(R)}$ will form a *partition* of the sample space $Omega$ and thus:

#math.equation(
  block: true,
  numbering: none,
  $
    sum_(x) p_(X)(x) = sum_(x) prob(X = x) = 1
  $,
)

Particularly, for any event $A$, we have that:

#math.equation(
  block: true,
  numbering: none,
  $prob(X in A) = prob(A) = sum_(x in A) p_(X)(x)$,
)

== Continuous Random Variables and their Distributions
We say that a random variable $X$ is *continuous* if it can take an *uncountable* number of values. In this section we are going to explore continuous random variables and their characteristic functions.

The first thing we can notice is that the definition of *probability mass function* we gave for discrete random variables cannot be used in this situation: if we think about it, if $X$ can take an uncountable number of values, if every punctual probability was different from 0, this would violate the axiom of total probability, i.e., $sum_(x) prob(X = x) = infinity != 1$.

Therefore, a first important property we can derive for continuous random variables is:

#math.equation(
  block: true,
  numbering: none,
  $
    p_(X)(x) = 0, forall x in bb(R)
  $,
)

We need to find a different way to characterize continuous random variables. To do so, we introduce the concept of *probability density function*.

#definition(title: "Probability Density Function")[
  Given a random variable $X$, the  *probability density function* (pdf) of $X$ is a function $f_(X)(x)$ such that:

  #math.equation(
    block: true,
    $integral_(-infinity)^x f_(X)(x) d x = F_(X)(x) space <--> space f_(X)(x) = (d F_(X)(x)) / (d x)$,
  )
]

As already mentioned, the probability density function plays for continuous variables the same role of the probability mass function for discrete variables. Indeed $f(x) >= 0 forall x in bb(R)$ and

#math.equation(
  block: true,
  numbering: none,
  $integral_(-infinity)^(infinity)f(x) space d x = 1$,
)

In particular, for any event $A$ we have that

#math.equation(
  block: true,
  numbering: none,
  $prob(X in A) = prob(A) = integral_(x in A) f_(X)(x) space d x$,
)

#example-box("Typical Exercise", [
  Suppose the lifetime, in years, of some electronic component is a continuous random variable with the following probability density function:

  #math.equation(
    block: true,
    numbering: none,
    $
      f_(X)(x) = cases(k/x^3 space "if" x >= 1, 0 space space "otherwise")
    $,
  )

  Find $k$, draw a graph of the cdf $F(x)$ and compute the probability for the lifetime to exceed 5 years.

  #solution[
    To find $k$, we need to use the property that the total integral of the pdf must be equal to 1, that is:

    #math.equation(
      block: true,
      numbering: none,
      $
        integral_(1)^(infinity) f_(X)(x) space d x = integral_1^(infinity) (k/x^3) space d x = 1
      $,
    )

    Solving the integral we get:

    #math.equation(
      block: true,
      numbering: none,
      $
        k integral_1^infinity x^(-3) space d x = k[(x^(-2))/(-2)]_1^infinity = k(0 + 1/2) = k/2 = 1 space ==> space k = 2
      $,
    )

    Since we know that $"cdf" = integral"pdf"$ and we know that for $x < 1$ $F(x) = 0$, we can compute $F(x)$ for $x >= 1$:

    #math.equation(
      block: true,
      numbering: none,
      $
        F_(X)(x) = integral_1^x (2/t^3) space d t = 2[-(t^(-2))/2]_1^x = 1 - (1/x^2)
      $,
    )

    Now that we have the distribution function we can compute the probability that the lifetime exceeds five years by looking at the complement of the cdf at $x=5$:

    #math.equation(
      block: true,
      numbering: none,
      $
        prob(X > 5) = 1 - F_(X)(5) = 1 - (1 - 1/25) = 1/25 = 0.04
      $,
    )

    Following we also show the graph of the cdf $F(x)$ which should confirm our results:

    #figure(
      image("images/02_excdf.png", width: 60%),
      caption: "Cumulative Distribution Function (CDF) for the continuous random variable X representing the lifetime of an electronic component.",
    )
  ]
])

#pagebreak()

== Discrete vs Continuous Random Variables
Following we summarize the difference between discrete and continuous random variables:

#align(center)[
  #table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: horizon,
    table.header([*Distribution*], [*Discrete*], [*Continuous*]),
    [Definition],
    [(p.m.f.) $space space space p_(X)(x) = prob(X = x)$],
    [(p.d.f.) $space space space f_(X)(x) = F'(x)$],

    [Probability \ Computation],
    $prob(X in A) = limits(sum)_(x in A) p_(X)(x)$,
    $prob(X in A) = limits(integral)_(x in A) f_(X)(x) space d x$,

    [Cumulative \ Distribution \ Function],
    $F_(X)(x) = prob(X <= x) \ = limits(sum)_(y space <= space x) p_(X)(y)$,
    $F(x) = prob(X <= x) \ = limits(integral)_(-infinity)^x f(y) space d y$,

    [Total Probability], $limits(sum)_x p_(X)(x) = 1$, $limits(integral)_(-infinity)^(infinity) f(x) space d x = 1$,
  )
]

#remark[
  In both the discrete and continuous case, the *c.d.f.* $F(x)$ is a *non decreasing* function of $x$, taking values in $[0,1]$ with $limits(lim)_(x -> -infinity) F(x) = 0$ and $limits(lim)_(x -> infinity) F(x) = 1$. In case we were talking about the *survival function* the results would be inverted, that is, it would be a *non increasing* function of $x$, taking values in $[0,1]$ with $limits(lim)_(x -> -infinity) S(x) = 1$ and $limits(lim)_(x -> infinity) S(x) = 0$.
]
== Distribution of Random Vectors
Up to this moment we have only considered *one* random variable *at a time*. However in many practical situations we may be interested in studying *multiple* random variables *simultaneously*. To do so, we introduce the concept of *random vector*.

For simplicity, we focus on a vector *$(X,Y)$* of dimnesion $2$, but everything can be extended to higher dimensions.

Since we are talking about more than one random variable, we need to define the concept of *joint p.m.f* and *joint p.d.f*. Given two variables $X, Y$ we have:

#math.equation(
  block: true,
  numbering: "(1)",
  $
    p_(X,Y)(x,y) = prob((X,Y) = (x,y)) = prob(X = y inter Y = y)
  $,
)<eq:joint_pmf>

In this course, we are going to focus on homogeneous randon vectors, in which all the random variables are either discrete or continuous.

#definition(title: "Joint Cumulative Distribution Function")[
  For a vector of random variables, the *joint cumulative distribution function* is defined as follows:

  #math.equation(
    block: true,
    numbering: "(1)",
    $
      F_(X,Y)(x,y) = prob(X <= x inter Y <= y)
    $,
  )<eq:join_cdf>

  Given the join c.d.f we can also define the *join probability density function* as the mixed derivative of the joint c.d.f:

  #math.equation(
    block: true,
    numbering: "(1)",
    $
      f_(X,Y)(x,y) = (partial^2)/partial x partial y F_(X,Y)(x,y)
    $,
  )<eq:join_cdf>
]

Following we report in a table the main formulas we need to use in case we are dealing with continuous or discrete random vectors.

#align(center)[
  #table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: horizon,
    table.header([*Distribution*], [*Discrete*], [*Continuous*]),
    [Marginal \ Distributions],
    [$p_(X)(x) = limits(sum)_(y) p_(X,Y)(x,y)\ p_(Y)(y) = limits(sum)_(x)p_(X,Y)(x,y)$],
    [$f_(X)(x) = integral f_(X,Y)(x,y) d y \ f_(Y)(y) = integral f_(X,Y)(x,y) d x$],

    [Independence], $p_(X,Y)(x,y) = p_(X)(x) p_(Y)(y$, $f_(X,Y)(x,y) = f_(X)(x) f_(Y)(y)$,

    [Computing \ Probabilities],
    $prob((X,Y) in A) = \ limits(sum sum)_((x,y) in A) p_(X,Y)(x,y)$,
    $prob((X,Y) in A) = \ limits(integral integral)_((x,y) in A) f_(X,Y)(x,y) space d x space d y$,
  )
]
