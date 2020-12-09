---
date: 2020-12-09
title: "Black Friday"
summary: "or apparently, doctoral student review now?"
tags: ["cmu", "musings"]
---

I think I should have done this in college. In general, I plan 10 years ahead, but I'm not very good at doing retrospectives. No time like the present?

Engineering, per commit history:

- May
  - "SELECT" without predicate.
    - Thoughts: Underlying segfault cause was `ProjectionTranslator` assuming that its child would never be `nullptr`. Codegen often has assumptions designed for TPL instead of SQL.
- Jun, Jul
  - `libcount` update.
  - Ported TPL2 with TN.
    - Thoughts: The TPL2 port was excruciatingly slow. The fundamental problem is that the changes you need are actually quite small, however, features, bug fixes, and regressions in either repository are all indistinguishable since neither of them bother upstreaming changes to each other and they're not even formatted the same way. This problem exists in industry as well when people do hard forks (see MySQL derivatives: 5.6 vs 5.7 vs 8).
    - Takeaway: If I want my code to outlive me, I need to work on the main repo. Let's see if I can stick to this, five years from now.
  - Fix TPL2 update counts.
    - Thoughts: The interesting part is decoupling the "number of rows affected" counter from the `StorageInterface`, because you may want to implement an update (single row) as a delete+insert (naively two rows). Arguably, the `StorageInterface` may want to expose a special "delete+insert" operation instead, but we didn't explore that approach.
- Aug
  - Forward declare codegen translators.
  - Fix codegen always being serial (whoops).
  - "SET" statements. In support of paper.
- Sep:
  - `EXPORT` more stuff.
    - Thoughts: I think the reason we have symbol visibility issues is that we're building NoisePage as a library.
  - OU counters. In support of paper.
    - Thoughts: I wrote some really bad code at first that looked like `if (CountersEnabled()) { CounterCode }`. It created way too much nesting and was a complete eyesore. This was refactored into the `CounterAdd`, `CounterMul`, and so on functions, which abstracted away the `if` check and the common case of wanting to do some basic math on a counter. I should look out for more opportunities to do refactors like that.
  - Network layer refactor. This was in preparation of implementing the messaging protocol for NoisePage.
    - Thoughts: I am not convinced that we currently have a particularly good network architecture. It is libevent-based and has some "mask on event mask off event" way of going through the state machine. I think this is not exactly the async event server model that you would use libevent-style libraries for.
- Oct:
  - Fix "SET" for quirky Postgres parser types. Many Postgres types like bools, dates, timestamps, and so on, come in as strings.
  - "ready-for-ci" is a nice small hack. Pull politely from GitHub API when possible, scrape webpage less politely when not possible.
  - CMake refactor (3x build speedup, "get up for water and back" build times in practice).
    - Thoughts: The big win is unity builds. Unity builds save you from poor developer forward-include discipline. Smaller wins are `ninja` for maximizing parallelism and `lld` for linking a ton of tests. However, a similar benefit can be achieved with a higher `-j` to `make` and by clumping our googletest-and-ctest-based tests together into a single binary. We are still slower than DuckDB to build, I suspect this is because they do unity builds per folder.
  - Fix SQL values in bytecode generation.
    - Thoughts: `VisitForLValue`, `VisitForRValue`, the underlying problem is that we didn't have much of an idea of what we were doing when we were porting TPL1, and copying is easy. Same sins as in the optimizer, in some sense.
    - Takeaway: I first saw this in Rust: make the right thing easy and make the wrong (or otherwise dubious) thing painful. A one character difference is not enough.
  - Fix "SELECT NULL" and "SELECT *".
  - Migrate wiki to "docs/" folder. Personally, I never knew when the wiki was updated -- I think this is a good change.
  - System release.
  - Messenger subsystem.
    - Thoughts: ZeroMQ is an interesting library. See the presentation I made.
  - Fix "UPDATE foo SET a=a", except it was still buggy and WZ would eventually really fix it.
  - Forward declare more stuff. With unity builds, very little benefit observed.
- Nov
  - "IN" operator.
  - Started catalog DSL.
  - Abandoned catalog DSL.
    - Thoughts: Trying to design a DSL to cover all existing use cases was quite fun and educational. But I am concerned about exceeding the general weirdness budget of our system and our testing infrastructure. The junit stuff is messy. The testing scripts are a little too close to enterprise Java. I am not willing to introduce another dependency that will break and need to be extended in funny ways.
    - Takeaway: There is a time and place for well-written C++. Reaching out for too much external tooling or "just write another script" will lead us into trouble.
  - Resource constraints for `catalog_sql_test`.
    - Thoughts: I don't know how to solve this yet. I need a way to get my "If you're consuming ports or common filenames, you need to declare it in this config file" message in front of anyone writing a new C++ test.
  - "::" style casting.
  - Hook up a previously useless "parallel_execution" flag.
    - Thoughts: The duplication of settings is kind of a footgun. Both in testing infrastructure and in the main codebase. In this case, the flag was set in the settings manager, and this was never read into execution settings.
- Dec
  - "NOT IN" operator. The postgres parser is wacky in parsing identically except for `=` or `<>` as a name.
  - Completed catalog refactor.
    - Thoughts: This fixed a number of copy-paste bugs, just by modularizing and brace-enclosing logical blocks of code. I think the catalog looks a damn lot better than it did. Unfortunately, indexes can't be automatically built without pushing more builder-related information into the types, which might be too much arcane C++ for people to reasonably pick up. We did push attribute sizes into the type of each PgTable schema though. This fixes a class of mismatched-type bugs.
    - Takeaway: Type-level information is pretty good. Just that C++ has garbage syntax.

Research:
- The main effort was the OU paper -- reviewing hooks, writing counters, reviewing indexes, other small things.
- I read Kemme's database replication from cover to cover. Focused mostly (and perhaps unsurprisingly) on middleware-based replication, but that's not really what we're doing.
- I read mostly networking-related literature, and a fair bit about message queues.
- Replication is a WIP.

Other:
- I read Poor Economics and The Outlaw Ocean. Good books. Unfortunately too real.
- Still slowly flipping my way through All of Statistics. I definitely do **not** enjoy this as a hobby. Closer to eating vegetables, except I actually like vegetables.
- I started reading `d2l.ai`. 
- I made (or tried to make), in rough order of least to most successful: custard, pau (dough), seri muka, char siu, liu sar pau (filling), smashed cucumber, Americanized cumin lamb, mango cheesecake (with biscoff base!), kek batik.
- I'm now pretty good at making a respectable kek batik. I want to try layering marie with biscoff or other cookie types.

