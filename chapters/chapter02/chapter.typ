#import "@preview/theorion:0.4.0": *
#import cosmos.fancy: *
#show: show-theorion
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#import "../../lib.typ": *
#import "@preview/cetz:0.4.2"

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

#figure(
  table(
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
  ),
  caption: "Main differences between discrete and continuous random variables.",
)

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
      f_(X,Y)(x,y) = (partial^2)/(partial x partial y) F_(X,Y)(x,y)
    $,
  )<eq:join_cdf>
]

Following we report in a table the main formulas we need to use in case we are dealing with continuous or discrete random vectors.

#figure(
  table(
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
  ),
  caption: "Main formulas for discrete and continuous random vectors.",
)<tab:0201>

@tab:0201 already introduces to the concept of *independence* between two random variables. To clarify this concept, we give the following definition.

#definition(title: "Independent Random Variables")[
  Given random variables $X, Y$ we say that they are *independent* if:

  #math.equation(
    block: true,
    numbering: "(1)",
    $
      p_(X,Y)(x,y) = p_(X)(x) p_(Y)(y)
    $,
  )

  for all values of $x, y$. This means the events ${X = x}, {Y = y}$ are independent for all $x, y$. In other words, variables $X$ and $Y$ take their values independently of each other.
]<def:independent_rv>

#remark[Clearly @def:independent_rv is only taking into account discrete random variables, however the same definition can be extended to continuous random variables by substituting the p.m.f with the p.d.f.
]

#example-box("Study of Independency between Two R.V.'s", [
  Consider the case in which we have $X$ and $Y$, two *continuous r.v.*'s with joint probability density function given by:

  #math.equation(
    block: true,
    numbering: none,
    $
      f_(X,Y)(x,y) = cases(
        1 space "if" x^2 + y^2 <= 1,
        0 space space "otherwise"
      )
    $,
  )

  We want to study if $X$ and $Y$ are independent. The answer is *no*, to see this we can look at the *support* of the random vector $(X,Y)$, which is *not a rectangle*. Indeed, it is the unit circle, thus if we know the value of $X$, this will limit the possible values of $Y$ and viceversa. Therefore, $X$ and $Y$ cannot be independent.
])

#exercise[
  Suppose we have the following probability density function for two continuous random variables $X$ and $Y$:

  #math.equation(
    block: true,
    numbering: none,
    $
      f_(X,Y)(x,y) = cases(
        k space "if" x^2 + y^2 <= r^2,
        0 space space "otherwise"
      )
    $,
  )

  Find the value of $k$ such that $f_(X,Y)(x,y)$ is a valid probability density function for $(X,Y)$.
]

#solution[
  First of all, we know that $k$ must be *non-negative*: $K >= 1$. This is useful as a lower bound. The only thing that is left is to find an upper bound for $k$.

  To upper bound this, we know that the probability of the whole sample space must be equal to $1$, that is $prob(Omega_((X,Y))) = 1$. We also know that to compute a probability we can start from the probability density function and integrate it over the support of the random vector $(X,Y)$:

  #math.equation(
    block: true,
    numbering: none,
    $
      prob(Omega_((X,Y))) = integral_(-infinity)^infinity integral_(-infinity)^(infinity) f_(X,Y)(x,y) space d x space d y = 1
    $,
  )

  The support of the random vector $X, Y$ is the set of points inside the circle of radius $r$. That is, $Omega_((X_Y)) = {(x,y) in bb(R)^2 : x^2 + y^2 <= r^}$ which is shown in the graph below:
  #figure(
    cetz.canvas({
      import cetz.draw: *

      set-style(
        mark: (fill: black, scale: 2),
        stroke: (thickness: 0.4pt, cap: "round"),
        angle: (radius: 0.3, label-radius: .22, fill: green.lighten(80%), stroke: (paint: green.darken(50%))),
        content: (padding: 1pt),
      )


      line((-2, 0), (2, 0), mark: (end: "stealth"))
      content((), [$space x$], anchor: "west")
      line((0, -2), (0, 2), mark: (end: "stealth"))
      content((), [$y space space$], anchor: "east")
      stroke(blue + 0.6pt)
      circle((0, 0), name: "circle", radius: 1, fill: blue.lighten(80%).transparentize(50%))

      content((name: "circle", anchor: 5deg), [#text(fill: blue)[*$space r$*]], anchor: "south-west")
    }),
    caption: [Support of the random vector $(X, Y)$],
  )


  Therefore we can rewrite in the previous integral simply as the integral over the support, the integral everywhere else will be zero. In this case, since we are computing an integral over a circular region, we are basically searching for a value $k$ such that the cylinder with radius $r$ and height $k$ has volume equal to $1$.

  Instead of computing the integral we can instead compute the volume of such cylinder with the classic formula $V = pi r^2 h$; therefore we have:

  #math.equation(
    block: true,
    numbering: none,
    $limits(integral integral)_(Omega_(X Y)) = pi r^2 k = 1 ==> k = 1 / (pi r^2)$,
  )
  #rhs([$qed$])

  #line(length: 100%)
]

== Conditional Probabilities
Consider the previous exercise, but now suppose the support  was $Omega_(X,Y) = {(x,y) in bb(R)^2 : x^2 + y^2 = 1}$, it would be just the _circumference_ not the whole circle. In this case, any time we fix a value for the $X$ variable, there are only two possible values that $Y$ can take:

#math.equation(
  block: true,
  numbering: none,
  $Y | X cases(
    - sqrt(1 - x^2),
    sqrt(1 - x^2)
  )$,
)

So even though this looks as a random vector of two random variables, in reality, they are not both continuous random variables. Whenever we fix one variable, say $X = x$, what we miss about the other variable is a *discrete choice*.

#remark[As a general rule, in order to be able to properly compute the probability density function of a random vector of dimension $n$ (where $n$ is the number of random variables), we need to be able to compute the 'volume' of the hyper-surface induced by the *support* of the random vector in $bb(R)^n$. In the previous case, even though we had two random variables, the support was a circumference, which is a one-dimensional object, thus we could not define a proper two-dimensional probability density function. These objects for which the dimension of the support is lower than the dimensionality they are represented in are called *manifolds*.
]

Suppose we wanted to compute the probability of an event $A$ for a random vector $(X,Y)$ whose support is the manifold defined by $x^2 + y^2 = 1$. This situation is represented in @fig:manifold_support_probability. In practice we have that:

#math.equation(
  block: true,
  numbering: none,
  $
    prob(A) = prob((x_1 <= x <= x_2) inter (x^2 + y^2 = 1)) \ = prob((x_1 <= x <= x_2) inter [(y = sqrt(1 - x^2)) union (y = -sqrt(1 - x^2))]) \
    = prob((x_1 <= x <= x_2) inter (y = sqrt(1 - x^2))) + prob((x_1 <= x <= x_2) inter (y = -sqrt(1 - x^2))) \
  $,
)

Clearly, it is not possible to compute a *double integral* over a two dimensional: if we fix a value for $x$ there is only a possible for $y$. We need a different method to deal with this.

#figure(
  cetz.canvas(length: 2cm, {
    import cetz.draw: *

    set-style(
      mark: (fill: black, scale: 2),
      stroke: (thickness: 0.4pt, cap: "round"),
      angle: (radius: 0.3, label-radius: .22, fill: green.lighten(80%), stroke: (paint: green.darken(50%))),
      content: (padding: 1pt),
    )


    line((-2, 0), (2, 0), mark: (end: "stealth"))
    content((), [$space x$], anchor: "west")
    line((0, -1.4), (0, 1.4), mark: (end: "stealth"))
    content((), [$y space space$], anchor: "east")

    stroke(blue + 2.5pt)
    circle((0, 0), name: "circle", radius: .8)

    content(
      (name: "circle", anchor: 45deg),
      [#text(fill: blue)[*$quad quad Omega_(X,Y) : x^2 + y^2 = 1$*]],
      anchor: "west",
    )

    stroke(purple + 0.6pt)
    fill(purple.lighten(80%).transparentize(50%))
    rect((-1.2, -0.5), (-0.2, 0.5), name: "rectangle")
    content((name: "rectangle", anchor: "center"), [#text(fill: purple)[*$A$*]], anchor: "west")

    content((name: "rectangle", anchor: "west"), [#text(fill: purple)[$x_1$]], anchor: "south-east")
    content((name: "rectangle", anchor: "east"), [#text(fill: purple)[$space x_2$]], anchor: "south-west")
  }),
  caption: [Support of the random vector $(X, Y)$],
)<fig:manifold_support_probability>

The method we need to address such a situation is *conditional probability*, that we are just about to define.

#definition(title: "Conditional Probability for Discrete R.V.'s")[
  Suppose we have $X, Y$ two random variables. If these r.v.'s are *discrete*, we can define the *conditional probability mass function* of $Y$ given $X$ as:

  #math.equation(
    block: true,
    numbering: "(1)",
    $
      p_((Y|X))(y|x) : prob(Y = y | X = x) = prob(X = x inter Y = y) / prob(X = x) = (p_(X,Y)(x y)) / (p_(X)(x))
    $,
  )<eq:conditional_pmf>

  where the numerator of the last fraction is given by @eq:joint_pmf and the denominator is the *marginal p.m.f.* of $X$.
  Actually, this is not just _one_ p.m.f., but we have a different one for _each value_ of $x$. We can now define the *conditional cumulative distribution function* as:

  #math.equation(
    block: true,
    numbering: "(1)",
    $
      F_((Y|X))(y|x) = prob(Y <= y | X = x) = (prob(X=x inter Y <= y))/(prob(X = x))
    $,
  )<eq:conditional_cdf>

  If we look at @eq:conditional_cdf, we can notice we can write it as a summation of probability mass functions, therefore it becomes:

  #math.equation(
    block: true,
    numbering: "(1)",
    $
      F_((Y|X))(y|x) = limits(sum)_(hat(y) <= y) p_((Y|X))(hat(y)|x)
    $,
  )<eq:conditional_cdf_sum>

]



Let's now take a look at the continuous case, where not surprisingly we are going to use density functions and replace summations with integrals.

#definition(title: "Conditional Probability for Continuous R.V.'s")[
  Suppose we have $X, Y$ two random variables. If these r.v.'s are *continuous*, we can define the *conditional probability density function* of $Y$ given $X$ as:

  #math.equation(
    block: true,
    numbering: "(1)",
    $
      f_((Y|X))(y|x) : (f_(X,Y)(x, y)) / (f_(X)(x))
    $,
  )<eq:conditional_pdf>

  As far as the *conditional cumulative distribution function* is concerned, we have:

  #math.equation(
    block: true,
    numbering: "(1)",
    $
      F_((Y|X))(y|x) = limits(integral)_(-infinity)^y f_((Y|X))(y|x) space d y
    $,
  )<eq:conditional_cdf_cont>
]

#warning-box[
  It may look promising to try and directly define the conditional probability distribution function with the following formula:

  #math.equation(
    block: true,
    numbering: none,
    $
      F_((Y|X))(y|x) = (F_(X,Y)(x, y)) / (F_(X)(x))
    $,
  )

  This is *completely wrong*, indeed if we think for a moment about the meaning of the c.d.f., we can notice that this formula does not make any sense. What this formula really does is compute the probability that $Y <= y$ given that $X <= x$, that is:

  #math.equation(
    block: true,
    numbering: none,
    $
      prob(Y <= y | X <= x) = (prob(X <= x inter Y <= y)) / (prob(X <= x)) = (F_(X,Y)(x, y)) / (F_(X)(x))
    $,
  )
]

In general, for any two variables $X, Y$, depending on whether they are discrete or continuous, we can always factorize in the following ways:

- For _discrete_ random variables we can factorize their joint probability mass function as:
  #math.equation(
    block: true,
    numbering: none,
    $
      p_(X,Y)(x,y) = p_(X)(x)p(Y|X)(y|x)
    $,
  )
- For _continuous_ random variables the joint prob. density function can be factorized as:
  #math.equation(
    block: true,
    numbering: none,
    $
      f_(X,Y)(x,y) = f_(X)(x)f(Y|X)(y|x)
    $,
  )

Of course if the random variables are independent we'll have that the conditional mass / density functions will be equal to the marginal ones. As far as distribution functions are concerned we *cannot* factorize them as:

#math.equation(
  block: true,
  numbering: none,
  $coleq(#orange, F_(X,Y)(x,y)) = coleq(#orange, F_(X)(x)) coleq(#blue, F_(Y|X)(y|x))$,
)

The mathematical reason behind this is that we are dealing with incompatible objects:

- the #text(fill: orange)[orange] components use $X$ to represent many possible values for $x$
- the #text(fill: blue)[blue] component uses a fixed value of $x$

#theorem(title: "Chain Rule for Joint Probabilities")[
  Given a random vector of $n$ random variables $overline(X) = (X_1, X_2, ..., X_n)$. If the vector is made of *discrete* random variables, we can factorize the joint probability mass function as:

  #math.equation(
    block: true,
    numbering: none,
    $
      p_(overline(X))(overline(x)) = p_(X_1)(x_1) dot p_(X_2|X_1)(x_2|x_1)dot p_(X_3|X_1,X_2)(x_3|x_1,x_2) ...
    $,
  )

  We can do the same for *continuous* random variables by replacing the probability mass functions with probability density functions:

  #math.equation(
    block: true,
    numbering: none,
    $
      f_(overline(X))(overline(x)) = f_(X_1)(x_1) dot f_(X_2|X_1)(x_2|x_1)dot f_(X_3|X_1,X_2)(x_3|x_1,x_2) ...
    $,
  )
]

Getting back to our examples, remember that we want to find $k$ such that the function

#math.equation(
  block: true,
  numbering: none,
  $
    f_(X,Y)(x,y) = cases(k "if" x^2 + y^2 = 1, 0 space space "otherwise")
  $,
)

is a valid _probability density function_. Remember this is not a density in $bb(R)^2$, but rather a density over the one-dimensional manifold defined by the circumference of radius $1$. We can imagine to _unfold_ the circumference, transforming it into a line of length equal to the circumference itself. Remember that the circumference has radius $1$, therefore its length is equal to $2 pi$. @fig:unfolding_circle shows how this unfolding process works.



#figure(
  cetz.canvas({
    import cetz.draw: *

    // Left side - R^2 with circle
    group({
      // Axes
      line((-2, 0), (2, 0), mark: (end: ">"), name: "x-axis")
      line((0, -2), (0, 2), mark: (end: ">"), name: "y-axis")

      // Axis labels
      content((2.2, -0.2), [x])
      content((-0.2, 2.2), [y])

      // Circle x^2 + y^2 = 1
      circle((0, 0), radius: 1.3, stroke: 3pt)

      // Color segments of circle
      arc((1.3, 0), start: 0deg, stop: 180deg, radius: 1.3, stroke: (paint: orange, thickness: 1pt), mark: (end: ">"))
      arc((-1.3, 0), start: 180deg, stop: 360deg, radius: 1.3, stroke: (paint: green, thickness: 1pt), mark: (end: ">"))


      // R^2 label
      content((-1.5, 2), text(size: 14pt)[$bb(R)^2$])

      // Mark point at (1, 0)
      circle((1.3, 0), radius: 0.08, fill: black)
      content((1.6, -0.3), text(size: 10pt)[1])
    })

    // Arrow between the two spaces
    set-origin((4, 0))
    line((-0.5, 0), (0.8, 0), mark: (end: ">"), stroke: 2pt)
    content((0.12, 0.5), text(size: 12pt)[_unfolding_])

    // Right side - R^1 (number line)
    set-origin((4, 0))
    group({
      // Horizontal axis
      line((-2, 0), (2, 0), mark: (end: ">"), stroke: 1pt, name: "num-line")

      // Mark origin
      line((0, -0.15), (0, 0.15), stroke: 2pt)
      content((0, 0.4), text(size: 10pt)[0])

      // Colored segments on the line
      line((-1.5, 0), (-0.04, 0), stroke: (paint: green, thickness: 2pt))
      line((0.04, 0), (1.5, 0), stroke: (paint: orange, thickness: 2pt))

      line((1.5, -0.15), (1.5, 0.15), stroke: (paint: orange, thickness: 2pt))
      line((-1.5, -0.15), (-1.5, 0.15), stroke: (paint: green, thickness: 2pt))

      // Pi labels
      content((-1.5, -0.5), text(fill: green, size: 12pt)[$-pi$])
      content((1.5, -0.5), text(fill: orange, size: 12pt)[$pi$])

      // R^1 label
      content((2, 1), text(size: 14pt)[$bb(R)^1$])

      // Y in (-1, 1) label
    })
  }),
  caption: [Mapping from the unit circle in $bb(R)^2$ to $bb(R)^1$],
)<fig:unfolding_circle>

In this new 'unfolded' space, we can notice that for the orange part:

- $X$ can take values in the interval $[-1, 1]$, indeed, if we go back to the original space the coordinate $x$ can be any value between $-1$ and $1$.
- $Y$ can only take values in the ranger $[0,1]$, since it is the upper part of the circle.

We can conclude that $Y|X = sqrt(1 -x^2)$. Similarly, for the green part we have that $Y|X = -sqrt(1 - x^2)$, since $Y$ can only take values in the range $[-1, 0]$. We can now solve the original problem by solving the integral:



#math.equation(
  block: true,
  numbering: none,
  $
    limits(integral)_(-pi)^(pi) k space d x = k x lr(|, size: #300%)_(-pi)^(pi) = k pi + k pi = 2k pi
  $,
)

Thus since we have the constraint that the upper bound must be equal to $1$, we have that $2 k pi = 1$, therefore $k = 1 / (2 pi)$. We can also notice that the probability of $Y$ being larger or smaller thant $0$ is completely independent of the value of $X$.

We can define a new random variable $I$ which serves as an *indicator* of the sign of $Y$:

#math.equation(
  block: true,
  numbering: none,
  $
    I = cases(1 space "if" Y >= 0, 0 space space "otherwise") ==> (X, Y) = (X, I sqrt(1 - x^2))
  $,
)

Clearly $I$ is a *discrete random variable*. Now it is evident that in the beginning we were not dealing with two continuous random variables, but rather with a continuous random variable $X$ and a discrete random variable $I$.
