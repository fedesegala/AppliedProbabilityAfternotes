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

// Numerazione delle figure per capitolo
#set figure(numbering: num => {
  let chapter = counter(heading.where(level: 1)).get().first()
  numbering("1.1", chapter, num)
})

// Numerazione delle equazioni per capitolo
#set math.equation(numbering: num => {
  let chapter = counter(heading.where(level: 1)).get().first()
  numbering("1.1", chapter, num)
})

// Resetta i contatori ad ogni nuovo capitolo
#show heading.where(level: 1): it => {
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
  counter(math.equation).update(0)
  it
}


= Random Variables and Probability Distributions
This chapter will introduce us to the concept of random variables. In the first sections we are going to define the concepts of *discrete* and *continuous* random variables and their characteristic functions. Then we will explore some of the most important and widely used probability distributions.

== Background
To start off, it's important to understand *what is* a random variable. To do so, let us look at the following definition.

#definition(title: "Random Variable")[
  A *random variable* is a *function* of an _outcome_ defined as:

  #math.equation(block: true, $X = f(omega) \ X : Omega -> X(Omega) = Omega_X subset.eq bb(R)$)

  In other words, it is a _quantity that depends on a chance_.
]

The *domain* of a random variable is the _sample space_ of a random experiment $Omega$, while the *range*, also called the *support*, of the random variables is a subset of the real numbers $bb(R)$, and it correspond to the possible values the random variable can take. Interesting cases are $bb(R), bb(N), (0, infinity), (0,1)$.

Since random variables are functions, we may be interesed in studying their inverse. Following we give a definition of this concept.

#definition(title: "Generalized Inverse of a Random Variable")[
  Given a random variable $X: Omega -> Omega_X$, its *generalized inverse* is defined as:

  #math.equation(block: true, $X^(-1)(x) = {omega in Omega : X(omega) = x}$)<eq:generalized_inverse>
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


== Discrete and Continuous Random Variables

=== Discrete Random Variables and their Distributions
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

==== Random Variable Characterization
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

==== Properties of PMF, CDF and Survival Function
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

=== Continuous Random Variables and their Distributions
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
      image("images/02_excdf.png", width: 43%),
      caption: "Cumulative Distribution Function (CDF) for the continuous random variable X representing the lifetime of an electronic component.",
    )
  ]
])

#pagebreak()

=== Discrete vs Continuous Random Variables
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
  $
    p_(X,Y)(x,y) = prob((X,Y) = (x,y)) = prob(X = y inter Y = y)
  $,
)<eq:joint_pmf>

In this course, we are going to focus on homogeneous randon vectors, in which all the random variables are either discrete or continuous.

#definition(title: "Joint Cumulative Distribution Function")[
  For a vector of random variables, the *joint cumulative distribution function* is defined as follows:

  #math.equation(
    block: true,
    $
      F_(X,Y)(x,y) = prob(X <= x inter Y <= y)
    $,
  )<eq:join_cdf>

  Given the join c.d.f we can also define the *join probability density function* as the mixed derivative of the joint c.d.f:

  #math.equation(
    block: true,
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

The method we need to address such a situation is *conditional probability*, that we are just about to define.
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



#definition(title: "Conditional Probability for Discrete R.V.'s")[
  Suppose we have $X, Y$ two random variables. If these r.v.'s are *discrete*, we can define the *conditional probability mass function* of $Y$ given $X$ as:

  #math.equation(
    block: true,
    $
      p_((Y|X))(y|x) : prob(Y = y | X = x) = prob(X = x inter Y = y) / prob(X = x) = (p_(X,Y)(x y)) / (p_(X)(x))
    $,
  )<eq:conditional_pmf>

  where the numerator of the last fraction is given by @eq:joint_pmf and the denominator is the *marginal p.m.f.* of $X$.
  Actually, this is not just _one_ p.m.f., but we have a different one for _each value_ of $x$. We can now define the *conditional cumulative distribution function* as:

  #math.equation(
    block: true,
    $
      F_((Y|X))(y|x) = prob(Y <= y | X = x) = (prob(X=x inter Y <= y))/(prob(X = x))
    $,
  )<eq:conditional_cdf>

  If we look at @eq:conditional_cdf, we can notice we can write it as a summation of probability mass functions, therefore it becomes:

  #math.equation(
    block: true,
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

== Probability Density Factorization
Even though we already mentioned the concept of independency between random variables in @def:independent_rv, it's worth to revisit that definition giving a practical tool to check if two random variables are independent or not.

=== Independency via Factorization
We say that two random variables $X, Y$ are independent if and only if it is possible to find functions $h_1$ and $h_2$ such that:

- for *discrete* random variables we have that
  #math.equation(
    block: true,
    numbering: none,
    $
      p_(X,Y)(x,y) = h_1(x) space h_2(y) quad forall x, y in bb(R)^2
    $,
  )
  in this case we can also say that the marginal $p_(X)(x) prop h_1(x)$ and equivalently $p_(Y)(y) prop h_2(y)$, that is the marginal are proportional to the functions $h_1$ and $h_2$ respectively (or equal up to a constant)

- for *continuous* random variables we have that
  #math.equation(
    block: true,
    numbering: none,
    $
      f_(X,Y)(x,y) = h_1(x) space h_2(y) quad forall x, y in bb(R)^2
    $,
  )
  where, again the marginals can be seen as  proportional to the functions $h_1$ and $h_2$ respectively: $f_(X)(x) prop h_1(x)$ and equivalently $f_(Y)(y) prop h_2(y)$.

#example-box("Independency via factorization", [
  Two random variable $T, S$ have join probability density function given by:

  #math.equation(
    block: true,
    numbering: none,
    $
      f_(T, S)(t, s) = 18 e^(-6t)e^(-3s) bb(1)_(t,s in R^(2)_+)
    $,
  )

  where the indicator function has exactly the function of expressing the concept that when we are considering negative values for either $t$ or $s$ the density is zero.

  We can try to *factorize* the joint p.d.f. dividing the two members. The only 'tricky' part is the indicator function but we can notice that $(t,s) in (bb(R)^2_+ <=> t in R_+ inter s in R_+)$; therefore we can write the following:

  #math.equation(
    block: true,
    numbering: none,
    $
      f_(T,S)(t,s) = coleq(#purple, 18e^(-6t)bb(1)_(t in R_+)) space space coleq(#green, e^(-3s)bb(1)_(s in R_+))
    $,
  )

  where we can see the purple factor as $coleq(#purple, h_1(t))$, and the green factor as $coleq(#green, h_2(s))$. Therefore, we can conclude that $T$ and $S$ are independent random variables.

  We may now ask ourselves whether $h_1(t) = f_(T)(t)$ and $h_2(s) = f_(S)(s)$; indeed from what we said above we know they are proportional, but we can't say anything about the *proportionality constant*. To solve this we can rewrite the marginals as scaled by an unknown proportionality constant. We are going to first focus on $f_(T)(t)$:

  #math.equation(
    block: true,
    numbering: none,
    $
      f_(T)(t) = k space h_1(t) = 18 k e^(-6t) bb(1)_(t > 0)
    $,
  )

  From the _law of total probability_ we also know that integrating the marginal over the whole support $bb(R)$ should give us $1$; therefore we can write:

  #math.equation(
    block: true,
    numbering: none,
    $
      1 = limits(integral)_(-infinity)^(infinity) f_(T)(t) space d t &= limits(integral)_0^(infinity) 18 k e^(-6t) space d t = 18 k limits(integral)_0^(infinity) e^(-6t) space d t \
      &= 18 k space [- 1/6 e^(6t)]_0^(infinity) = 18 k space [- 0/6 - (-1/6)] = 3 k
    $,
  )

  Therefore we can conclude that the constant $k$ we were looking for is equal to $1/3$. So we can conclude that marginal density function of $T$ is:

  #math.equation(
    block: true,
    numbering: none,
    $
      F_(T)(t) = 6 e^(-6t) bb(1)_(t > 0)
    $,
  )

  To compute the second marginal $f_(S)(s)$ we don't even need to compute a second integral; that's because we know the joint p.d.f. can be written as a product of the marginals (by independency), therefore we can compute the following:

  #math.equation(
    block: true,
    numbering: none,
    $
      f_(T,S)(t,s) & = 18 e^(-6t) bb(1)_(t > 0) space e^(-3s) bb(1)_(s > 0) \
                   & = f_(T)(t) space f_(S)(s) \
                   & = 6 e^(-6t) bb(1)_(t > 0) space 3 e^(-3s) bb(1)_(s > 0)
    $,
  )

  that is because since we need to get back to the original 18 in the joint p.d.f., the only possible value for the proportionality factor of $h_2(s)$ is 3.  #rhs([$qed$])
])

By looking at the previous example we can also notice that there is another (calculus-based) method to compute the marginal probabilities, that is computing the integrals of the density functions over the other variables:

#math.equation(
  block: true,
  numbering: none,
  $
    f_(T)(t) = limits(integral)_(0)^(infinity) f_(T,S)(t,s) space d s quad quad quad f_(S)(s) = limits(integral)_(0)^(infinity) f_(T,S)(t,s) space d t
  $,
)


=== Factorization via Marginal and Conditional Probabilities
#example-box("Dependent Variables Factorization", [
  Suppose we have two R.V.'s $X, Y$ with joint probability density function given by:

  #math.equation(
    block: true,
    numbering: none,
    $
      f_(X,Y)(x,y) = x e^(-x(y+1)) bb(1)_(x,y in R^(2)_+)
    $,
  )

  First of all, we don't even know whether this is a _valid p.d.f._, in order to _check_ this we need to compute the double integral over the whole support and require it to be equal to $1$:

  #math.equation(
    block: true,
    numbering: none,
    $
      limits(integral)_0^infinity limits(integral)_0^infinity x^e^(-x(y+1)) space d x d y = 1
    $,
  )

  Since this double integral is quite ugly we can try to *factorize* the joint p.d.f.  by separating the terms depending of only on $x$ and those depending only on $y$ (if possible):

  #math.equation(
    block: true,
    $
      f_(X,Y)(x,y) = x e^(-x) bb(1)_{x > 0} dot e^(-x y) bb(1)_{y > 0}
    $,
  )<eq:wrong_factorization>

  For what concerns the first term, it's possible to notice it only depends on $x$, while the second one cannot be further simplified since it depends on on both $x$ and $y$. We can conclude the two random variables are *not independent*.
])

It is always possible to *factorize* the joint p.d.f of two random variables $X, Y$ using the marginal and conditional probabilities:

#math.equation(
  block: true,
  $
    f_(X,Y)(x,y) = f_(X)(x) space f_(Y | X)(y | x)
  $,
)<eq:marginal_conditional_factorization>

#warning-box[If the random variables are not independent, and don't have additional information, there is not shortcut to know which is the marginal and which is the conditional probability density function. So going back to the previous example, it would be totally *wrong* to see the factorization in <eq:wrong_factorization> as if the two factors were the marginal and conditional p.d.f. respectively as in @eq:marginal_conditional_factorization.]

To address the previous exercise, one may recall that the *exponential distribution* has form

#math.equation(
  block: true,
  numbering: none,
  $
    lambda e^(-lambda t) bb(1)_(t > 0)
  $,
)

and is always a valid p.d.f. for any $lambda > 0$. With this new piece of information, we can now look again at the factorization in <eq:wrong_factorization> and notice that we could actually reorder the factors so that both members look like valid exponential marginal distributions:

#math.equation(
  block: true,
  numbering: none,
  $
    f_(X,Y)(x,y) = e^(-x) bb(1)_(x > 0) dot x e^(-x y) bb(1)_(y > 0)
  $,
)

In this way, the first factor looks like an exponential distribution with $lambda = 1$ and the second number looks like an exponential distribution with $lambda = x$. Now we can really say that $f_(X,Y)(x,y)$ can be factorized in marginal and conditional where:

- the *marginal* p.d.f. of $X$ is given by $e^(-x) bb(1)_(x > 0)$

- the *conditional* p.d.f. of $Y$ given $X$ is given by $x e^(-x y) bb(1)_(y > 0)$

To check the correctness of this factorization we can now compute check that the integral over all possible values of $y$ yields the marginal of $X$, and that the joint p.d.f. divided the the marginal of $X$ yields the conditional of $Y$ given $X$, that is:

#math.equation(
  block: true,
  numbering: none,
  $
    f_(X)(x) = limits(integral)_0^infinity f_(X,Y)(x,y) d y = e^(-x) quad quad quad (f_(X,Y)(x,y)) / (f_(X)(x)) = x e^(-x y)
  $,
)

== Conditional Independency

=== Characterization of Single Random Variables
Following we try to summarize what we have seen so far about random variables and random vectors. Starting from a *single random variable*, its _distribution_ is characterized by either of:

- either one between probability *mass* function or *density* function (depending on whether the random variable is discrete or continuous)
- the *cumulative distribution function* which is obtained by integrating or summing the p.m.f. or p.d.f. over the possible values of the random variable.
- the *survival function* which is obtained by computing the complement of the c.d.f.

=== Characterization of Random Vectors
In case we are dealing with a *pair* of random variables, the _distribution_ $(X,Y)$ is characterized by either of:

- the *joint* probability *mass* function or *density* function (depending on whether the random variables are discrete or continuous)
- the *joint cumulative distribution function* which is obtained by integrating or summing the joint p.m.f. or p.d.f. over the possible values of the random variables.
- the *joint survival function* which is obtained by computing the complement of the joint cumulative distribution function
- the *marginal* of $X$ and the *conditional* of $Y$ given $X$ (or viceversa); when referring to marginal and conditional distribution we may referring to either one of the p.m.f. / p.d.f., c.d.f, or survival function
- the *marginals* for $X$ and $Y$ and the information that they are *independent*


=== Independency and Conditional Independency
In case we are told that it is possible to get the joint of $X$ and $Y$ from just the two marginals, then we can conclude that $X$ and $Y$ are independent random variables.

Similarly, if we are told that it is possible to get the joint of $(X, Y, Z)$ from just the three marginals, then we can conclude that $X, Y, Z$ are *mutually independent*, that is every possible pair is independent: $X perp Y, Y perp Z, X perp Z$.

In case we are told that it's possible to get the joint of $(X, Y, Z)$ from the marginal of $X$, the conditional of $Y$ given $X$ and the condition of $Z$ given $Y$, this means we don't need knowledge about $Z | X, Y$; we can conclude $Z$ is *conditionally independent* of $X$ given $Y$.  We can formalize this concept in @def:conditional_independency.

#pagebreak()

#definition(title: "Conditional Independency")[
  Given three random variables $(X,Y,Z)$, we say that $Z$ is *conditionally independent* of $X$ given $Y$ if and only if:

  #math.equation(
    block: true,
    $
      f_(Z | Y)(z | y) = f_(Z | X,Y)(z | x,y)
    $,
  )<eq:conditional_independency>

  which basically means that the knowledge of $X$ does not provide any additional information about $Z$ once we know $Y$.

]<def:conditional_independency>

#remark[
  With respect of the conditional independency definition, we can rewrite the density of $Z$ given $X$ and $Y$ by means of @eq:conditional_pdf (conditional p.d.f.):
  #math.equation(
    block: true,
    numbering: none,
    $
      f_(Z | X,Y)(z | x,y) = (f_(Z,X | Y)(z,x | y)) / (f_(X | Y)(x | y))
    $,
  )

  where the rational is that to compute the conditional probability of something conditioned to something else, we can always computed it dividing their joint probability by the marginal of the conditioning variable. With this in mind we can derive:

  #math.equation(
    block: true,
    numbering: none,
    $
      f_(Z | Y)(z | y) f_(X | Y)(x | y) = f_(Z, X | Y)(z,x | y)
    $,
  )
]

== Characteristics of a Distribution
In the previous chapter we discussed some conditions that are sufficient to determine all the characteristics of a distribution, we didn't mention however what these characteristics actually are. Since there is potentially a plethora of characteristics that can be defined given a distribution, we are going to focus on just some of them, specifically we are dividing them in three principal *families*:

- measures of *central tendency*: the _mean_, _median_ and _mode_
- measures of *variability*: _variance_, _standard deviation_, _range_, _interquartile range_,
- measures of *position* or *shape*: _quantiles_ , _skewness_ and _kurtosis_

We are also going to measure the *relationship* between *two variables*, by means of tools such as _covariance_ and _correlation_ (potentially with many different indices).

==== Expected Value of a Random Variable
#definition(title: "Mean of a Random Variable")[
  Given a random variable $X$ we define the *mean* or *expected value* as:

  #math.equation(
    block: true,
    $
      mu_(X) = exp(X) = limits(sum)_(x in Omega_X) x space p_X)(x) space "or" space mu_(X) = exp(X) limits(integral)_(x in Omega_X) x space f_(X)(x) space d x
    $,
  )<eq:mean_random_variable>

  basically, it is a weighted average of all possible values the random variable can take, where the weights are given by the probabilities of each value.
]<def:mean_random_variable>

We can see the *mean* of a random variably as the *physical center of mass* of its distribution. Indeed, if we imagine the p.d.f. as a physical object with density proportional to the value of the p.d.f. at each point, then the mean is the point where we could balance this object on the tip of a pencil.

==== Mode and Median
Imagine we want to guess the result of an experiment for a random variable $X$. To do so we may come up with different ideas.

We could pick the value with the highest probability or highest density value in case the random variable is continuous; this is called the *mode* of the random variable. It is the value that maximizes the probability of correctly guessing the outcome.

Clearly, this approach is flawed in some sense, consider for instance the experiment of throwing a die, every event has probability $1/6$, so we can't actually define a mode here. To see another example, suppose we have a discrete random variable $X$ with $Omega_X = [-n, n]$. The probability of having $x = 0$ is $1/2$ and the probability of having any other value is evenly split among the remaining values. The choice in this case would be to pick 0 as the value independently of the value of $n$. The problem is there is always a positive probability that $X = n$, so if for instance $n = 1,000,000$, we would have $1/2$ probability of being off by very large amounts.

Let $a$ be a possible guess for the value of $X$. We can measure our error as $|a-x|$, that is, we compute the *absolute error*. Before doing the experiment the absolute error is unknown, but it can be seen as a random variable itself, thus we could try to minimize it in expectation choosing the value of $a$ that minimizes $exp(|a - X|)$.

#math.equation(
  block: true,
  numbering: none,
  $
    m = limits(arg min)_(a in bb(R)) exp(|a - X|)
  $,
)

The value $m$ is actually called the *median* of the random variable $X$.


==== Properties of the Expected Value
Before looking at the properties of the expected value, it's worth to define the concept of *linear operator*. Let's look at the following definition.

#definition(title: "Linear Operator")[
  An operator $cal(g)$ is a function such that for any linear transformation $cal(T)$ it is the case that $cal(g) dot cal(T) = cal(T) dot cal(g)$, in other words we have that:

  #math.equation(
    block: true,
    numbering: none,
    $
      cal(g)(a x + b) = a cal(g)(x) + b
    $,
  )

]<def:linear_operator>

===== Linearity

The expected value is indeed a *linear operator*. This means that for any random variable $X$ and for any constants $a, b in bb(R)$ it is the case that:

$ exp(a X + b) = a exp(X) + b $<eq:linear_operator_expectation>

@eq:linear_operator_expectation holds only in case of linear transformations of the random variable.

#example-box("Linearity of Expected Value", [
  A discrete random variable $X$ with $Omega_X = {0,1}$ where the probability mass function is given by:

  #math.equation(
    block: true,
    numbering: none,
    $
      p_X (X) = cases(
        1 - p space space "if" x = 0,
        p space space "if" x = 1
      )
    $,
  )

  The expected value of $X$ is given by:
  #math.equation(
    block: true,
    numbering: none,
    $
      exp(X) = 0 dot (1-p) + 1 dot p = p
    $,
  )

  Similarly, if we apply a linear transformation to $X$, for instance $Y = 25 X - 2$ we have:

  #math.equation(
    block: true,
    numbering: none,
    $
      exp(Y) = exp(25 X - 2) = 25 exp(X) - 2 = 25 p - 2
    $,
  )
])

@def:mean_random_variable suggests us that we can calculate the expected value of a random variable $W$ where $W$ is a linear transformation of $X$, i.e., $W = cal(T)(X)$  without even knowing the distribution of $W$. We can compute the expected value for *any function of a random variable* as :
#math.equation(
  block: true,
  $
    exp(h(X)) = cases(
      limits(sum)_(x in Omega_X) h(x) space p_X (x) space space & "if" X "is discrete",
      limits(integral)_(x in Omega_X) h(x) space f_X (x) space d x space space & "if" X "is continuous"
    )
  $,
)<eq:expected_value_function_random_variable>

As a corollary of this property, we can also notice that the expected value of a constant is equal to the constant itself, and that given $n$ random variables $X_1, ..., X_n$ we have that:

#math.equation(
  block: true,
  numbering: none,
  $
    exp(limits(sum)_(i = 1)^n X_i) = limits(sum)_(i = 1)^n exp(X_i)
  $,
)

#remark[
  As $n -> infinity$, under adequate conditions, we may have that

  #math.equation(
    block: true,
    numbering: none,
    $
      limits(sum)_(i = 1)^n X_i -> X^*
    $,
  )

  with $X^*$ being another 'fresh' random variable. If this is the case we have that
  #math.equation(
    block: true,
    numbering: none,
    $
      limits(sum)_(i = 1)^n exp(X_i) -> exp(X^*)
    $,
  )
]
===== Jensen's Inequality
With respect to @eq:expected_value_function_random_variable, we can notice that if the function $h$ is *convex*, then the following inequality holds:

#math.equation(
  block: true,
  $
    exp(h(X)) >= exp(X)
  $,
)<eq:jensen_inequality_1>

on the other hand if the function $h$ is *concave*, then the opposite inequality holds:
#math.equation(
  block: true,
  $
    exp(h(X)) <= exp(X)
  $,
)<eq:jensen_inequality_2>

===== Mean Squared Error Minimizer
Consider the previous example where we were trying to find the best possible guess for the outcome of some experiment. Suppose that instead of the absolute error we were trying to minimized the *mean squared error*, we would find the optimal value is $exp(X)$, that is:
#math.equation(
  block: true,
  $
    exp(X) = limits(arg min)_(a in bb(R)) space exp((a - X)^2)
  $,
)<eq:mean_squared_error_minimizer>

==== Variance of a Random Variable
Consider @eq:mean_squared_error_minimizer. If we try to substitute the optimal value $a = exp(X)$ in the expression we get the following equation:

#math.equation(
  block: true,
  $
    limits(min)_(a in bb(R)) space exp((a - X)^2) = exp((exp(X) - X)^2) = var(X)
  $,
)<eq:variance_random_variable>

that is, the *variance* of a random variable $X$ can be seen as the minimum mean squared error we can get when trying to guess the outcome of the experiment. We can also write the variance of a random variable by expanding the square in @eq:variance_random_variable:

#math.equation(
  block: true,
  $
    var(X) = exp(X^2) - exp(X)^2
  $,
)<eq:variance_random_variable_expanded>

==== Properties of the Variance

===== Scaling Property
If we try to compute the variance of a *linear transformation* we obtain:

#math.equation(
  block: true,
  numbering: none,
  $
    var(a X + b) & = exp((a X + b)^2) - exp(a X + b)^2 \
    & = exp(a^2 X^2 + 2 a b X + b^2) - ( exp(X) + b^2 \
    & = a^2 exp(X^2) + coleq(#purple, 2 a b exp(X)) + coleq(#orange, b^2) - (a^2 exp(X)^2 + coleq(#purple, 2 a b exp(X)) +coleq(#orange, b^2)) \
    & = a^2 (exp(X^2) - exp(X)^2) = a^2 var(X)
  $,
)

This also suggests us that the variance of a constant is equal to zero, this is by no surprise since the variance is used to measure the variability of a random variable, and a constant has no variability at all.

===== Law of Total Variance
Consider 2 (continuous) random variables $X, Y$ with p.d.f. $f_(X,Y)(x,y)$. Given this random vector we can say that it is fully defined by its join p.d.f., that is $(X,Y) ~ f_(X,Y)(x,y)$, but we can also derive the marginal probabilities both for $X$ and for $Y$. Given all the previous quantities we can also define the conditional probability of $X$ given $Y$ and viceversa:

#math.equation(
  block: true,
  numbering: none,
  $
    X | Y ~ f_(X | Y)(x | y) = (f_(X,Y)(x,y)) / (f_(Y)(y))
  $,
)

#definition(title: "Conditional Expectation")[
  Given a random vector of two continuous random variables $(X,Y)$ we can define the
  *conditional expectation* as the expected value of one random variable given the other:

  #math.equation(
    block: true,
    numbering: none,
    $
      exp(X | Y) = limits(integral)_(-infinity)^infinity x space f_(X | Y)(x | y) space d x
    $,
  )

  Clearly, this depends on the value taken by $Y$.
]

It is important to notice that $exp(X | Y)$ is random because $Y$ is random. For every fixed $y in Omega_Y$, $exp(X | Y = y)$ is a number, but since $Y$ is random, $exp(X | Y)$ is a random variable. Basically we can see $exp(X | Y)$ as a function of $y$, say, $g(y)$. We can try to compute the expected value of $g(y)$:

#math.equation(
  block: true,
  numbering: none,
  $
    exp(g(y))_Y &= exp(exp(X | Y)_X)_Y = limits(integral)_(-infinity)^(infinity) exp(X | Y = y) space f_(Y)(y) space d y \
    &= limits(integral)_(-infinity)^(infinity) [limits(integral)_(-infinity)^(infinity) x space f_(X | Y)(x | y) space d x] space f_(Y)(y) space d y
    = limits(integral)_(-infinity)^infinity limits(integral)_(-infinity)^(infinity) x f_(X, Y)(x, y) space d x space d y \
    &= limits(integral)_(-infinity)^infinity limits(integral)_(-infinity)^(infinity) x f_(X, Y)(x, y) space d y space d x space = limits(integral)_(-infinity)^(infinity) x [limits(integral)_(-infinity)^(infinity) f_(X, Y)(x, y) space d y] space d x \
    &= limits(integral)_(-infinity)^(infinity) x f_(X)(x) space d x = exp(X)
  $,
)

#definition(title: "Conditional Variance")[
  Given two random variables $(X,Y)$ we can define the *conditional variance* as:

  #math.equation(
    block: true,
    numbering: none,
    $
      var(X | Y) = exp(X^2 | Y) - exp(X | Y)^2
    $,
  )
]<def:conditional_variance>

Again, the value of the conditional variance may depend on the value taken by $Y$. Similarly to the previous case, since the conditional variance can be seen as a random variable, we can try to compute the expected value of the conditional variance.
#math.equation(
  block: true,
  numbering: none,
  $
    exp(var(X | Y)) = exp(exp(X^2 | Y)) - exp(exp(X | Y)^2)
  $,
)

This is obtained by *linearity* of the expected value operator. We can notice that the first member of the difference is actually equal to $exp(X^2)$, indeed the outer expectation is taken with respect to the value of $Y$, thus it serves to take into account all possible values for $Y$. For the second member however we can't do the same, since there is a square involved, we can notice the following:

#math.equation(
  block: true,
  numbering: none,
  $
    exp(W^2) - exp(W)^2 = var(W) ==> exp(W^2) = var(W) + exp(W)^2
  $,
)

Thus we can rewrite the previous quantity as:

#math.equation(
  block: true,
  numbering: none,
  $
    exp(var(X | Y)) & = exp(X^2) - [var(exp(X | Y)) + exp(exp(X | Y))^2] \
                    & = exp(X^2) - var(exp(X | Y)) - exp(X)^2
  $,
)

where we used the property seen before that $exp(exp(X | Y)) = exp(X)$ and we squared it. Now if we put together the terms depending only on the $X$ we can obtain the variance back:

#math.equation(
  block: true,
  numbering: none,
  $
    exp(var(X | Y)) = var(X) - var(exp(X | Y))
  $,
)

To take this one step even further we can rearrange the terms to obtain the following important result called the *law of total variance*

#math.equation(
  block: true,
  $
    var(X) = exp(var(X | Y)) + var(exp(X | Y))
  $,
)<eq:law_of_total_variance>


#figure(
  cetz.canvas({
    import cetz.draw: *

    line((-5, 0), (5, 0), mark: (end: ">"), name: "x-axis")
    line((0, -3), (0, 4), mark: (end: ">"), name: "y-axis")
    content((5.3, -0.2), $X$)
    content((-0.4, 4), $Y$)

    let y1 = 0.5
    let y2 = 1.5
    let y3 = 2.5

    line((-4.5, y1), (5, y1), stroke: (paint: rgb(100, 150, 200), thickness: 1pt))
    line((-4.5, y2), (5, y2), stroke: (paint: rgb("#44a744"), thickness: 1pt))
    line((-4.5, y3), (5, y3), stroke: (paint: rgb("#be771a"), thickness: 1pt))

    content((-5, y1), text(fill: rgb(100, 150, 200), size: 8pt, $y_1$), anchor: "east")
    content((-5, y2), text(fill: rgb("#44a744"), size: 8pt, $y_2$), anchor: "east")
    content((-5, y3), text(fill: rgb("#be771a"), size: 8pt, $y_3$), anchor: "east")

    // Valori attesi E[X|Y=y_i]
    let ex_y1 = 1
    let ex_y2 = 2.5
    let ex_y3 = 4

    // Punti E[X|Y=y_i]
    circle((ex_y1, y1), radius: 0.1, fill: rgb(100, 150, 200), stroke: black)
    circle((ex_y2, y2), radius: 0.1, fill: rgb("#44a744"), stroke: black)
    circle((ex_y3, y3), radius: 0.1, fill: rgb("#be771a"), stroke: black)

    line((-3.5, -2.5), (ex_y2, y2), (ex_y3, y3), stroke: (paint: black, thickness: 0.8pt, dash: "dashed"))

    content((ex_y1, -0.5), text(size: 8pt, $bb(E)[X|Y=y_1]$))
    content((ex_y2 + 1, y2 - 0.5), text(size: 8pt, $bb(E)[X|Y=y_2]$))
    content((ex_y3 + 1, y3 - 0.5), text(size: 8pt, $bb(E)[X|Y=y_3]$))

    let density_points = ()
    for i in range(0, 100) {
      let y = -2.5 + i * 0.06
      let dens = 0

      // Uso funzioni sigmoidali per transizioni lisce
      if y < y1 {
        dens = 0.19 * calc.exp(-calc.pow((y - y1) / 0.8, 2))
      } else if y >= y1 and y < y2 {
        // Transizione liscia con funzione sigmoidale
        let t = (y - y1) / (y2 - y1)
        dens = 0.2 + 0.7 * (3 * calc.pow(t, 2) - 2 * calc.pow(t, 3))
      } else if y >= y2 and y <= y3 {
        // Massimo plateau tra y2 e y3
        dens = 0.9
      } else if y > y3 and y < y3 + 0.8 {
        // Decrescita liscia dopo y3
        let t = (y - y3) / 0.8
        dens = 0.9 * (1 - (3 * calc.pow(t, 2) - 2 * calc.pow(t, 3)))
      } else {
        // Coda esponenziale
        dens = 0
      }

      density_points.push((dens * 1.8, y))
    }

    for i in range(1, density_points.len()) {
      line(density_points.at(i - 1), density_points.at(i), stroke: (paint: rgb("#e63946"), thickness: 0.8pt))
    }

    content((-0.5, 3.4), text(size: 9pt, fill: rgb("#e63946"), $f_Y (y)$))

    // Distribuzione di E[X|Y] lungo la linea tratteggiata
    // Calcolo la direzione della linea
    let line_start_x = -3.5
    let line_start_y = -2.5
    let line_end_x = ex_y3
    let line_end_y = y3

    // Vettore direzione
    let dx = line_end_x - line_start_x
    let dy = line_end_y - line_start_y
    let line_length = calc.sqrt(dx * dx + dy * dy)

    // Vettore perpendicolare normalizzato
    let perp_x = -dy / line_length
    let perp_y = dx / line_length

    let density_expy_points = ()
    let density_expy_base = ()

    for i in range(0, 100) {
      let t = i / 99.0 // Parametro da 0 a 1 lungo la linea
      let base_x = line_start_x + t * dx
      let base_y = line_start_y + t * dy

      // Densità che segue f_Y (stessa forma ma ruotata)
      let y_val = base_y // Usa la coordinata y per determinare la densità
      let dens = 0

      if y_val < y1 {
        dens = 0.4 * calc.exp(-calc.pow((y_val - y1) / 0.8, 2))
      } else if y_val >= y1 and y_val < y2 {
        let s = (y_val - y1) / (y2 - y1)
        dens = 0.4 + 0.9 * (2 * calc.pow(s, 2) - 2 * calc.pow(s, 3))
      } else if y_val >= y2 and y_val <= y3 {
        let s = (y_val - y2) / (y3 - y2)
        dens = 0.4 + 0.4 * (1 * calc.pow(s, 2) - 2 * calc.pow(s, 3))
      } else {
        dens = 6
      }

      // Punto sulla curva perpendicolare alla linea (aumentato moltiplicatore)
      let curve_x = base_x + perp_x * dens * 2.5
      let curve_y = base_y + perp_y * dens * 2.5
      density_expy_points.push((curve_x, curve_y))
      density_expy_base.push((base_x, base_y))
    }

    // Disegna la curva della densità di E[X|Y]
    for i in range(1, density_expy_points.len()) {
      line(density_expy_points.at(i - 1), density_expy_points.at(i), stroke: (paint: rgb("#457b9d"), thickness: 2pt))
    }

    // Etichetta per f_E[X|Y]
    content((ex_y3 - 1.5, y3 + 0.8), text(size: 13pt, fill: rgb("#457b9d"), $f_(bb(E)[X|Y])(x, y)$))
  }),
  caption: [Visualization of conditional expectation distribution function],
)<fig:conditional_expectation_distribution>

Consider @fig:conditional_expectation_distribution: whenever we fix a value for $Y$, which in the picture corresponds to $y_1, y_2, y_3$, we may find the expected value of $X$ given that value of $Y$. In red we can see the density function of $Y$. Now since we said we can visualize the conditional expectation as a random variable itself, according to the value that $Y$ takes, we can also visualize its density function, which is represented in blue in the picture.

==== Covariance and Correlation
Up to now we never really talked about the *relationship* between two random variables. In order to quantify this information it is necessary to introduce the concepts of *covariance* and *correlation*.

#definition(title: "Covariance")[
  Given two random variables $(X,Y)$ we can define the *covariance* between them $sigma_(X Y)$ and it is given by the following equation:

  #math.equation(
    block: true,
    $
      cov(X, Y) & = exp((X - exp(X)) (Y - exp(Y))) \
                & = exp(X Y) - exp(X)exp(Y)
    $,
  )<eq_2_covariance>
]

Usually, when people talk about covariance they refer to it as the measure of association between two random variables, as if this is the only possible way of measuring association. In reality, this is a very limited index, which can only measure *linear association*.

===== Expected Value and Variance
Let $X$ be a Binomial random variable with parameters $n$ and $p$. Considering its probability mass function in @eq_4_binomial_pmf, we can compute its *expected* *value* as:

#math.equation(
  block: true,
  $
    exp(X) = exp(limits(sum)_(i=1)^n X_i) = limits(sum)_(i=1)^n exp(X_i) = n dot p
  $,
)

where we used the linearity of expectation to move the expectation inside the sum.
As far as the *variance* is concerned, we cannot use the same trick, in that the variance operator is not linear.

Consider two discrete random variables $X, Y$ with joint probability mass function $p_(X Y)(x,y)$ and with support which is represented in @fig_3_support_xy. Suppose also that the orange point is the point $(exp(X), exp(Y))$.

#figure(
  cetz.canvas({
    import cetz.draw: *

    line((-5, 0), (5, 0), mark: (end: ">"), name: "x-axis")
    line((0, -3), (0, 3), mark: (end: ">"), name: "y-axis")
    content((5.3, -0.2), $X$)
    content((-0.4, 3), $Y$)

    let start_x = -5
    let end_x = 4.5
    let step_x = 0.9

    let xy_points = ()
    let x_support = ()
    let y_support = ()

    while start_x <= end_x {
      xy_points.push((start_x, 0.5 * start_x))
      x_support.push((start_x, 0))
      y_support.push((0, 0.5 * start_x))
      start_x = start_x + step_x
    }

    for i in range(0, xy_points.len()) {
      circle(xy_points.at(i), radius: 0.05, fill: blue.lighten(80%), stroke: blue)

      circle(x_support.at(i), radius: 0.05, fill: red.lighten(80%), stroke: red)

      circle(y_support.at(i), radius: 0.05, fill: green.lighten(80%), stroke: green)
    }

    for i in range(1, xy_points.len()) {
      line(xy_points.at(i - 1), xy_points.at(i), stroke: (paint: rgb("#457b9d"), thickness: 0.5pt, dash: "dashed"))
    }

    for i in range(0, x_support.len()) {
      line(x_support.at(i), xy_points.at(i), stroke: (thickness: 0.2pt, dash: "dashed"))
      line(y_support.at(i), xy_points.at(i), stroke: (thickness: 0.2pt, dash: "dashed"))
    }

    circle((1.8, 0.5 * 1.8), radius: 0.1, fill: orange.lighten(70%), stroke: orange)
    line((1.8, -0.3), (1.8, 0.5 * 1.8), stroke: (thickness: 0.3pt, dash: "dashed"))
    content((1.8, -0.5), text(size: 8pt, fill: orange)[$exp(X) = mu_X$])
    line((-0.3, 0.5 * 1.8), (1.8, 0.5 * 1.8), stroke: (thickness: 0.3pt, dash: "dashed"))
    content((-1.1, 0.5 * 1.8), text(size: 8pt, fill: orange)[$exp(Y) = mu_Y$])

    content((-3, 2.5), text(size: 10pt, fill: red)[Support of $X : Omega_X$])
    content((-3, 2), text(size: 10pt, fill: green)[Support of $Y : Omega_Y$])
  }),
  caption: [Support of two random variables $X$ and $Y$ that are positively correlated],
)<fig_3_support_xy>

Suppose now that we fix a value both for the random variable $X$ and $Y$. We could try to compute the 'offset' of those values from their respective expected values, that is:

#math.equation(
  block: true,
  numbering: none,
  $
    X - exp(X) space space "and" space space Y - exp(Y)
  $,
)

It is evident that, if we fix a point $(x,y)$ in the support of the random vector $(X,Y)$, and multiply the offsets define above and we weigh them by the joint probability of $(x,y)$, will always get a positive quantity; that is

#math.equation(
  block: true,
  numbering: none,
  $
    cov(X, Y) quad = limits(sum)_((x,y) in Omega_(X Y)) (x - exp(X)) space (y - exp(Y)) space p_(X Y)(x,y) > 0
  $,
)<eq:positive_covariance>

In other word, $X$ and $Y$ are *positively correlated*: this means that when $X$ is above its expected value, also $Y$ tends to be above its expected value, and viceversa.


To be more specific, the one in @fig_3_support_xy is an example of *perfect linear relationship* meaning that, whenever we know the value of one of the two random variables, we can exactly determine the value of the other one.

#remark[
  It is possible to notice that the *magnitude* of the covariance depends on the *dispersione* of the two random variables, that is, the higher the variance of either one of the random variables, the higher the covariance will be.
]

We would actually like to be able to obtain a *standardized* way to measure the linear association between two random variables, in order to be able to compare the strength of the linear relationship between different pairs of random variables. To do so we can introduce the concept of *correlation coefficient*.

#definition(title: "Correlation Coefficient")[
  Given two random variables $(X,Y)$ we can define the *correlation coefficient* between them $rho_(X Y)$ as:

  #math.equation(
    block: true,
    $
      "Corr"(X,Y) = rho_(X Y) = (cov(X, Y)) / (sqrt(var(X)) space sqrt(var(Y)))
    $,
  )<eq:correlation_coefficient>

  One important property of the correlation coefficient is that it is always bounded between -1 and 1, that is:
  #math.equation(
    block: true,
    numbering: none,
    $
      -1 <= rho_(X Y) <= 1
    $,
  )
]<def:correlation_coefficient>

In our previous example of @fig_3_support_xy, since the two random variables are perfectly positively correlated, we have that $rho_(X Y) = 1$.

#warning-box[
  It is essential to notice that both covariance and correlation coefficient only measure *linear association* between two random variables. Two random variables may not be linearly correlated at all, but present some kind of non-linear dependency between them.
]

To understand this consider two random variables whose support is represented in @fig:non_linear_relationship.

#figure(
  cetz.canvas({
    import cetz.draw: *

    line((-5, 0), (5, 0), mark: (end: ">"), name: "x-axis")
    line((0, -0.5), (0, 3), mark: (end: ">"), name: "y-axis")
    content((5.3, -0.2), $X$)
    content((-0.4, 3), $Y$)

    let start_x = -4
    let x_step_positive = 0.8

    let xy_points = ()

    let x_support = ()
    let y_support = ()

    while start_x <= 4 {
      if start_x < 0 {
        xy_points.push((start_x, -0.5 * start_x))
        y_support.push((0, -0.5 * start_x))
      } else {
        xy_points.push((start_x, 0.5 * start_x))
        y_support.push((0, 0.5 * start_x))
      }
      x_support.push((start_x, 0))

      start_x = start_x + x_step_positive
    }

    for i in range(0, xy_points.len()) {
      circle(xy_points.at(i), radius: 0.05, fill: blue.lighten(80%), stroke: blue)
    }


    for i in range(1, xy_points.len()) {
      line(xy_points.at(i - 1), xy_points.at(i), stroke: (paint: rgb("#457b9d"), thickness: 0.5pt, dash: "dashed"))
    }

    for i in range(0, y_support.len()) {
      line(y_support.at(i), xy_points.at(i), stroke: (thickness: 0.2pt, dash: "dashed"))
      line(x_support.at(i), xy_points.at(i), stroke: (thickness: 0.2pt, dash: "dashed"))
    }

    line((-4, 1.5), (4, 1.5), stroke: (paint: purple, thickness: 2pt, dash: "dotted"))
    content((-4.5, 1.5), text(size: 10pt, fill: purple)[$exp(Y)$])

    line((0, -0.3), (0, 2.5), stroke: (paint: purple, thickness: 2pt, dash: "dotted"))
    content((0, -1), text(size: 10pt, fill: purple)[$exp(X)$])

    circle((2, 1), radius: 0.1, fill: orange.lighten(70%), stroke: orange)
    content((2.3, 0.6), text(size: 10pt, fill: orange)[$(x_1, y_1)$])
    circle((-2, 1), radius: 0.1, fill: orange.lighten(70%), stroke: orange)
    content((-2.3, 0.6), text(size: 10pt, fill: orange)[$(x_2, y_2)$])
  }),
  caption: [Support of two random variables $X$ and $Y$ that not linearly correlated],
)<fig:non_linear_relationship>

In this case we would have that the quantity $x_1 - exp(X)$ would be positive, while the quantity $y_1 - exp(Y_1)$ would be negative, thus the product between them would yield a negative value. The problem in this case is that if we consider the point $(x_2, y_2)$, and consider the offset with respect to the expected values, we would find that their product is positive but with the same magnitude of the previous one. This would happen for every other pair of points in the support, thus we would obtain a linear correlation factor equal to zero.

We basically have found out that the two random variables are *uncorrelated*, meaning that there is no linear relationship between them, even though they are clearly *not independent*, indeed knowing the value of one of the two random variables allows us to know the value of the other one up to a sign.

In general, we can always say that if two random variables are independent, then they are also uncorrelated, and have covariance equal to zero. The opposite is not true in general, as we have just seen in the example above, in such case, we can only state that their relation, if any, is non-linear.

==== Properties of Covariance and Variance
As we have introduced a new operator, it is worth to take a look at its properties, specifically, since it is strongly related to the variance operator, not surprisingly we'll see how variance and covariance can be put together to derive some useful results.

- $var(a X + b Y + c) = a^2 var(X) + b^2 var(Y) + 2 a b cov(X, Y)$, here we can see that the first two members of the sum can be obtained from the scaling property of the variance, as well as the disappearance of the constant $c$.

- If we want to compute the covariance between linear transformations of multiple random variables we need to take into account all possible pairs of linearly transformed variable: $cov(a X + b Y, c Z + d W) = a d cov(X, W) + b c cov(Y, Z) + a d cov(X, W) + b d cov(Y, W)$

- $cov(X, a) = exp((x - exp(X))(a - exp(a))) = exp((x - exp(X)) dot 0) = 0$
- $cov(X, Y) = cov(Y, X)$, that is the covariance is *symmetric* as well as the correlation coefficient

- $cov(a X + b, b Y + c) = a c cov(X, Y)$, in case we are dealing with the correlation operator we shall have that the constants $a, c$ will cancel out with the scaling of the standard deviations in the denominator, that is $rho(a X + b, c Y + d) = rho(X, Y)$

==== Chebyshev's Inequality
One last important property involving the variance of a random variable is the so called *Chebyshev's inequality*. This is a very useful result, which comes in handy when we don't know the exact distribution of a random variable, but we know its expected value $mu$ and variance $sigma^2$, which thinking about it are two values which is not so difficult to estimate from experimental data. In such case we can use this result.

#theorem(title: "Chebyshev's Inequality")[
  Given a random variable $X$ with expected value $exp(X) = mu$ and variance $var(X) = sigma^2$, then for any $epsilon > 0$ we have that:

  #math.equation(
    block: true,
    $
      prob(|X - mu| > epsilon) <= ((sigma)/(epsilon))^2
    $,
  )
]

This result is very important since it allows us to bound the probability that a random variable deviates from its expected value by more than a certain amount $epsilon$, just knowing its variance.
