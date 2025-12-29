#import "@preview/theorion:0.4.1": *
#import cosmos.fancy: *
#show: show-theorion
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#import "../../lib.typ": *
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
