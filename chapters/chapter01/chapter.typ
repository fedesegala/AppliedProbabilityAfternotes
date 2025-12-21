#import "@preview/theorion:0.4.1": *
#import cosmos.fancy: *
#show: show-theorion
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#import "../../lib.typ": *

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
  numbering("(1.1)", chapter, num)
})

// Resetta i contatori ad ogni nuovo capitolo
#show heading.where(level: 1): it => {
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
  counter(math.equation).update(0)
  it
}

= Overview of Elementary Probability
This chapter is focused on providing a concise overview of some fundamental concepts in probability theory that will be essential for understanding more advanced topics that will be presented in the following chapters.

== Sample Space and Events
This section is focused on providing a clear understanding of the concepts of *sample space* and *events*, which are foundational elements in probability theory. It will first introduce the definitions and then provide some examples to better understand these concepts.

#definition(title: "Sample Space and Events")[
  A collection of all elementary results, or *outcomes* of an experiment, is called a *sample space*. Any set of _outcomes_ from the sample space is called an *event*. In other words, we can state that an event can be viewed as an *arbitrary subset* of the sample space.
]

Following we introduce some common _notation_ that will be used throughout the notes for referring to specific concepts:

- $Omega, S$ are typically used to denote the *sample space*.
- $emptyset$ is typically used to denote the empty set or event
- $A, B, E$ and other _capital letters_ are used for events
- $omega, s$ are going to be used for *individual outcomes*
- we will use the notation #$bb(P)[E]$ or $P[E]$ to denote the *probability* of an event

#remark[One important aspect to consider about the empty set $emptyset$ is that it belongs to any sample space, i.e., $emptyset in Omega space forall Omega$.]

#remark[Regarding events and individual outcomes it is important to remember that $E subset Omega$ and that, to distinguish between an event with a single outcome and the outcome itself we have respectively $omega in Omega$ and ${omega} subset Omega$.]

#example-box("Simple Die Toss", [
  Suppose a tossed die can produce one of 6 possible outcomes: 1 dot, through 6 dots. Each outcome is an *event*. Anyway there are other possible events, such as 'observing an even number of dots', a number of dots which is less than 4, an so on.
])

=== Some examples of Sample Spaces

#exercise[
  Two identical birds are initially on two nearby trees (A and B respectively). At random intervals, a sudden noise frightens one of the birds, making it fly to the other tree. At each event, each bird has the same probability of being the one frightened and changing tree. Find the *sample space* if _only the number of birds on tree A_ is considered.
]

#solution[
  Since the problem asks for the sample space in terms of number of birds on a specific tree, i.e., A. Tree A can have either 0, 1, or 2 birds; Therefore the sample space is $Omega = {0,1,2}$.
]

#remark[It is important to notice that we are only interested in the number of birds on a specific tree; therefore the sample space will be independent on other birds features, such as their color, size, and so on, so forth.]

#exercise[
  Let's make things more complicated, if we were to consider both the number of birds on tree A and on tree B, what would be the sample space?
]

#solution[
  Each event in this case, can be represented as a *tuple* of the form $(x,y)$, where $x$ is the number of birds on tree A and $y$ is the number of birds on tree B. Therefore the possible events are: $Omega = {(0,2), (1,1), (0,2)}$.
]

Taking into account the assignment of the previous exercises, we can notice that there are two important aspects to consider:

- the sudden noise occurs at *random intervals*
- the happening of the noise can be considered an *event*. At *each event*, each bird has the same probability of moving

Clearly, the concept we have failed to represent so far is *time*. To be more precise, we can write the sample spaces prior to any noise event as respectively: $Omega_0 = {0,1,2}$ and $Omega_0 = {(0,2), (1,1), (2,0)}$.

If we wanted to describe the *full experiment* we would need to descrive an *infinite sequence* of states. This is what's called a *random sequence*. We can briefly describe it as in @eq:01_infinite_sample_space.

#math.equation(
  block: true,
  numbering: "(1)",
  $Omega = {(x_0, x_1, x_2, ...) | x_i in Omega_0 space forall i in bb(N)}$,
)<eq:01_infinite_sample_space>

#tip-box[Before starting to solve any kind of probability problem, also during the exam, always start by *defining* the *sample space*. This is a fundamental step that will help at better understanding the problem and avoid mistakes throughout the solution process.]

Once we have defined the sample space, we can start defining *events*. For example, suppose the event $A$ stands to represent the case when "initially both birds are on tree B": $A = {(0,2)}$.
Provided we have this information, @eq:02_conditioned_sample_space shows the sample space for the presence on *tree A* conditioned on the fact that the starting position is the one described by $A$.

#math.equation(
  block: true,
  numbering: "(1)",
  $Omega_A = {0,1,x_3,1,x_4, ... | x_i in {0,2}} subset Omega$,
)<eq:02_conditioned_sample_space>

=== Discrete vs Continuous Sample Spaces
One additional important aspect to consider is the *countability* of the sample space. Indeed we may find ourselves working with either *discrete* or *continuous* sample spaces. A discrete sample space is one that is either _finite_ or _countably infinite_, meaning that its elements can be put into a one-to-one correspondence with the natural numbers. On the other hand, a continuous sample space contains an uncountably infinite number of outcomes, often represented by intervals of real numbers.

For instance, the time between consecutive noise events in the previous example could be modeled by means of a _continuous sample space_: $Omega = {t_0, t_1, t_2, ... | t_j in bb(R)^+}$.

Instead of recording the birds' positions only after each noise event, we could decide to record their positions *continuously over time*. In this case the sample space would become:

#math.equation(
  block: true,
  numbering: none,
  $Omega = {(X_t)_(t>=0) : x_t in {0,1,2}},$,
)

where at any given point in time $t$, $X_t$ represents the number of birds on tree A.

== Basic Set Operations for Events
This section is focused on introducing some basic set operations that can be performed on events. Since events are subsets of the sample space, we can apply standard set operations such as union, intersection, and complement to them.

==== Union of Events
The *union* of two events $A$ and $B$, denoted by $A union B$, represents the event that either event $A$ occurs, event $B$ occurs, or both events occur. In other words, the union of events includes all outcomes that are in either event.

==== Intersection of Events
The *intersection* of two events $A$ and $B$, denoted by $A inter B$ , represents the event that both event $A$ and event $B$ occur simultaneously. The intersection of events includes only those outcomes that are common to both events.

==== Complement of an Event
The *complement* of an event $A$, denoted by $overline(A)$, represents the event that event $A$ does not occur. The complement of an event includes all outcomes that are in the sample space but not in event $A$.

#definition(title: "Set Difference")[
  Given two sets $A$ and $B$, the *set difference* of $A$ and $B$, denoted by $A \\ B$, is defined as the set of elements that are in $A$ but not in $B$. Formally, it can be expressed as:

  #align(center)[
    $A \\ B = A inter overline(B)$  ]
]

==== De Morgan's Laws
De Morgan's Laws provide a relationship between the union and intersection of sets through complementation.

#theorem(title: "The Morgan 1st Law")[
  Given sets $E_1, ..., E_n$, the complement of their union is equal to the intersection of their complements:

  #align(center)[
    $overline(E_1 union E_2 union ... union E_n) = overline(E)_1 inter overline(E)_2 inter ... inter overline(E_n)$
  ]
]

#theorem(title: "The Morgan 2nd Law")[
  Given sets $E_1, ..., E_n$, the complement of their intersection is equal to the union of their complements:

  #align(center)[
    $overline(E_1 inter E_2 inter ... inter E_n) = overline(E)_1 union overline(E)_2 union ... union overline(E_n)$
  ]
]

==== Disjoint and Exhaustive Events
There are two important concepts related to events that are worth mentioning: *disjoint* and *exhaustive* events.

#definition(title: "Disjoint Events")[
  Events A and B are *disjoint* if their intersection is empty:

  #align(center)[
    $A inter B$ = emptyset
  ]

  Events $E_1, E_2, ...$ are *mutually exclusive* or *pairwise disjoint* if any two of these events are disjoint:

  #align(center)[
    $E_i inter E_j = emptyset space forall i != j$
  ]
]

#definition(title: "Exhaustive Events")[
  A collection of events $E_1, E_2, ...$ is said to be *exhaustive* if their union covers the entire sample space:

  #align(center)[
    $E_1 union E_2 union ... = Omega$
  ]
]

==== Partitions of the Sample Space
Defining mutual exclusivity and exhaustivity allows us to introduce the concept of *partitions* of the sample space. This is a useful concept when dealing with events that cover the entire sample space without overlapping.

We say that a collection of *mutually exclusive* and *exhaustive* events $E_1, E_2, ...$ forms a *partition* of the sample space $Omega$. This concept is clearly shown in @fig:01_partition

#figure(
  image("images/01_partition.png", width: 40%),
  caption: "Example of a partition of the sample space",
)<fig:01_partition>

#remark[Any event $A subset Omega$ can be written in terms of the union of its intersections with the elements of the partition. This is illustrated in @fig:02_event_partition:

  #math.equation(block: true, numbering: "(1)", $A = (A inter B_1) union (A inter B_2) union (A inter B_3)$)
]

#figure(
  image("images/02_event_partition.png", width: 40%),
  caption: "Event represented in terms of a partition of the sample space",
)<fig:02_event_partition>


== Definition of Probability
In this section we are going to try to provide a formal definition for the notion of *probability*. First of all the reason why we introduced sample spaces and events in the first place, is that events are the entities for which we can compute _probabilities_.

In a very coarse way, we can think of probability as a *measure* that assigns to each event a number between 0 and 1, representing the *likelihood* of that event occurring. In a more technical language, a probability is a *function* which maps each event from the sample space to a real number in the interval [0, 1].

==== A little Digression
In mathematics, a function che be described as the following:

#math.equation(
  block: true,
  numbering: none,
  $
    f(x) = sin(x) \
    f: bb(R) arrow [-1, 1]
  $,
)

We can see that we need to define both the *domain* and the *codomain* of the function along with the *rule* that describes how to map elements from the domain to elements in the codomain. Since probability is a function we'll need to do the same for it.

==== Sigma Algebra
Now that we have seen how a probability can be seen as a function, to formally define it, we need to specify its domain, codomain, and the mapping rule. This will give us a solid foundation to work with probabilities in a rigorous manner.

As per the *codomain*, we have already mentioned that probabilities are real numbers in the interval $[0,1] in bb(R)$.  The matter becomes a little bit more complicated when it comes to defining the *domain*. We can imagine the domain of the probability function as a _collection of events_ with some specific properties. This collection is called a *sigma-algebra* (or *σ-algebra*). Typically, a sigma-algebra is denoted by the symbol $frak(M)$.

#definition(title: "Sigma Algebra")[
  A collection $frak(M)$ of events is a *#sym.sigma - algebra* on a sample space $Omega$ if:

  - it includes the sample space:
  #align(center)[
    $Omega in frak(M)$
  ]
  - every event in $frak(M)$ is contained along with its complement:
  #align(center)[$E in frak(M) => overline(E) in frak(M)$]
  - every finite or countable collection of events in $frak(M)$ is contained along with its union:
  #align(center)[
    $E_1, E_2, ... in frak(M) => E_1 union E_2 union ... in frak(M)$
  ]
]<def:02_sigma_algebra>

We can notice the following important aspects about sigma-algebras:

- $frak(M) = {emptyset, Omega}$ is the smallest possible sigma-algebra on $Omega$, called *degenerate*
- $frak(M) = 2^Omega = {E : E subset Omega}$ is the largest possible sigma-algebra on $Omega$, called *power set*


#remark[
  When $Omega subset.eq bb(N)$, is *countable* the most common choice for the associated sigma algebra is the *power set* $frak(M) = 2^Omega$.

  On the other hand, when dealing with *uncountable* $Omega subset.eq bb(R)$, the power set _too large_ to be useful. In this case a common choice for the sigma-algebra is the *Borel Sigma Algebra*, denoted by $cal(B)$, which contains all possible sets that one could practically think about except for everything that could get created by some strange recursive process that resembles the construction of _fractals_.
]

#pagebreak()

==== Axiomatic Definition of Probability
Now that we have defined the sigma-algebra, we can finally provide a formal definition of probability.
#definition(title: "Probability")[
  Assume a sample space #sym.Omega and a sigma-algebra of events $frak(M)$ defined on it. *Probability*

  #math.equation(block: true, $bb(P) -> [0,1]$)

  is a function of events with the domain $frak(M)$ and the range $[0,1]$ that satisfies the following conditions (which are called the *axioms of probability*):

  - *Unit Measure*: the sample space has unit probability: $bb(P)[Omega] = 1$
  - *Sigma-Additivity*: for any finite or countable collection of mutually exclusive events $E_1, E_2, ... in frak(M)$, the probability of their union is equal to the sum of their individual probabilities:
  #align(center)[
    $bb(P)[E_1 union E_2 union ...] = bb(P)[E_1] + bb(P)[E_2] + ...$
  ]
]<def:03_probability>

It is good to notice that, from the first properties, we can derive that the computing the probability of the sample space amounts to say: '_something happened'_. The second property becomes fundamental when dealing with events that can be broken down into simpler, mutually exclusive events, allowing us to compute their probabilities more easily.


All rules of probability are a direct consequence of @def:03_probability. This will allow us to compute probabilities for all events in our interest. Following we outline some of the most important probability rules that will be useful in the next chapters.

- $bb(P)[emptyset] = 0$: this is easy to verify; indeed the we know from the axioms that $bb(P)[Omega] = 1$. From the second axiom we know that the union of any disjoint event has probability equal to their sum, that is $bb(P)(Omega) + bb(P)[emptyset] = 1 => bb(P)[emptyset] = 0$
- $bb(P)[A union B] = bb(P)[A] + bb(P)[B] - bb(P)[A inter B]$; we can actually notice that the following relation holds: $bb(P)[A union B] = bb(P)[A inter overline(B)] + bb(P)[B inter overline(A)] + bb(P)[A inter B]$.

We can see how the second formulation is supported by the second axiom in that the three members of the summation form a *partition* of the event $A union B$. The reason why the first formulation is commonly preferred, is that that, if $A$ and $B$ are *independent* the probability of their intersection is given by $bb(P)[A]bb(P)[B]$.

Intuitively, saying that two experiments are independent means that the outcome of one does not affect the outcome of the other one. To be more formal we should also consider that the occurrence of an event doesn't even influence the events' probability in the other experiment.

We would even like to be more formal about the definition of independency but it's not possible without first introducing the concept of *conditional probability*.

==== Inclusion - Exclusion Principle
There are many cases in which we may be interested in computing the probability (or the amount of elements) of the union of multiple events. We already know how to do that in case of two events. In case we have three or more events we can generalize through the *Inclusion-Exclusion Principle*.We know that in the two event case we have:

#math.equation(
  block: true,
  numbering: none,
  $text("count")(A_1 union A_2) = text("count")(A_1) + text("count")(A_2) - text("count")(A_1 inter A_2)$,
)

Suppose now that we have three non-disjoint events $A_1, A_2, A_3$ as represented in .

The number elements in the union in such case would be given by:

#math.equation(
  block: true,
  numbering: none,
  $text("count")(union.big_(i=1)^3 A_i) = sum_(i=1)^3 text("count")(A_i) - sum_(i<j)text("count")(A_i inter A_j) + text("count")(inter.big_(i=1)^3A_i)$,
)
#figure(
  image("images/04_inclusion_exclusion.png", width: 70%),
  caption: "Three non-disjoint events",
)<fig:04_inclusion_exclusion>

We are not going to see the full generalized version of the formula, mainly because it is so ugly. Anyway as a general principle we can say that to compute the count of the union multiple events:

- we first sum the counts of each individual event
- we subtract the counts ef each pairwise union (even number of events)
- we add back the counts of each triple-wise union (odd number of events)
- we keep on alternating between subtracting the count of "even-unions" and adding the count of "odd-unions" until we reach the union of all events

#pagebreak()

== Conditional Probability
After defining the basic notion of probability, it's time to move on to a slightly more powerful concept, which is the one of *conditional probability*. The following definition gives us a way to compute conditional probabilities of two events.

#definition(title: "Conditional Probability")[
  Given two events $A$ and $B$ we can define the conditional probability of one event _given_ that the other one has occurred as follows:

  #math.equation(block: true, $prob(A|B) = (prob(A inter B)) / (prob(B))$)<eq:03_cond_prob>
]

To understand the meaning of @eq:03_cond_prob we can consider the following example.

#example-box("Computation of conditional probability", [
  Suppose we throw a die 2 times and observe that the sum is 7. We can assert the following:

  - the probability that the event $(6,6)$ happened is 0, since it is impossible to obtain a 7 with $(6,6)$
  - the probability the rolling $(3,4)$ can be computed even without looking at @eq:03_cond_prob. Indeed if we know that the sum of the tosses is 7, we can manually compute the sample space: ${(1,6), (2,5), (3,4), (4,3), (5,2), (6,1)}$. By simply noticing that the event $(3,4)$ is present only once in the sample space we conclude that its probability is given by $1/6$.
])

==== Formula Derivation
The reason behind the formulation of @eq:03_cond_prob is the following: before an experiment the sample space $Omega$ is the set of all possible experiments outcomes. Due to the fact that we are considering a probability we are dealing with a sigma algebra $frak(M)$, we can make safely state the following:

#align(center)[
  $A,B in frak(M) => A inter B in frak(M) => prob(A), prob(B), prob(A inter B) text("are known")$
]

or at least can be computed in some way. We can say that #text(fill: red)[$bb(P): frak(M) -> [0,1]$] is a #text(fill: red)[*prior probability*]. If now we perform the experiment and know that $B$ happens we can update the probability to incorporate the new knowledge by computing a new #text(fill: blue)[$bb(P) | B: frak(M) -> [0,1]$], a #text(fill: blue)[*posterior probability*]. In practical terms, if $B$ happened, $overline(B)$ becomes impossible and we can *restrict our sample space* to only those outcomes in which $B$ happens. Therefore the new sample space becomes $Omega_B = {omega in Omega | omega in B}$.

Let's understand the reason why we need to divide by $prob(B)$ in @eq:03_cond_prob:

- suppose we are interested in the whole sample space $Omega$

- prior to knowing that $B$ happened, the probability of $Omega$ is obviously 1: $prob(Omega) = 1$

- after knowing that $B$ happened, the new sample space becomes $Omega_B$ = $Omega inter B = B$


- since the new sample space is $Omega inter B$, its probability must still be 1: $prob(Omega inter B) = 1$, but since $Omega inter B = B$ we have that $prob(B | B) = 1$


- since we want to make sure that $prob(B | B) = 1$ we can compute $prob(Omega inter B)/prob(B) = 1$, in order to normalize the probability to 1

We can now focus on the single posterior probability of the event $A$ given that $B$ happened following a similar reasoning:

- for any event $A$ prior to knowing that $B$ happened, its probability is given by $prob(A)$

- after knowing that $B$ happened, the new sample space becomes $Omega_B$ = $Omega inter B = B$

- since we need to compute the probability of $A$ in the new sample space, we need to restrict $A$ to only those outcomes in which $B$ happens, therefore the new event becomes $A inter B$. Thus the probability of $A$ in the new sample space becomes $prob(A inter B)$

- to scale everything back to the previous sample space we need to divide by $prob(B)$.

The previous reasoning is clearly represented in the Venn diagram shown in @fig:03_condprob.
#figure(
  image("images/03_condprob.png", width: 60%),
  caption: "Venn diagram representation of conditional probability",
)<fig:03_condprob>


We are now ready to provide a formal definition of independency between two events.

#definition(title: "Independent Events")[
  Given two events $A$ and $B$, we say that they are independent if by knowing that one event has changed the probability of the other event remains the same. Formally, this can be expressed as:

  #math.equation(block: true, $prob(A | B) = prob(A inter B)/prob(B) = prob(A)$)<eq:04_independent_events>
]

#warning-box[Although the notions of independency and disjointedness may seem similar at a first glance, they are actually the *opposite*. Indeed if two events are disjoint, the occurrence of one event implies that the other event cannot occur, which means that knowing one event has occurred changes the probability of the other event to zero. Therefore, disjoint events are not independent.]

From the previous definition we can derive the following important relation for independent events.

#theorem[Given two independent events $A, B$ we can look at their definition in order to derive a different formulation for their intersection:

  #math.equation(block: true, $prob(A inter B) = prob(A) prob(B)$)<eq:05_independent_events_intersection>
]

== Conditional Probability and Bayes' theorem
This section will introduce one of the most important results in all probability theory. Before doing so, we show a couple of examples.

=== Exercise - Crashes in a Computer Program (Baron 2.35)

===== Problem Statement
A new computer program consists of two modules. The first module contains an error with probability 0.2. The second module is more complex and has a probability of 0.4 of containing an error, _independently of the first one_.

An error in the first module alone causes the program to crash with probability 0.5. For the second module, an error causes a crash with probability 0.8. If there are errors in both modules the probability of a crash rises to 0.9. Suppose that the program has crashed. What is the probability of error in both modules? #sym.qed

===== Definition of the Sample Space and Sigma Algebra
Let's first try to map all the information provided into terms we are already familiar with. The *experiment* basically consists in running the program. The *sample space $Omega$* should contain all results of this experiment, that is, the program itself and the result of executing it. We can notice how this. Since the experiment is very complicated it makes sense to try and focus only on relevant outcomes. Let's list all the relevant events that must be included in our *sigma algebra*:

- $E_1$: module 1 contains an error$-> overline(E)_1 in frak(M)$  (by $sigma$-algebra properties)

- $E_2$: module 2 contains an error $-> overline(E)_2 in frak(M)$  (by $sigma$-algebra properties)

- $Omega$: any event happens $-> emptyset in frak(M)$  (by $sigma$-algebra properties)

- $C$: program crashes $-> overline(C) in frak(M)$  (by $sigma$-algebra properties)

By the properties of sigma algebras we can also state the following events must be included in $frak(M)$:
- $E_1 union E_2 in frak(M)$, since sigma algebras are closed under union

- $overline(E_1 union E_2) in frak(M)$, since sigma algebras are closed under complement

- $overline(E)_1 inter overline(E)_2 in frak(M)$, by applying De Morgan laws

The same rational can be applied starting from the complement events. Therefore the sigma algebra will also contain $E_1 inter E_2$. Notice that by simply considering the events $E_1, E_2, C$ we can already keep track of all the possible events we may be interested in ($C inter E_1, C inter E_2, ...$).

===== Information Extraction
Let's now try to extract valuable information from the problem statement:

- $prob(E_1) = 0.2$

- $prob(E_2) = 0.4$

Since $E_1 tack.t space E_2$ we can use @eq:05_independent_events_intersection to compute the probability of their intersection: $prob(E_1 inter E_2) = prob(E_1) prob(E_2) = 0.08$. The problem also provides us with the following information:

- $prob(C | E_1 inter overline(E)_2) = 0.5$: crash given an error on first module alone

- $prob(C | overline(E)_1 inter E_2) = 0.8$: crash given an error on second module alone

- $prob(C | E_1 inter E_2) = 0.9$: crash given an error on both modules

===== Information Organization
Now that we have extracted all the relevant information from the problem statement, we can try to organize it in a more structured way. The main approach in order to compute probability is _divide and conquer_. So what we do is trying to divide our events in the smallest possible pieces, that are mutually exclusive and that cover the whole space. This amounts to finding *relevant partitions*. Consider the following picture:

#align(center)[
  #image("images/06_baronex.png", width: 60%)
]
One partition we can consider is the one given by the events $E_1, E_2$ combined and their complements:

- $B_1 = overline(E)_1 inter overline(E)_2 <-> overline(E_1 union E_2)$: this represents the case in which no module has an error

- $B_2 = E_1 inter overline(E)_2$: this represents the case in which only the first module has an error

- $B_3 = overline(E)_1 inter E_2$: this represents the case in which only the second module has an error

- $B_4 = E_1 inter E_2$: this represents the case in which both modules have an error

We can easily notice that these events $(B_1, B_2, B_3, B_4)$ are mutually exclusive and span the whole sample space. Therefore they form a partition of the sample space. Another partition we can consider is the one given by the crash event and its complement: $(C, overline(C))$.

In order to divide and conquer, we can *identify* the *partition* for which we have *prior probabilities* (probabilities which are not conditioned on other events) and the ones for which we need to compute *conditional probabilities*. This step allows us to _find a logical temporal order of events_. In our case we can notice that we have prior probabilities for the events in the partition $(B_1, B_2, B_3, B_4)$ and conditional probabilities for the events in the partition $(C, overline(C))$.

Now we can *compute* the *available probabilities* from the basic information we have extracted. First we can compute the probability of the _intersection_ $B_4 = E_1 inter E_2$:

#math.equation(numbering: none, block: true, $prob(B_4) = prob(E_1 inter E_2) = prob(E_1) prob(E_2) = 0.08$)

Now we would like to compute the probability of $B_1$, for doing so we need the probability of the union, that we can compute as follows:

#math.equation(
  block: true,
  numbering: none,
  $prob(E_1 union E_2) = prob(E_1) + prob(E_2) - prob(E_1 inter E_2) = 0.2 + 0.4 - 0.08 = 0.52$,
)

Thus, the probability of the event $B_1$ becomes: $prob(B_1) = 1 - prob(E_1 union E_2) = 1 - 0.52 = 0.48$.

To compute the probability of $B_2$ we need to compute the following:

- $prob(B_2) = prob(E_1 inter overline(E)_2)$, since $E_1 perp E_2$, then also $E_1 perp overline(E)_2$, therefore we can apply @eq:05_independent_events_intersection and compute: $prob(E_1 inter overline(E)_2) = prob(E_1) prob(overline(E)_2) = 0.2(1-0.4)=0.12$

- the same reasoning can be applied to compute $B_3$, for completeness though, we can also compute both $B_2, B_3$ as follows ($B_3$ case):

#math.equation(
  block: true,
  numbering: none,
  $prob(B_3) = prob(E_2) - prob(E_1 inter E_2) = 0.4 - 0.08 = 0.32$,
)

#remark[Since $(B_1 ... B_4)$ form a partition we can verify that the sum of their probabilities is equal to 1: $prob(B_1) + prob(B_2) + prob(B_3) + prob(B_4) = 0.48 + 0.12 + 0.32 + 0.08 = 1$.]

Assuming that if we have no crashes the program works fine, we can produce the following diagram that summarizes all the information we have gathered so far. Tha's illustrate @fig:07_knowledge.

Now that we have all the information we have gathered we are finally ready to give a solution. Since we are asked to compute the probability of having errors in both modules given that the program has crashed. We can rewrite it in terms of our events as follows:

#math.equation(
  block: true,
  numbering: none,
  $prob(E_1 inter E_2 | C) = prob(B_4 | C)$,
)

#figure(
  image("images/07_knowledge.png", width: 80%),
  caption: "Summary of the information gathered from the problem statement and from the intermediate stages",
)<fig:07_knowledge>

We can retrieve the definition of conditional probability in @eq:03_cond_prob and apply it to our case: $prob(B_4 | C) = prob(B_4 inter C) / (prob(C))$. To do so, we need different components.

First of all we need to compute the probability of $B_4 inter C$, this can be done by backtracking on the tree in @fig:07_knowledge:

#math.equation(
  block: true,
  numbering: none,
  $prob(B_4 inter C) = prob(B_4) prob(C | B_4) = 0.08 dot 0.9 = 0.072$,
)

Now wee need to compute the probability of a crash, that is $prob(C)$, this is a slightly more complicated matter. To do so, we need to take into consideration all the possible paths that lead from the root of the tree up to node $C$. Therefore we can write:

#math.equation(
  block: true,
  numbering: none,
  $prob(C) = prob(B_1) prob(C | B_1) + prob(B_2) prob(C | B_2) + prob(B_3) prob(C | B_3) + prob(B_4) prob(C | B_4) \ = sum_(i = 1)^4 prob(B_i) prob(C | B_i) \ = 0.48 dot 0 + 0.12 dot 0.5 + 0.32 dot 0.8 + 0.08 * 0.9 = 0.388$,
)

Now that we have all the elements we need, we can finally compute the probability we were looking for:

#math.equation(
  block: true,
  numbering: none,
  $prob(B_4 | C) = (prob(B_4 inter C)) / (prob(C)) = 0.072 / 0.388 approx 0.1856 space qed$,
)

=== Law of Total Probability
Even though we didn't explicitly mentioned, while resolving the last exercise we have actually applied probably what is one of the most important results in probability theory: the *law of total probability*.

Precisely, we did it when computing the probability of a crash $prob(C)$. We can now formally state the law as follows.

#axiom(title: "Law of Total Probability")[
  Given a partition of the sample space $(B_1, B_2, ...)$ and an event $A$, the probability of $A$ can be computed as follows:

  #math.equation(
    block: true,
    $prob(A) = sum_(i) prob(B_i) prob(A | B_i)$,
  )<eq:06_law_total_probability>
]<axiom:01_law_total_probability>

This is the reason why in the previous example we spent so much time trying to compute the partition $(B_1, B_2, B_3, B_4)$. In case we have only two events we can rewrite it as follows:

#math.equation(
  block: true,
  numbering: none,
  $prob(A) = prob(A | B)prob(B) + prob(A | overline(B)) prob(overline(B))$,
)

=== Bayes' Rule
Another important result that we can derive from the definition of conditional probability is *Bayes' Rule*. This rule allows us to _reverse_ the conditioning of a probability. Formally we can state it as follows.

#theorem(title: "Bayes' Rule")[
  Given an event $A$ and a partition of the sample space $B = (B_1, B_2, ..., B_k)$, the conditional probability of $B_i in B$ given $A$ can be computed as follows:

  #math.equation(
    block: true,
    $prob(B_i | A) = (prob(A | B_i) prob(B_i)) / (sum_(j=1)^k prob(A | B_j) prob(B_j))$,
  )<eq:07_bayes_rule>
]

In particular, since $B$ and $overline(B)$ always form a partition of the sample space, we can rewrite @eq:07_bayes_rule for the case of two events as follows:
#math.equation(
  block: true,
  numbering: "(1)",
  $prob(B | A) = (prob(A | B) prob(B)) / (prob(A | B) prob(B) + prob(A | overline(B)) prob(overline(B)))$,
)<eq:08_bayes_rule_two_events>

=== Exercise - Reliability of a System (Baron 2.20)
===== Problem Statement
Consider the following system of connected components.

#align(center)[
  #image("images/05_ex.png", width: 50%)
]

Calculate the reliability of the following system if each component is operable with probability 0.92 independently of the other components #sym.qed

===== Solution
To solve the proposed problem, we need to define the sample space. In order to be as fast as possible, we can assume it being partitioned by only two events: the system works ($W$) or the system fails ($overline(W)$). To answer the question we need to compute $prob(W)$, that is, the probability that the system works, which is another way to define _reliability_.

For the system to be operational it is necessary that a 'signal' is allowed to travel from the left side to the right side of the system. In order for this to happen we can see there are basically three possible paths:

- the upper part in which the components that need to function are $A$ and $B$, we can call this situation $B_1$
- the middle part in which the components that need to function are $C$ and either one of $D$ and $E$ (or both), we can call this situation $B_2$

So, we can say that in general the probability of full functionality of the system can be defined as $prob(B_1 union B_2)$. Now that we have defined these events, we can try to compute their individual probabilities.

To compute $prob(B_1)$ we need both components $A$ and $B$ to be operational. Since the components are independent we can apply @eq:05_independent_events_intersection and compute: $prob(B_1) = prob(A) prob(B) = 0.92 dot 0.92 = 0.8464$.

For the lower part of the circuit, since we have a parallel connection between $D$ and $E$, we can compute the probability of at least one of them working as follows: $prob(D union E) = prob(D) + prob(E) - prob(D inter E) = 0.92 + 0.92 - (0.92 dot 0.92) = 0.9936$.

With this new probability defined we can also compute the probability of $B_2$: $prob(B_2) = prob(C) prob(D union E) = 0.92 dot 0.9936 = 0.914112$.

Now that we have both the elements, we can compute the overall probability of the system working as follows:

#math.equation(
  block: true,
  numbering: none,
  $prob(W) = prob(B_1 union B_2) = prob(B_1) + prob(B_2) - prob(B_1 inter B_2) \ = 0.8464 + 0.914112 - (0.8464 dot 0.914112) = 0.9756$,
)


Now, if we wanted we can also compute the probability of failure of the system as follows: $prob(overline(W)) = 1 - prob(W) = 1 - 0.9756 = 0.0244$ #rhs([#sym.qed])
