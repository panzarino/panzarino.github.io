---
layout: post
title: "How to Change a Pull Request Target Branch"
date: 2015-05-16 22:30:00
comments: true
description: "Basics of how the new website works"
keywords: "website, site"
categories:
- github
tags:
- github
- shell
---

I constantly see people asking about how to merge a GitHub pull request into a different branch other than that specified by the creator of the pull request. 
I like to work on a `dev` branch so new commits that are not ready for release aren't really seen by anyone. Not that I want to hide anything, I just don't want users to download developmental commits while thinking it is production ready.

The problem comes in when people submit a pull request. By default, GitHub compares the PR to the `master` branch, because thats where most development occurs and is the branch that everyone sees by default. 
The new submitted PR is now compared to the `master` branch, but that's not where I want to merge it.

GitHub does not allow owners or contributors to the repository to change the target branch, and it can be a pain to get the PR author to change the target branch. 
That's where the command line comes in to save the day.

There are two ways that you can do this, so I'll start with the easier way.

Start by `fetch`ing the PR into a new branch and changing into that branch. You need to know the ID of the PR for this to work (it is the number shown after the title on GitHub and also in the URL).

{% highlight console %}
$ git fetch origin pull/ID/head:BRANCHNAME
$ git checkout BRANCHNAME
{% endhighlight %}

You will now be on the branch that contains the changes in the PR. You can do whatever you want to the code now, or just leave it as is.

When you're ready to merge, go ahead and change into the branch that you want to merge into. Merge the PR branch into that branch and push, and it's as easy as that. You can delete the PR branch when you are done with it.

{% highlight console %}
$ git checkout TARGET_BRANCH
$ git merge BRANCHNAME
$ git branch -d BRANCHNAME
$ git push
{% endhighlight %}

Once you have merged and pushed, you can go ahead and close the PR on GitHub. It won't say that it's merged, but you can easily write that in a comment so the author does not get upset.

For such a highly requested feature, it should be implemented by GitHub (relatively) soon. Until then, these simple commands will get the job done.