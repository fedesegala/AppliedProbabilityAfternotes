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

= Introduction to Stochastic Processes 
After introducing the basic elements we are going to work with, we can present the really interesting objects that are going to make use of the previously introduced building blocks: *stochastic process*. This chapter provides an introduction to stochastic processes and some of their properties. 

== Central Limit Theorem and Law of Large Numbers
Before actually defining stochastic processes, it is fundamental to introduce two key results in probability theory that are essential for understanding the behavior of stochastic processes: the *Central Limit Theorem* and the *Law of Large Numbers*. These theorems provide insights into how random variables behave when aggregated over time or across many trials. 

=== Central Limit Theorem 
Let us consider a sequence of random variables $X_1, X_2, X_3, ...$ and the *sum* of their first $n$ elements. As we have seen in the previous chapter, this is again a random variable: 

#math.equation(block: true, numbering:none,
$
S_n = X_1 + X_2 + ... + X_n
$)

We should already be familiar with the following facts: 

- if all random variables $X_i$ have a *common mean* $mu = exp(X_i)$, then the expected value of the sum is given by: $exp(S_n) n mu$

- if all random variables $X_i$ are *independent* and have a *common variance* $sigma^2 = var(X_i)$, then the variance of the sum is given by: $var(S_n) = n sigma^2$

We would now like to investigate what we can say about the sequence of sums $S_1, S_2, S_3, ...$ as the number $n$ of them grows. To work this out, let's consider the $n$ standard normal random variables $X_i limits(~)^"i.i.d" N(0,1)$ for which we know that $exp(X_i) = 0, var(X_i) = 1$. We know that their sum $S_n$ has expected value $exp(S_n) = 0$ and variance $var(S_n) = n$. The sum we have obtained is again a Normal random variable, but it's not standard anymore since its variance is not $1$: $S_n ~ N(0, n)$. 

#figure(
image("/assets/0401_normalsum.png", width: 70%),
caption: [Sum of $n$ i.i.d. standard normal random variables. $S_n ~ cal(N)(0, n)$])<fig_0401_normalsumsingle>

@fig_0401_normalsumsingle shows the evolution of the random variable $S_n$ as $n$ increases: it is possible to notice that, the larger the n, the more the distribution of $S_n$ spreads out. 

Suppose we wanted to obtain a new value $S_(n+1)$, this would be given by the sum of $S_n$ and a new independent standard normal random variable $X_(n+1)$. We know that $S_n, X_(n+1)$ are independent, but the newly obtained sum $S_(n+1)$ is not independent of $S_n$: 

#math.equation(block: true, numbering:none,
$
exp(S_(n+1) | S_n) = exp(S_n) + exp(X_(n+1)) = S_n + 0 = S_n \
var(S_(n+1) | S_n) = 1 " since " S_n " is now fixed" \
==> S_(n+1) | S_n ~ cal(N)(S_n, 1)
$)

In _time series analysis_ this is called an *autoregressive process*. We discussed in some of the previous chapters that for sums of independent random variables we have that $S_(n+1) | S_n$ is independent of all the previous ones. This means we can write the *joint distribution* of $S_1, ..., S_n$ as follows: 

#math.equation(block: true,
$
f_(S_1"," ..."," S_n)(s_1, ..., s_n) &= f_(S_1)(s_1) f_(S_2 | S_1)(s_2 | s_1) f_(S_3 | S_2)(s_3 | s_2) space ... \
&= cal(N)(0,1) dot cal(N)(s_1, 1) dot cal(N)(s_2, 1) ... cal(N)(s_(n-1), 1) 
$)

This is not the same as having $n$ independent random variables each with marginal distribution $cal(N)(0,n)$. To better understand this, let's look at @fig_0402_multiplecumsums (left side) which shows some realizations of the sums of $n$ i.i.d. standard normal random variables as the value of $n$ increases. This is in strong contrast with what we have obtained in the right side of the figure, where we showcased the behavior of $n$ independent random variables each with distribution $cal(N)(0,n)$.

#figure(
  grid(
    columns: 2,
    align: horizon,
    image("/assets/0402_multiple_cumsums.png"),
    image("/assets/0403_single_independentpath.png", width: 90%)
  ),
  caption: [On the left: multiple realizations of the sum of $n$ i.i.d. standard normal random variables. On the right: values obtained by simulating $n$ a random variable $Y ~ cal(N)(0,n)$ independently as the value of $n$ increases.]
)<fig_0402_multiplecumsums>

It is evident that the left side of the figure represents a much more "tidy" behavior compared to the right side. This is because, in the left side, each new value is dependent on the previous one, while in the right side each value is completely independent of the previous ones and may strongly vary w.r.t. the previous one. 