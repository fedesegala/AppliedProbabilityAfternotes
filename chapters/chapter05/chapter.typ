#import "@preview/theorion:0.4.1": *
#import cosmos.fancy: *
#show: show-theorion
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#import "../../lib.typ": *
#import "@preview/cetz:0.4.2"
#import "@preview/suiji:0.5.1": *

#show ref: it => {
  if query(it.target).len() == 0 {
    return text(fill: red, "ciaone" + str(it.target))
  }
  it
}
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

= Continuous Time Markov Chains
This chapter presents concepts from the Carlton-Devoir textbook for the course. We will explore Continuous Time Markov Chains (CTMCs), their properties, and applications.

== Introduction to Continuous Time Markov Chains
Let's start with the definition of a Continuous Time Markov Chain.

#definition(title: "Continuous-time Markov Chain (CTMC)")[
  A *family* $X = {X(t) : t >= 0$ of random variables taking values in a *discrete* (countable) state space $cal(S)$ and indexed by the half line $[0, oo)$ is called a *continuous-time Markov chain* if it satisfies the _Markov property_ specified in
  @eq_0405_markovproperty:

  #math.equation(block:true, numbering: none,
    $
      prob(X(t_n) = x_n &| X(t_1)=x_1"," ..."," X(t_(n-1)) = x_(n-1)) = \
      &= prob(X(t_n) = x_n | X(t_(n-1)) = x_(n-1))
    $)

  for all $n in NN$, all $x_1, x_2, ..., x_n in cal(S)$ and all ordered sequences of times $t_1, < t_2 < ... < t_n in [0, oo)$.
]

This Markov property is really nice, in that it grants us that the following equality holds:

#math.equation(block: true, numbering: none,
  $
    prob(X(t_n) = x_n | X(t_(n-1)) = x_(n-1)) = p_(X(t_n) | X(t_(n-1)) space (x_n | x_(n-1))
  $)

which, in this case is a function of four elements: the two times $t_n$ and $t_(n-1)$, and the two states $x_n$ and $x_(n-1)$. For each fixed present time, present state and future time, $(t_(n-1), t_n, x_(n-1))$ this is a *probability mass function* for the future state $X_n$.

In particular this p.m.f. is a non-negative function of $X_n$ and the sum over all possible future states is equal to 1. If we think about this, we could arrange this information in a *matrix* form, where the rows represent the present states and the columns represent the future states; however, since we are in continuous time, we would need a different matrix for each pair of times $(t_(n-1), t_n)$. This would lead to the need of representing a ton of information, which is not really practical. For this reason, we will introduce some *simplifying assumptions* that will allow us to reduce the amount of information we need to keep track of.

==== Assumption 1 - State Space Enumeration
First of all, we assign to each state a numerical label so that $cal(S) = {0, 1, 2, 3, ..., n}$, where $n$ could be either finite of infinite. This will allow us to represent the transition probabilities in a matrix form, where the rows and columns are indexed by these numerical labels.

==== Assumption 2 - Homogeneity
We will only consider *homogeneous* CTMC's, this means that $forall s < t$ and all $i, j in cal(S)$

#math.equation(block: true, numbering: none,
  $
    prob(X(t) = j | X(s) = i) = p_(i,j)(s,t)
$)


only depends on times $t,s$ through their difference $t-s$:
#math.equation(block: true,
$
  p_(i,j) (s,t) = p_(i,j)(0, t-s)
$)<eq_0501_homogeneity_condition>

We can also notice that $t-s$ is also a time in the half-line $[0, oo)$, this allows us to only describe the behavior of the *homogeneous* CTMC as:

#math.equation(block: true, numbering: none,
$
  p_(i,j) (0,t) &= p_(i,j) (t) = prob(X_(t) = j | X(0) = i) \
  &= prob(X(s+t) = j | X(s) = i)
$)

for $i,j in cal(S), t in [0,oo)$. To properly work with this we also need the marginal of $X(0)$, which is responsible for indicating us where to start from.

== Transition semi-group
Considering @eq_0501_homogeneity_condition, we can define $p_(i,j)$ as the *transition probabilities* of the CTMC, i.e., the probability of going from state $i$ to state $j$ in time $t$.

If we arrange all these transition probabilities in a matrix $P_t$ with entries $p_(i,j(t)$, where the row $i$ represents the _present state_ and the column $j$ represent the _future state_, we obtain the *transition matrix* at time $t$. We are going to use such matrix conditioning on the initial state (rows) and studying the conditional probabilities of ending in a state (column) after a time $t$.

#remark[
  Notice that each transition matrix $P_t$ is a *square* matrix of size $|cal(S)|$, which could, as already mentioned, be either finite or infinite.
]

#definition(title: "Transition semi-group")[
  The *family* ${P_t: t >= 0}$ is called the *transition semi-group* of the HCTMC, and it has the following three properties:

  + $P_0 = bold(I)$, the identity matrix.

  + for every $t > 0$, $P_t$ is a *stochastic matrix*, i.e., it has _non-negative entries_ and each row sums to 1. This is necessary, since each row represents a probability mass function over the future states given the present state.

  + the *Chapman-Kolmogorov equations* hold: $P_(s+t) = P_s P_t, forall s, t >= 0$
]

Following we try to give a better understanding of the last property, that is, the adherence to the Chapman-Kolmogorov equations. Let's consider three timestamps: $t < s < t+s$. What these equations require is that, if we look at the status of the system first at time $t$ and then at time $s+t$, we should obtain the same result as if we looked at the system directly at time $s+t$.

Let's look at a single transition probability $p_(i,j)(s,t)$ of the transition matrix $P_(s+t)$. This represents the probability of going from state $i$ to state $j$ in time $s+t$. We can compute this probability by considering all possible intermediate states $n$ that the system could be in at time $t$. Using the _law of total probability_ we can write the following:
#math.equation(block: true, numbering: none,
$
  p_(i,j) (s + t) &= prob(X(t+s) = j | X(0) = i) \
   &= sum_(n in cal(S)) prob(X(t+s) = j | X(t) = n) space prob(X(t) = n | X(0) = i) \
   &= sum_(n in cal(S)) p_(n,j)(s) space p_(i,n)(t)
$)

where in the last step we used homogeneity to express the conditional probabilities, let's try to identify what each member of the product represents:

- $p_(n,j)(s)$ is the probability of transitioning from state $n$ to $j$ in time $s$, which in other words is the "final step" of the transition from $i$ to $j$, assuming that previously we jumped from $i$ to $n$ in time $t$.

- $p_(i,n)(t)$ is exactly modeling the probability of jumping from $i$ to $n$ in time $t$, which is the "first step" of the transition from $i$ to $j$.

If we make $n$ take all possible values in the state space $cal(S)$ we end up with the first element of the product ranging over a _single column_ of the matrix, the one corresponding to the future state $j$, while the second element of the product ranges over a _single row_ of the matrix, the one corresponding to the present state $i$, namely we computed a scalar product between the row $i$ of the matrix $P_t$ and the column $j$ of the matrix $P_s$.

If we now we consider all the entries $p_(i,j)(s,t)$, we would need to compute all the scalar products between all the rows of $P_t$ and all the columns of $P_s$, which is exactly a _matrix multiplication_:

#math.equation(block: true, numbering: none,
$
  P_(s+t) = P_t dot P_s
$)

#remark[
  This equation has actually inverted indices with respect to the matrix multiplication we have presented in the definition of the Chapman-Kolmogorov equations; however, we can notice that we could've considered all the intermediate states $n$ at time $s$ instead of time $t$, which would have led us to the same result but with the indices inverted:

  #math.equation(block: true,
  $
    P_(s+t) = P_t dot P_s = P_s dot P_t
  $)

  This means that, in the particular case of the transition semi-group of a HCTMC, the *matrices commute*.
]

== Example - Poisson Process
A *Poisson process* with *intensity* $lambda$ is a continuous-time *counting process*:

#math.equation(block: true, numbering: none,
$
N = {N(t): t >= 0}
$)

taking values in $cal(S) = {0, 1, 2, ...}$ with the following properties:

+ $N(0) = 0$
+ the _increments_ are *independent* and *stationary*
+ $prob(N(h)=1) = lambda h + cal(o)(h); prob(N(h) >= 2) = cal(o)(h)$ for small $h > 0$

#remark[
  $cal(o)(h)$ is a function that goes to zero faster than $h$ as $h$ approaches 0:

  #math.equation(block: true, numbering: none,
  $
    limits(lim)_(h->0) cal(o)(h) = 0 quad "and" quad limits(lim)_(h->0) cal(o)(h)/h = 0
  $)
]

#remark[
  As already mentioned in @def_0406_strongstationarity, a stochastic process is (strongly) stationary if the finite dimensional distributions are invariant to time shifts. This means that the following distributions are equivalent:

  - $X_t$ and $X_t+h$ are equal in distribution for all $t, h >= 0$
  - $(X_t, X_s) " and " (X_(t+n), X_(s+n)) quad forall t, s, n >= 0$
  - $(X_t, X_s, X_u)$ and $(X_(t+h), X_(s+h), X_(u+h)) quad forall t, s, u, h >= 0$
]

The previous two remarks should help to clarify the meaning of the last Poisson counting processes property. Let's now summarize what we know about the Poisson counting process $N ~ P "PP"(lambda)$:

- from property number 1 we know that $N(0) = 0$, this means that $prob(N(0) = 0) = 1$, i.e., we know the marginal at time 0.

- from property number 2, we know that the increments  $N(t+s) - N(s)$ are independent and stationary, this is illustrated in @fig_0501_strongstationarity_increments below.

  #figure(
    cetz.canvas({
      import cetz.draw: *


      line((-0.5, 0), (8, 0), mark: (end: "stealth"))
      content((), [$space t$], anchor: "west")
      line((0, -.5), (0,4), mark: (end: "stealth"))
      content((), [$N(t) space space$], anchor: "east")
      stroke(blue + 0.6pt)



      // line((0,0), (6,3))

      line((1,3.6),(1,-0.5), stroke: (thickness: 0.4pt, paint: purple))
      content((1, -.7), [#text(fill: purple)[$t$]])

      line((3,3.6),(3,-0.5), stroke: (thickness: 0.4pt, paint: purple))
      content((3, -.7), [#text(fill: purple)[$t+s$]])

      line((6,3.6),(6,-0.5), stroke: (thickness: 0.4pt, paint: purple))
      content((6, -.7), [#text(fill: purple)[$t+s+h$]])

      circle((0, 0), radius: 0.08, fill: blue)
      circle((1, 0.5), radius: 0.08, fill: blue)
      circle((3,1.5), radius: 0.08, fill: blue)
      circle((6,3), radius: 0.08, fill: blue)

      line((1,0.5), (3.3,0.5), stroke: (thickness: 0.2pt, dash: "dashed", paint: green))
      line((3,1.5), (6.3,1.5), stroke: (thickness: 0.2pt, dash: "dashed", paint: green))
      line((3.3, 0.5), (3.3,1.5), stroke: (thickness: 0.2pt, paint: green))
      content((3.4,1), angle: -90deg, [#text(size: 3.5pt)[*$N(t+s) - N(s)$*]])

      line((6,3), (6.3,3), stroke: (thickness: 0.2pt, dash: "dashed", paint: green))
      line((6.3, 3), (6.3,1.5), stroke: (thickness: 0.2pt, paint: green))
      content((6.5, 2.2), angle: -90deg, [#text(size: 5pt)[*$N(t+s+h) - N(t+s)$*]])

    }),
    caption: [Strong stationarity of increments in a counting process],
  )<fig_0501_strongstationarity_increments>

  This means that is we consider $N(t + s) - N(s)$, this distribution is only dependent on the value of $t$, and similarly $N(t + s + h) - N(t + s)$, which only depends on $h$. 
  
