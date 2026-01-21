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

  + for any $t, s geq 0$ the increment $N(t+s) - N(s)$ is a Poisson random variable with parameter $lambda t$: $N(t+s) - N(t) ~ "Pois"(lambda t)$.
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


== Properties of Poisson Processes
Now that we have proved the equality of the three definitions we can introduce some of their properties. First of all we have seen how Poisson processes are particular cases of a HCTMC characterized by transition probabilities in the form

#math.equation(block: true, numbering: none,
$
  p_(m, n+m)(t) = prob(N(t+h) = n + m |N(h) = m)
$)

satisfying the following condition:

#math.equation(block: true, numbering: none,
$
  p_(m, n+m)(t) = cases(
    1 - lambda h + cal(o)(t) quad &"if" n = 0,
    lambda h + cal(o)(t) quad &"if" n = 1,
    cal(o)(t) quad &"if" n > 1,
  )
$)

We have also shown that the following equation is true:

#math.equation(block: true, numbering: none,
$
  p_(m, n+m)(t) &= prob(N(t+h) = n + m | N(h) = m) \
  &= prob(N(t) = n | N(0) = 0) = prob(N(t) = n)
$)

This is very useful, since we have a very practical tool to compute the last probability value, since $N(t) ~ "Pois"(lambda t)$.

The process can, alternatively, be characterized by the *holding times*, also called _inter-arrival times_, $X_i limits(~)^"i.i.d." "Exp"(lambda)$. This results in arrival times given by the following equation:

#math.equation(block: true, numbering: none,
$
  T_n = sum_(i = 1)^n X_i ~ "Gamma"(n, lambda)
$)

which is not surprising, since a sum of i.i.d. exponentially distributed random variables with the same parameter $lambda$ can be modeled by means of a _Gamma distribution_ (see @th_0301_additivity_exponential).

We are now ready to introduce two fundamental properties about Poisson processes: superposition and thinning.

=== Superposition
This first property will empower us with the possibility of combining two Poisson processes into one, similarly to what we did when we were summing up independent Poisson random variables. (see @th_0302_additivity_poisson_rv).

The proof of why this property is valid is left as an exercise but we encourage the reader to try it out.

#theorem(title: "Superposition of Poisson Process")[
  Let $N_1 = {N_1(t) : t>=0}$ and $N_2: {N_2(t) : t>= 0}$ be two _independent Poisson processes_, with intensities $lambda_1, lambda_2$ respectively. Then, the process $N = {N(t) : t>=0}$ given by $N(t) = N_1(t) + N_2(t)$ is also a Poisson process with intensity $lambda = lambda_1 + lambda_2$.
]<th_0601_superposition>

The result can actually be extended to a sum of a countable number of poisson processes:

#math.equation(block: true, numbering: none,
$
  N_i limits(~)^perp "PP"(lambda_i) quad ==> quad N = sum_(i = 1)^k N_i ~ "PP"(sum_(i=1)^k lambda_i)
$)

Actually, it also possible to extend this to an uncountable sum of independent Poisson processes, provided the sum of the rates is finite.

#figure(
  image("/assets/0606_superposition_visualization.png", width: 60%),
  caption: [Visualization of the *superposition property* for Poisson processes]
)<fig_0603_superposition>

=== Thinning or Splitting
The following property is kind of the opposite compared to the previously introduced superposition. It will empower us with the possibility to extract more specific Poisson processes from a more general one.

#theorem(title: "Thinning")[
  Let $N = {N(t) : t >= 0}$ be a Poisson process with intensity $lambda$ and let $tilde(N) = {tilde(N)(t) : t >= 0}$ be the process obtained by retaining each arrival event with probability $p$ and discarding it with probability $1 - p$. Then $tilde(N) ~ "PP"(lambda p)$. Furthermore, the process $M: {M(t) : t >= 0}$ formed by the discarded arrivals, i.e., $M(t) = N(t) - tilde(N)(t)$ for all $t >= 0$, is also a Poisson process with intensity $lambda(1 - p)$ and independent of $tilde(N)$.
]<th_0602_thinning>

This theorem may seem a little more involved than the previous one about superposition, let's try to visualize it.

#figure(
  image("/assets/0607_splitting_visualization.png", width: 60%),
  caption: [Visualization of the *thinning property* for a Poisson process]
)

This result can be extended to a countable number of thinned processes, i.e.,

#math.equation(block: true, numbering: none,
$
  tilde(N_i) limits(~)^perp "PP"(lambda p_i), quad "for" p_i > 0, sum_(i=1)^k p_i = 1
$)

provided each arrival of the original process $N$ is assigned, independently to a single process $tilde(N_i)$ with probability $p_i$.

=== Mean and Covariance functions
We have seen that the marginal distributions of the Poisson process are Poisson, i.e.,

#math.equation(block: true, numbering: none,
$
  N ~ "PP"(lambda) quad ==> quad N(t) ~ "Pois"(lambda t)
$)

So clearly, the Poisson process cannot be *stationary*:

- $mu_N(t) = exp(N(t)) = lambda t$ which depends on $t$ and is not a constant value as we would expect in case of a stationary process

- $sigma^2_N (t) = var(N(t)) = lambda t$ which, again, depends on $t$

This method to prove _non stationarity_ may appear surprising if we think about @def_0505_stationary_distribution, but if we think about it, in the definition we asked the process to converge to a certain, fixed, distribution in the long run, which directly implies obtaining a mean and a variance which are constant. Also we can notice that for the mean not to be constant is in disagree with @def_0404_weakstationarity, where we required for the mean to be constant.

We can also compute the covariance function for the process. For $s > t$:

#math.equation(block: true, numbering: none,
$
  sigma_N (t, s) &= cov(N(t), N(s)) = cov(N(t), N(t)+ N(s) - N(t)) \
  &= cov(N(t), N(t)) + cov(N(t), N(s) - N(t)) = var(N(t)) + 0 = lambda(t)
$)

By a similar argument, for $s < t$, $sigma_N (t, s) = lambda s$. So, in general we have that:

#math.equation(block: true,
$
  sigma_N (t, s) = lambda min{t, s}
$)<eq_0604_poisson_covariance_function>

== Some Examples

#example-box("Carlton-Devoir 7.25")[
  Database queries to a certain data warehouse occur randomly throughout the day. On average, 0.8 queries arrive per second during regular business hours. Assume a Poisson process model is applicable here.

  _What is the probability of exactly 1 query in the first second and exactly 2 queries in the four seconds thereafter?_

  Let $N(t)$ denote the number of queries in the first $t$ seconds. Then $N ~ "PP"(0.8)$ and $N(1), N(5) - N(1)$ are independent Poisson random variables. We can thus compute the probability of the joint event by multiplying individual marginal probabilities.

  To do so we can notice that $N(1)$ che be written as $N(1) - N(0)$ and that we are left with two independent increments (@def_0604_PoissonProcess_2 [2]), we still need to compute the *marginals* to be multiplied, but this is easily computed by condition [3] of @def_0604_PoissonProcess_2:

  #math.equation(block: true, numbering: none,
  $
    prob(N(1) = 1"," N(5) - N(1) = 2) &= prob(N(1) = 1) prob(N(5) - N(1) = 2) \
    &= (e^(-0.8)0.8)/1! space (e^(-0.8 * 4) (0.8 dot 4)^2)/2! = 0.075
  $)

  _What is the probability of exactly 1 query in the first second and exactly 2 queries in the first 5 seconds?_

  This time, time intervals are *not disjoint*, so we need to condition in order to find the required probability.

  #math.equation(block: true, numbering: none,
  $
    prob(N(5) = 2"," N(1) = 1) &= prob(N(5) = 2 | N(1) = 1)prob(N(1) = 1) \
    &= prob(N(1) = 1) prob(N(5) - N(1) = 1) \
    &= (e^(-0.8) 0.8)/1! space (e^(-3.2) 3.2^1)/1! = 0.0469
  $)
]

Notice how, in the last part of the previous example, the intervals $[0, 1], [0,5]$ are _overlapping_, the variables $N(1)$ and $N(5)$ are *correlated* with $sigma_N(1,5) = 0.8 min{1, 5} = 0.8$. As one might expect the covariance is positive, since an increase in $N(1)$ is clearly related to an increase in $N(5)$.

#example-box("Carlton-Devoir 7.27")[
  Two roads feed into the northbound lanes on the Anderson Street Bridge. During rush hour, the number of vehicles arriving from the first road can be modeled by a Poisson process with a rate parameter of 10 per minute, while arrivals from the second read form an independent Poisson process with rate 8 cars per minute.

  _What is the probability that a total of more than 100 vehicles will arrive at the two feeder roads in the first 5 minutes of rush hour?_

  To solve this question we can address @th_0601_superposition: we have two independent processes with different rate parameters, $N_1 ~ "PP"(10), N_2 ~ "PP"(8)$. The resulting Poisson process is going to be $N ~ "PP"(18)$. Now we can use @def_0604_PoissonProcess_2 [3] to see that the increment $N(4) - N(0) ~ "Pois"(lambda t) => N(4) - N(0) ~ "Pois"(18 * 5)$:

  #math.equation(block: true, numbering: none,
  $
    prob(N(5) > 100) = 1 - prob(N(5) <= 100) = 1 - "ppois"(100, 5 * 18) = 0.11349
  $)
]

#example-box("Carlton-Devoir 7.28")[
  At a certain large hospital, patients enter the emergency room at a mean rate of 15 per hour. Suppose 20% of patients arrive in critical condition, i.e., they require immediate treatment. Assume patient arrivals meet the conditions of a Poisson process.

  _What is the probability that more than 50 patients arrive in the next 4 hours?_

  Similarly to what we did in the previous examples, we have a process $N ~ "PP"(15)$, we need to compute:

  #math.equation(block: true, numbering: none,
  $
    prob(N(4) > 50) = 1 - prob(N(4) <= 50) = "ppois"(50, 15*4) = 0.89232
  $)

  _What is the probability that more than 10 critical patients arrive in the next 4 hours?_

  To address this question we need to use the *thinning property* (see @th_0602_thinning), by means of which we can model a thinned process representing the sole critical patients in the following way:

  #math.equation(block: true, numbering: none,
  $
    N^* ~ "PP"(15 * 0.4) ==> N^* ~ "PP"(3)
  $)

  Thus we can apply a reasoning similar to the previous:

  #math.equation(block: true, numbering: none,
  $
    prob(N^*(4) > 10) = 1 - prob(N^*(4) <= 10) = 1 - "ppois"(10, 3*4) = 0.6528
  $)

  _What is the probability that more that 10 critical patients and more than 40 non critical patients arrive in the next 4 hours?_

  We can notice that, by the thinning property, we can model the process of non-critical patients as $tilde(N) ~ "PP"(lambda (1 - "P"_"critical")) ==> tilde(N) ~ "PP"(lambda dot 0.8)$. We can also notice that $N^*$ and $tilde(N)$ are two independent processes thus we can multiply the marginal probabilities to obtain the required probability:

  #math.equation(block: true, numbering: none,
  $
    prob(N^*(4) > 10"," tilde(N)(4) > 40) &= prob(N^*(4) > 10) * prob(tilde(N)(4) > 40) \
    &= [1 - prob(N^*(4) <= 10)] * [1 - prob(tilde(N)(4) <= 40)] \
    &= [1 - "ppois"(10, 3*4)] * [1 - "ppois"(40, 12*4)] \
    &= 0.6528 * 0.8617 = 0.5626
  $)
]

#example-box("Carlton-Devoir 7.26")[
  Consider again the database queries described in the first example, i.e., $N ~ "PP"(0.8)$, where $N(t)$ denotes the number of queries in the first $t$ seconds. 
  
  _What is the *expected* waiting time, from the beginning of regular business hours, until the arrival of the 50th query?_
  
  Let $T_(50)$ denote the time to the 50-th query from the beginning of regular business hours. We know that the time between each process state change is exponential, we'd like to model the expected sum of these exponential variables, which we know can be done with a *Gamma distribution* with shape parameter $alpha = 50$ and $lambda = 0.8$: $T_50 ~ "Gamma"(50, 0.8)$. 
  
  We are now required to provide the expected time, so we can simply answer with the expected value for a Gamma distributed random variable: 
  
  #math.equation(block: true, numbering: none,
  $
    exp(T_50) = alpha / lambda = 50 / 0.8 = 62.5
  $)
  
  _If 50 or more queries arrive in the first minute, system users will experience a significant backlog in subsequent minutes because of processing time. What is the probability that this happens?_
  
  A backlog occurs if $T_50$, that is, the time needed for more than 50 queries to arrive, is less than or equal than 60 seconds. Thus we can compute the probability of a backlog as follows: 
  
  #math.equation(block: true, numbering: none,
  $
    prob(T_50 <= 60) = "pgamma"(60, 60, 0.8) = 0.4054
  $)
  
  Alternatively we can notice that a backlog occurs if the number of queries in the first 60 seconds is 50 or more, so the same probability can be retrieved as follows: 
  
  #math.equation(block: true, numbering: none,
  $
    prob(N(60) >= 50) = 1 - "ppois"(49, 60*0.8) = 0.4054
  $)
]

With this final example, we conclude the material covered in this course. I hope you found the journey both engaging and insightful!