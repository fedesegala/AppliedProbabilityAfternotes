#import "@preview/theorion:0.4.1": *
#import cosmos.fancy: *
#show: show-theorion
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#import "../../lib.typ": *
#import "@preview/suiji:0.5.1": *
#import "@preview/cetz:0.4.2"

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

  #math.equation(block: true,
  $
    p_(i j)(h) approx g_(i j) h space "if" i != j, quad quad p_(i i) approx 1 + g_(i i) h
  $)<eq_050401_transitionprobs_as_transitionrates>

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

==== Wrapping it up
Suppose we have $X = {X_t = X(t): t >= 0}$, a continuous homogeneous time Markov chain, whose random behavior (*law*) is completely described by the following elements:

+ _initial distributition_ $pi^((0)) = (pi_1^((0)), pi_2^((0)), ...)$, where $pi_i^((0)) = prob(X(0) = i)$

+ _transition semigroup_ ${P_t = P(t) : t>=0}$, where $p_(i j)(t) = prob(X(t) = j | X(0) = i)$

According to these elements we can define _infinitesimal generator_ as the derivative of the transition semigroup with respect to time $t$:

#math.equation(block: true, numbering: none,
$
  lim_(h arrow.b 0) (P_h - I)/h = G
$)

Notice how, in some textbooks, the generator $G$ is also referred to by the symbol $Q$. Given such generator, it is possible to replace the transition semigroup with the generator itself, since it is possible to recover the original transition probabilities by means of the forward-backward equations in @eq_0506_forward_eq, @eq_0507_backward_eq: $P_t^' = P_t dot G = G dot P_t$, an equation to which a solution can be found via the matrix exponential $P^t = e^(G t)$, which can be rewritten as follows:

#math.equation(block: true, numbering: none,
$
  e^(G t) = sum_(n=0)^oo 1/n! (G t)^n
$)

We can actually apply to the above equation the usual properties of the exponential function:

- $e^bb(0) = I$, the identity matrix, where $bb(0)$ is the zero-matrix

- $e^A dot e^(-A) = I$, since $e^(A - A) = e^bb(0) = I$, i.e., we can obtain the identity matrix by mutiplying by the exponential of the opposite

- $e^(s A) dot e^(t A) = e^((s+t) A) = e^((t+s) A) = e^(t A) dot e^(s A)$, i.ie., the exponential of a matrix multiplied by more than one constant are commutative

- if $A B = B A$, then also $e^A e^B = e^B e^A$, if the starting matrices commute w.r.t. the product, then also the exponentiated matrices commute

- $d / d t e^(t A) = A e^(t A) = e^(t A) A$, the derivative of the matrix exponential is computed in a similar fashion to the standard, plain exponential function, case

In `R` we are going to compute this automatically by means of the function `expm` provided by the library `expm`.

== Birth and Death Processes - Poisson Processes
In this section, we introduce a process that is even more general than the Poisson process, the *birth and death process*. Rather than delving into all the technical details, our goal is to provide an intuitive overview. This will help illustrate how the concepts and tools we've developed so far can be applied in a broader context.

As we have already mentioned, we can represent a HCTMC by means of a *graph*, where the process' states constitute the set of nodes, and the transition probabilities represent the weighted directed edges. Let's see a graph representing our birth-death process along with it infinitesimal generator:

#let graph_1 =  cetz.canvas({
  import cetz.draw: *
  // Draw four nodes in a line: 0, 1, 2, 3
  let node_y = 0
  let node_xs = (0, 2, 4, 6)
  let node_labels = ("0", "1", "2", "3")
  let lambdas = ([$lambda_0$], [$lambda_1$], [$lambda_2$])
  let mus = ([$mu_1$], [$mu_2$], [$mu_3$])

  // Draw nodes
  for i in range(0, 4) {
    circle((node_xs.at(i), node_y), radius: 0.25, fill: white, stroke: (thickness: 1pt, paint: black))
    content((i*2, 0), [$#i$])

  }

  // Draw curved edges for lambda (above)
  for i in range(1, 4) {
    let x0 = node_xs.at(i - 1)
    let x1 = node_xs.at(i)
    let y0 = node_y
    let y1 = node_y
    // Control points for curve above
    let ctrl_y = node_y + 1.0
    let ctrl_x = (x0 + x1) / 2


    bezier(
      (x0 + 0.15, 0.2), (x1 - 0.15, 0.2), (ctrl_x - 0.5, 0.5), (ctrl_x + 0.5, 0.5),
      mark: (end: "stealth")
    )

    bezier(
      (x0 + 0.15, -0.2), (x1 - 0.15, -0.2), (ctrl_x - 0.5, -0.5), (ctrl_x + 0.5, -0.5),
      mark: (start: "stealth")
    )


    content((ctrl_x, 0.7), text[#lambdas.at((i - 1))])
    content((ctrl_x, -0.7), text[#mus.at(i - 1)])

  }
})

#grid(
  columns: (50%, 50%),
  math.equation(block: true, numbering: none,
  $
    G = mat(
      -lambda_0, lambda_0, 0, 0, ...;
      mu_1, -(lambda_1 + mu_1), lambda_1, 0, ...;
      0, mu_2, -(lambda_2 + mu_2), lambda_2, ...;
      dots.v, dots.v, dots.v, dots.down
    )
  $),
  figure(
  graph_1,
  caption: [Graph representing the birth-death process]
  ),
)

There are some special cases to a birth-death process, we list them below:

- if all $mu_i = 0, space forall i$ we are actually dealing with a *pure birth process*, in which the state (number of births) can only increase, starting from a certain point
- if all $mu_i = 0$, $lambda_i = lambda$ and $pi_0^((0)) = 1$ we end up with the already introduced *Poisson process*. This means that every Poisson process is also a birth process
-  if all $lambda_i = 0, space forall i$ we have a *pure death process*, it is important to notice that this special process must start at some state $j != 0$ because once it reaches 0 it never gets out. $j=0$ is called an *absorbing state*

With this new kind of process in mind, let's try to solve the matrix exponential presented earlier in this chapter. To do so consider the expression $P_t = e^(t G)$ which allows us to retrieve the semigroup starting from the infinitesimal generator. . Notice how $G$ has infinite dimension, since the number of states in this process is made such that it can take into account every possible number. This can only be solved in a _recursive_ fashion.

Instead of trying to compute the transition semigroup of this birth-death process, which gets quite complicate, we are going to observe how all the stuff we have introduced so far can allow us to retrieve a closed form solution for the transition semigroup we have shown in the previous example about Poisson processes.

In case of a Poisson process we have that the probability of starting the process at state 0 is given by the following equation, _remember we are going to omit the first $0$ in $p_(0 i)$ since we are always going to study the probability of switching from state 0 to state $i$ in a time $t$_:

#math.equation(block: true, numbering: none,
$
  p_(0)^' (t) = -lambda p_(0)(t) = 0,
$)

We have obtained $p_(0 0)^' (t) = -lambda p_(0, 0)(t)$ by plugging $i = 0, j = 0$ in @eq_0506_forward_eq, and noticing that for any intermediate state $k != 0$ it is impossible to talk about _"going back from state $k$ to state 0" by definition of a Poisson process_. We have set the equality to 0, since, by definition of Poisson process, it is necessary for a Poisson process to *start in state 0*, thus no movement can occur. If now we consider any other $j > 0$ we obtain the following:

#math.equation(block: true, numbering: none,
$
  p_(0 j)(t) = lambda p_(j-1)(t) - lambda p_(j)(t)
$)

This is due to the fact, that considering Chapman-Kolmogorov equations, we need to consider all the cases in which we can go from state 0 to state $j$ by an intermediate state $k$; the only cases in which the transition rates are non-null are either for $g_(j j)$ (when the intermediate step must be done from state 0 to $j$), and in $g_(j-1, j)$ (in which the intermediate jump occurred from state 0 to $j-1$).

If we solve the first differential equation we get the following result for $p_0$:

#math.equation(block: true, numbering: none,
$
  p_0(t) = e^(- lambda)
$)

Now, we can plug this result in to the next differential equation for $j = 1$:
#math.equation(block: true, numbering: none,
$
  p'_1(t) = lambda e^(-lambda t) - lambda p_1(t) \
  ==> p_1(t) = lambda t e^(- lambda t)
$)

We can apply this reasoning recursively, and obtain the $p_j$ for any state $j$ by solving increasingly difficult differential equation. We will end up noticing the following general pattern:

#math.equation(block: true,
$
  p_j (t) = (lambda t)^j / j! e^(- lambda t)
$)<eq_0508_poisson_process_transition_probabilities>

We can recognize the expression in @eq_0508_poisson_process_transition_probabilities as a Poisson random variable distribution, which makes sense, since we are computing the following probability:

#math.equation(block: true, numbering: none,
$
  p_(0 j) = prob(N(t) = j | N(0) = 0)
$)

In the end we obtain that $N(t) ~ "Pois"(lambda t)$ for any time $t$ considered; and, by homogeneity:

#math.equation(block: true,
$
  prob(N(t) = j | N(0) = 0) &= prob(N(s + t) = j | N(s) = 0) \
  &= prob(N(s+t) = j + i | N(s) = i)
$)<eq_0509_indipendent_poisson_incrments>

The last equality in @eq_0509_indipendent_poisson_incrments comes from the fact, as we will later see, that the *increments are independent* of the previous state. We are going to better see this in the next chapter, where we present the three equivalent definitions of a Poisson process.

== Holding Times - Conditional Transition Matrix
Suppose we have a stochastic process, more precisely an homogeneous continuous time Markov chain, at that such process process is in state $i$ at a certain time $s$: $X(s) = i$. We can define $U_i$ as follows:

#math.equation(block: true,
$
  U_i = "inf"{t > 0 : X(s+t) != i}
$)<eq_0510_holding_time_definition>

is the time the process $X$ stays in state $i$ before jumpnig outside. We will see it later, but in case the process is a Poisson this is a random variable sampled from an exponential distribution with parameter $lambda$. If we generalize this concept to a general HCTMC we will get:

#math.equation(block: true, numbering: none,
$
  U_i ~ "Exp"(-g_(i i))
$)

Let's now assume we know the exact time $u_i$ at which the process leaves state $i$. Let's now study the following probability:

#math.equation(block: true, numbering: none,
$
  prob(X(s + u_i) = j | U_i = u_i"," X(s) = i), j != i
$)

that is, the probability of jumping from state $i$ to state $j$ in exactly time $u_i$. This can be approximated as follows (given a sufficiently small $h$):

#math.equation(block: true, numbering: none,
$
  prob(X(s + u_i) = j | U_i = u_i"," X(s) = i) approx (p_(i j)(h)) / (1 - p_(i i)(h))
$)

where the left hand side of the equation is the _probability_ of ending up in state $j$ knowing that the process moves out of $i$ at time $u_i$, and the right end side of the equation is obtained by unfolding the conditional probability rule $P(A | B) = P(A inter B) / P(B)$: $p_(i j)$ is exactly the probability of going out of $i$ and specifically in state $j$, the denominator is the probability of going in any other state different from $i$. let's now consider the limit of this equation for $h arrow 0$:

#math.equation(block: true, numbering: none,
$
  lim_(h arrow.b 0) (p_(i j)(h)) / (1 - p_(i i)(h)) = (g_(i j) h) /( 1 - (1 + g_(i i) h)) =  - (g_(i j)) /  g_(i i)
$)

where we obtained the first equality by pluggin in the limit the expressions for $p_(i j)$ and $p_(i i)$ in terms of the infinitesimal generator (@eq_050401_transitionprobs_as_transitionrates). This value is called *conditional transition probability* where conditional stands to indicate that we are not keeping in consideration time, in fact we are studying the process at the precise time in which the jump occurs. By arranging all these values form we obtain a *conditional transition matrix* $tilde(P)$, with entries $tilde(p_(i j))$ where: 

#math.equation(block: true,
$
  tilde(p_(i j)) = - (g_(i j)) / g_(i i) = prob(#text[ jumping from $i$ to $j$ ] | #text[ jumping happens ])
$)<eq_0511_conditional_transition_probabilities>

#example-box("Conditional Transition Probability for Poisson Processes")[
  Even though we still have to talk in detail about Poisson process it is worth noticing that in a Poisson process the value for the infinitesimal transition rate can only assume two possible values: 
  
  #math.equation(block: true, numbering: none,
  $
    g_(i j) = cases(
      lambda quad "if" j = i+1, 
      0 quad "otherwise"
    )
  $)
  
  this makes sense, in fact in a Poisson process, which is a counting process, we can only talk about increasing the number of occurred rare events by one. Suppose that now we know that after some time $u_i$ we are jumping out of state $i$. Let's plug the above information into @eq_0511_conditional_transition_probabilities and observe the result: 
  
  #math.equation(block: true, numbering: none,
  $
    prob(X(s + u_i) = j | X(s) = i) = cases(
      - lambda/lambda &= 1 quad &" if " j = i+1,
      &0 quad &i" otherwise "
    )
  $)
]
