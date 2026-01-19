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

= Poisson Processes
In the previous chapter we have introduced standard homogeneous continuous time Markov chains, focusin in the last part on birth and death processes. We have also mentinoed throughout the whole previous chapter how Poisson processes are homogeneous continuous time Markov chains and how they can be seen as special cases of birth processes.

In this chapter we are going to focus on Poisson processes, specifically we are going to see how there are three possible ways to define a Poisson process, trying to give an idea of how to prove this relationship.

For starting out, let's recall the Landau notation, which is going to appear frequently throughout this chapter.

#definition(title: "Landau Notation")[
  Consider a continuous variable $x in RR$ tending to some limit $x_0 in RR$. Consider now two functions, $f(x)$ and $g(x) > 0$. The *Landau symbols*, commonly known as _big - O_ and _little - O_ are defined as follows:

  - $f(x) = cal(O)(g(x)) <==> |f(x)| < M g(x)$ for some constant $M$ and all values of $x$

  - $f(x) = cal(o)(g(x)) <==> limits(lim)_ (x -> x_0) (f(x) \/ g(x)) = 0$
]

We will specifically be interested in the case in which $x_0 = 0$ and $g(x) = $, so that we will interpret $f(x) = cal(o)(x)$ as "_$f$ goes to zero faster than $x$_".

#remark[
  Notice that in case we have $f_1 (x) = cal(o)(x)$ and $f_2(x) = cal(o)(x)$, then their sum $f_1 (x) + f_2 (x) = cal(o)(x)$, so we'll informally write $cal(o)(x) + cal(o)(x) = cal(o)(x)$, which also holds for infinitely countable sums.
]

We can now introduce the first very important definition for us to deal with, which is the one of a *counting process*.

#definition(title: "Counting Process")[
  A stochastic process $X(t)$ is called a *counting process* if the following conditions hold:

  + $X(t) in NN$ for all $t in cal(T) subset RR$, the time domain: _discrete sample space_
  + $X(s) leq X(t)$ for all $s leq t$, meaning that counts can only increase over time
]<def_0602_counting_process>


#remark[
  Not all counting process are CTMC's but we will focus our attention on those which are.
]

In the following sections we are going to provide three Poisson processes' equivalent definitions. In the next sections we are then going to show intuitively why the definitions are equivalent.

== Poisson Process - Definitions

#definition(title: "Poisson Process (1)")[
  A *Poisson process* with intensity $lambda$ is a continuous time counting process $N = {N(t): t geq 0}$ which satisfies the following three conditions:

  + $N(0) = 0$, that is, the counting always starts from 0

  + the *increments* are *independent* and *stationary*, that is, the distribution of $N(t+h) - N(t)$ depends only on $h$

  + $prob(N(h)=1) = lambda h + cal(o)(h); prob(N(h) >= 2) = cal(o)(h)$ for small $h > 0$
]<def_0603_PoissonProcess_1>


To clarify condition 2 of @def_0603_PoissonProcess_1, remember that for a process to be _strongly stationary_ it is necessary that its finite dimensional distributions are invariant w.r.t. time shifts. This means that the following distributions are equivalent:

- $X_t$ and $X_(t + h)$ are equal in distribution for all $t, h geq 0$;

- if $(X_t, X_s)$ are equal, also $X_(t+n), X_(s+n)$ are equal

- if $(X_t, X_s, X_u)$ are equals, also $(X_(t+h), X_(s+h), X_(u+h))$ are equal

The third condition already allows us to provide some "approximated" transition probabilities for this very important process. We will later see how it is possible to compute closed form equations. @fig_0601_strongstationarity_increments shows in a graphical way what it means for increments to be independent and stationary.

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
)<fig_0601_strongstationarity_increments>

#remark[
  According to the third condition of the definition, we can notice the following:

  #math.equation(block: true, numbering: none,
  $
  prob(N(h) = 0 | N(0) = 0) = 1 - lambda h + cal(o)(h)
  $)

  that is, the probability for the process to remain in the same state after a small amount of time $h$ is obtained by subtracting to the total probability 1 the probability of the elements presented in condition (3).
]

#definition(title: "Poisson Process (2)")[
  A *Poisson process* with intensity $lambda$ is continuous-time counting process $N = {N(t): t geq 0}$ which satisfies the following properties:

  + $N(0) = 0$, similarly to the previous definition, we require for the starting state of the process to be 0

  + for any pair of disjoint intervals, $(s_1, s_1 + t_1]$ and $(s_2, s_2 + t_2]$ the *increments* $N(s_1 + t_1) - N(s_1)$ and $N_(s_2 + t_2) - N_(s_2)$ are *independent*

  + for any $t, s geq 0$ the increment $N(t+s) - N(t)$ is a Poisson random variable with parameter $lambda t$: $N(t+s) - N(t) ~ "Pois"(lambda t)$.
]<def_0604_PoissonProcess_2>

#definition(title: "Poisson Process (3)")[
  A *Poisson process* with intensity $lambda$ is a continuous-time counting process $N = {N(t): t geq 0}$ that satisfies the following properties:

  + $N(0) = 0$, again we require for the starting point of the process to be 0

  + let $T_0 = 0$ and $T_n = inf{t : N(t) = n}$ be the $n$-th arrival time, i.e., the time at which the process jumps from state $n-1$ to state $n$, for $n = 1, 2, ...$. The inter-arrival times $X_n = T_n - T_(n - 1)$ are independent and identically distributed exponential random variables with rate $lambda$.
]<def_0605_PoissonProcess_3>


== Proof of Equivalence
In this section we are going to prove the equivalence for the previously introduced definition of a Poisson process. We are actually going to prove the following chain of implications:

#math.equation(block: true, numbering: none,
$
  #text[@def_0603_PoissonProcess_1] ==> #text[@def_0604_PoissonProcess_2] ==> #text[@def_0605_PoissonProcess_3] ==> #text[@def_0603_PoissonProcess_1]
$)

which is going to grant us equality of those definitions.

=== @def_0603_PoissonProcess_1 $=>$ @def_0604_PoissonProcess_2
To understand why the first definition implies the second one, we can notice that the first condition in both definitions is actually the same, and that the first condition of @def_0603_PoissonProcess_1 is a stricter condition w.r.t. the second of @def_0604_PoissonProcess_2, this means the implication holds for them.

Let's now focus on the third. We can see how the third condition of @def_0603_PoissonProcess_1 provides a _first order approximation_ for the _transition semi-group_ of a Poisson process $N ~ "PP"(lambda)$:

#math.equation(block: true,
$
  P_t = mat(
    1 - lambda t + cal(o)(t), lambda t + cal(o)(t), cal(o)(t), cal(o)(t), ...;

    0, 1 - lambda t + cal(o)(t), lambda t + cal(o)(t), cal(o)(t), ...;

    0, 0, 1 - lambda t + cal(o)(t), lambda t + cal(o)(t), ...;

    dots.v, dots.v, dots.v, dots.down;
  )
$)<eq_0601_approximated_poisson_transition_semigroup>

This is actually already quite useful, as it provides direct information about the generator of the process:

#math.equation(block: true, numbering: none,
$
  G = P'_0 = lim_(h arrow.b 0) (P_(0 + h) - P_0) / h = lim_(h arrow.b 0) (P_h - "I")/h
$)

or, if we only want to focus on the single elements of the generator, we can compute them as follows:

#math.equation(block: true, numbering: none,
$
  g_(i i) = lim_(h arrow.b 0) (1 - lambda h + cal(o)(h) - 1)/h = - lambda, quad forall i in cal(S) \

  g_(i i+1) = lim_(h arrow.b 0) (lambda h + cal(o)(h))/h = lambda, quad forall i in cal(S) \

  g_(i j) = lim_(h arrow.b 0) cal(o)(h) / h = 0 quad forall j >= i + 1
$)

Which lead to the following form for the infinitesimal generator:

#math.equation(block: true,
$
G = mat(
  -lambda, lambda, 0, 0, 0, ...;
  0, -lambda, lambda, 0, 0, ...;
  0, 0, -lambda, lambda, 0, ...;
  dots.v, dots.v, dots.v, dots.v, dots.down;
)
$)<eq_0602_poissonprocess_generator>

At this point, we can use the forward-backward equations in @eq_0506_forward_eq, @eq_0507_backward_eq to obtain a closed form expression for the transition semigroup: $P'_t = P_t dot G$. Since the state-space is infinite, we cannot directly compute directly the following matrix exponential:

#math.equation(block: true, numbering: none,
$
  P_t = e^(t space G)
$)

but we can simplify the problem, solving it in a _recursive_ fashion. From the first condition we can recall that $N(0) = 1$, so

#math.equation(block: true, numbering: none,
$
  p_(0 j) = prob(N(t) = j | N(0) = 0) = prob(N(t) = j) = pi^((t))_j
$)

In particular, for all $i greater 0$ we end up in one of the following situations:

- if $j less i$ then $p_(i j)(t) = 0$, this is because we are dealing with a counting process, and in the future it is not allowed to have a quantity which is lower than the previous

- if $j geq i$ we can use the stationarity of the increments of condition (2) to derive the following equation for the transition probability:

  #math.equation(block: true, numbering: none,
  $
    p_(i j)(t) = prob(N(t) = j | N(0) = i) = prob(N(t) = j - i | N(0) = 0) = pi^((t))_(j-i)
  $)

Therefore, we only need to find $p_(0 j)(t) = pi^((t))_j$ by solving the following system of differential equations:

#math.equation(block: true, numbering: none,
$
  cases(
    p'_(0 0)(t) = - lambda p_(0 0)(t),
    p'_(0 j)(t) = lambda p_(0 space j-1)(t) - lambda p_(0 j)(t) quad j greater 0
  )
$)

with the following boundary condition (given by condition (1)):

#math.equation(block: true, numbering: none,
$
  p_(0 j) = pi^((t))_j = cases(1 quad "if" j = 0, 0 quad "otherwise")
$)

We can notice that the reasoning applied to obtain this differential equation is identical to the one we have presented in the previous chapter. For further clearance it is strongly suggested to go and check out that section.

It is relatively easy to see that, for $j = 0$, we have $p_(0 0)(t) = e^(- lambda t)$ and, substituting this in the equation for $j = 1$ we obtain $p'_(0 1) = lambda e^(- lambda t) - lambda p_(0 1)(t)$. Once again we can solve this and obtain the solution, which is $p_(0 1)(t) = lambda t e^(- lambda t)$. Now we can substitute in the differential equation for $j = 2$ and so on so forth. We will notice a pattern, which leads us to provide a *general solution*:

#math.equation(block: true,
$
  pi^((t))_j = p_(0 j)(t) = (lambda t)^j / j! e^(-lambda t) quad quad forall t geq 0, j = 0, 1, 2, ...
$)<eq_0603_poisson_transition_probabilities_closed_form>

We can notice that in @eq_0603_poisson_transition_probabilities_closed_form we have the _probability mass function_ of a Poisson random variable with rate parameter $lambda t$; and, by the stationarity of the increments, we can finally derive condition (3) of @def_0604_PoissonProcess_2:

#math.equation(block: true, numbering: none,
$
  prob(N(0 + t) = i | N(0) = 0) = prob(N(t + h) = i + j | N(t) = i) = pi^((t))_(i + j) \
  ==> N(t+h) - N(h) ~ "Pois"(lambda t)
$)

In particular, if $N ~ "PP"(lambda)$, the unit-time increment $N(h+1) - N(h)$ has a Poisson distribution with rate $lambda$ #sym.qed

=== @def_0604_PoissonProcess_2 $=>$ @def_0605_PoissonProcess_3
Again, similarly to the previous proof, we have that condition (1) coincides for @def_0604_PoissonProcess_2 and @def_0605_PoissonProcess_3.

@def_0605_PoissonProcess_3 introduces the sequence of random variables $T_0, T_1, ...$ given by:

#math.equation(block: true, numbering: none,
$
  T_0 = 0, quad quad T_n = inf{t : N(t) = n}
$)

this is called the *sequence of arrival times*, since $T_n$ represents the time of the $n$-th arrival.

Another important sequence introduced by @def_0605_PoissonProcess_3 is the *sequence of inter-arrival times* $X_1, X_2, ...$ given by:

#math.equation(block: true, numbering: none,
$
  X_n = T_n - T_(n-1)
$)

To better understand this, let's visualize a typical path of a Poisson process in the interval $[0, t]$:

#figure(
  image("/assets/0605_typcal_poisson_process_path.png", width: 80%),
  caption: [Typical path of a Poisson process in the interval $[0,t]$]
)

If we want the inter-arrival times to be i.i.d. exponential random variables with parameter $lambda$ it is necessary that the "unit-increments" follow a Poisson distribution with parameter $lambda$, and vice-versa. Thus it is true that @def_0604_PoissonProcess_2 implies @def_0605_PoissonProcess_3 #sym.qed

=== @def_0605_PoissonProcess_3 $=>$ @def_0603_PoissonProcess_1
To prove this implication it is necessary to prove that, given a sequence of i.i.d. exponentially distributed inter-arrival times, the process $N$ defined by:

#math.equation(block: true, numbering: none,
$
  N(t) = max{n : T_n leq t} quad "for" T_n = sum_(i = 1)^n X_i
$)

is a Poisson process with parameter $lambda$. It's clear that even understanding what we need to prove is not trivial, let's try to understand why $N(t) = max{n : T_n leq t}$ what we are looking for. Let's suppose we have a process which started from state 0, then after some time $t_1$ reached state 1, and after some other time $t_2$ reached state 2. Let's try to build the process $N(t)$ from the definition above:

- at time $t leq t_1$ the state is going to be $N(t) = 0$, since there is no value $T_n$ such that $T_n leq t$, meaning that nothing has changed in the original process, so it makes sense to keep the count stuck to the initial value 0

- at time $t_1 leq t leq t_2$ the state is going to be $N(t) = 1$, in fact, the maximum value of the sequence $T_n$ which is less than or equal to $t$ is exactly $T_1$

- a similar rational is to be applied for any other state of the process $N(t)$ with $t greater 1$


#remark[
  We can notice the following very useful important fact:
#math.equation(block: true, numbering: none,
$
  N(t) geq n quad <==> quad T_n leq t
$)

To understand why, it is sufficient to look at the above bullet list where we explain why it makes sense to consider a process $N(t)$ defined in that strange way.
]

We can now apply the law of total probability and find out the following:

#math.equation(block: true, numbering: none,
$
  prob(N(t) = 1) = prob(T_1 leq t leq T_2) = prob(X_1 leq t leq X_1 + X_2) \
  = integral_0^oo prob(X_1 leq t leq X_1 + X_2 | X_1 = s) prob(X_1 = s) space d s  quad (1)\
  = integral_0^oo prob(X_1 leq t leq X_1 + X_2 | X_1 = s) lambda e^(-lambda s) space d s quad (2) \
  = lambda integral_0^t prob(X_2 greater t-s) space e^(- lambda s) space d s = lambda integral_0^t  e^(-lambda(t - s)) space e^(-lambda s) space d s quad (3) \
  = lambda integral_0^t e^(- lambda t) space d s = lambda [s e^(-lambda t)]_0^t = lambda t e^(- lambda t)
  
$)

where we have obtained equation (1) by applying the law of total probability for continuous function; after this we have obtained equation (2) by simply plugging into the marginal probability the p.d.f. for exponential random variables. Looking to equation (3) we can notice it can be obtained by noticing that $prob(X_2 greater t - s)$ is already conveying what we are actually looking for in (2). The second equation in (3) is obtained by plugging in the survival function for exponential random variables. 

#remark[
  Notice how in (3) we have been able to switch the integration interval from $(o, oo)$ to $(o, t)$. The reason is quite straightforward (even though I had to ask my girlfriend): if we consider a value of $s$ which is greater than $t$ we end up computing the probability of $X_2 greater a, space a in NN^-$, which is trivial and non-meaningful. 
]

We can also notice how the final result can be rewritten in the following manner: 
#math.equation(block: true, numbering: none,
$
  lambda t e^(- lambda t) = lambda t + lambda t(e^(- lambda t) - 1)
$)

Having rewritten this value in such a way is very convenient because we can notice the following two facts: 

#math.equation(block: true, numbering: none,
$
  lambda t(e^(-lambda t) - 1) arrow 0 " and " (lambda t (e^(-lambda t) - 1)) / t arrow 0 quad " as " t arrow.b 0
$)

So we have proven that is $prob(N(t) = 1) = lambda t + cal(o)(t)$. For $prob(N(t) geq 2)$ we proceed in a similar fashion: 

#math.equation(block: true, numbering: none,
$
  prob(N(t) geq 2) &= prob(T_2 leq t) = prob(X_1 + X_2 leq t) \
  &= integral_0^oo prob(X_1 + X_2 leq t | X_s = s)lambda e^(-lambda t) space d s \
  &= lambda integral_0^t prob(X_2 leq t - s) e^(-lambda t) space d s = lambda integral_0^t (1 - e^(-lambda(t - s)))e^(- lambda s) space d s quad  (1) \
  &= lambda integral_0^t (e^(-lambda s) - e^(- lambda t) space d s = 1 - e^(-lambda t) -lambda t e^(- lambda t)
$)

where at the line of equality (1) we switched from the left to the right side by noticing the $integral prob(X_2 leq t - s)$ is exactly the formulation of the cumulative distribution function. 

Now, similarly to what we did before, we can notice the following facts: 

#math.equation(block: true, numbering: none,
$
  1 - e^(-lambda t) - lambda t e^(-lambda t) arrow 0 quad " and " quad (1 - e^(- lambda t) - lambda t e^(-lambda t))/t arrow 0 quad quad "as" t arrow.b 0
$)

thus we can conclude that $prob(N(t) geq 2) = 1 - e^-lambda t -lambda t e^(-lambda t) = cal(o)(t)$. 

Finally we get that $prob(N(t) = 0) = 1 - prob(N(t) = 1) -prob(N(t) geq 2) = 1 - lambda t + cal(o)(t)$, so we can safely conclude that @def_0605_PoissonProcess_3 implies @def_0603_PoissonProcess_1 #sym.qed

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
