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
  teaser: svn-2-git.png

---

In this post I describe the steps that will easily get your
source code out of Subversion and into Git. I'll assume that you are 
already familiar with basic SVN and GIT concepts.

The process that I describe relies on Git commands and a Bash shell. If you're on
Windows then <a href="https://git-scm.com/download/win" target="_blank">Git for Windows</a> 
comes with a Git-Bash console shell.

At the end of this post I also provide a bare-bones run-sheet outlining the commands in
a script fashion.

The steps broadly are:

* Create an authors mapping file.
* Create a directory to become the local Git repository.
* Initialise your local Git repository specifying your SVN layout
* Fetch from SVN into your local Git repository.
* Convert remote branches and tags.
* Create an actual remote repository.
* Push your local Git to your remote Git repo.


<!--end-of-excerpt-->

## Consider creating a `GitMigrations` directory

If you have a number of repositories to migrate then you may consider creating a directory in which to do the migrations:

~~~bash
mkdir ~/GitMigrations
cd ~/GitMigrations
~~~

## Create an authors mapping file

Git knows users by full name and email address, whilst SVN only knows them by their username.

If you accidentally forget this step (like I did once or twice) then later in this post I will
show you how to fix the author information after you have fetched the SVN repository.

The following command will create an authors mapping file:

~~~bash
svn log --quiet http://svn.repo/yourproject/ | 
    awk '/^r/ {printf "%s = %s <%s@example.com>\n",$3,$3,$3}' | 
    sort -u > ~/GitMigrations/your-project-authors.txt
~~~

This will create a file like:

~~~
BuildServer = BuildServer <BuildServer@example.com>
j.doe = j.doe <j.doe@example.com>
m.smith = m.smith <m.smith@example.com>
~~~

Fix these to be whatever they need to be, perhaps:

~~~
BuildServer = Build Server <build-server-do-not-reply@your.company.com>
j.doe = Jane Doe <jane.doe@your.company.com>
m.smith = Mark Smith <mark.smith@your.company.com>
~~~

## Initialize your local Git repository with SVN layout

Create a directory that will become the local Git repository for the migrated Subversion project.

~~~bash
mkdir ~/GitMigrations/yourLocalRepository
~~~

### For standard SVN layouts

If your SVN project followed a standard Subversion layout then you can simply do:

~~~bash
cd ~/GitMigrations/yourLocalRepository
git svn init http://svn.repo/yourproject/ --stdlayout
~~~

### For non-standard SVN layouts

If your Subversion project had been created with a non-standard layout, perhaps 
an unnecessary sub-folder under trunk and tags that duplicated the project name, then
specify these locations explicitly:

~~~bash
cd ~/GitMigrations/yourLocalRepository
git svn init http://svn.repo/yourproject/ --trunk=trunk/yourproject/ --tags=tags/yourproject/ --branches=branches/
~~~

If you don't have any branches or tags then simply omit the command line option.

### Review the Subversion layout configuration

~~~bash
git config --local --list
~~~

The output will contain a section that looks something like the following and describes the 
Subversion URL and the trunk, tags and branches mappings:

~~~
svn-remote.svn.url=http://svn.repo/
svn-remote.svn.fetch=yourproject/trunk/yourproject:refs/remotes/origin/trunk
svn-remote.svn.tags=yourproject/tags/yourproject/*:refs/remotes/origin/tags/*
~~~

Assuming that all looks good then proceed.

## Fetch the Subversion project into you local Git repository

Fetch your Subversion project into your local Git repository. Remember to specify the authors mapping file:

~~~bash
git svn fetch --authors-file=~/GitMigrations/your-project-authors.txt
~~~

This step can take minutes, hours, or even days depending on the size (commit history, branches and tags) of your SVN project.

### Check the local Git repository

You should now have a local Git repository with everything. Let's check it:

~~~bash
git status
~~~

Which will report something like:

~~~
On branch master
nothing to commit, working directory clean
~~~

Now try:

~~~bash
git branch -a
~~~

You should see something like:

~~~
* master
  remotes/origin/tags/v1.0.0
  remotes/origin/tags/v1.0.1
  remotes/origin/tags/v1.0.2
  remotes/origin/tags/v1.0.3
  remotes/origin/tags/v1.0.4
~~~

Notice that the SVN tags and branches have become remote branches. We will fix these to be local branches and Git tags in a subsequent step.

If you're happy that everything is okay then this is a good time to take a copy of your local Git repository
in case you mess-up any of the subsequent step. This is especially useful if the fetch took hours or days
to complete.

~~~bash
cd ~/GitMigrations
cp -r yourLocalRepository yourLocalRepository-ORIGINAL-FETCH
du --bytes --max-depth=0 yourLocalRepository yourLocalRepository-ORIGINAL-FETCH
cd ~/GitMigrations/yourLocalRepository
~~~

#### Convert remote SVN branches to local Git branches

The SVN branches are currently remote branches in our local Git repository. Let's convert them
to local Git branches:

~~~bash
for branch in `git branch -r | grep "branches/" | sed 's/ branches\///'`; do
  git branch $branch refs/remotes/$branch
done
~~~

#### Convert remote SVN tags to local Git tags

The SVN tags are currently remote branches in our local Git repository. Let's convert them
to local Git tags:

~~~bash
for tag in `git branch -r | grep "tags/" | sed 's/ tags\///'`; do
  git tag -a -m"Converting SVN tags" $tag refs/remotes/$tag
done
~~~

#### Confirm that the authors look good

Check to see that the authors look good:

~~~bash
git shortlog -se
~~~

If you see something like the following then you have forgotten to specify an authors mapping file when fetching from SVN:

~~~
   1670  BuildServer <BuildServer@2e623813-2a3c-424f-a4f0-eae878f2f3e4>
    603  j.doe <j.doe@2e623813-2a3c-424f-a4f0-eae878f2f3e4>
    402  m.smith <m.smith@2e623813-2a3c-424f-a4f0-eae878f2f3e4>
~~~

##### Fix authors (if you forgot to specify an authors mapping file)

Create a Bash shell script to fix the author names and email addresses with an entry for every author that you wish to correct.

Perhaps call this file `update-authors.bash` and locate it in the `~/GitMigrations/` directory:

~~~bash
#!/bin/bash

git filter-branch --env-filter '

n=$GIT_AUTHOR_NAME
m=$GIT_AUTHOR_EMAIL

case ${GIT_AUTHOR_NAME} in
	BuildServer) n="Build Server" ; m="build-server-do-not-reply@yourcompany.com" ;;
	j.doe) n="Jane Doe" ; m="jane.doe@yourcompany.com" ;;
	m.smith) n="Mark Smith" ; m="mark.smith@yourcompany.com" ;;
esac

export GIT_AUTHOR_NAME="$n"
export GIT_AUTHOR_EMAIL="$m"
export GIT_COMMITTER_NAME="$n"
export GIT_COMMITTER_EMAIL="$m"
'
~~~

From within your local Git repository directory run the `update-authors.bash` shell script:

~~~bash
~/GitMigrations/update-authors.bash
~~~

Checking the authors again with:

~~~bash
git shortlog -se
~~~

You should now see something like:

~~~
   1670  Build Server <build-server-do-not-reply@yourcompany.com>
    603  Jane Doe <jane.doe@yourcompany.com>
    402  Mark Smith <mark.smith@yourcompany.com>
~~~

## Create an actual remote Git repository

You will now need an actual Git remote repository. This may be on a GitHub, BitBucket,
or other Git server. You will probably use their user interface
to create a new empty repository and then take note of
the repository URL.

### Add an origin remote to your local Git repository

Assuming that your GitHub or BitBucket server will become your official
code-base and be known as the `origin` you would set this into your
local repository. For example:

~~~bash
git remote add origin https://<user>@bitbucket.org/<user>/<repo>.git
~~~

Take care set `<user>` and `<repo>` to appropriate values above.

### Push the local repository to your remote repository

Now you will need to push you local repository to your remote. This is a two step
process

Step 1: push all master and branch source:

~~~bash
git push --all origin
~~~

Step 2: push all tags:

~~~
git push --tags origin
~~~

## Let others know of the new repository

Let everyone know of the new repository.

## Bare bones run-sheet

The following is a bare-bones run sheet of all that I have describe above.
Modify it with your repository and user names.

~~~bash
# Create a directory to do the migrations in
mkdir ~/GitMigration
cd ~/GitMigration

# Create an authors mapping file
svn log --quiet http://svn.repo/yourproject/ | 
    awk '/^r/ {printf "%s = %s <%s@example.com>\n",$3,$3,$3}' | 
    sort -u > ~/GitMigration/your-project-authors.txt

# Remember to edit the author mapping as needed, then continue...

# Create and initailize a local Git repository
mkdir ~/GitMigration/yourLocalRepository
cd ~/GitMigration/yourLocalRepository
git svn init http://svn.repo/yourproject/ --trunk=trunk/ --tags=tags/ --branches=branches/

# Check the SVN layout mapping is initialized correctly
git config --local --list

# Fetch your SVN repository into a local Git repository
git svn fetch --authors-file=~/GitMigration/your-project-authors.txt

# Remember that the above could take a while...

# Take a copy of your original fetch just in case you need it
cd ~/GitMigration
cp -r yourLocalRepository yourLocalRepository-ORIGINAL-FETCH
cd ~/GitMigration/yourLocalRepository

# Take a look at the status and the branches to see if it all looks good
git status
git branch -a

# Convert branches
for branch in `git branch -r | grep "branches/" | sed 's/ branches\///'`; do
  git branch $branch refs/remotes/$branch
done

# Convert tags
for tag in `git branch -r | grep "tags/" | sed 's/ tags\///'`; do
  git tag -a -m"Converting SVN tags" $tag refs/remotes/$tag
done

# Check that the authors look good
git shortlog -se

# If the authors don't good then create a git filter-branch script to fix them
# This is not detailed here. See the detailed instructions in my post.


# Now go and create an actual remote Git repository, for example, on a GitHub or
# Bitbucket server, then come back and continue...

# Add the remote origin URL to your local repository
git remote add origin https://username@remote-repo-url/username/remote-repo-name.git

# Push all source and tags to your remote repository
git push --all  origin
git push --tags origin
~~~

