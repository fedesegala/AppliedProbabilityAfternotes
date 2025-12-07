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

