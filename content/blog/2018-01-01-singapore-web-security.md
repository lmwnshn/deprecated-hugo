---
date: 2018-01-01
title: "Defeating \"web security\" in Singapore"
summary: "going through some old stuff"
tags: ["singapore", "security"]
---

Considering that cybersecurity and PPP were large factors in choosing computer science and CMU respectively, I've done very little of both ever since I got here. Too many distractions, too much emphasis on classes.

Hopefully, that will change. Trying to free up Fridays... though I've forgotten everything.

I also recall griping about the apparent lack of cybersecurity core classes in NUS; this was after a NUS STePS mini-CTF which someone from my high school won. Well, CMU is the same - I'm mostly done with the core, and it appears that you can graduate with memories of "oh yeah bomblab and attacklab I vaguely remember those" as the extent of your security knowledge.

Sure, CS education and job training aren't exactly the same thing, but the goal of becoming a well-paid code monkey seems to be fairly common, so perhaps writing secure code should be stressed a little more? But I digress.

Throwback to high school days.

## What I knew

- I was reading [this](https://www.amazon.com/Web-Application-Hackers-Handbook-Exploiting/dp/1118026470) book
	- Not too dense, light to medium reading, a high schooler can easily follow along
	- I got results from it, so I suppose I recommend it
- Other than that, I knew nothing

## Targets

I'm not going to explicitly call out the companies (two major offenders). Not that I've ever received anything in return, though that's standard for the region - thanks is mostly in the form of ignoring you (as opposed to waving the law around). Ah well.

I'll just mention that they're still around.

And they're still selling their CMS and custom solutions.

To government agencies (MOE, MINDEF, URA, IRA, WDA, HPB, basically most of them).

To corporate bodies (NTUC, Singtel, a small bunch).

And to individual schools (primarily JCs and secondary schools).

Sleep well :)

## What I got and why

**Quick disclaimer: I kept none of this information. I poked around, found something sketchy, reported it, and eventually it would get fixed by them with nobody else the wiser.**

For anyone that participated in SSEF,

- Name, gender, birthday, citizenship, school,
- NRIC, homephone, mobile phone, home address,
- Advisor name, advisor phone number, etc.

**Why?** It was sent to you in plain JSON every time you loaded the page. Or you could make an unauthenticated call to the /getMemberList endpoint. Your choice.

(I wasn't sure whether I wanted to include this, since I couldn't confirm that it was fixed. But it has been three years, after all. You'd hope that was enough time.)

---

For anyone using an old CMS made by a company before its rebranding,

- Full access to the school system
	- Name, NRIC, home address, foreign address,
	- Grades, disciplinary reports, medical reports,
	- Viewing and modifying the above,
	- All the things you'd expect a school to have basically.

**Why?** They had some cute 1-1 substitution cipher protecting their authentication cookie and a text field that let you get encrypt(x) for any x of your choice. Just change your ID to be whoever you want.

Once that was fixed,

- Still full access to most of the system
	- **Why?** Laziness. They fixed it for one cookie field, ID, but didn't fix up Role and Type of account.

And apart from that, you could get everyone's graduation transcripts by brute forcing URLs since they weren't password protected and you could guess the day-hh:mm:ss that the file was generated.

I suppose there was this other little bug where you could change people's messages on a forum, say if you wanted to outbid them for a tutorial question. Memories of waking up to an overheating laptop and trying to disable IPv6..

---

For anyone using a new CMS made by the abovementioned company after its rebranding,

- Actual account passwords
	- Potential for finding reused passwords
	- **Why?** They save your password in plaintext, they probably still do despite numerous complaints and suggestions. They will proceed to email your password back to you if you forgot your password. It turns out the request that lets you UpdateEmail?id=...&email=... doesn't bother checking that you own the id in question.

After they fixed the above lazily (i.e. with id checking instead of not storing plaintext passwords),

- Actual account passwords
	- Just get a staff account, they have the right to change anybody's email
	- You could have promoted your own account to a staff account too
	- So all staff accounts can still get your password. Welp.

Enough on passwords. Next.

- Read everyone's private messages
	- **Why?** Dumb viewMessage?id=1 type of system, protected on desktop, but not on mobile - go to mobile version and change the number

- Download any file
	- **Why?** Same as messages above

- On their social media clone within the CMS,
	- Posting messages as anybody
		- **Why?** Post function takes a createdBy that it trusts
	- Hijacking the browser of whoever views your "Wall"
		- **Why?** Stored XSS in post title
	- Complete control over anybody's "Wall"
		- **Why?** Published asmx web service that has no authentication safeguards

## Closing remarks

Why this post? And why now?

I guess my point is something like - a high schooler with a single book can turn your systems upside down terbalik, aren't you worried? Why are you paying so much for insecure, poorly written software? All of the attacks highlighted above are elementary textbook attacks. You could teach a motivated p6 kid to do it all in a week.

And I only described my personal stuff above. There's more, (and objectively the other stories are far more interesting, mine is skiddy level), but those aren't my stories to tell.

It has been long enough that everyone involved *should* have fixed their stuff, though.

I'd like to see bug bounty culture mandated in Asia. Force companies to pay out for breaches, and maybe they'll start caring more about their users. Security needs to be an upfront consideration, not a PDPA compliance afterthought. And if you select the lowest bidder, well.. pay peanuts, catch monkeys.

It would also be interesting to have a "passed pentesting" requirement for software that handles PDPA protected stuff.

But hey, I'm just an undergrad - what do I know?

[And yet... somehow... life goes on.](http://www.gocomics.com/calvinandhobbes/1991/04/12)
