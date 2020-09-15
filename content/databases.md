---
title: Databases
type: simple
layout: simple
url: /databases/
toc: true
---

Keeping track of useful things that I've read.

## Async IO

### Lord of the `io_uring` : `io_uring` tutorial. [Link](https://unixism.net/loti/).

- Key idea: avoid syscall and user/kernel copy overhead with shared ring buffers.
- `io_uring` shares two ring buffers (submission queue SQ, completion queue CQ) between kernel and user space.
- Submissions can be batched before a notify (`io_uring_enter`); the kernel can poll the SQ directly to avoid submission overhead for high frequency submissions.
- Completions are added to CQ by kernel (1:1 submissions:completions, tagged with identifier) in no particular guaranteed order.
- Most applications should just use `liburing`, but that requires kernel 5.6+. Ubuntu 20.04 LTS only ships 5.4.

## Code style

### Redis : The different types of code comments. [Link](http://antirez.com/news/124).

- Key idea: function, design, why, teacher, checklist, guide, comments are useful. Specifically, "what" comments are not necessarily harmful.
- Excellent example comments. 

### Personal notes.

- Give a component a DescriptiveName. Use DescriptiveName to refer to DescriptiveName even if repetitive. 
- Words to be banned or strongly reconsidered prior to use:
  - Too much potential for ambiguity, allows for too much sloppiness in coding: this, that, it.
  - Too much potential for run-on sentences: more than two commas, semicolon (make a new sentence instead), any sentence longer than two lines of comments.
- Just capitalize and punctuate every sentence. Much better looking.

## Networking

### Beej : Socket programming guide. [Link](https://beej.us/guide/bgnet/).
### L5RDMA : Sockets suck. [Paper](https://db.in.tum.de/~fent/papers/Low-Latency%20Communication%20for%20Fast%20DBMS%20Using%20RDMA%20and%20Shared%20Memory.pdf), [Slides](https://db.in.tum.de/~fent/papers/Low-Latency%20Slides.pdf?lang=en).

- Key idea: Networking has become a performance bottleneck; solve with RDMA/RoCE/shared memory. The paper does a cool bootstrap to the best available network tech.
- Silo: 58k txn/s per second single-threaded (embedded), 1.5k (TCP), 2.7k (domain socket). Networking and IPC are huge bottlenecks!
  - Corollary: when investigating claims of high performance we should check: fsync frequency, embedded vs over network.

## Performance

### sled : Great benchmarking overview and experiment checklist. [Link](https://sled.rs/perf.html).

- P state and turbo boost, see [sysbench](#sysbench--machine-tuning-tips-from-sysbench-maintainer-linkhttpswwwperconacomresourcesvideosbenchmark-noise-reduction-how-configure-your-machines-stable-results).
- Drop the pagecache. `sync && echo 3 | sudo tee /proc/sys/vm/drop_caches`
- Compact system-wide memory. `echo 1 | sudo tee /proc/sys/vm/compact_memory`

### sysbench : Machine tuning tips from sysbench maintainer. [Link](https://www.percona.com/resources/videos/benchmark-noise-reduction-how-configure-your-machines-stable-results).

- Key idea: "If you are not seeing stable results in your performance comparisons, you are wasting your time".
- CPU frequency:
  - Disable higher P states. `echo performance | sudo tee /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_governo`
  - Disable higher C states. `(echo 0; cat) > /dev/cpu_dma_latency &`
  - Disable turbo boost. `echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo`
- Scheduler: it depends.
  - Leave it at CFS.
  - Disable autogroup. `sysctl kernel.sched_autogroup_enabled=0`
  - Raise minimal granularity. `sysctl kernel.sched_min_granularity_ns=5000000`
  - Relevant [Postgres](https://www.postgresql.org/message-id/50E4AAB1.9040902@optionshouse.com) discussion, also suggests tuning `sched_migration_cost`.
- ASLR: Disable. (security risk!) `sysctl kernel.randomize_va_space=0`
- NUMA: Disable autobalance. `sysctl kernel.numa_balancing=0`
- Swap: Minimize. `sysctl vm.swappinness=1`
- THP: Disable. `echo never > /sys/kernel/mm/transparent_hugepage/enabled` and `echo never > /sys/kernel/mm/transparent_hugepage/defrag`.
- Memory allocator: Keep consistent version between benchmarks.
- Spectre/meltdown: Keep mitigations similar between benchmarks.
