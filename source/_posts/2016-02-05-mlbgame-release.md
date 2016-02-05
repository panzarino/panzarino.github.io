---
layout: post
title: "mlbgame Release"
date: 2016-02-05 22:00:00
comments: true
description: "A Python API to retrieve and read MLB GameDay XML data"
keywords: "mlbgame, python, mlb"
categories:
- python
tags:
- python
- github
---

I have finally released the first official version of mlbgame, which is a python API that returns MLB game information. 

I started development on this project in early November, and finally released it about a week ago. 
As of writing this, the current version is 1.0.3, with a few bug fixes from the initial release (one of which I discovered while writing this article). 

The full source code can be accessed on [GitHub](https://github.com/zachpanz88/mlbgame) (leave a star), 
with new developments being worked on in the [`dev`](https://github.com/zachpanz88/mlbgame/tree/dev) branch.

The full documentation for mlbgame is available [here](http://panzarino.me/mlbgame/).

I was inspired to create this project becuase I realized that there is not really a good API for accessing MLB data. 
I was also inspired by [nflgame](https://github.com/BurntSushi/nflgame), a similar project that retrieves NFL data. 
Many of the functions in this project originated from similar functions in nflgame. 
(The source code for a cool website I made using nflgame can be accessed [here](https://github.com/zachpanz88/fantasy-football))

mlbgame is listed in the [Python Package Index (PyPI)](https://pypi.python.org/pypi/mlbgame/) and therefore can be installed with `pip` 
(you will probably have to run it with `sudo`).

{% highlight console %}
$ pip install mlbgame
{% endhighlight %}

Here is an example of how to use mlbgame.

A full source file of this example is available [here](https://gist.github.com/zachpanz88/978b0e6b7d00950ad415).

Obviously, you have to start by importing the package. 
Only the main module is needed to access most functionality. 
Additional stats information is available in [`statmap.py`](https://github.com/zachpanz88/mlbgame/blob/master/mlbgame/statmap.py).

{% highlight python %}
import mlbgame
{% endhighlight %}

For this example, we will be working with a single Mets (my favorite team) game from this season (2015) on August 10. 
To start, we use the `day` function to get the data from a single day (use the `games` function to get games from multiple days). 
Because this function returns a list of games due to multiple games occurring on the same day, we must only select the first game in the list, becuase that is the game that we want 
(with the way we use the `day` function there will only be one game in the list). 
So, we know the team and the date of the game, but we do not know if that team was home or away. 
Instead of having to find out this information, we can set both home and away to "Mets", and mlbgame will find a game where the Mets are either home or away. 
Knowing all this, we need to retrieve the game object:

{% highlight python %}
game = mlbgame.day(2015, 8, 10, home="Mets", away="Mets")[0]
{% endhighlight %}

We can simply `print game` to get a quick score report for the game, which looks like this:

{% highlight console %}
Rockies (2) at Mets (4)
{% endhighlight %}

Well that's great, we now have the score, but it really isn't too much information. 
Say we want to find out how the Mets pitchers did in that game. 
This is where we have to use `player_stats` function, becuase we want the stats for the individual players in the game (as opposed to the `team_stats` function).
The `player_stats` function only needs the id of the game to get all the stats for that game.
Once we get these stats, we can loop through and print out the Mets pitcher stats (we know the Mets are home because of the above output).

{% highlight python %}
stats = mlbgame.player_stats(game.game_id)
for player in stats['home_pitching']:
    print player
{% endhighlight %}

And the output is:

{% highlight console %}
Jon Niese - 2 Earned Runs, 5 Strikouts, 6 Hits
Tyler Clippard - 0 Earned Runs, 0 Strikouts, 0 Hits
Jeurys Familia - 0 Earned Runs, 2 Strikouts, 0 Hits
{% endhighlight %}

Of course those are just a few important stats, with many more available stats which you can check out in [`statmap.py`](https://github.com/zachpanz88/mlbgame/blob/master/mlbgame/statmap.py).

Looks like the pitching did fairly well that game, but how was the hitting? 
Lets loop through the hitters and print out their basic stats:

{% highlight python %}
for player in stats['home_batting']:
    print player
{% endhighlight %}

And the output is (notice the players are in order of which they first appeared at the plate):

{% highlight console %}
Curtis Granderson - 0 for 3 with 1 RBI
Daniel Murphy - 1 for 4 with 2 RBI
Yoenis Cespedes - 0 for 4
Lucas Duda - 1 for 4
Kelly Johnson - 0 for 4
Travis d'Arnaud - 2 for 4 with 1 RBI and 1 Home Runs
Michael Conforto - 0 for 3
Jeurys Familia - 0 for 0
Jon Niese - 0 for 1
Juan Uribe - 0 for 1
Tyler Clippard - 0 for 0
Juan Lagares - 0 for 0
Ruben Tejada - 0 for 1
{% endhighlight %}

This was a quick little example of how to use mlbgame, but there is so much more that the package can do. 
Check out the [full documentation](http://zachpanz88.github.io/mlbgame/) for more examples and usage information, 
and make sure to drop by the [GitHub repo](https://github.com/zachpanz88/mlbgame). 
If you find any issues or bugs in the project, please report them [here](https://github.com/zachpanz88/mlbgame/issues/new). 
I hope that mlbgame can be useful to you in some way, and I appreciate all users of the package.
