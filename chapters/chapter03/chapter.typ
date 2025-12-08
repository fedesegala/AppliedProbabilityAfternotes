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
      q = 1 - p space space & "if" space x = 0 \
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

Now that we have defined all the important characteristics of a Bernoulli random variable, we can try to use is to model some more complex experiment. Suppose for example that we want to *replicate* a bernoulli trial multiple times, say $n$ and each of those trials is independent, this is how we get a *Binomial distribution*.

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

where $I_i$ is an indicator that *at least* $i$ trials are needed to get the first success. We can compute the expected value of $X$ as follows:

#math.equation(
  block: true,
  numbering: none,
  $
    exp(X) = exp(limits(sum)_(i=1)^infinity exp(I_i)) = limits(sum)_(i=1)^infinity prob(X >= i)
  $,
)

but $prob(X >= i)$ is the probability that the first $i - 1$ trials are failures, so $prob(X >= i) = (1 - p)^(i-1)$ therefore we have:

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

== Hypergeometric Distribution
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
Let $X$ be a hypergeometric random variable with p.m.f. given by $"hyper geom"(x, n, N, M)$, then we can define its expected value and variance as follows:

#math.equation(
  block: true,
  $
    exp(X) = n dot M/N quad quad quad var(X) = (N - n)/(N - 1) dot n dot M/N (1 - M/N)
  $,
)
