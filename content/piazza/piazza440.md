---
date: 2018-05-31
title: "440 Piazza"
summary: "Some questions from 440 Piazza."
tags: ["piazza-440"]
toc: true
---

## Go scheduler randomness (or lack thereof)

Disclaimer : I was not a TA and also not a student in this version of the class. I was just hanging around the 440 Piazza and found this question interesting.

**Original question: about the order of output in an example**

```go
package main

import "fmt"

func sum(s []int, c chan int) {
   sum := 0
   for _, v := range s {
      sum += v
   }
   c <- sum
}

func main() {
   s := []int{7, 2, 8, -9, 4, 0}

   c := make(chan int)
   go sum(s[:len(s)/2], c)
   go sum(s[len(s)/2:], c)
   x, y := <-c, <-c

   fmt.Println(x, y, x+y)
}
```

The output is -5 17 12, why is -5 ahead of 17?

I thought the order should be random, because the order of calculating 2 threads could be different.

## Answer

My understanding is that they are in fact random. Just that for some reason or other, the go example server tends to return `-5 17 12`.

If you import time and sleep at the start of the sum function,

```go
time.Sleep(1 * time.Nanosecond)
```

you should see `17 -5 12` appear sometimes.

In general, I believe there are no ordering guarantees for calling goroutines in this way.

(After a followup saying there must be a reason.)

Everything that happens on a computer has a reason.

I wouldn't advise being clever [0], which is the only reason I can think of that you might need an answer that isn't simply "they're random". But if you're interested, to my knowledge, and feel free to correct me:

1. Go uses a cooperative scheduler [1,2]. As of the current runtime, it mainly (only?) preempts on function calls [3]. You're just doing math, so it won't preempt. But on the playground and by default on older versions of Go, `GOMAXPROCS=1` [4].

2. Read the scheduler source [5]. Maybe the scheduler design doc too [6]. You're interested in `runqput`. Trace through the code. I'm relatively sure `next` is true, so you end up using the `runnext` slot. So the last thing scheduled runs first.

3. I don't know why you'd want to when the source is available, but you can also just trace the scheduler [7].

[0] https://golang.org/ref/mem  
[1] https://rakyll.org/scheduler/  
[2] http://www.sarathlakshman.com/2016/06/15/pitfall-of-golang-scheduler  
[3] https://github.com/golang/go/issues/11462  
[4] https://golang.org/pkg/runtime/#GOMAXPROCS  
[5] https://golang.org/src/runtime/proc.go  
[6] https://docs.google.com/document/d/1TTj4T2JO42uD5ID9e89oa0sLKhJYD0Y_kqxDv3I3XMw/edit  
[7] https://www.ardanlabs.com/blog/2015/02/scheduler-tracing-in-go.html
