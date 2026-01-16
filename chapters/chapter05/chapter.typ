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

#math.equation(block: true,
$
  P_(s+t) = P_t dot P_s
$)<eq_0502_chapman_kolmogorov>

#remark[
  This equation has actually inverted indices with respect to the matrix multiplication we have presented in the definition of the Chapman-Kolmogorov equations; however, we can notice that we could've considered all the intermediate states $n$ at time $s$ instead of time $t$, which would have led us to the same result but with the indices inverted:

  #math.equation(block: true, numbering: none,
  $
    P_(s+t) = P_t dot P_s = P_s dot P_t
  $)

  This means that, in the particular case of the transition semi-group of a HCTMC, the *matrices commute*.
]

Following we show the matrix form of the transition semi-group at time $t$:

#math.equation(block: true,
$
  #text[*$P$*]_t = mat(
    p_(1 1) (t), p_(1 2) (t), p_(1 3) (t), p_(1 4) (t), ...;
    p_(2 1) (t), p_(2 2) (t), p_(2 3) (t), p_(2 4) (t), ...;
    p_(3 1) (t), p_(3 2) (t), p_(3 3) (t), p_(3 4) (t), ...;
    dots.v, dots.v, dots.v, dots.v, dots.down;
  )
$)<eq_0504_transition_semigroup_general_form>

The transition semi-group ${P_t}$ together with the distribution of the initial point $X(0)$ allows us to determine the full behavior of the process.

#example-box("Poisson Process")[
  In this example we are going to introduce a very important type of process, the Poisson one, which will be dealt with in much more detail in the next chapter.
  
  $N = {N(t): t >= 0}$ is a Poisson process with intensity $lambda$ if $S = {0, 1, 2, ...}$, $pi_0^((0)) = 1$, and for all $i,j in cal(S)$ we have the following: 
  
  #math.equation(block: true, numbering: none,
  $
  p_(i j) = 0 "if" j < i; quad quad p_(i i) = 1 - lambda t + cal(o)(t); \
  p_(i i+1) = lambda t + cal(o)(t); quad quad p_(i j) = cal(o)(t) "if" j >= i +2
  $)
  
  or, to view this in matrix form: 
  
  #math.equation(block: true, numbering: none,
  $
  P_t = mat(
    1 - lambda t + cal(o)(t), lambda t + cal(o)(t), cal(o)(t), cal(o)(t), ...; 
    0, 1 - lambda t + cal(o)(t), lambda t + cal(o)(t), cal(o)(t), ...; 
    0, 0, 1 - lambda t + cal(o)(t), lambda t + cal(o)(t), ...; 
    dots.v, dots.v, dots.v, dots.v, dots.down;
  )
  $)
  
  In the next chapter we are going to provide a closed form solution without approximation errors for this kind of process. For the time being, it shall just be noticed that this process is *homogeneous*, so the condition
  
  #math.equation(block: true, numbering: none,
  $
    p_(i j)(t) = prob(N(s+t) = j | N(s) = i) = prob(N(t) = j | N(0) = i)
  $)
  
  is satisfied, even if the events $N(0) = i$ have probability zero for all $i != 0$. 
]

#definition(title: "Standard semigroup")[
  The semigroup ${P_t}$ (the notation $P(t)$ will be used to indicate it is a function of time) is called *standard* if $P_t --> I$, the identity matrix as $t arrow.b 0$. In other words, as $t arrow.b 0, p_(i i)(t) -> 1$ and for $i != j, p_(i j)(t) -> 0$
]<def_0502_standard_semigroup>

In other words, we are extending the concept of *continuity* of a function to the standard semi-group around the point 0. Clearly, it is necessary for the semi-group to be standard, in order for it to be "differentiable". We can notice that, this definition, along with the adherence to the _Chapman-Kolmogorov_ equation grants this to be continuous for any time $t > 0$.

Not only the standard semi-group is continuous, but it is also *differentiable* at any time $t$. In particular $p_(i j) (t)$ is differentiable w.r.t $t$ for any $i, j in cal(S)$.  From now on, unless explicitly stated, we will assume that ${P_t}$ is a *standard* semigroup.


== Generator of a HCTMC
After we made sure that the transition semigroup is indeed differentiable, let's try to calculate its derivative; remembering of course that we are dealing with a matrix:

#math.equation(block: true, numbering: none,
$
lim_(h -> 0) space (P(h) - P(0)) / h = lim_(h -> 0) space (P(h) - I) / h = G
$)

Such matrix $G$ obtained by taking the derivative is called the *infinitesimal generator* of the HCTMC. We can take a look at the formal definition.

#definition(title: "Infinitesimal Generator")[
  Given any standard HCTMC $X$ with transition semi-group $P_t$, there exists constants ${g_(i j): i,j in cal(S)$ such that, for sufficiently small $h$:

  #math.equation(block: true, numbering: none,
  $
    p_(i j)(h) approx g_(i j) h space "if" i != j, quad quad p_(i i) approx 1 + g_(i i) h
  $)

  The matrix with entries $g_(i j)$ is denoted by $G$ and called the *infinitesimal generator* of the HCTMC.
]<def_0503_generator>

#remark[
  We can observe that, since the derivative is a constant, this means that the HCTMC described by $P(t)$ is a *linear function of time*.
]

The ${g_(i j)}$ for $j!=i$ are usually called the *instantaneous transition rates* and are such that

#math.equation(block: true, numbering: none,
$
 g_(i j) = lim_(h arrow.b 0) (p_(i j)(h)) / h  quad forall i != j
$)

from which we can exactly retrieve the expression for $p_(i j)(h)$ that appears in @def_0503_generator. Actually the exact formula for those $p_(i j)(h)$ is given as follows:

#math.equation(block: true,
$
  p_(i j)(h) = g_(i j) h + cal(o)(h)
$)<eq_0503_transition_prob_from_generator_exact>

Up to now we have focused on what happens for the elements which are not on the diagonal of the semigroup (or the generator, by transitivity). From a mathematical point of view, to compute these constants it is necessary to subtract 1, because of the subtraction with the identity matrix, that is:

#math.equation(block: true, numbering: none,
$
g_(i i) (h) = lim_(h arrow.b 0) (p_(i i)(h) - 1) / h
$)

To better understand this, suppose that, at time $t >= 0$, the chain $X$ is at state $i$, so $X(t) = i$ and consider what could happen in the time interval $(t, t+h)$ of very small length $h$: 

- with probability $p_(i,i) (h) + cal(o)(h)$ the state of the process will remain the same $X(t+h) = i$, where $cal(o)(h)$ is an error term which takes into account the possibility that the chain moves out of $i$ and back, within the interval

- with probability $p_(i j)(h) + cal(o)(h)$ the chain moves to state $j != i$: $X(t+h) = j$, where $cal(o)(h)$ takes into account the possibility that the chain moves into $j$, out and back in, within the time interval

In other words we have the following: 

#math.equation(block: true, numbering: none,
$
  X(t+h) = cases(
    i quad &"with probability " 1 + g_(i i) h + cal(o)(h),
    j != i quad &"with probability " g_(i j) h + cal(o)(h)
  )
$)

and, assuming $h$ is small enough for the error terms to be negligible, if we fix the present state $i$ we can write the law of total probability for the future state as follows: 

#math.equation(block: true, numbering: none,
$
  1 = sum_(j in cal(S)) p_(i j)(h) approx 1 + g_(i i) h + sum_(j != i) g_(i j) h = 1 + h sum_(j in cal(S)) g_(i j) 
$)

which leads to the following result: 

#math.equation(block: true,
$
  sum_(j in cal(S)) g_(i j) = 0 ==> g_(i i) = - sum_(j != i) g_(i j)
$)<eq_0505_instantaneous_exit_rates>

The collection ${g_(i i)}$ of the chain is usually referred to *instantaneous exit rates*; overall we refer to @eq_0505_instantaneous_exit_rates as *global balance equations*. 
#remark[
  We can actually see a standard HCTMC as a graph, where the nodes of the graph constitute the state space $cal(S)$ and the matrix $G$ constitutes the set of weighted directed edges  
]

To wrap it up, we can view the generator of a process as a square matrix with: 

- the instantaneous exit rates (negative values) on the diagonal
- the instantaneous transition rates (positive values) outside of the diagonal

== Forward and Backward Equations
In the last section we have seen how it is possible to effectively retrieve the generator starting from the transition-semigroup. Now we will focus on the opposite operation, that is, starting from the generator, we are going to try to retrieve the transition semigroup. 

Suppose we start the process at $X(0) = i$, for some $i in cal(S)$. If we make $h$ sufficiently small, we try to make use of the Chapman-Kolmogorov equation in @eq_0502_chapman_kolmogorov to find the value of $p_(i j)(t+h)$: 

#math.equation(block: true, numbering: none,
$
  p_(i j)(t + h) &= sum_(k in cal(S)) p_(i k)(t) p_(k j)(h) \
  &approx p_(i j)(t)(1 + g_(j j)h) + sum_(k in cal(S)\ k != j) p_(i k)(t) g_(k j) h \
  &= p_(i j)(t) + h sum_(k in cal(S))p_(i k)(t) g_(k j)
$)

Where we derived the first equality by means of Chapman-Kolmogorov equations and went from the first line to the second one by leveraging the fact that we are considering an infinitesimal time interval, thus the transition probability can be approximated by means of the infinitesimal transition rate. The third line of the equation is simply obtained by unfolding the first product and then rearranging the elements in the summation. Let's now consider the equality we have obtained: 

#math.equation(block: true, numbering: none,
$
  p_(i j)(t+h) = p_(i j)(t) + h sum_(k in cal(S)) p_(i k)(t) g_(k j)
$)

And apply on both side a subtraction by $p_(i j)(t)$ and division by $h$. Let's first do it on the left side. We can notice that performing these operations amount to computing the derivative of the left member (since $h$ is infinitesimally small): 

#math.equation(block: true, numbering: none,
$
  (p_(i j)(t + h) - p_(i j)(t))/h = p_(i j)^' (t)
$)

Let's do the same operation on the right side of the previous equation: 

#math.equation(block: true, numbering: none,
$
  (p_(i j)(t) + h sum_(k in cal(S)) p_(i k)(t) g_(k j) - p_(i j)(t)) / h = sum_(k in cal(S)) p_(i k)(t) g_(k j)
$)

In the end we are left with the following *forward equations* theorem. 
#theorem(title: "Forward Equations")[
  For all $i, j in cal(S)$ and $t >= 0$ we have that the following equality holds: 
  
  #math.equation(block: true,
  $
    p_(i j)^' = sum_(k in cal(S)) p_(i k)(t) g_(k j)
  $)<eq_0506_forward_eq>
  
  Or, in matrix notation: $P_t^' = P_t dot G$ with initial condition $P_0 = I$. 
]<th_0501_forward_eq>

We can see that the backward equations can be retrieved in a very similar fashion by reasoning the other way around, that is, considering transition probabilities for $X(t + h)$ given $X(h)$. 

#math.equation(block: true, numbering: none,
$
  p_(i j)(t + h) &= sum_(k in cal(S)) p_(i k)(h) p_(k j)(t) \
  &approx (1 + g_(i i)h) p_(i j)(t) + sum_(k in cal(S) \ k != j) g_(i k) h p_(k j)(t) \
  &= p_(i j)(t) + h sum_(k in cal(S)) g_(i k) p_(k j)(t)
$)

#theorem(title: "Backward Equations")[
  For all $i, j in cal(S)$ and $t >= 0$, we have that: 
  
  #math.equation(block: true,
  $
    p_(i j)^' (t) = sum_(k in cal(S)) g_(i k) p_(k j)(t)
  $)<eq_0507_backward_eq>
  
  Or, in matrix notation: $P_t^' = G dot P_t$ with initial condition $P_0 = I$. 
]<th_0502_backward_equation>

==== Matrix Exponential
We can notice that in both the forward and backward equations we end up with a solution in the form (if we were working with normal functions and scalars): $f'(x) = a dot f(x)$. If we think about it, the only function $f$ which has such form when considering its derivative is the *exponential function*. 

The problem is that we are dealing with much more complex elements, _matrices_ for which, however, it's possible to define an exponential. To do so, let's first look, informally, at the definition of what e^(a x) means. Whenever we are computing such value, we are actually computing the limit of a series: 

#math.equation(block: true, numbering: none,
$
  f(x) = e^(a x) = sum_(n = 0)^oo (a x)^n / n!
$)

Let's now apply the same reasoning for matrices: 

#math.equation(block: true, numbering: none,
$
  P_t = e^(G t) = sum_(n = 0)^oo (G t)^n / n!
$)

In this course we are going to address this in two possible ways: 

- from a symbolic point of view, we can solve this by means of *wolfram alpha*
- from a numerical point of view, we are going to use *R* in order to compute this


// #pagebreak()
// #pagebreak()
// == Poisson Processes
// In this section, which is quite important we are going to study what are Poisson Processes and how they are characterized. A *Poisson process* with *intensity* $lambda$ is a continuous-time *counting process*:

// #math.equation(block: true, numbering: none,
// $
// N = {N(t): t >= 0}
// $)

// taking values in $cal(S) = {0, 1, 2, ...}$ with the following properties:

// + $N(0) = 0$
// + the _increments_ are *independent* and *stationary*
// + $prob(N(h)=1) = lambda h + cal(o)(h); prob(N(h) >= 2) = cal(o)(h)$ for small $h > 0$

// #remark[
//   $cal(o)(h)$ is a function that goes to zero faster than $h$ as $h$ approaches 0:

//   #math.equation(block: true, numbering: none,
//   $
//     limits(lim)_(h->0) cal(o)(h) = 0 quad "and" quad limits(lim)_(h->0) cal(o)(h)/h = 0
//   $)
// ]

// #remark[
//   As already mentioned in @def_0406_strongstationarity, a stochastic process is (strongly) stationary if the finite dimensional distributions are invariant to time shifts. This means that the following distributions are equivalent:

//   - $X_t$ and $X_t+h$ are equal in distribution for all $t, h >= 0$
//   - $(X_t, X_s) " and " (X_(t+n), X_(s+n)) quad forall t, s, n >= 0$
//   - $(X_t, X_s, X_u)$ and $(X_(t+h), X_(s+h), X_(u+h)) quad forall t, s, u, h >= 0$
// ]

// The previous two remarks should help to clarify the meaning of the last Poisson counting processes property. Let's now summarize what we know about the Poisson counting process $N ~ P "PP"(lambda)$:

// - from property number 1 we know that $N(0) = 0$, this means that $prob(N(0) = 0) = 1$, i.e., we know the marginal at time 0.

// - from property number 2, we know that the increments  $N(t+s) - N(s)$ are independent and stationary, this is illustrated in @fig_0501_strongstationarity_increments below.

//   #figure(
//     cetz.canvas({
//       import cetz.draw: *


//       line((-0.5, 0), (8, 0), mark: (end: "stealth"))
//       content((), [$space t$], anchor: "west")
//       line((0, -.5), (0,4), mark: (end: "stealth"))
//       content((), [$N(t) space space$], anchor: "east")
//       stroke(blue + 0.6pt)



//       // line((0,0), (6,3))

//       line((1,3.6),(1,-0.5), stroke: (thickness: 0.4pt, paint: purple))
//       content((1, -.7), [#text(fill: purple)[$t$]])

//       line((3,3.6),(3,-0.5), stroke: (thickness: 0.4pt, paint: purple))
//       content((3, -.7), [#text(fill: purple)[$t+s$]])

//       line((6,3.6),(6,-0.5), stroke: (thickness: 0.4pt, paint: purple))
//       content((6, -.7), [#text(fill: purple)[$t+s+h$]])

//       circle((0, 0), radius: 0.08, fill: blue)
//       circle((1, 0.5), radius: 0.08, fill: blue)
//       circle((3,1.5), radius: 0.08, fill: blue)
//       circle((6,3), radius: 0.08, fill: blue)

//       line((1,0.5), (3.3,0.5), stroke: (thickness: 0.2pt, dash: "dashed", paint: green))
//       line((3,1.5), (6.3,1.5), stroke: (thickness: 0.2pt, dash: "dashed", paint: green))
//       line((3.3, 0.5), (3.3,1.5), stroke: (thickness: 0.2pt, paint: green))
//       content((3.4,1), angle: -90deg, [#text(size: 3.5pt)[*$N(t+s) - N(s)$*]])

//       line((6,3), (6.3,3), stroke: (thickness: 0.2pt, dash: "dashed", paint: green))
//       line((6.3, 3), (6.3,1.5), stroke: (thickness: 0.2pt, paint: green))
//       content((6.5, 2.2), angle: -90deg, [#text(size: 5pt)[*$N(t+s+h) - N(t+s)$*]])

//     }),
//     caption: [Strong stationarity of increments in a counting process],
//   )<fig_0501_strongstationarity_increments>

//   This means that is we consider $N(t + s) - N(s)$, this distribution is only dependent on the value of $t$, and similarly $N(t + s + h) - N(t + s)$, which only depends on $h$.


// === Poisson Process - Definition (1)
// All these notions we have presented allow us to provide a first definition of a Poisson process, there are actually other equivalent definitions, but we will present them later on.

// #definition(title: "Poisson Process (1)")[
//   A *Poisson process* with intensity $lambda$ is a continuous time countin process $N = {N(t): t >= 0}$ taking values in $cal(S) = {0,1,2,...}$ such that:

//   - $N(0) = 0$, no other possible outcome is allowed
//   - the increments are independent and stationary
//   - $prob(N(h) = 1) = lambda h + cal(o)(h)$ and $prob(N(h)) >= 2 = cal(o)(h)$
// ]<def_0501_poisson_process_1>

// What we are still missing to further explore in this definition is the last condition. To do so, we can start studying the probability of $N(h)$ being 1 by means of the law of total probability:

// #math.equation(block: true, numbering: none,
// $
//   prob(N(h) = 1) &= sum_(n=0)^oo prob(N(h) = 1 | N(0) = n) space prob(N(0) = n) \
//   &= prob(N(h) = 1 | N(0) = 0) space "by property (1)" \
//   &= p_(0,1)(h) space "the transition probability from 0 to 1 in time h"
// $)

// Let's study what happens inside the transition semi-group of a Poisson process:

// #math.equation(block: true,
// $
//   P_t = mat(
//   1 - lambda t  + cal(o)(t), lambda t + cal(o)(t), cal(o)(t), cal(o)(t), space ...;
//   0, 1 - lambda t + cal(o)(t), lambda t + cal(o)(t), cal(o)(t), space ...;
//   0, 0, 1 - lambda t + cal(o)(t), lambda t + cal(o)(t), space ...;
//   dots.v, dots.v, dots.v, dots.v, space dots.down;
// )
// $)<eq_0502_poisson_transition_semigroup>

// This allows us to notice that, thanks to stationarity we can actually provide a more explicit expression for the transition probabilities of a Poisson process, according to the present state $i$ and the future state $j$:

// - $p_(i,j) (h) = 0$ for all $j < i$, this is not clear now, but it will be looking at the definition of a Counting process

// - $p_(i,i) (h) = 1 - lambda(t) + cal(o)(t)$, this is the probability of not having any increment in time $h$

// - $p_(i, i+1) (h) = lambda t + cal(o)(t)$, this is the probability of having exactly one increment in time $h$

// - $p_(i,j) (h) = cal(o)(t) space forall j >= i+2$, this is the probability of having two or more increments in time $h$, which, not surprisingly, goes to zero faster than $h$ as $h$ approaches 0

// To understand why the first point is correct, we need to introduce the definition of the more general *counting process*:

// #definition(title: "Counting Process")[
//   A stochastic process $X(t)$ is called a *counting process* if the following conditions hold:

//   + $X(t) in NN quad forall t in cal(T) subset RR$, the *time domain*

//   + $X(s) <= X(t) quad forall s <= t$

//   + Counts are non-negative integers, $X(t) in {0, 1, 2, 3, ...}$
// ]<def_0502_counting_process>

// Basically, the first point of @def_0501_poisson_process_1 holds because, by looking at the second condition of @def_0502_counting_process we know that the counting process is non-decreasing, this means that we cannot have less counts in the future than in the present, which translates to the impossibility of going from state $i$ to any state $j < i$.

// #remark[
//   The reason why we have introduced the $cal(o)(t)$ factor is to keep into account the size of the considered time interval. In fact, as the time interval $t$ considered approaches 0, the smaller are the chances of having more than one increment.
// ]

// #warning-box[
//   The definition of a counting process is actually quite general: it does not specify anything about the distribution of the increments, nor about their independence or stationarity. In fact, a counting process could be as simple as a deterministic function that counts the number of events that have occurred up to time $t$.
// ]

// === Poisson Process - Definition (2)
// Let's focus for some more time on the Poisson process $N ~ P P(lambda)$ and let's look at the transition probabilities in case the future state $j$ is greater than the present state $i$ by more than 1, i.e., $j > i + 1$:

// #math.equation(block: true, numbering: none,
// $
//   p_(i,j)(t) = cal(o)(t) &= prob(N(t) = j | N(0) = i) \
//   &= prob(N(t + h) = j | N(t) = i) space "by stationarity"
// $)

// Considering the quantity $cal(o)(h)$ we know the following facts:

// #math.equation(block: true, numbering: none,
// $
// lim_(t->0) cal(o)(t) = 0 quad quad quad lim_(t -> 0) (cal(o)(t))/t = 0
// $)

// We can notice that, independently of whether $i = 0$ or $i != 0$, the value of $j$ is always different from 0. Let's now study the two cases according to the value of $i$.

// If $i != 0$ we can notice that, even though $prob(N(t) = j | N(0) = i)$ is well defined, that is never going to happen, because the conditioning probability $prob(N(0) != 0) = 0$, so we are left only with the second equivalence $prob(N(t+h) = j | N(t) = i)$.

// Let's now focus on the case in which $i=0$, we can imagine to take three pictures of the process at three different times: $t=0$, $t=h$, $t=t+h$ while the process moves. Let's consider the following equality which leverages the law of total probability:

// #math.equation(block: true, numbering: none,
// $
// p_(i,j)(t+h) = sum_(k=0)^oo p_(i,k)(h) space p_(k,j)(t)
// $)

// Consider now the left side of the equation and consider the following manipulation, which will later be transported also to the right side:

// #math.equation(block: true, numbering: none,
// $
//   limits(lim)_(h->0) space (p_(i,j)(t+h) - p_(i,j)(t))/h <==> (d space p_(i,j)(t))/ (d t) = p_(i,j)^' (t) \
// $)

// In the last few lines we have introduced the *derivative* of the transition probability. We can actually define this for any homogeneous continuous time Markov chain, for any state $i,j in cal(S)$ and any time $t in [0, oo)$. Let's now consider the full equality:

// #math.equation(block: true, numbering: none,
// $
//   p_(i,j)^' (t) &= limits(lim)_(h->0) space 1/h [sum_(k=0 \ coleq(#red, k!= i","j))^oo p_(i,k)(h) p_(k,j)(t) + coleq(#red, p_(i,i)(h) p_(i,j)(t)) + coleq(#red, p_(i,j)(h) p_(j,j)(t)) - p_(i,j)(t)] \

//   &= limits(lim)_(h->0) space 1/h [sum_(k!=i)^oo p_(i,k)(h) p_(k, j)(t)  + p_(i,j)(t) (p_(i,i)(h) - 1)] \
// $)

// If we take a look at the transition semi-group of the Poisson process in @eq_0502_poisson_transition_semigroup, we can notice that $p_(i,k)(h) = 0$ whenever $k > i$ and that $p_(k,j)(t) = 0$ whenever $j > k$. If we try to study when the quantity $p_(i,k)(h) space p_(k,j)(t)$ is positive we can notice that:

// - $k != 0$, this is necessary because we need $k > 0$ and we assumed $i = 0$, otherwise we'd have $p_(i,k)(h) = 0$, which would make the product null

// - at the same time we need $k <= j$ otherwise the other component $p_(k,j)(t)$ would be equal to 0, making the product null

// We have that $k$ must be larger or equal than $j$ not to make the second factor go to zero but at the same time $k$ needs to be smaller or equal than $i$ not to let the first factor be 0. This is impossible, so the summation must cancel out: this leaves us with the following equality:

// #math.equation(block: true, numbering: none,
// $
//   p_(i,j)^' (t)&= limits(lim)_(h->0) space 1/h [p_(i,j)(t) space (p_(i,i)(h) - 1)] \
//   &= p_(i,j)(t) lim_(h->0) (p_(i,i))(h) - 1 / h
// $)

// Here we can notice that, the probability of staying in state $i$ in an amount of time that approaches 0, is 1, thus we can rewrite the above equation as:

// #math.equation(block: true, numbering: none,
// $
//   p_(i,j)^' (t) = p_(i,j)(t) lim_(h->0) (p_(i,i)(0 + h) - p_(i,i)(0))/h = p_(i,j)(t) p_(i,i)^' (0)
// $)

// This was for the case in which $j > i + 1$, to be as formal as possible we should derive this also in case $j$ was equal to $i + 1$ and to $i$; we are not going to do so, but it turns out that using Chapman-Kolmogorov equations we can start from the original transition semi-group and obtain a relationship between the derivatives of the different entries of the matrix.

// In this case we have $p_(i,j)(t) = cal(o)(t)$ and $p_(i,i)(t) = 1 - lambda t - cal(o)(t)$, meaning that we can write the derivative as follows:

// #math.equation(block: true, numbering: none,
// $
//   p_(i,j)^' (t) = cal(o) (t) (1 - lambda t -cal(o)(t) )
// $)

// This is clearly a *differential equation*, which we are not going to solve, but intuitively we see that if we managed to solve that we could switch from the expression where the $p_(i,j)(t)$ is an approximation to the closed form solution in which we have the exact definition of the function.

// #definition(title: "Poisson Process (2)")[
//   A *Poisson process* with intensity parameter $lambda$ is a continuous-time counting process $N = {N(t): t >= 0}$ that satisfies the following properties:

//   + $N(0) = 0$

//   + given any pair of disjoint intervals $(s_1, s_1+t_1], (s_2, s_2 + t_2]$, the increments $N(s_1 + t_1) - N(s_1)$ and $N(s_2 + t_2) - N(s_2)$ are *independent*

//   + for any $t, s >= 0$, $N(t+s) - N(s) ~ "Po"(lambda t)$
// ]