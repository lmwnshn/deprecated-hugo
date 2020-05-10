---
date: 2018-03-09
title: "Plans and planes"
summary: "teaching distributed with mcdonalds"
tags: ["cmu", "useful"]
---

Lab was pretty fun this week, notwithstanding coffee and midterm woes. "Why are caches important?" is a question that I've never thought about in-depth before; people just kind of accept that caching = speedy, but there's so much more that you can pull out of it. Credit to her for asking it, though I hope I didn't miss any actual 150-related questions while this was going on.

***

*Note: I believe strongly in using revised histories (aka alternative facts) if it simplifies explanation and gets the point across better. All facts are potentially alternative unless otherwise stated.*

Consider ordering takeout from Macs.

Back in the day, you'd walk to Macs, read the menu there, place your order and then go back. Similarly for early web servers: your computer goes there, reads the file, does something with it, and forgets about it as soon as it goes home.

But this is dumb, because if you wanted to place a second Macs order, you'd need to walk there to get the menu again. Instead, you could have taken a copy of the menu (cached it locally), and next time you can just refer to that.

And what if 500 of your neighbors want to order Macs too? It'd be much more efficient for one of you to walk to Macs, get the menu, and come back with copies for everyone. (POP cache - this is what I was trying to motivate)

I thought the ordering McDonald's analogy was pretty dumb while I was coming up with it, mainly because the food still has to get to you somehow. But I've been thinking about it - you can use this scenario to motivate

1. caching
    - local cache (keep your own menu)
    - nearby server cache (CDN POP; like those people who buy sandwiches and resell them at CMU)
2. issues with caching:
    - cache freshness (is the menu still relevant?)
    - cache consistency (what if you and your friend have different menus?)
3. cache invalidation strategies (adapted from 15-440 course content)
    - broadcast invalidation (putting an ad in the newspaper, to notify everyone interested whenever there's a menu update)
    - check it before you use it (useless in this context, unless you assume you can only make one order per menu lookup)
    - callback (make Macs keep track of everyone with a menu and call them when the menu changes)
    - leases (Macs promises not to modify the menu for X days)
    - faith based caching (assume your version is correct and try to make an order)
4. cache eviction
    - what if you run out of space for all these old menus you're accumulating?
    - throw away the oldest (LRU)
    - what if there are coupons attached to old menus that you can use?
        - don't evict open (aka useful) files
    - when is caching even useful anyway?
        - if you never reuse the cached things, you're just creating extra work for yourself
        - LRU vs MRU for a sequential scan through time
    - what if you're interacting with 20 different franchise stores and each has a slightly different menu, but you only have space for 10 menus?
        - adaptive LRU: only keep a copy if you had to order from them more than once
        - optimal replacement: throw away the copy that will be used furthest in the future
        - also introduces the idea of working set, hit and miss rates
5. peer to peer file transfer (e.g. torrents)
    - if your friend has a menu, just get a copy from them
    - privacy (do you want your friend knowing you're ordering Macs again?)
    - security (what if your friend pranks you with a bad menu?)
6. remote procedure calls
    - if you don't care about the details and have a friend that can make the order for you
    - how are you communicating with them? (RPC protocol must be well-defined)
    - "first page of the top menu in your pile" might not mean the same thing
        - address space is not shared (pointers/relative addressing is meaningless)
        - we need to send and/or uniquely identify what we're talking about

You can keep going on about latency and bandwidth and a whole bunch of other concepts too. I feel like I can stretch this scenario to 10-20 minutes of distributed/filesystem things now. I haven't decided what a good format would be, though - prezi seems the most suitable so far, because at every step there are more subtleties that aren't relevant to the big picture.

Fundamentally, the reason this works out so nicely is that a McDonald's menu is pretty much just a file anyway. All the usual reasons still apply. It just helps to add context by analogy.

Well, as my roommate said when he walked in at 2am:

> what? why are you doing this? you have a flight, go to sleep

My task scheduler may be a little suboptimal. Oh well. ¯\\(ツ)/¯

***

Speaking of airplanes, I'm catching up on so much sleep right now. The 150 jacket is actually really comfortable. Two legs down, three to go!

I'm slightly disappointed by my food choices at HK airport. I was very amused by this sign:

![Fried A Vegetable](/include/blog/2018-03-09-plans-and-planes/fried_a_vegetable.jpg)

And chose to eat at a place called Taiwan Beef Noodle, but it was honestly pretty bad. I got beef noodle soup and bubble tea; if everyday noodle was a 10, this would be a 2. Undercooked cartilage (resulting in a very flat and uninspiring soup), undersoaked bubble tea pearls. Then again, I suppose that's why they're an airport stall - dumb transiting people (exempli gratia, me) keep them in business.

(also sticker !'d at this, until I remembered what country I was in)

![HKD prices](/include/blog/2018-03-09-plans-and-planes/hkd_prices.jpg)

***

Caught up on CMU email, woo!

Since we told them to take a break, I feel like I should prepare slides or something for Monday... maybe on the way back.

Meanwhile, a little hypocritically, notes need to be made and homework needs to be cleared.
