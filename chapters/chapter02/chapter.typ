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

  #math.equation(block: true, numbering: none, $P(x) = prob(X = x)$)

  is called the *probability mass function*. The *cumulative distribution function* is defined as:

  #math.equation(block: true, numbering: none, $F(x) = prob(X <= x) = sum_(y <= x) P(y)$)

  The set of all possible values of $X$ is called the *support* of the distribution.
]

Suppose we toss a fair coin three times and we want to count the number of heads $X$ that we get. The cumulative distribution function and probability mass function of such a random variable are illustrated in @fig:0201.
#figure(
  image("images/01_pmf_cdf.png", width: 90%),
  caption: "Example of Probability Mass Function (PMF) and Cumulative Distribution Function (CDF) for a discrete random variable X representing the number of heads in three coin tosses.",
)<fig:0201>

#remark[Formally, we say that the *probability mass function* characterizes the distribution of a discrete random variable, as it contains all the information about the probabilities of each possible outcome.
]
