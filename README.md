# zsh-helpoutput

The purpose of this repository is to keep copies of the `--help` output
from various commands to make it easy to identify when changes should be
made to [Zsh](http://zsh.sourceforge.net/) completion functions.

## Branches

Git branches are used to separate out scripts and to track which updates
are outstanding from zsh's perspective:

- **master** – various helper shell scripts
- **usage** – all the `--help` output files where changes have been applied to the corresponding zsh completion function
- **pending/_cmd_** – like usage but where zsh completion updates are outstanding

You can happily ignore the scripts and just view the usage branch or
one of the pending branches.

For push requests, consider using a pending-style branch. I'll cherry-pick
onto the usage branch once zsh functions are updated. Expect rebases and
similar changes that break the git tree on the usage branch. Also fetch
replace references as I sometimes use them to fixup pending branches
after a rebase. This has long been a private repository so I've yet to
work out how to manage it if it is used collaboratively.

## Directories

Commands are split across several directories:

- **freebsd**, **solaris**, etc – system specific
- **external** – software that includes a zsh completion rather than the function being part of zsh
- **gnu** – official GNU
- **x** – GUI software
- **closed** – commercial, i.e. not Open source software
- **common** – everything else

## Scripts

A top-level script is used to generate and compare the help output.
Further scripts help with some of the git usage.

### overlay

The idea is to overlay the master branch with one of the other branches.
This isn't necessary and overlaying branches is a dirty hack but it is
useful to separate the two sets of files while having both available. This
script - `overlay` - sets this up using git worktree. Take care if you
use the script, I'm really not sure it won't do something destructive.

Once the overlay is done, you can switch between the usage and pending
branches as normal without scripts being affected. Working on the master
branch requires a separate checkout or the option `--git-dir=.s.git`
to be specified. There are other ways to achieve much the same thing;
git worktrees are a fairly new feature.

### updates

This is the main script. When the script is run without arguments,
it prints a list of commands with their version numbers.
Commands printed in red are those for which a newer version is installed
than has previously been examined.

You can specify exact commands to view the differences in `--help` output,
e.g: `./updates less`

If there are noteworthy changes, e.g. new options, the `-u` option can
be used to update the usage file. You can use `-c` to commit the change
immediately which in simple cases is usually fine. Often you'll want
the commit on a pending branch, however.
e.g.

    git branch pending/less $(git log --format='%h' --max-count=1 common/less)
    ./updates -uc less

We now want to record that we have examined the new software versions
diffs, regardless of whether there was any changes of note. The `-s` option
updates these, again in combination with `-c`, the change will be committed:
e.g. `./updates -sc less`

The updates script also has a `-a` option for including commands that
aren't installed in the listing.

For the master branch, it is usually good to squash changes before pushing:

    git --git-dir=.s.git rebase -i --autosquash origin/master

### changes

This is just a wrapper for viewing the history of a file.

## Synopses Files

Recipes for extracting the usage synopsis and version numbers for commands
are stored in files named `Synopses` in each of the subdirectories.

For each command, a number of functions are called in a particular
order. In the order that they should be used, these are:

- `cmd` – Specify the name of the command
- `version` – Specify the most recent version of the command that has been examined.
- `variant` _(optional)_ – Handle a command name clash between two programs or separate implementations
- `subdir` _(optional)_ – Specify that a subdirectory should be used.
- `getversion` – Used at the end of a pipe to read the installed version number
- `getusage` – Used at the end of a pipe to read the usage synopsis. Can be used more than once: specify a parameter to give a unique name for the file.
- `subcmds` _(optional)_ – Produce multiple synopsis files for different subcommands

There are also some additional functions that are useful as part of the
pipelines for getversion and getusage:

- `emit` – This simply runs the command with any specified options. It is actually
an alias using noglob because `-?` is not uncommon for getting the
usage. As a convention, I tend to use `-?` when any invalid option is
required to evoke the usage synopsis from the command: it is less likely
to become a valid option later than, say, `-h`.
- `step` – This runs a program but only if the command specified with cmd is
actually present.
- `field` – A simple wrapper around awk to pull out whitespace separated fields. A
negative index counts from the end of the line. This is meant for version
numbers so the first line of input is handled.
- `guess` – This will attempt to guess at the version number by looking for a
field that has the right form.
- `line` – Select a specified input line by index.
- `pack` – Attempt to determine the version number using the system packaging
system. This tends to be slow and doesn't work for the base system on
a traditional Unix system so is only used as a last resort.
- `nobug` – Used in the middle of a pipeline to filter out lines saying "Report
bugs to …". This is mainly useful because for some, especially GNU,
software the line gets customised by RedHat, SuSE etc which is not
helpful when viewing differences between releases.

## Licensing

Copyright of --help output does not of course belong to me. I've partly
retained the weird stuff with branches to separate them. If anyone objects,
I can remove theirs.

There's a LICENSE file on the master branch to cover the scripts though
there's not much to them.

