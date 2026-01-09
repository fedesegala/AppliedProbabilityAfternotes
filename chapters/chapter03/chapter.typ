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

= Common Random Variable Distributions
In the last chapters we introduced the concept of random variables, and how to compute important quantities such as the expectation, variance and other important characteristics for those random variables, such as their c.d.f and p.d.f.

Even though from a theoretical point of view that is enough to compute everything we need about a random variable, in practice it is useful to that there are some random variables that behave in a very specific way and that we can use as building blocks to model more complex phenomena.
In this chapter we will introduce some of the most common *families* of *random variables*, that is, groups of random variables that share some common characteristics and that can be used to model specific types of phenomena.

== Bernoulli and Binomial Distributions
The simplest random variable distribution we can think about is the *Bernoulli distribution*.

#definition(title: "Bernoulli Distribution")[
  A random variable with two possible outcomes, 0 and 1 (usually representing _failure_ and _success_ respectively), is called a *Bernoulli random variable*, its distribution is a *Bernoulli distribution* and any experiment with a _binary outcome_ is a Bernoulli *trial*.

  The *sample space* of the random variable is given by $Omega_X = {0,1}$. The distribution is modeled by a _single parameter_ $p$ which represents the _probability of success_ for the trial. Therefore the probability of a failure is $1 - p$.
]

===== Probability Mass Function
Let $X$ be a Bernoulli random variable with parameter $p$. The probability mass function (p.m.f.) of $X$ is defined as follows:

#math.equation(
  block: true,
  $
    p_X (x) = cases(
      q = 1 - p space space & "if" space x = 0,
      p & "if" space x = 1
    )
  $,
)<eq_1_bernoulli_pmf>

===== Expected Value and Variance
Let $X$ be a Bernoulli random variable with parameter $p$. Considering its probability mass function in @eq_1_bernoulli_pmf, we can compute its expected value.

#math.equation(
  block: true,
  $
    exp(X) = limits(sum)_(x in Omega_X) x dot p_X (X) = 0dot (1 - p) + 1 dot (p) = p
  $,
)<eq_2_bernoulli_expectation>

Given the expected value compute previously, we can also plug it into @eq:variance_random_variable_expanded to compute the variance of a Bernoulli random variable.

#math.equation(
  block: true,
  $
    var(X) = exp(X^2) - exp(X)^2 = p - p^2 = p(1 - p)
  $,
)<eq_3_bernoulli_variance>

Now that we have defined all the important characteristics of a Bernoulli random variable, we can try to use is to model some more complex experiment. Suppose for example that we want to *replicate* a Bernoulli trial multiple times, say $n$ and each of those trials is independent, this is how we get a *Binomial distribution*.

#definition(title: "Binomial Distribution")[
  A variable described as the number of successes $Y$ in a sequence of independent Bernoulli trials $X_i limits(~)^("i.i.d.") "Ber"(p)$, has *binomial distribution*. Its parameters are $n$, the number of trials, and $p$, the probability of success in each trial.
]

Given $n$ independent Bernoulli trials $X_i limits(~)^("i.i.d.") "Ber"(p)$, we can define the random variable $Y$ as the number of successes in those trials as $Y = limits(sum)_(i=1)^n X_i$.

===== Probability Mass Function
Let $X$ be a Binomial random variable with parameters $n$ and $p$. The probability mass function (p.m.f.) of $X$ is defined as follows:

#math.equation(
  block: true,
  $
    p_X (x) = binom(n, x) space p^x space (1 - p)^(n - x)
  $,
)<eq_4_binomial_pmf>

To get a better understanding of why the p.m.f. as defined as in @eq_4_binomial_pmf, we can think about the following:
- We need to have exactly $x$ successes, which happens with probability $p^x$.

- We need to have exactly $n - x$ failures, which happens with probability $(1 - p)^(n - x)$.

- The successes and failures can be arranged in any order, and there are $binom(n, x)$ ways to choose which $x$ trials are successes out of $n$ total trials.

===== Expected Value
The *expected value* of a Binomial random variable can be computed using the linearity of expectation as follows:

#math.equation(
  block: true,
  $
    exp(X) = exp(limits(sum)_(i=1)^n X_i) = limits(sum)_(i=1)^n exp(X_i) = n dot p
  $,
)<eq_5_binomial_expectation>

where we used the fact that each $X_i$ is a Bernoulli random variable with parameter $p$, therefore its expected value is $p$ as shown in @eq_2_bernoulli_expectation. As far as the *variance* is concerned, we can compute it in the following way:

#math.equation(
  block: true,
  $
    var(X) = var(limits(sum)_(i=1)^n X_i) = limits(sum)_(i=1)^n var(X_i) = n dot p dot (1 - p) = n p q
  $,
)<eq_6_binomial_variance>

Notice that we could use the fact that the $X_i$ are independent to compute the variance of their sum as the sum of their variances, as the last property of the last chapter states.

===== R Implementation
In R we have the following functions to work with Binomial random variables at our disposal:

- `dbinom(x, n, p)` $= prob(X = x)$, that is the probability mass function (p.m.f.).

- `pbinom(x, n, p)` $= prob(X <= x)$, that is the cumulative distribution function (c.d.f.).

- `qbinom(q, n, p)` $= x "if" prob(X <= x) = q$, that is the quantile function.

- `rbinom(r, n, p)` $= {x_1, x_2, ..., x_r}$, that is a vector of $r$ random samples drawn from the distribution.

#remark[
  All `R` functions that allow us to work with any common random variable distribution follow the same naming convention, where the first letter indicates the type of function (`d` for p.m.f./p.d.f., `p` for c.d.f., `q` for quantile function and `r` for random sampling), followed by the name of the distribution.
]

== Multinomial Distribution
After introducing the Bernoulli and Binomial distributions, we can now generalize those concepts to the *Multinomial distribution*. If the experiments we are modeling are binary there are only two possible outcomes and we can model a repetition of them by means of the binomial. In case the experiments have _more than two possible outcomes_, say $k$ we need to use the multinomial distribution.

#definition(title: "Multinomial Distribution")[
  A random variable described as the counts of each outcome in a sequence of independent trials with $k$ possible outcomes, has *multinomial distribution*. Its parameters are $n$, the number of trials, and $p_1, p_2, ..., p_k$, the probabilities of each outcome in each trial, such that $limits(sum)_(i=1)^k p_i = 1$.
]

===== Probability Mass Function
Let $X_i$ be the number of times outcome $i$ occurs in $n$ independent trials, each with $k$ possible outcomes. The random vector $(X_1, X_2, ..., X_k)$ has *joint multinomial distribution* with probability mass function (p.m.f.) defined as follows:

#math.equation(
  block: true,
  $
    prob(X_1 = x_1 space X_2 = x_2 space ... space X_k = x_k) = (n!)/(x_1 ! ... x_k !) space p_1^(x_1)space ... space p_k^(x_k)
  $,
)

where we implicitly have the constraints that $limits(sum)_(i=1)^k x_i = n$ and we have introduced the *multinomial coefficient* $(n!)/(x_1 ! ... x_k !)$ which counts the number of ways to arrange $n$ trials with $x_i$ occurrences of outcome $i$ for each $i$. Of course we also need to have that the values $x_i >= 0$.

It is always possible to transform a multinomial distribution into a bunch of binomial distributions by considering each outcome separately. To do so, we just need to focus on one of the $k$ outcomes at a time, where the success is getting that specific outcome, and the failure is getting any of the other $k - 1$ outcomes.

===== Expected Value, Variance and Covariance
By focusing solely on the outcome $i$, since the experiments are Bernoulli trials with success probability $p_i$, we can use the results we obtained for the Binomial distribution to compute the expected value and variance of the random variable $X_i$ as follows:

#math.equation(
  block: true,
  numbering: none,
  $
    exp(X_i) = p_1 quad quad quad var(X_i) = n dot p_i dot (1 - p_i)
  $,
)

Since we are dealing with a vector of random variables, we can also compute the *covariance* between any two random variables $X_i$ and $X_j$ with $i != j$ as follows:

#math.equation(
  block: true,
  $
    cov(X_i, X_j) = -n dot p_i dot p_j
  $,
)<eq_7_multinomial_covariance>

Intuitively this negative covariance makes sense, since if the count of outcome $i$ increases, the count of outcome $j$ must decrease, given that the total number of trials $n$ is fixed.

===== R Implementation
Since the multinomial distribution is a joint distribution over multiple random variables, in `R` we only have two functions to work with it:

- `dmultinom`: the joint probability density function (p.m.f.)
- `rmultinom`: the function to generate random samples from the distribution.

We don't have a specific function for the cumulative distribution function (c.d.f.) or the quantile function; they are indeed very hard to define and manage for joint distributions.

== Geometric Distribution
Another common random variable distribution is the *Geometric distribution*, it is again very much related to the Bernoulli distribution.

#definition(title: "Geometric Distribution")[
  A random variable that models the number of Bernoulli trials needed to get the first success, has *Geometric distribution*. Its parameter is $p$, the probability of success in each trial.
]

===== Probability Mass Function
Let $X$ be a Geometric random variable with parameter $p$. The probability mass function (p.m.f.) of $X$ is defined as follows:

#math.equation(
  block: true,
  $
    prob(X = x) = (1 - p)^(x-1)dot p
  $,
)<eq_8_geometric_pmf>

where $x$ can take any positive integer value, that is $x in {1, 2, 3, ...}$. The rational behind this formulation is that the have the first success at trial $x$ we need to have $x - 1$ failures, each of which happens with probability $1-p$, and a success, that happens with probability $p$.

===== Expected Value and Variance
Let $X$ be a Geometric random variable with parameter $p$. Considering its probability mass function in @eq_8_geometric_pmf. To compute its *expected value*, suppose we can write the random variable $X$ as follows:

#math.equation(
  block: true,
  numbering: none,
  $
    X = limits(sum)_(i=1)^infinity I_i
  $,
)

Where $I_i$ is an indicator that *at least* $i$ trials are needed to get the first success. We can compute the expected value of $X$ as follows:

#math.equation(
  block: true,
  numbering: none,
  $
    exp(X) = exp(limits(sum)_(i=1)^infinity exp(I_i)) = limits(sum)_(i=1)^infinity prob(X >= i)
  $,
)

But $prob(X >= i)$ is the probability that the first $i - 1$ trials are failures, so $prob(X >= i) = (1 - p)^(i-1)$ therefore we have:

#math.equation(
  block: true,
  $
    exp(X) = limits(sum)_(i=1)^infinity (1 - p)^(i-1) = limits(sum)_(j=0)^infinity (1 - p)^j = 1 / (1 - (1 - p)) = 1 / p
  $,
)<eq_9_geometric_expectation>

Notice how we use the formula for the convergence of a *geometric series* to compute the final result, this is why this distribution is called *geometric*. As far as the *variance* is concerned, we can compute it in the following way:

#math.equation(
  block: true,
  $
    var(X) = (1 - p) / p^2
  $,
)<eq_10_geometric_variance>

#remark[
  Notice how the expected value of a Geometric random variable has the formulation in @eq_9_geometric_expectation by no surprise: the more the probability of success $p$ increases, the less trials we expect to need in order to get the first success.
]

===== Memoryless Property
Until now we have not mentioned the cumulative distribution function (c.d.f.) of this random variable. However, it is interesting to notice that the c.d.f. of a Geometric random variable has a very special property, called the *memoryless property*.

Imagine that we have already performed at least $y$ trials of an Bernoulli experiment without getting a success. The probability that we are going to _keep going_ for at least another $x$ trials without getting a success can be modeled with in the following way:

#math.equation(
  block: true,
  $
    prob(X > x + y | X - y) = prob(X > x)
  $,
)<eq_11_memoryless_property>

In other words, the probability of needing more than $x + y$ trials given that we have already performed $y$ trials without success is equal to the probability of needing more than $x$ trials from scratch. This property is called *memoryless* because the process does not care about what happened in the past, it only cares about the present situation.

===== R Implementation
Before understanding how `R` provides us with functions to work with this kind of random variable, it is crucial to understand that there are two different conventions to define this random variable.

Previously we defined a geometric random variable as the number of trials needed in order to observe a success. However, it is also common to define it as the number of *failures before* the success. In the first case we have $Omega_X = {1, 2, ...}$, whilst in the second case we have $Omega_X = {0, 1, 2, ...}$, since we can have zero failures before the first success.

The second one is exactly the convention that `R` uses, therefore all the functions we are going to introduce now are based on that definition. To switch from the second definition to the first one, it is necessary to first transform the random variable $X$ into the random variable $X = Y + 1$. Similarly we'll have that:

#math.equation(
  block: true,
  numbering: none,
  $
    prob(X = x) = prob(Y = x - 1)
  $,
)

In `R` we have the following functions to work with Geometric random variables:

- `dgeom(x-1, p)` $= prob(X = x)$

- `pgeom(x-1, p)` $= prob(X <= x)$

- `qgeom(q, p)` $= x - 1"if" prob(X <= x) = q$

- `rgeom(r, p)` simulates $r$ realizations of $X - 1$

== Hyper-geometric Distribution
Another important random variable distribution is the *hypergeometric distribution*, which is used to model experiments where we draw samples without replacement from a finite population.

#definition(title: "Hypergeometric Distribution")[
  A random variable that models the number of successes in a sample of size $n$ drawn *without replacement* from a population of size $N$ containing $M$ successes and $N - M$ failures has *hypergeometric distribution*.
]

===== Probability Mass Function
Let $X$ be a hypergeometric random variable with parameters $N$ (population size), $M$ (number of successes in the population), $M$ (number of failures), $n$ (the sample size). The probability mass function (p.m.f.) of $X$ is defined as in the following equation:

#math.equation(
  block: true,
  $
    prob(X = x) = "hyper geom"(x, n, M, N) = (binom(M, x) binom(N-M, n-x)) / (binom(N, n))
  $,
)

where $x$ is an integer such that $max(0, n - N + M) <= x <= min(n, M)$

===== Expected Value and Variance
Let $X$ be a hypergeometric random variable with p.m.f. given by $"hyper geom"(x, n, N, M)$, then we can de fine its expected value and variance as follows:

#math.equation(
  block: true,
  $
    exp(X) = n dot M/N quad quad quad var(X) = (N - n)/(N - 1) dot n dot M/N (1 - M/N)
  $,
)

== Introduction to Stochastic Processes
In this section we will try to build a link between everything we have seen so far about random variables and basic probability theory, and the core concept of this course: *stochastic processes*.
A sequence ${X_n}$ of random variables is a *stochastic process*. With the term "sequence" we refer to an _infinite random vector_.

If we consider a *_finite collection_* of random variables ${X_1, X_2, ..., X_n}$ we can characterize all we need to know about such random variables and their relationships by means of their *joint probability distribution*. Indeed starting from it we can compute all the marginal probabilities; furthermore we can also notice that $forall i_1, i_2, ..., i_k$ and for $k >= 1$ we can compute the joint probability of $(X_(i 1), X_(i 2), ..., X_(i k))$ by integrating (or summing) out all the other variables from the joint distribution.

If we can do this for every possible finite subset of r.v.'s from our infinite collection, that means we know the *law* (which is the distribution in this context of random processes) of the random sequence. Informally speaking, we can say that if $X = {X_n}_(n=1)^infinity$ the *law of $X$* is defined as the collection of all the _finite-dimensional distributions_ $forall n in {1, 2, 3, ...}$.
Given any subset of indices $i_1, i_2, ..., i_k$ with $k >= 1$, the finite-dimensional distribution is defined as the joint distribution of the random variables $(X_(i 1), X_(i 2), ..., X_(i k))$.


The simplest stochastic process we can think about is a collection $X_i limits(~)^("i.i.d.") F_X quad i = 1, 2, ...$. A finite subset of them is called a *sample* from distribution $F_X$. The reason why it is the simplest is given in the following equation:

#math.equation(
  block: true,
  numbering: none,
  $
    forall n, forall i_1, i_2, ..., i_n : prob((X_(i_1), ... , X_(i_n))) = F_(X_(i 1), ... X_(i n)) (x_(i 1), ..., x_(i n)) = product_(j=1)^n F_X (x_(i j)),
  $,
)

That is, the joint distribution of any finite subset of them can be computed as the product of their marginal distributions, since they are all *independent* and *identically* *distributed*.

#remark[
  If the random variables are independent but not identically distributed we need to know the *marginal distribution* for each one of the random variables. Namely, if $X_i limits(~)^("ind") F_(X_i)$ then we have that the joint probability of the sample is given by:

  #math.equation(
    block: true,
    numbering: none,
    $
      F_(X_(i 1), ... X_(i n)) (x_(i 1), ..., x_(i n)) = product_(j=1)^n F_(X_(i j)) (x_(i j))
    $,
  )

  Namely, we need to have knowledge about a countable number of marginal distributions.
]

#example-box("Sequence of independent non identically distributed random variables", [
  Suppose we are dealing with a sequence of independent random variables which are not *identically distributed*. To keep the matter simple, let's suppose that the distribution changes according to the index of the random variable in the sequence and the basic distribution is always a Bernoulli distribution, that is: $X_i ~ "Bern"(1 / i)$.

  Of course, considering everything we have said so far, we can say that ${X_n}_(n=1)^infinity$ is a stochastic process.
])

Consider now the following object:
#math.equation(
  block: true,
  numbering: none,
  $
    Y_n = limits(sum)_(i = 1)^n X_i "Bin"(n,p))
  $,
)

And consider the collection ${Y_n}_(n=1)^infinity$; that one is also a *stochastic process*. Again, in this case $Y_i$'s are surely *not* *identically* *distributed*, indeed if $n != m$, $Y_m$ and $Y_n$ have a different distribution while both being Binomial random variable. As far as independency is concerned we can take a look at the following equation:

#math.equation(
  block: true,
  numbering: none,
  $
    Y_(n+1) = limits(sum)_(i = 1)^(n+1) X_i = Y_n + X_(n+1)
  $,
)

if we try to study the value of $Y_(n+1)$ alone we can correctly conclude that it may take any value in {0, ..., n+1}; however if we consider $Y_(n+1) | Y_n = n$ we can easily see that $Y_(n+1)$ can only take the values in {n, n+1}, thus $Y_(n+1)$ and $Y_n$ are *not independent*. Indeed the conditional distribution of $Y_(n+1) | Y_n$ is given by:

#math.equation(
  block: true,
  numbering: none,
  $
    p_(Y_(n+1) | Y_n) (y_(n+1) | y_n) = cases(
      1 - p quad & "if" y_(n+1) = y_n,
      p & "if" y_(n+1) = y_n + 1,
      0 & "otherwise"
    )
  $,
)

That is actually quite trivial to compute since we are dealing with Binomial random variables built from independent Bernoulli trials.
In *general*, supposing we are working with Binomial random variables, we have that:

#math.equation(
  block: true,
  numbering: none,
  $
    p_(Y_1, Y_2, ..., Y_n) (y_1, y_2, ..., y_n) = p_(Y_1)(y_1) space p_(Y_2 | Y_1)(y_2 | y_1) ... space p_(Y_n | Y_(n-1)) (y_n | y_(n-1))
  $,
)

Suppose that we know $Y_n = y_n$ and $Y_(n-1) = y_(n-1)$, let's see how we can use this information:

#math.equation(
  block: true,
  numbering: none,
  $
    Y_(n+1) = Y_n + X_(n+1)
  $,
)

Basically, the first information is very useful since it tells us how many successes we had up to trial $n$, whilst the second information is just telling us that we can write $Y_n = y_(n-1) + X_n$, but we already know the value of $Y_n$ so that second piece of information is not really adding anything new in case we already know $Y_n$.

#warning-box[
  This does not mean, by any means, that $Y_(n+1)$ and $Y_(n-1)$ are independent. Indeed the value of $Y_(n+1)$ is very much dependent on the value of $Y_(n-1)$: $Y_(n+1) = Y_(n-1) + X_n + X_(n+1)$. To be more precise, we can also write the conditional probability of $Y_(n+1) | Y_(n-1)$ as follows:

  #math.equation(
    numbering: none,
    block: true,
    $
      p_(Y_(n+1) | Y_(n-1)) (y_(n+1) | y_(n-1)) = cases((1 - p)^2 quad quad quad &"if" y_(n+1) = y_(n-1), 2(1-p)p &"if" y_(n+1) = y_(n-1)+1, p^2 &"if" y_(n+1) = y_(n-1)+2, 0 &"otherwise")
    $,
  )
  What we can say about $Y_(n+1)$ and $Y_(n-1)$ is that they are *conditionally independent* given $Y_n$, this is very useful because it allows us to simplify the computation of joint probabilities.
]

If we now try to look at the joint probabilities we may be interested in,we can use what we have just observed to write the following:

#math.equation(
  block: true,
  $p_(Y_1, ..., Y_n) (y_1, ..., y_n) &= p_(Y_1)(y_1) dot p_(Y_2 | Y_1)(y_2 | y_1) dot p_(Y_3 | Y_2) (y_3 | y_2) ... \ &= p_(Y_1)(y_1) limits(Pi)_(i=1)^(n-1) p_(Y_(i+1) | Y_i) (y_(i+1) | y_i)$,
)<eq_03_stochastic_process_joint_probability>

If each $X_i$ is the result of a coin toss we can model a $Y_n$ as the _number of wins_ in the first $n$ throws we can    model a $Y_n$ as the _number of wins_ in the first $n$ throws. For the first toss we are going to have the following:

#math.equation(block: true, numbering: none, $p_(Y_1) (y_1) = cases(1-p quad quad &"if" y_1 = 0, p &"if" y_1 = 1)$)

This is straightforward since $Y_1$ is just a Bernoulli random variable. For the second toss we have:

#math.equation(
  block: true,
  numbering: none,
  $
    p_(Y_2) (y_2) = cases((1-p)^2 quad quad &"if" y_2 = 0, 2(1-p)p &"if" y_2 = 1, p^2 &"if" y_2 = 2)
  $,
)

We can derive this result by noticing that $Y_2 ~ "Binom"(2, p)$. Given these pieces of information we can compute several different probabilities. For instance $prob(Y_1 = 1)$, $prob(Y_n = 1)$. But what about the probability of getting a win in the first throw and only lose in the next 6? This can be modeled by the following equation which leverages @eq_03_stochastic_process_joint_probability:

#math.equation(
  block: true,
  numbering: none,
  $
    prob(Y_1 = 1 and Y_2 = 1 &and ... and Y_7 = 1) = p_(Y_1)(y_1) dot p_(Y_2 | Y_1)(1 | 1) \
    & dot ... dot p_(Y_7 | Y_6) (1 | 1) \
    & = p dot limits(Pi)_(i=1)^(7-1) p_(Y_(i+1) | Y_i) (1 | 1) \ &= p dot limits(Pi)_(i=1)^(6) (1-p)^2 = p (1-p)^(12) = 1/2 (1/2)^(12) = 1/2^(13)
  $,
)

#definition(title: "Markov Process")[
  A sequence $X = {X_n}_(n=1)^infinity$ where each $X_n+1$ is *conditionally independent* of ${X_(n-1) ... X_1}$ given $X_n$ is called a *Markov process* or *Markov chain*, which is a stochastic process with some interesting properties that make it easier to study and analyze.
]

==== Stochastic Processes and Common Random Variables
Let's now try to review the concept of *geometric* distribution we have already seen before but in a stochastic process fashion. Consider the random variables $X_i limits(~)^("i.i.d.") "Ber"(p)$ and consider the following:

#math.equation(
  block: true,
  numbering: none,
  $
    W_1 = min{n : X_n = 1}
  $,
)

Clearly we can see $W_1 ~ "Geom"(p)$. And we can sort of consider its value as the 'expected waiting time' until the first success. We can also consider the random variable $Y_n$ as the sum of all the $X_i$ up to time $n$.

We can define two random sequences as follows:

- $W = {W_n}$ as the sequence of *waiting times* between changes in the process (or in the value of $Y_n$). We also refer to them as *inter-arrival times*.
- $Y = {Y_n}$ as the sequence that counts the number of successes up to time $n$, basically it is a *counting process*.

We can actually do the same for *hyper-geometric* random variables. Suppose we have for instance $N$ balls in an urn, of which $M$ are successes (say red) and $N - M$ are failures. The probability of success when drawing a ball at random from the urn is $p = M/N$. So if we consider the first ball extraction we obtain the following:

#math.equation(
  block: true,
  numbering: none,
  $
    X_1 ~ "Bern"(p_1 = M/N)
  $,
)

Now, if we move to the second extraction, we still have a Bernoulli random variable, but we don't know its parameter, since it depends on the result of the first extraction. We can consider two cases:

- $X_2 | X_1 = 1 ~ "Bern"((M-1)/(N-1))$, in case the first extraction was a success.


- $X_2 | X_1 = 0 ~ "Bern"(M/(N-1))$, in case the first extraction was a failure.


If we now take a look at $X_3$, we can notice that this gets more complicated:

- $X_3 | X_2 = 1, X_1 = 1 ~ "Bern"((M-2)/(N-2))$, in case the first two extractions were successes.

- $X_3 | X_2 = 1, X_1 = 0 ~ "Bern"((M-1)/(N-2))$, in case the first extraction was a failure and the second a success.

- $X_3 | X_2 = 0, X_1 = 1 ~ "Bern"((M-1)/(N-2))$, in case the first extraction was a success and the second a failure.

- $X_3 | X_2 = 0, X_1 = 0 ~ "Bern"(M/(N-2))$, in case the first two extractions were failures.

We can notice that, if we take in consideration the *sum* of the successes up to time $n$, we can actually define the conditional distribution based solely on the value of that sum, not the individual outcomes of each previous extraction. We say that, in general, $X_(n+1)$ is *conditionally independent* on ${X_n, X_(n-1), ..., X_1}$ given $Y_n = limits(sum)_(i=1)^n X_i$.

== Negative Binomial Distribution
Earlier in this chapter we have been talking  about binomial distributions and how they are related to the geometric distribution, which measures the 'waiting time' until the first success in a sequence of Bernoulli trials.

#definition(title: "Negative Binomial Distribution")[
  Given a sequence of independent Bernoulli trials with success probability $p$, we can model the *number of trials* to obtain *$k$ successes* with a *Negative Binomial distribution*. Suppose we have $W_i limits(~)^"i.i.d." "Geom"(p)$. The random variable

  #math.equation(
    block: true,
    $
      N_k = limits(sum)_(i=1)^k W_i
    $,
  )

  follows a *Negative Binomial distribution* with parameters $k$ and $p$.
]

==== Probability Mass Function
Let $N_k$ be a Negative Binomial random variable with parameters $k$ and $p$. The probability mass function (p.m.f.) of $N_k$ is defined as follows:

#math.equation(
  block: true,
  $
    p_X (x) = binom(x-1, k-1) space (1 - p)^(x-k) space p^k quad forall x >= k
  $,
)<eq_3_negbinomial_pmf>

intuitively, this formulation makes sense: to have the $k$-th success at trial $x$ we need to have $k -1$ successes in the first $x - 1$ trial (which can happen in $binom(x-1, k-1)$ ways). Every combination $k-1$ successes and $x - k$ failures happens with probability $p^(k-1) (1-p)^(x-k)$; finally we need to have a success at trial $x$, which happens with probability $p$.

==== Expected Value and Variance
Let $N_k$ be a Negative Binomial random variable with parameters $k$ and $p$. Considering its probability mass function in @eq_3_negbinomial_pmf, we can compute its expected value and variance as follows:

#math.equation(
  block: true,
  $
    exp(N_k) = k / p quad quad quad var(N_k) = k (1 - p) / p^2
  $,
)<eq_4_negbinomial_expectation_variance>

==== R Implementation
Before introducing the `R` functions to work with Negative Binomial random variables, it is important to notice that there are two different conventions to define this random variable, `R` actually uses a different one with respect to the one we have just introduced, similarly to what happened with the Geometric distribution, we will need to adjust the parameters accordingly:

- `dnbinom(x - k, k, p)` $= prob(X = x)$, is the probability mass function (p.m.f.).
- `pnbinom(x - k, k, p)` $= prob(X <= x)$, is the cumulative distribution function (c.d.f.).
- `qnbinom(q, k, p) + k` $= x$ "if" $prob(X <= x) = q$, is the quantile function.
- `rnbinom(r, k, p)` simulates $r$ realizations of $X - k$.

To switch from the `R` definition to the one we have introduced, it is necessary to first transform the random variable $X$ into the random variable $X = Y + k$.

== Uniform Distribution
In the past few sections we have been focusing our attention on *discrete random variables*, but as we know, there are also *continuous random variables*.

#definition(title: "Uniform Distribution")[
  A random variable that has an equal probability of taking any value within a given interval $[a, b]$ has *Uniform distribution*. Its parameters are $a$ and $b$, the endpoints of the interval. If the interval of values if $[0,1]$ we say that the random variable has a *standard uniform distribution*.
]
==== Probability Density Function
Let $X$ be a Uniform random variable with parameters $a$ and $b$. The probability density function (p.d.f.) of $X$ is defined as follows:

#math.equation(
  block: true,
  $
    f_X (x) = 1/(b-a) quad quad forall x in [a, b]
  $,
)<eq:03_uniform_pdf>

Actually the above definition is not really precise, indeed when we talk about continuous random variables we cannot really talk about probability, rather we need to talk about *density*. The reason because uniform distributions are so important is that they are the building blocks for all other random variable distributions.

#remark[
  In order for @eq:03_uniform_pdf to be valid, it is necessary that the value $|b - a|$ is a finite positive number so that there is no chance of dividing by zero or by infinity. The rational behind this is quite simple, if we try to choose a random number in an interval of infinite length, we cannot do it with uniform probability since the density would be zero everywhere.
]


==== Uniform Property
For any $h>0$ and $t in [a, b-h]$ we have that:

#math.equation(
  block: true,
  numbering: none,
  $
    prob(t < X < t + h) = limits(integral)_t^(t+h) 1 / (b-a) space d x = h / (b - a)
  $,
)

is *independent of $t$*. The probability is only determined by the length of the interval not buy the location of the point in the interval.

==== Expected Value and Variance
Let $X$ be a Uniform random variable with parameters $a$ and $b$. Considering its probability density function in @eq:03_uniform_pdf, we can compute its expected value and variance as follows:

#math.equation(
  block: true,
  $
    exp(X) = (a + b) / 2 quad quad quad var(X) = (b - a)^2 / 12
  $,
)<eq_5_uniform_expectation_variance>

It is by no surprise that the expected value of a uniform random variable is the midpoint of the interval $[a, b]$. As far as the variance is concerned, we can notice that it increases quadratically with the length of the interval. If we consider the standard uniform distribution, that is $a = 0$ and $b = 1$, we have that $exp(X) = 1/2$ and $var(X) = 1/12$.

==== Uniform Distribution Transformation and Standardization
One very common operation when working with this kind of random variable is to transform it into a standard uniform random variable and vice-versa. Consider two random variables $X ~ "Uniform"(a,b)$ and $Y ~ "Uniform"(0,1)$. We can transform $X$ into $Y$ and vice-versa as follows:

#math.equation(
  block: true,
  $
    Y = (X - a) / (b - a) ~ "Uniform"(0,1) \
    X = a + (b - a) Y ~ "Uniform"(a,b)
  $,
)

Let's now consider the following new random variable:

#math.equation(block: true, numbering: none, $Z = (X - exp(X)) / (sqrt(var(X))) space ~ "Uniform"(z_l, z_u)$)

Abd suppose we want to compute its expected value and variance. To do so we need to compute the values of $z_l$ and $z_u$ first:

#math.equation(
  block: true,
  numbering: none,
  $
    x = a quad => quad z_l = (a - exp(X)) / (sqrt(var(X))) = (a - (a + b) / 2) / (sqrt((b - a)^2 / 12)) \
    x = b quad => quad z_u = (b - exp(X)) / (sqrt(var(X))) = (b - (a + b) / 2) / sqrt((b - a)^2 / 12)
  $,
)

Now that we have these values it is easy to notice that  $exp(Z) = 0, quad var(Z) = 1$.

#definition(title: "Standardization")[
  Given *any* discrete or continuous random variable $X$ with expected value $exp(X) = mu$ and variance $var(X) = sigma^2$, we can define the *standardized* random variable $Z$ as follows:

  #math.equation(
    block: true,
    $
      Z = (X - mu) / sigma^2
    $,
  )<eq_03_standardization>

  which satisfies $exp(Z) = 0$ and $var(Z) = 1$.
]

It is actually easy to see why the expected value and variance of $Z$ are as we have just said:

#math.equation(
  block: true,
  numbering: none,
  $
    exp(Z) = exp((X - mu) / sqrt(sigma^2)) = 1/sigma (exp(X) - mu) = 0 \
    var(Z) = var((X - mu) / sqrt(sigma^2)) = 1/sigma^2 (var(X) - 0) = 1 quad qed
  $,
)

The set of possible values of $Z$ and $X$ are different. For instance, consider $X ~ "Bern"(p)$ with $Omega_X = {0, 1}$.  The standardized random variable $Z$ can now be built as follows:

#math.equation(
  block: true,
  numbering: none,
  $
    Z = X - p / sqrt(p(1 - p))
  $,
)

If we now take a look at the possible values of $Z$ we have: $Omega_Z = {- p/sqrt(p(1-p)), (1-p)/sqrt(p(1-p))}$ respectively when $X = 0$ and $X = 1$. Clearly $Z$ is *not a Bernoulli*. This tells us a very important fact about standardization.

#warning-box[In general, a *standardized random variable* does not belong to the _same family_ of the original random variable that was used to build the standardization]

Following we have a theorem which tells us something very important about standardization and uniform random variables:

#theorem(title: "Standardization of Uniform Random Variables")[
  Given any uniform random variable $X ~ "Uniform"(a,b)$, it is *closed under linear transformation*, that is the uniformness of the random variable is preserved under any linear transformation, including *standardization*.
]

#warning-box[
  Even though the name suggests it, the *standard uniform random variable* $Y ~ "Uniform"(0,1)$ is just a special case of uniform random variable. It is *not* the result of a standardization process.
]

==== R Implementation
In `R` we have the following functions to work with Uniform random variables:

- `dunif(x, a, b)` $= f_X(x)$, is the probability density function (p.d.f.).
- `punif(x, a, b)` $= prob(X <= x)$, is the cumulative distribution function (c.d.f.).
- `qunif(q, a, b)` $= x = F^(-1)(q)$, i.e., $prob(X <= x) = q$, is the quantile function.
- `runif(r, a, b)` simulates $r$ realizations of $X$.
#pagebreak()

== Normal (Gaussian) Distribution
Although it is not the distribution we are going to preponderantly use in this course, the *Normal distribution* is so common and important in all probability theory that it is worth spending some time on it. If the uniform distribution serves to express the idea of 'equiprobability', the normal distribution is often used to model 'natural' phenomena.

#definition(title: "Normal Distribution")[
  A random variable that models phenomena where values tend to cluster around a central mean value with a certain variability has *Normal distribution*. Its parameters are $mu$ (the mean) and $sigma^2$ (the variance).
]

When dealing with this kind of random variables we often refer to the mean as *location parameter* and to the variance as *scale parameter*.

==== Probability Density Function
Let $X$ be a Normal random variable with parameters $mu$ and $sigma^2$. The probability density function (p.d.f.) of $X$ is defined as follows:

#math.equation(
  block: true,
  $
    f_X (x) = 1 / (sigma sqrt(2 pi)) "exp"{ (- (x - mu)^2) / (2 sigma^2)}
  $,
)<eq_6_normal_pdf>

We can see how this formulation intuitively makes sense. The numerator of the fraction in the exponential is squared so that larger errors are more penalized (i.e., less likely) w.r.t. smaller errors. The numerator is then divided by the variance so that larger variances lead to less penalization for larger errors. Finally the whole expression is normalized by the factor $1 / (sigma sqrt(2 pi))$ so that the total area under the curve is equal to 1.

We can see that the value of $mu$ serves to control the *location* of the distribution's peak, whilst the value of $sigma^2$ serves to control the *spread* of the distribution around the mean. This is illustrated in @fig_03_normal_distribution.

#figure(
  image("/assets/03_01_normal_distribution.png", width: 50%),
  caption: "Normal distributions with different parameters",
)<fig_03_normal_distribution>

==== Standardization
There is actually no point in computing the expected value and variance of a Normal random variable in that they are exactly equal to the parameters used to define the distribution: $exp(X) = mu$ and $var(X) = sigma^2$.

Nevertheless, it is possible to define a *standard normal random variable* $Z$ such as it has expected value equal to 0 and variance equal to 1. Along with this fact, it is interesting to notice that Normal random variables are *closed under linear transformation*, that is if we take any Normal random variable and we apply a linear transformation to it, the resulting random variable is still Normal. In particular we can notice the following:

#math.equation(
  block: true,
  $
    X = a Z + b ~ "Normal"(a exp(Z) + b, a^2 var(Z))
  $,
)

and by simply plugging the knowledge that $exp(Z) = 0$ and $var(Z) = 1$ in the above equation we have that $X ~ "Normal"(b, a^2)$.


==== Transformation from and to Standard Normal
Given any Normal random variable $X ~ "Normal"(mu, sigma^2)$ and a standard normal random variable $Z ~ "Normal"(0,1)$ we can transform $X$ into $Z$ and vice-versa as follows:

#math.equation(
  block: true,
  $
    Z = (X - mu) / sigma ~ "Normal"(0,1) \
    X = mu + sigma Z ~ "Normal"(mu, sigma^2)
  $,
)

This is indeed very similar to the standardization process we have already seen in the case of uniform random variables.

==== R Implementation
In `R` we have the following functions to work with Normal random variables:

- `dnorm(x, mu, sigma)` $= f_X(x)$, is the probability density function (p.d.f.).
- `pnorm(x, mu, sigma)` $= prob(X <= x)$, is the cumulative distribution function (c.d.f.).
- `qnorm(q, mu, sigma)` $= x = F^(-1)(q)$, i.e., $prob(X <= x) = q$, is the quantile function.
- `rnorm(r, mu, sigma)` simulates $r$ realizations of $X$.

== Poisson Distribution
Let's now take a look at what is probably the most important distribution for this course: the *Poisson distribution*.  Let's first take a look at its definition.

#definition(title: "Poisson Distribution")[
  The numbero of "*rare*" events occurring within a fixed interval of time has *Poisson Distribution*.
]

This definition looks a bit vague in that we still need to clarify what we mean by "rare" events. Before doing so, let's first take a look at its probability mass function.

==== Probability Mass Function
Let $X ~ "Poisson"(lambda)$ be a Poisson random variable with parameter $lambda > 0$. The probability mass function (p.m.f.) of $X$ is defined as follows:

#math.equation(
  block: true,
  $
    p_X (x) = e^(- lambda) lambda^x / x! quad forall x in {0, 1, 2, ...}
  $,
)<eq_7_poisson_pmf>

Though this formulation may look strange, it is indeed a probability mass function. Indeed it is both positive for all $x$ and it sums to 1.

===== Positivity
To understand why it is positive there is not much to say, all the components of the product in @eq_7_poisson_pmf are positive for any $lambda > 0$ and any $x in {0, 1, 2, ...}$.

===== Normalization
To understand why it sums to 1 we can consider the definition of $f(lambda) = e^lambda$ as the limit of an infinite series:

#math.equation(
  block: true,
  numbering: none,
  $
    e^lambda = limits(sum)_(x=0)^infinity lambda^x / x! space <==> space limits(sum)_(x=0)^infinity e^(- lambda) lambda^x / x! = 1
  $,
)

where the series on the right-hand side is exactly the formulation of the p.m.f. in @eq_7_poisson_pmf. If we try to see this the other way around, we may wonder which is the constant factor $k$ that makes the function $lambda^x / x!$ be a proper p.m.f. We can find such a constant by solving the following equation:

#math.equation(
  block: true,
  numbering: none,
  $
    1 = k dot limits(sum)_(x=0)^infinity lambda^x / x! space <==> k = 1 / limits(sum)_(x=0)^infinity lambda^x / x! = e^(- lambda)
  $,
)

==== Expected Value and Variance
We can try to compute the *expected value* of the Poisson distribution by leveraging again the Taylor series expansion of the exponential function:

#math.equation(
  block: true,
  $
    exp(X) &= limits(sum)_(x=0)^infinity x space p_X(x) = limits(sum)_(x=0)^infinity x space e^(- lambda) lambda^x / x! \
    &= 0 + limits(sum)_(x=1)^infinity coleq(#purple, x) space e^(-lambda) coleq(#orange, lambda^x) / coleq(#purple, x!) = coleq(#orange, lambda) e^(- lambda) limits(sum)_(x=1)^infinity coleq(#orange, lambda^(x-1)) / coleq(#purple, (x - 1)!) \
    &= e^(-lambda) lambda limits(sum)_(x=0)^infinity lambda^x / x! = e^(-lambda) lambda e^lambda = lambda
  $,
)<eq_pois_expected_value>

The parameter $lambda$ of the Poisson distribution is called the *rate* or *frequency* parameter, since it represents the expected (mean) number of events per fixed amount of time.

Before actually computing the variance of the Poisson distribution it is necessary to compute another quantity. Specifically by recalling @eq_expected_value_function_random_variable we can notice the following:

#math.equation(
  block: true,
  numbering: none,
  $
    exp(X(X - 1)) &= limits(sum)_(x=0)^infinity x(x-1) space p_X (x) = limits(sum)_(x=0)^infinity x(x-1) space e^(- lambda) lambda^x / x! \
    &= 0 + 0 + e^(- lambda) lambda^2 limits(sum)_(x=2)^infinity x(x-1)lambda^(x-2) / (x(x-1)(x-2)!) = lambda^2
  $,
)

Now, if we notice that by linearity of expectation we can also write:

#math.equation(
  block: true,
  numbering: none,
  $
    exp(X(X-1)) = exp(X^2 - X) = exp(X^2) - exp(X)
  $,
)

Therefore we can combine the results above and conclude that $exp(X^2) = lambda^2 + lambda$. Now we are finally ready to give an expression for the *variance*:

#math.equation(
  block: true,
  $
    var(X) = exp(X^2) - (exp(X))^2 = (lambda^2 + lambda) - lambda^2 = lambda
  $,
)<eq_pois_variance>

We can also generalize what we have seen before when we were computing $exp(X(X-1))$:

#math.equation(
  block: true,
  numbering: none,
  $
    exp(limits(Pi)_(i=0)^(k-1)(X-i)) = lambda^k
  $,
)

==== R Implementation
In `R` we have the following functions to work with Poisson random variables:
- `dpois(x, lambda)` $= p_X (x)$, is the probability mass function (p.m.f.).
- `ppois(x, lambda)` $= prob(X <= x)$, is the cumulative distribution function (c.d.f.).
- `qpois(q, lambda)` $= x = F^(-1)(q)$, i.e., $prob(X <= x) = q$, is the quantile function.
- `rpois(r, lambda)` simulates $r$ realizations of $X$.


==== Properties of Poisson Random Variables
In this section we are going to observe some important properties of Poisson random variables, which will come in very handy in the next few chapters.

===== Poisson Approximation of Binomial Distribution
In this section we are going to see how the Poisson distribution can be used to approximate a Binomial distribution when the number of trials considered is large and the probability of success $p$ of those Bernoulli trials is small. This approximation is adequate say, for $n >= 30$ and $p <= 0.05$ and becomes more and more accurate as $n$ increases and $p$ decreases.

#theorem(title: "Law of Rare Events")[
  #math.equation(
    block: true,
    $
      limits("lim")_(n -> infinity, p -> 0 \ n p = lambda) binom(n, x) p^x (1 - p)^(n - x) = e^(- lambda) lambda^x / x!
    $,
  )
]<theo_law_rare_events>

The convergence presented in @theo_law_rare_events is called *convergence in distribution*, which is not the same as the usual convergence we are used to.

In our case, this means that, as the number of Bernoulli trials $n$ increases and the probability of success $p$ decreases in such a way that their product $n p$ remains constant, say equal to $lambda$, the distribution of the Binomial random variable $X ~ "Binom"(n, p)$ approaches the distribution of the Poisson random variable $Y ~ "Poisson"(lambda)$.

To make this more concrete, consider a sequence of random variables $X_n ~ "Binom"(n, lambda/n)$, where $lambda/n = p$, for some adequate value of $lambda$, that is, $p = lambda/n < 1$. We can notice that $n p = lambda$ but if $n -> infinity$ then $p = lambda / n -> 0$. This means that the distribution of $X_n$ approaches the distribution of $Y ~ "Poisson"(lambda)$ as $n$ increases. If $n -> infinity$ then $X_n limits(-->)^"d" X l~ "Poisson"(lambda)$, where "$limits(-->)^d$" indicates _convergence in distribution_. To better understand this, it is useful to remember that each $X_n$ can be seen as a function of $omega$: $X_n (omega)$.

#figure(
  cetz.canvas({
    import cetz.draw: *

    let rng = gen-rng-f(42)
    line((-5, 0), (5, 0), mark: (end: ">"), name: "x-axis")
    line((-4.5, -.5), (-4.5, 3), mark: (end: ">"), name: "y-axis")
    content((5.1, -0.4), $omega in Omega$)
    content((-5, 3), $X_n$)

    let start_x = -4.5
    let step = 0.01

    let x_1_vals = ()
    let x_2_vals = ()
    let x_3_vals = ()

    while start_x <= 3.7 {
      let y_1 = 2 + calc.sin(3 * start_x) * 0.5 * calc.cos(start_x)
      let y_2 = 1 + calc.sin(4 * start_x) * calc.abs(calc.cos(start_x / 2))
      let y_3 = 0.8 + calc.sin(3 * start_x) * calc.abs(calc.cos(start_x / 2)) + 1
      x_1_vals.push((start_x, y_1))
      x_2_vals.push((start_x, y_2))
      x_3_vals.push((start_x, y_3))
      start_x += step
    }

    for i in range(1, x_1_vals.len()) {
      line(x_1_vals.at(i - 1), x_1_vals.at(i), stroke: (paint: rgb("#457b9d"), thickness: 1pt))

      line(x_2_vals.at(i - 1), x_2_vals.at(i), stroke: (paint: rgb("#e63946"), thickness: 1pt))

      line(x_3_vals.at(i - 1), x_3_vals.at(i), stroke: (paint: rgb("#4e9c36"), thickness: 1pt))
    }

    content((4.7, 2.8), text(fill: rgb("#457b9d"))[*$X_1(omega)$*])
    content((4.7, 2), text(fill: rgb("#4e9c36"))[*$X_2(omega)$*])
    content((4.7, 1), text(fill: rgb("#e63946"))[*$X_3(omega)$*])
  }),

  caption: [Different random variables $X_n$ plots for the same outcome $omega$],
)<fig_03_different_random_variables>

@fig_03_different_random_variables shows that every time we perform the experiment, we get one outcome $omega in Omega$ and each $X_n (omega)$ gets its individual value $x_n$.

#warning-box[
  Convergence in distribution *does not mean* that for each $omega$ we have:

  #math.equation(
    block: true,
    numbering: none,
    $
      X_n (omega) = x_n quad "and" quad X(omega) = x
    $,
  )

  rather, it is interested in the *probability* of $X_n$ taking values in certain intervals converging to the probability of $X$ taking values in the same intervals as $n$ goes to infinity.
]

===== Additivity of Poisson Random Variables
Another very important property of Poisson random variables is their *additivity*. Let's look at the following theorem:

#theorem(title: "Additivity of Poisson Random Variables")[
  If $X ~ "Poisson"(lambda)$ and $Y ~ "Poisson"(mu)$ are two *independent* Poisson random variables, then $X + Y ~ "Poisson"(lambda + mu)$.
]

To view this under a more practical light, consider two disjoint periods of time $pi_1$ and $pi_2$, say $pi_1 = [0, t_1), pi_2 = [t_1, t_2]$. Suppose for each of these periods we define a Poisson random variable, for instance $X ~ "Pois"(lambda)$ counts the number of rare events occurring during $pi_1$ and $Y ~ "Pois"(mu)$ counts number of rare events occurring in $pi_2$; where $X$ and $Y$ represent respectively the fact that we are expecting to observe $lambda$ events during $pi_1$  and $mu$ events to happen during the span of $pi_2$: $exp(X) = lambda, exp(Y) = mu$.

Let's now consider the period $Pi = [0, t_2]$ and define the random variable $W$ as the number or rare events occurring during $Pi$, intuitively also this variable is a Poisson. If we also remember that the parameter of a Poisson random variable models the expected number of events occurring during the time period, we can intuitively say that it makes sense to expect to observe $lambda + mu$ events during the period $Pi$. Therefore we can conclude that $W ~ "Pois"(lambda + mu)$.

#warning-box[
  The additivity property of Poisson random variables *only holds* when the random variables considered are *independent*.
]

Let's now try to prove the theorem in a formal way. By the notion of independence we know that the following equation holds:

#math.equation(
  block: true,
  numbering: none,
  $
    prob(X = r and Y = s) & = prob(X = r) prob(Y = s) \
                          & = lambda^r e^(-lambda) / r! space mu^s e^(-mu) / s!
  $,
)

Now we actually need to consider all possible ways of obtaining $W = n$, that is, we need to consider all the pairs $(r, s)$ such that $r + s = n$. Therefore we can write:

#math.equation(
  block: true,
  numbering: none,
  $
    prob(X + Y = n) & = limits(sum)_(r=0)^n prob(X = r and Y = n - r) \
                    & = limits(sum)_(r=0)^n (lambda^r e^(-lambda)) / r! (mu^(n-r) e^(-mu)) / ( (n - r)!) \
  $,
)

We can multiply and divide everything inside the sum by $n!$, this is useful since now we can bring out of the summation all the terms that do not depend on $r$ and obtain the following:

#math.equation(
  block: true,
  numbering: none,
  $
    prob(X + Y = n) & =(e^(-(lambda+mu)))/n! limits(sum)_(r=0)^n binom(n, r) lambda^r mu^(n-r) \
                    & = ((lambda + mu)^n space e^(-(lambda+mu))) / n!
  $,
)

which is exactly the p.m.f. of a Poisson random variable with parameter $lambda + mu$. This can be easily generalized to the sum of $k$ independent Poisson random variables by _mathematical induction_.
It is actually possible to generalize this property even further: we can even consider the case in which there is a *infinite countable* number of independent Poisson random variables.

#theorem(title: "Generalized Additivity of Poisson Random Variables")[
  Let $X_j ~ "Pois"(lambda_j)$ for $j = 1, 2, ...$ be a sequence of independent random variables. If we have that $sum_(j=1)^infinity lambda_j = lambda < infinity$, i.e., the series converges, then we have that:

  #math.equation(
    block: true,
    numbering: none,
    $
      prob(S = sum_(j=2)^infinity X_j < infinity) = 1 quad "and" quad S ~ "Pois"(lambda)
    $,
  )

  that is, the infinite sum of independent Poisson r.v.'s is still a Poisson r.v. If, on the other hand, the series $sum lambda_j = infinity$ then also the probability that the infinite sum diverges is equal to 1.
]

The type of convergence used by this theorem is called *almost sure convergence*, which is stronger than convergence in distribution. To better understand this, suppose we have a sequence $X_i ~ "Pois"(lambda_i)$. We can define *partial sums*: $S_1 = X_1$, $S_2 = X_1 + X_2$, $S_3 = X_1 + X_2 + X_3$, and so on until $S_n$. Along with these random variables we can also define the partial sums of their parameters: $mu_1 = lambda_1$, $mu_2 = lambda_1 + lambda_2$, $mu_3 = lambda_1 + lambda_2 + lambda_3$, and so on until $mu_n$, so that $S_n ~ "Pois"(mu_n)$.

If we have that $mu_n limits(->)_infinity mu < infinity$, then we have that $S_n limits(-->)^bb(P) S ~ "Pois"(mu)$, where "$limits(-->)^bb(P)$" indicates *convergence in probability*.

#let c1 = cetz.canvas({
  import cetz.draw: *

  let rng = gen-rng-f(42)
  line((-.5, 0), (10, 0), mark: (end: ">"), name: "x-axis")
  line((0, -.5), (-0, 5), mark: (end: ">"), name: "y-axis")
  content((10.1, -0.4), $omega in Omega$)
  content((-0.5, 5.2), $X_n$)

  let x1_vals = ((0, 1), (2, 1), (2, 2), (4, 2), (4, 3), (6, 3), (6, 1), (9, 1))
  let x2_vals = (
    (0, 0.8),
    (1.5, 0.8),
    (1.5, 1.5),
    (2.5, 1.5),
    (2.5, 0.8),
    (4, 0.8),
    (4, 1.5),
    (5, 1.5),
    (5, 1),
    (7, 1),
    (7, 2),
    (9, 2),
  )

  for i in range(1, x1_vals.len()) {
    line(x1_vals.at(i - 1), x1_vals.at(i), stroke: (paint: rgb("#457b9d"), thickness: 1pt))
  }

  for i in range(1, x2_vals.len()) {
    line(x2_vals.at(i - 1), x2_vals.at(i), stroke: (paint: rgb("#680a80"), thickness: 1pt))
  }

  content((9.7, 0.8), text(fill: rgb("#457b9d"))[*$X_1(omega)$*])
  content((9.7, 2), text(fill: rgb("#680a80"))[*$X_2(omega)$*])
})

#let c2 = cetz.canvas({
  import cetz.draw: *

  let rng = gen-rng-f(42)
  line((-.5, 0), (10, 0), mark: (end: ">"), name: "x-axis")
  line((0, -.5), (-0, 5), mark: (end: ">"), name: "y-axis")
  content((10.1, -0.4), $omega in Omega$)
  content((-0.5, 5.2), $S_n$)

  let x1_vals = ((0, 1), (2, 1), (2, 2), (4, 2), (4, 3), (6, 3), (6, 1), (9, 1))
  let x2_vals = (
    (0, 1.8),
    (1.5, 1.8),
    (1.5, 2.5),
    (2, 2.5),
    (2, 3.5),
    (2.5, 3.5),
    (2.5, 2.8),
    (4, 2.8),
    (4, 4.5),
    (5, 4.5),
    (5, 4),
    (6, 4),
    (6, 2),
    (7, 2),
    (7, 3),
    (9, 3),
  )

  for i in range(1, x1_vals.len()) {
    line(x1_vals.at(i - 1), x1_vals.at(i), stroke: (paint: rgb("#457b9d"), thickness: 1pt))
  }

  for i in range(1, x2_vals.len()) {
    line(x2_vals.at(i - 1), x2_vals.at(i), stroke: (paint: rgb("#680a80"), thickness: 1pt))
  }

  content((9.2, 0.6), text(fill: rgb("#457b9d"))[*$S_1 = X_1(omega)$*])
  content((8.3, 3.5), text(fill: rgb("#680a80"))[*$S_2 = X_1(omega) + X_2(omega)$*])
})

#figure(
  c1,
  caption: [Two random variables $X_1$ and $X_2$ for the same outcome $omega$],
)<fig_03_independent_rv_omega>

#figure(
  c2,
  caption: [Partial sums $S_1$ and $S_2$ for the same outcome $omega$],
)<fig_03_dependent_partial_sums>

Looking at the figures above and trying to consider a fixed value of $omega$, in @fig_03_independent_rv_omega the observed values of the sequence may not converge, but in @fig_03_dependent_partial_sums, for each $omega$ the observed values $X_n (omega) = x_n$ always converge, if $n$ is large enough. The convergence works every time we perform the experiment. This happens thanks to the strong dependence that exists between the partial sums.

===== Poisson - Multinomial Relationship
Up to this point we have talked about sums, basically we have seen that if we know the values of the $X$'s then we can easily compute the value of their sums. Now we would like to invert this relation. Suppose we know the value of a sum of Poisson random variables, we'd like to be able to infer something about the values of the individual Poisson r.v.'s that are being summed up. Let's look at the following theorem.

#theorem(title: "Poisson - Multinomial Relationship")[
  Let $S_n = X_1 + ... + X_n$ be the sum of $n$ independent Poisson random variables each with parameter $lambda_i$ and let $lambda = lambda_1 + ... + lambda_n$. The *conditional distribution* of the vector *$X$* $= (X_1, ..., X_n)$ given the value of $S_n$ is *multinomial* with its parameter being *$p$* $= (lambda_1\/lambda, ... , lambda_n\/lambda)$.
]

Intuitively, this makes sense, because if we know that the total number of events observed is $k$, then the only uncertainty the remains is about how these $k$ events are distributed among the different $X_i$'s. This is exactly what a multinomial distribution models.

To see this in a more formal way, suppose we have $r_1 + r_2 + ... + r_n = s$, then we can write:

#math.equation(
  block: true,
  numbering: none,
  $
    prob(X_1 = r_1", ..., " X_n = r_n | S_n = s) &= (prob(X_1 = r_1", ..., " X_n = r_n "," S_n = s)) / (prob(S_n = s)) \
    &= (coleq(#green, Pi_(j=1)^n) (lambda_j^(r_j) coleq(#green, e^(-lambda_j)) / (r_j!))) / (lambda^s coleq(#green, e^(lambda))/s!) = s! / (pi_(j=1)^n r_j!) ((lambda_1) / lambda)^(r_1) ... ((lambda_n) / lambda)^(r_n)
  $,
)

where the first equality comes from the definition of conditional probability in @eq:conditional_cdf and the second equality is obtained by noticing that $S_n = s$ is a redundant condition once we have all the values of the $X_i$'s and by multiplying the p.m.f.'s of the individual Poisson random variables. As far as the third equality is concerned the $lambda^s$ has been replaced by a product of $lambda^(r_1) dot ... dot lambda^(r_n) = lambda$, and the other simplifications are highligted in green.

#remark[
  Notice that, in case $n=2$, the multinomial distribution reduces to a _Binomial distribution_. Given $S_2 = s$, if $X_1 = r$ and $X_2 = s - r$, we have that:

  #math.equation(
    block: true,
    numbering: none,
    $
      prob(X_1 = r"," X_2 = s - r | S_2 = s) & = prob(X_1 = r | S_2 = s) \
                                             & = binom(s, r) p^r (1 - p)^(s - r)
    $,
  )

  where $p = lambda_1 / (lambda_1 + lambda_2)$.
]

#remark[
  In a very similar fashion it is possible to do the opposite, that is, let $S ~ "Pois"(lambda)$ and assume that, conditionally on $S$, $X$ has a $"Binom"(S, p)$ distribution. Then $X$ and $Y = S-X$ are *independent* Poisson random variables with parameters $lambda_1 = lambda p$ and $lambda_2 = lambda (1-p)$.
]

To see why this last remark is true, we can produce the following derivation:

#math.equation(
  block: true,
  numbering: none,
  $
    prob(X = r"," S - X = k) &= coleq(#orange, prob(S = k + r)) coleq(#blue, prob(X = r | S = k + r)) \
    &= coleq(#orange, (lambda^(k + r) e^(-lambda)) / ((k + r)!)) coleq(#blue, binom(k + r, r) p^r (1 - p)^k) \
    &= ((lambda p)^r e^(-lambda p)) / (r!) space ((lambda (1-p))^k e^(-lambda (1-p))) / (k!)
  $,
)

Here, instead of starting from the conditional, and writing it as the ratio between the joint and the marginal, we have started from the joint of $X, Y$ being equal to $r, k$ writing it as the product of the marginal of $S$ and the conditional of $X$ given $S$. The #text(fill: orange)[marginal of $S$] can be found by noticing that $S ~ "Pois"(lambda)$. The #text(fill: blue)[conditional of $X$ given $S$] is a Binomial distribution, indeed we want to estimate the probability of having exactly $r$ successes out of $k + r$ trials, where the probability of success is $p$.

Notice how $prob(X = r | S = n) = binom(n, r) p^r (1 - p)^(n - r) limits(==>)^(n = k + r \ n - r = k) binom(k + r, r) p^r (1 - p)^(k + r - r)$. And we have written $e^(-lambda)$ as $e^(-lambda(p + 1 - p)) = e^(-lambda p) space e^(-lambda(1-p))$ which has been later split into the two partes in the last equality. We can notice that the two factors are exactly the p.m.f.'s of two independent Poisson random variables with parameters $lambda p$ and $lambda (1-p)$ respectively.

In the end, the important takeaway is that, with this type of random variables, if we have the marginals, we can also derive the conditionals and vice-versa. This property may look trivial but it is actually quite unique in the whole world of probability distributions.

== Exponential Distribution
Another very important distribution that is often used to model 'natural' phenomena is the *Exponential distribution*. Specifically it is often used to model *time*: waiting times, inter-arrival times, hardware lifetime, failure times and so on.

We are not going to spend time on giving the definition of this distribution, since it is pretty much all contained in the few lines above. Similarly to Poisson random variables, exponential random variables are also characterized by a *rate* parameter $lambda$ which models the expected number of events occurring per unit of time.

==== Probability Density Function
Since this distribution models time, it is only possible to define it in a continuous fashion. Let $X ~ "Exp"(lambda)$ be an exponential random variable with parameter $lambda > 0$. The *probability density function* of $X$ is defined as:

#math.equation(
  block: true,
  $
    f_X (x) = lambda e^(- lambda x) quad forall x > 0
  $,
)<eq_03_exp_pdf>

By means of this p.d.f. we can also write the *cumulative distribution function* as follows:

#math.equation(
  block: true,
  $
    F_X (x) = prob(X <= x) = limits(integral)_0^x lambda e^(- lambda t) d t = [-e^(- lambda t)]_0^x = 1 - e^(- lambda x)
  $,
)<eq_03_exp_cdf>

Sometimes it may be really useful to deal with the *survival function*, which is defined as in @eq_02_survival_function, therefore in this specific case we have:

#math.equation(
  block: true,
  $
    S_X (x) = prob(X > x) = 1 - F_X (x) = e^(- lambda x)
  $,
)<eq_03_exp_survival>

==== Expected Value and Variance
Since we know the expected value of a Poisson random variable with parameter $lambda$ is exactly $lambda$, we can leverage this, and obtain that, since $lambda$ here models the amout of 'rare' events occurring per unit of time, the *expected* waiting time for the occurrence of one such event is:

#math.equation(
  block: true,
  $
    exp(X) = 1 / lambda
  $,
)<eq_03_exponential_mean>

To see this in a more formal way, we can compute the expected value as follows:

#math.equation(
  block: true,
  numbering: none,
  $
    exp(X) &= limits(integral)_(0)^infinity x space lambda e^(- lambda x) space d x quad "integrating by parts: " cases(u = x"," d u = d x, d v = lambda e^(- lambda x)"," v = - e^(- lambda x)) \
    &= [-x e^(- lambda x)]_0^infinity + limits(integral)_0^oo e^(-lambda x) space d x = 0 - [(e^(- lambda x) / lambda)]_0^oo = 1 / lambda
  $,
)

As far as the variance is concerned we need to first compute the value of $exp(X^2)$:

#math.equation(
  block: true,
  numbering: none,
  $
    exp(X^2) &= limits(integral)_0^oo x^2 space lambda e^(-lambda x) space d x quad "integrating by parts: " cases(u = x^2"," d u = 2 x, d v = lambda e^(- lambda x)"," v = - e^(- lambda x)) \
    &= [-x^2 e^(- lambda x)]_0^oo + limits(integral)_0^oo 2 x e^(-lambda x) space d x =
    0 + 2 / lambda limits(integral)_0^oo lambda x e^(- lambda x) space d x = 2 / lambda^2
  $,
)

Now we can compute the *variance* as follows:

#math.equation(
  block: true,
  $
    var(x) = exp(X^2) - exp(X)^2 = (2 / lambda^2) - (1 / lambda)^2 = 1 / lambda^2
  $,
)<eq_03_exponential_variance>

==== R Implementation
As usual, in `R` we have the following functions to work with exponential random variables:

- `dexp(x, lambda)` $= f_X (x)$, is the probability density function (p.d.f.).
- `pexp(x, lambda)` $= prob(X <= x)$, is the cumulative distribution function (c.d.f.).
- `qexp(q, lambda)` $= x = F^(-1)(q)$, i.e., $prob(X <= x) = q$, is the quantile function.
- `rexp(r, lambda)` simulates $r$ realizations of $X$.

==== Poisson - Exponential Relationship
As we have already hinted, there is a very strong relationship between Poisson and Exponential random variables. This section is dedicated to exploring it in detail.

Consider a sequence or _rare_ events, where the number $N_t$ of occurrences during a period of time of length $t$ is modeled as a Poisson random variable with parameter $lambda$ proportional to $t$. In other words we can write $N_1 ~ "Pois"(lambda), N_t ~ "Pois"(lambda t)$.

Consider now the event $A =$ "the time $T$ until the next event (arrival) is greater than $t$". This is basically equivalent to saying that "during a period of time of length $t$ no events occur": we can write the event as $A = {N_t = 0}$. If we try to _compute the probability of $A$_ we get the following:

#math.equation(
  block: true,
  numbering: none,
  $
    prob(A) = prob(T > t) = prob(N_t = 0) = e^(- lambda t)
  $,
)

This is because, if we take a look at the p.m.f. of a Poisson random variable in @eq_7_poisson_pmf, we can see that our parameter when considering the time period of length $t$ is exactly $lambda t$, therefore if we set $x = 0$ we get exactly the following equality:

#math.equation(
  block: true,
  numbering: none,
  $
    p_X (x) = e^(- lambda) lambda^x / x! = e^(-lambda t)
  $,
)

But this is exactly equal to the *survival function* of an Exponential random variable with parameter $lambda t$ as shown in @eq_03_exp_survival. This property is also known as the *inevitability of exponential distribution*.

==== Properties of Exponential Random Variables
We have defined quite a bit of properties about Poisson random variables; not surprisingly, since they are so tightly related to Exponential ones, many of these properties can be translated to Exponential random variables as well.

===== Memoryless Property
One of the most important properties of Exponential random variables is their *memoryless property*. We are going to present it in the following theorem.

#theorem(
  title: "Memoryless Property for Exponential",
)[Suppose that an exponential random variable $T$ represents a waiting time. Regardless of the event $T > t$, when the total waiting time exceeds $t$, the remaining waiting time still has exponential distribution with the same parameter $lambda$.

  #math.equation(
    block: true,
    numbering: none,
    $
      prob(T > t + x | T > t) = prob(T > x) quad "for" t, x > 0
    $,
  )

  where $t$ represents the portion of waiting time that has already elapsed, and $x$ represents the additional remaining time.]

This can be proved by recognizing the survival function of the exponential distribution:

#math.equation(
  block: true,
  numbering: none,
  $
    prob(T > t + x | T > t) & = (prob(T > t + x inter T > t)) / (prob(T > t)) = e^(- lambda (t + x)) / (e^(- lambda t)) \
                            & = e^(- lambda x) = prob(T > x)
  $,
)

#remark[
  Just like the *geometric distribution* is the only discrete memoryless distribution, the *exponential distribution* is the only continuous memoryless distribution.
]

This is by no surprise, since we have already seen that the Binomial distribution is related to the Geometric distribution in a very similar way as the Poisson distribution is related to the Exponential distribution.

===== Minimization Property
When we talked about the Poisson distribution, we have mentioned the case in which we may have different independent Poisson random variables and we were interested in their sum, in which case the sum was still a Poisson random variable, and on the other hand we have also seen that if we had the sum of independent Poisson random variables, conditionally on the value of the sum, the individual random variables were multinomially distributed.

Since exponential random variables do not consider the number of events occurring but rather times until the occurrence of such events, it makes sense to consider the *minimum* of a set of independent exponential random variables.

#theorem(title: "Minimization Property")[
  Let $X_j ~ "Exp"(lambda_j)$ for $j = 1, 2, ..., n$ be a collection of *independent* exponential random variables, then we have that:

  #math.equation(
    block: true,
    numbering: none,
    $
      L_n = min{X_1, X_2, ..., X_n} ~ "Exp"(lambda)
    $,
  )

  where $lambda = limits(sum)_(j=1)^n lambda_j$ is the parameter of the resulting exponential random variable.
]

Indeed, we can take a look at the cumulative distribution function of $L_n$:

#math.equation(
  block: true,
  numbering: none,
  $
    F_(L_n) (x) & = prob(L_n <= x) = 1 - prob(L_n > x) \
                & = 1 - prob(X_1 > x"," X_2 > x"," ..."," X_n > x) \
                & = 1 - limits(product)_(j=1)^n prob(X_j > x) quad "by independence" \
                & = 1 - limits(product)_(j=1)^n e^(-lambda_j x) = 1 - e^(sum_(j=1)^n -lambda_j x) = 1 - e^(- lambda x)
  $,
)

where we went from the first to the second line by noticing that the minimum of $n$ r.v.'s is greater than $x$ if and only if all the individual r.v.'s are greater than $x$. In the end we have obtained exactly the survival function of an exponential random variable with parameter $lambda$, as we were supposed to.

#remark[
  It is important to notice that the minimum $L_n$ of independent exponential random variables is *not independent* of ${X_1, X_2, ..., X_n}$. Indeed $L_n = X_k$ for some $k in {1, ..., n}$ and:

  #math.equation(
    block: true,
    numbering: none,
    $
      prob(L_n = X_k) = lambda_k / lambda = lambda_k / (sum_(j=1)^n lambda_j)
    $,
  )

  Indeed, by the law of total probability for continuous random variables we have that:

  #math.equation(
    block: true,
    numbering: none,
    $
      prob(L_n = X_k) &= limits(integral)_0^oo prob(inter.big_(j!=k)(X_k < X_j) | X_k = x) f_(X_k) (x) space d x \
      &= limits(integral)_0^oo prob(inter.big_(j != k) X_j > x) f_(X_k) (x) space d x = limits(integral)_0^oo (limits(product)_(j!=k) e^(- lambda_j x)) space (lambda_k e^(- lambda_k x)) space d x \
      &= lambda_k limits(integral)_0^oo e^(- (lambda_1, ..., lambda_n)x) space d x = lambda_k / (sum_(j=1)^n lambda_j)
    $,
  )

  where we switched from the first to the second equality by noticing that the all the $X_j$'s are independent from the conditioning event $X_k = x$. It is clear that $sum_(k=1)^n prob(L_n = X_k) = 1$.
]

The above result can actually be generalized to the case in which we have a countably infinite number of independent exponential random variables. If the same of the parameters converges to a finite value, say $lambda$, when we have that:

#math.equation(
  block: true,
  numbering: none,
  $
    prob(L_n = x) = lambda_k / lambda quad "where" lambda = limits(sum)_(j=1)^infinity lambda_j < infinity
  $,
)

#warning-box[
  The same reasoning *cannot* be applied to the *maximum* of two or more independent exponential random variables. Indeed:

  #math.equation(
    block: true,
    numbering: none,
    $
      prob(max{X_1, X_2} <= x) & = prob(X_1 <= x"," X_2 <= x) = prob(X_1 <= x) space prob(X_2 <= x) \
                               & = (1 - e^(- lambda_1 x)) space (1 - e^(- lambda_2 x))
    $,
  )

  which cannot be simplified to the c.d.f. of an exponential random variable. Intuitively, this happens because we cannot reduce the c.d.f to a survival function as we did in the original case with the minimum.
]

== Gamma Distribution
When dealing with discrete random variables, we have seen how, given a Bernoulli trial and a series of independent repetitions of it, we can define more and more complex distributions, arriving at the negative binomial distribution, which models the number of trials until a fixed number of successes is observed, which in practice is the sum of independent geometric random variables.

Now we are going to se how, starting from a bunch of independent exponential random variables, we can define a more general distribution, called the *Gamma distribution*, which models the behavior of their sum.

#definition(title: "Gamma Distribution")[
  Let $X_1, X_2, ..., X_n$ be independent exponential random variables with parameter $lambda$. The *Gamma distribution* with parameters $alpha = n$, $lambda = lambda$ serves to model the distribution of the sum $Y = X_1 + X_2 + ... + X_n$. We write $Y ~ "Gamma"(alpha, lambda)$.
]

The parameter $alpha$ is often called the *shape parameter*, while $lambda$ is called the *rate parameter*. We can notice that when $alpha = 1$ we have that the Gamma distribution reduces to the Exponential distribution.

==== Probability Density Function
The *probability density function* of a Gamma random variable with parameters $alpha, lambda$ is defined as follows:

#math.equation(
  block: true,
  $
    f_X (x) = (lambda^alpha) / Gamma(alpha) space x^(alpha - 1) e^(- lambda x) quad forall x > 0
  $,
)<eq_03_gamma_pdf>

Intuitively the factor $x^(alpha-1)$ is used to gradually decrease the speed of the exponential decay, this is mainly the reason why, for the shape parameter $alpha = 1$ the distribution reduces to the exponential one. @fig_0302_gamma shows how the $alpha$ parameter affects the shape of the p.d.f. of a Gamma random variable.


#figure(
  image("/assets/0302_gamma.png", width: 50%),
  caption: "Probability density function of a Gamma random variable for different values of the shape parameter"
)<fig_0302_gamma>

===== Gamma Function
In the above definition we have used the *Gamma function* $Gamma(alpha)$ which can be seen as a generalization of the factorial function to real numbers. Suppose we are to write an algorithm that computes the factorial of a number $n$: in this case we must proceed *recursively*, since the factorial is defined by induction.

For the Gamma function we are going to proceed similarly, the only difference is that we are going to define it for any $alpha in bb(R)$. One may therefore think that we can define it as follows:

#math.equation(
  block: true,
  numbering: none,
  $
    Gamma(alpha) = alpha dot Gamma(alpha - 1)
  $,
)

The problem is the *starting point* (the base case of induction). This was easy in case of the factorial in that we stopped when reaching $0! = 1$. Here we need to proceed differently, before defining the function formally it is important to start from the mathematica (probabilistic, actually) motivation behind it. 
Consider a random variable with the following probability density function:


#math.equation(
  block: true,
  numbering: none,
  $
    f_X (x) = k space x^(alpha - 1) e^(- lambda x) quad forall alpha, x > 0
  $,
)

where $k$ is a normalizing constant that makes the area under the curve equal to 1. To find the value of $k$ we need to solve the following integral.

#math.equation(
  block: true,
  numbering: none,
  $
    1 = k limits(integral)_0^oo x^(alpha - 1) space e^(- lambda x) space d x
  $,
)

To solve this we proceed by parts, identifying the following: $cases(u = x^(alpha-1)"," d u = (alpha - 1)x^(alpha-2), d v = e^(-lambda x) d x"," v = -e^(-lambda x) / lambda)$. If $alpha = n$, integration by parts takes us to the following:

#math.equation(
  block: true,
  numbering: none,
  $
    1/k = limits(integral)_0^oo x^(n-1) &space e^(-lambda x) space d x = coleq(#orange, [x^(n-1) e^(-lambda x) / (-lambda)]_0^oo) coleq(#blue, -) limits(integral)_0^oo coleq(#blue, (n-1))x^(n-2) space e^(-lambda x)/coleq(#blue, (-lambda)) \
    &= coleq(#orange, 0) coleq(#blue, + (n-1)/lambda) limits(integral)_0^oo x^(n-2) space e^(-lambda x) space d x \
    &= (n-1)(n-2)/lambda^2 limits(integral)_0^oo x^(n-3) space e^(-lambda x) space d x = ... = (n-1)! / lambda^(n)
  $,
)

Therefore we can conclude that $k = lambda^n / (n-1)!$. This is not the normalization factor we find in @eq_03_gamma_pdf, that's because this is only valid in case $alpha$ is an integer.

When lambda is not an integer, the exponent of the $x$'s that get derived inside the integration by parts will not reach $0$ and we will not be able to stop the process, instead they may reach negative values. In general we have that the equation

#math.equation(
  block: true,
  numbering: none,
  $
    1/k = limits(integral)_0^oo x^(alpha - 1) space e^(- lambda x) space d x
  $,
)

has not a closed (analytical) form solution for any $alpha$. To solve this, a named function has been defined, called the *Gamma function*, which has actually been computed by setting *$lambda = 1$* and is defined as $Gamma(z) = limits(integral)_0^oo t^(z - 1) e^(-t) space d t$.

==== Expected Value and Variance
Following we are going to provide the formulas to compute the expected value and the variance of a Gamma random variable with parameters $alpha, lambda$.

#math.equation(
  block: true,
  $
    exp(X) = alpha / lambda quad quad quad var(X) = alpha / lambda^2
  $,
)

==== Additivity of Exponential Random Variables
Now that we have defined the Gamma distribution it is important to mention that, if we have $n$ independent random variables $X_j ~ "Exp"(lambda)$ for $j = 1, 2, ..., n$, then their sum $S_n = X_1 + X_2 + ... + X_n$ is a Gamma random variable with parameters $alpha = n$ and $lambda = lambda$.

==== R Implementation
As usual, in `R` we have the following functions to work with Gamma random variables:
- `dgamma(x, shape, rate)` $= f_X (x)$, is the probability density function 
- `pgamma(x, shape, rate)` $= prob(X <= x)$, is the cumulative distribution function 
- `qgamma(q, shape, rate)` $= x = F^(-1)(q)$, i.e., $prob(X <= x) = q$, the quantile function
- `rgamma(r, shape, rate)` simulates $r$ realizations of $X$. 