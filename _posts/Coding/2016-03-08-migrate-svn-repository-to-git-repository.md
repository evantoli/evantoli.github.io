---
layout: post
title: Migrate a SVN repository to Git
categories:
  - Coding
tags:
  - Git
  - SVN
  - Subversion
  - GitHub
  - BitBucket
image:
  teaser: git-logo-400x250.png
---

This is a condensed TL;DR version of the Atlassian tutorial 
"<a href="https://www.atlassian.com/git/tutorials/migrating-overview" target="_blank">Migrate to Git from SVN</a>"

It assumes you are familiar with SVN and GIT concepts. If you're not then refer to the Atlassian tutorial.

<!--end-of-excerpt-->

## Prepare

### Download migration helper

Download Atlassian's 
<a href="https://bitbucket.org/atlassian/svn-migration-scripts/downloads" target="_blank">svn-migration-scripts.jar</a> – either 
via your browser or at the command line using `wget`:

~~~
wget https://bitbucket.org/atlassian/svn-migration-scripts/downloads/svn-migration-scripts.jar
~~~

or using `curl`:

~~~
curl -O https://bitbucket.org/atlassian/svn-migration-scripts/downloads/svn-migration-scripts.jar
~~~

### Use the helper to verify you have all you need

At the command prompt run

~~~
java -jar ~/svn-migration-scripts.jar verify
~~~

This will result in something like the following if you have the necessary Git and Subversion tools installed. 

~~~
java -jar ~/svn-migration-scripts.jar verify

svn-migration-scripts: using version 0.1.56bbc7f
Git: using version 2.7.0.windows.1
Subversion: using version 1.8.13
git-svn: using version 2.7.0.windows.1

You appear to be running on a case-insensitive file-system. This is unsupported, and can result in data loss.
Cannot connect directly to internet. This may interfere with your ability to clone Subversion repositories and push Git repositories.
~~~

The case insensitive message may appear on Windows and Mac OS X systems. What to do? On Windows you can suck-it-and-see, whilst on a Mac you can solve this by mounting a temporary 5GB disk image that you could call `GitMigration`

~~~
java -jar ~/svn-migration-scripts.jar create-disk-image 5 GitMigration
~~~

In a corporate environment with a proxy server you might get the "Cannot connect directly to internet" message you see above. Don't worry about it if your source and target repositories are not in the cloud.

### Extract the author information

Git knows users by full name and email address, whilst SVN only knows a username. 

The following command will create an author mapping file.
~~~
cd ~/GitMigration 
java -jar ~/svn-migration-scripts.jar authors https://your.repo/your-project/ > authors.txt
~~~

This will five you a file like
~~~
j.doe = j.doe <j.doe@mycompany.com> 
m.smith = m.smith <m.smith@mycompany.com>
~~~

Fix these to be whatever they need to be, perhaps

~~~
j.doe = Jane Doe <jane.doe@your.company.com> 
m.smith = Mark Smith <mark.smith@your.company.com>
~~~

## Clone the SVN repository

Transform your SVN trunk, branches and tags into a new Git repository. The following 
assumes that your SVN repository is structure with a standard trunk, branch and tag structure:

~~~
git svn clone --stdlayout --authors-file=authors.txt <svn-repo>/<project> <git-repo-name>
~~~

Where `<svn-repo>/<project>` is the URI to the SVN project and `<git-repo-name>` is the new 
local Git repository that you are cloning into. For example, you might execute:

~~~
git svn clone --stdlayout --authors-file=authors.txt https://your.svn.repo/your-svn-project-name/ your-git-project-name
~~~

### Non-statndard SVN layouts

Use command-line options to identify non-standard SVN trunk, branch and tag structures:

~~~
git svn clone --trunk=/trunk --branches=/branches 
 --branches=/bugfixes --tags=/tags --authors-file=authors.txt 
 <svn-repo>/<project> <git-repo-name>
~~~

## Convert remote branches to local branches and Git tags

The `git svn clone` converts SVN branches and tags into Git remote branches. We
will now convert these into local branches and actual Git tags using the `clean-git`
script in the Atlassian `svn-migration-scripts.jar`.

To see the changes this script will make without actually making them run:

~~~
cd your-local-repo-directory
java -Dfile.encoding=utf-8 -jar ~/svn-migration-scripts.jar clean-git
~~~

And if you're happy run that again with the `--force` option to actually make the changes:

~~~
java -Dfile.encoding=utf-8 -jar ~/svn-migration-scripts.jar clean-git --force
~~~

## Create an actual remote Git repository 

You will now need an actual Git remote repository. This may be a GitHub account, 
a BitBucket server, or something else. Generally you will use their user interface 
to create a new empty repository and then take note of
the repository URL.

### Add an origin remote to you local Git repository

Assuming that your GitHub or BitBucket server will become your official 
code-base and be known as the `origin` you would set this into your 
local repository. For example:

~~~
git remote add origin https://<user>@bitbucket.org/<user>/<repo>.git
~~~

Take care set `<user>` and `<repo>` to appropriate values above.

## Push the local repository to your remote repository

Now you will need to push you local repository to your remote. This is a two step
process

Step 1: push all master and branch source:

~~~
git push -u origin --all
~~~

Step 2: push all tags:

~~~
git push --tags
~~~

## Let others know of the new repository

Let everyone know of the new repository.
