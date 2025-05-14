= Git and GitHub Fundamentals for Open-Source Contributions

== What is Git?
*Git* is an open-source version control system commonly used to make it easier for
developers to introduce changes to a project without stepping on each others' toes.
Git will track changes to files across time in the form of *commits*.

A commit contains:
- Code changes (referred to as the "commit diff")
- Author/Timestamp information
- A developer-written message describing the code changes

Commits are made on *branches*. Branches allow developers to compartmentalize code
changes by particular features, bug fixes, documentation updates, etc. Branches
can be merged into other branches, allowing for developers to work on things
at the same time while minimizing conflicts created by simultaneous work.

All of these branches live inside of a Git *repository*, which is the collection
of all branches and commits relevant to a Git project.

== What is GitHub?
*Github*, not to be confused with Git itself, is a Git repository hosting service
commonly used by open-source projects, as Github provides free hosting for public
and private repositories alike. It is leveraged by Decomp Toolkit Template projects
to run Github Actions, which can be used to automate things like progress website
updates and create Discord notifications when people contribute to a project.

== Setting Up Git

#link("https://docs.github.com/en/get-started/git-basics/set-up-git")[#underline("Here is a link to a guide")]
hosted by Github is a great place to start for setting up and configuring Git. Follow it and
you'll be able to set up Git locally on your machine!

== Forking a Repository on GitHub
#link("https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo")[#underline("Here is a link to a guide")]
provided by GitHub which is helpful for understanding repository forks, why they're useful, and how to work with them depending on your
operating system (Windows, Mac, Linux).

Check out the guide for step-by-steps instructions on how to:
- Create a Github repository fork
- Clone that repository fork
- Configure your fork to be able to pull changes from the "upstream" original repository

== Creating a Pull Request (PR)

A pull request is a method by which you can propose the merging of your code changes into
the original repository from your fork.

#link("https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork")[#underline("Here is a link to a guide")]
hosted by GitHub which will show you how to create a pull request once you've pushed changes to your remote fork.
It will take you step-by-step through the pull request creation process.

Your pull request should contain:
- A descriptive summary of your proposed changes contained in the PR
- A helpful description which goes into detail about what changes you made and why you did them as needed

== Responding to PR Reviews

Once you've opened a pull request, you're not done yet! There's still some steps that
will happen before your code is merged into the original project repository:
- A maintainer will review your pull request
- The maintainers may post comments to discuss your changes with you
- The maintainers may request code changes they would like to see to better align your code with project standards

Engage with the project maintainers on your pull request, pushing changes to your code as needed
until all feedback is addressed. Don't worry about updating your pull request on GitHub -
pushing changes to your fork branch will automatically update the pull request for you.

Once all of the feedback has been addressed, the maintainers will merge your changes
into the project repository. Congratulations - you're now a contributor to open source, and hopefully
the newest contributor to the BfBB Decomp project!

== Github Command Quick Reference

This section is intended to serve as a quick reference for some common Git workflows
that you will use while working on your project. The documentation here is provided for
the Git command line interface - you will have to reference the particular documentation
for your GUI client (Github Desktop, etc.) to determine how to perform these actions using
your GUI of choice.

=== Creating and Checking Out Branches
Branches are used to isolate development of particular features or bugs into
compartmentalized units.

To checkout a new branch `my_branch` using the `main` branch as a base:
```
git checkout main
git checkout -b my_branch
```

To checkout an existing branch `my_branch`:
```
git checkout my_branch
```

To delete a branch `my_branch` (*Note: This will delete any unmerged changes for good! Be careful!*):
```
git branch -D my_branch
```

=== Making Changes and Committing

Files must be staged before the changes contained in those files can be committed.

To stage an individual file:
```
git add path/to/my/file
```

To stage all tracked files:
```
git add -u
git status
```
`git status` is optional but it can be a good sanity check to make sure that the files
you intended to stage are staged and no files you did not intend to stage are staged.

To commit staged changes:
```
git commit -m "<commit message>"
```
A good commit message should:
- Contain a message summary no longer than 72 characters
- Describe what changes are made by the commit
- Explain any decisions or limitations contained in the changes (if the commit contains complex changes)

A good example commit for the BfBB Decomp project follows the format:
```
<decompiled filename>: <change to file>
```

Some examples of good commit messages:
```
zCamera: Matches for zCameraFlyRestoreBackup and zCameraRewardUpdate functions

zNPCGoalAmbient: zNPCGoalJellyBumped Near 100% Match

iTRC: Data Updates and Matches for Font Rendering Functions
```

=== Pushing Changes to Your Fork
To push changes from your local repository to your remote fork repository and configure tracking for that branch:
```
git push -u origin my_branch
```

To push changes from your local repository to your remote fork repository after configuring tracking:
```
git push
```

=== Integrating Upstream Changes into your Fork
When the upstream main branch is updated, and you want to integrate those changes
into your working branch `my_branch` by rebase (*recommended*):
```
git stash
git checkout main
git pull
git checkout my_branch
git rebase main
git stash apply
```

When the upstream main branch is updated, and you want to integrate those changes
into your working branch `my_branch` by merge (*not* recommended):
```
git stash
git checkout main
git pull
git checkout my_branch
git merge main
git stash apply
```
