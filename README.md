Self Destruct
=============
This gem gives you the ability to track failures and successes of your ruby process, and trigger an event when the ratio of the two falls below a threshold.  It's called Self Destruct because my original use for it was to have my process die after too many failures.  Obviously there are design decisions to be discussed when you've built an auto destruct mechanism into your program, but in the land of shipping products on a deadline, you don't always have the luxury of doing everything Completely Right.  So, for you shoot-from-the-hip-ers, you have been warned: be absolutely sure you want this functionality -- here be dragons. 

# Installation

```
gem install self_destruct
```

# Usage

```
agent = SelfDestruct::Agent.new
10.times do { agent.inc_successes }
100.times do {agent.inc_failures }
```

Because the ratio of successes to failures is below the threshold (the default is 5), this will trigger the default failure function, which is an `abort`.  You can pass in your own failure function as a lambda: 

```
opts  = { failure_lambda: lambda { <do something> } }
agent = SelfDestruct::Agent.new(opts)
```

Self Destruct also has the concept of a grace period -- the time to wait after the first incrementing of successes or failures to trigger the failure function should it be necessary.  The grace period is overridable.  (See below)

# Customize 
You can customize the behavior of the Self Destruct agent by passing in an `opts` hash.  The following keys are valid:

| Feature         | Default | Key             | Description                                                                               |
|-----------------|---------|-----------------|-------------------------------------------------------------------------------------------|
| Grace Period    | 60 (s)  | grace_period    | Time to wait before triggering failure function (if needed)                               |
| Min Attempts    | 20      | min_attempts    | Minimum number of (successes + failures) before triggering a failure function (if needed) |
| Failure Lambda  | abort   | failure_lambda  | What to do when ratio of successes to failures falls below threshold                      |
| Ratio Threshold | 5       | ratio_threshold | The ratio of successes to failures                                                        |
| Max Count       | 1000000 | max_count       | The number of (successes + failures) to reach before resetting counts                     |
