---
layout: post
title: "New Website"
date: 2015-12-09 04:00:00
comments: true
description: "Basics of how the new website works"
keywords: "website, site"
categories:
- general
tags:
- general
- website
- ruby
- shell
- github
---

So I just set up this new website with a new theme, which is hosted on [GitHub](https://github.com/zachpanz88/zachpanz88.github.io).

However, because GitHub does not allow custom plugins for Jekyll, I have to do a little bit of extra work than just uploading the Jekyll files to the repository. 

The code that I use to generate the website code is stored in the [`source`](https://github.com/zachpanz88/zachpanz88.github.io/tree/source) branch of the repository (currently default branch). 

GitHub uses the `master` branch of a repository to publish to a website, so I have to generate the html files on my own before I upload them. 

This is the basic process for every update to the site:

First, I commit all the files to the `source` branch so they are stored on GitHub:
{% highlight console %}
$ git add .
$ git commit -a -m "New update"
$ git push origin source
{% endhighlight %}

Next, I run the script that updates the website itself (on the `master` branch):
{% highlight console %}
$ rake publish
{% endhighlight %}

This is what the relevant part of the [`Rakefile`](https://github.com/zachpanz88/zachpanz88.github.io/blob/source/Rakefile) looks like. 
First, it builds the website with Jekyll in the `_site` directory. It then `cd`'s into the `_site` directory. 
To push the files to GitHub, it initializes a repository and sets the remote to match my website repository. 
It changes to the master branch using `--orphan`, meaning that there will be no history.
The program then commits the files and pushes them to the repository, using `--force`, so previous commits are overwritten. 
The only commit that resides in the [`master`](https://github.com/zachpanz88/zachpanz88.github.io/tree/master) branch is the last time the site was updated, which is stated in the commit message.
{% highlight ruby %}
# encoding: UTF-8
require "rubygems"
require "tmpdir"
require "bundler/setup"
require "jekyll"

GITHUB_REPONAME = "zachpanz88/zachpanz88.github.io"
GITHUB_REPO_BRANCH = "master"

SOURCE = "source/"
DEST   = "_site"
CONFIG = {
  'layouts' => File.join(SOURCE, "_layouts"),
  'posts' => File.join(SOURCE, "_posts"),
  'post_ext' => "md",
  'categories' => File.join(SOURCE, "categories"),
  'tags' => File.join(SOURCE, "tags")
}

task default: %w[publish]

desc "Generate blog files"
task :generate do
  Jekyll::Site.new(Jekyll.configuration({
    "source"      => "source/",
    "destination" => "_site",
    "config"      => "_config.yml"
  })).process
end

desc "Generate and publish blog to gh-pages"
task :publish => [:generate] do
  Dir.mktmpdir do |tmp|
    cp_r "_site/.", tmp

    pwd = Dir.pwd
    Dir.chdir tmp

    system "git init"
    system "git checkout --orphan #{GITHUB_REPO_BRANCH}"
    system "git add ."
    message = "Site updated at #{Time.now.utc}"
    system "git commit -am #{message.inspect}"
    system "git remote add origin git@github.com:#{GITHUB_REPONAME}.git"
    system "git push origin #{GITHUB_REPO_BRANCH} --force"

    Dir.chdir pwd
  end
end
{% endhighlight %}

So essentially thats all I have to do after making a change to the website, but it is pretty annoying because I can't publish posts from the GitHub web interface.

Knowing that I would have to type these commands over and over, I made a shell script [`update.sh`](https://github.com/zachpanz88/zachpanz88.github.io/blob/source/update.sh):
{% highlight bash %}
#!/bin/bash -e

# commit data
read -p 'Commit message: ' message

git add . -A
git commit -m "$message"
git push origin source

# update website
rake publish
{% endhighlight %}

Well, I guess that's all there really is to it.
