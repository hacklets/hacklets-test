# Table of Contents

* [What are Hacklets?](#what-are-hacklets)
* [Terminology and Concepts](#terminology-and-concepts)
    * [Concepts FAQ](#concepts-faq)
* [Installation](#installation)
* [Developers' Tutorial](#developers-tutorial)

# What are Hacklets?

Have you ever wished it would be easier to just take someone's configuration
for your favourite application and use it without hassle? Or to make it easier
for your friends and collegues to use your configuration?

What about taking multiple configurations for the same application and merging
and adapting it to your own taste, then publish it as your own?

Enter **the web of hacklets**.

Hacklets is first of all a way of organizing things, it's a methodology. With
hacklets, you get all the above, plus:

* you remain in control of your home directory - you actually see all the
  commands being issued, there's no magic! **Magic is bad**.
* it's not only for your home directory, you can use it just like that in any
  directory
* do you use to be a Java programmer, in the next second a Python one, and
  sometimes to extend PHP in C? No problem! You can easily switch back and
  forth between configurations using *profiles*
* with hacklets, you can also manage projects, do batch operations on all of
  them (don't you want to do all those push operations after a hard day of work
  in one shot? Or fetch everything in the morning, so you have a nice overview
  of what needs to be done?)
* hacklets is not only for configuration files, but also for sharing small
  scripts and tools, or entire sets of projects
* hacklets can conduct configuration wizardry for even more control
* do you have a new collegue at your **workplace**, and want to give him all
  the projects and configurations in one shot? Throw everything
  (configurations, projects along with their code, wizards) in some hacklets
  and a profile, and you get it running in a few minutes. For every collegue,
  forever!
* do you have multiple machines (at home or work) which you want to easily
  synchronize, or you've bought a new computer and you want the same or at
  least some of your other configurations and projects on the new machine? With
  hacklets, you can easily do that
* with hacklets, you are deprived of all those repetitive tasks you do all day,
  and win time to do the real stuff that matters. Hacklets makes you **happy**
  through productivity, and makes it extremely easy for you to **share** that
  happyness with your friends
* easy integration with github, or any other git repository hosting, or why
  not, your own server, your own bug tracker, your own tools - **once you get
  hacklets, you own it!**
* hacklets is a great platform for **backing up** pretty much everything, even
  your passwords on another machine
* if you develop a new tool, widget, script, configuration, or whatever digital
  information you may think of, for yourself, then you can just put it into
  a hacklet and share it. Others who have the same needs may use it, and
  improve it, and there we are, in a more dynamic and collaborative environment
  from which everybody wins
* no configuration or installation process stays in the way of your users
  adopting your tool and making the best out of it - hacklets is easily
  integrable with your already existing git project, and the best of all, your
  users get the code and they can start hacking on it right away
* **TODO**: more advantages

# Terminology and Concepts

In order to make it easier to communicate, we have to introduce some keywords
and concepts. Please keep in mind that hacklets relies heavily on other tools,
so you may well use those concepts. Yet we still need some keywords for them
which better fit into the hacklets universe.

In the next section, we're going to use this terminology written in *italic* in
an installation guide and tutorial at the same time. Please refer back if
something is unclear.

Hacklets uses git, shell scripting (TODO: developed on bash, what about
others?), and python (TODO: not yet there, but we reserve python as
a dependency). You should have some basic knowledge of git before proceeding.

In git, the usual setup is to have a **working tree** in a directory with all
the files of the project, and inside it a **git directory** called `.git`.
However, these directories can be situated anywhere, and this fact is used by
hacklets to make it possible to manage the hacklets.

* when you install hacklets, we say that you've **adopted** the hacklets
  hacklet in the `$HOME` **container**, that is, in case of the installation,
  this is your home directory, also known as `~` or `$HOME`
* a **container** is a directory managed by hacklets, with a directory called
  `.hacklets/` inside it. This is called the **backend directory**. At any
  given time, there is exactly one *backend directory* per *container*
* every *backend directory* has a **master hacklet**. Upon installation of
  hacklets, hacklets (this is the hacklet called "hacklets", and the *hacklets
  project*) sets itself as the *master hacklet* of your **home container** (that,
  is, the container that resides in `$HOME`)
* the master hacklet is stored in the *backends' subdirectory* `master/`. So in
  case of adopting the hacklets hacklet (in other words, installing it for the
  first time), the *git directory* of hacklets is typically stored in
  `$HOME/.hacklets/master/`
* the *backend directory* of a container only contains *git directories* of the
  hacklets being used (or ready to be used), and some other meta data needed by
  hacklets itself
* you can have as many containers as you want, for as many directories as you
  want, a *projects container* for instance
* when you want to install a hacklet, there is a two step process involved.
  First, you **fetch** that hacklet. Fetching a hacklet means downloading the
  git data, that is, the hacklet's *git directory* into `<backend>/project.git/`.
  Attention: this is not simply fetching in git terms, it's also some wiring
  done for hacklets' own needs (you'll see it in the tutorial)
* after *fetching* a hacklet, you're ready to *adopt* it in a **profile**
* a **profile** is a branch prefixed with `profile/` in which you *merge* (in git
  terms) or **adopt** hacklets. You can combine hacklets in any way you wish in
  as many profiles as you need

## Concepts FAQ

### Cand I rename this or that?  You can rename pretty much any directory
(TODO: implement this), except the `profile/` prefix for profiles. Please note
that strange things may happen if you rename critical parts, like the default
name of the *backend directory*, strange things which may, or may not be what
you wanted. Feel free to hack around it :-)

# Installation

TODO: before proceeding, make sure you know the basic git operations. If you're
a non-programmer or if you want to take it slowly, we've written a guide for
you: TODO link to wiki page here.

To create test users, run as root:

    USER=foo && PASS=bar && useradd -p $(perl -e"print crypt('$PASS', '$USER')") -c "Hello Hacklets" $USER && mkdir /home/$USER && chown -R $USER:users /home/$USER

To log in:

    su --login foo

To remove the test user, log out from that account, and as root:

    userdel foo && rm -rf /home/foo

TODO: step by step guide

Now that you have installed it by hand once, you can install it on other
machines with a little bit of automatization:

    bash <(curl https://raw.github.com/hacklets/hacklets-test/deploy/install.sh -L -o -)

After following the wizard, log out and log back in again.

Before using a container, you must initialize it:

    hacklets_activate_this

This will keep the container initialized in the current shell. If you open
a new shell and `cd` to that directory, you have to initialize the container
again.

TODO: alias `cd` to do `hacklets_activate_this` transparently

You do not need to do this more than once per user, per machine. Installing
hacklets in the **home container** is done only once.

# Tutorial

In this tutorial, we will try to get a minimal working environment built on top
of the hacklets infrastructure. We will use existing hacklets, as well as write
our own.

Please note that *hacklets* is a work in progress and it's not stable, so look
carefully at the commands executed and try to learn from them. Read the
manpages if necessary.

Hacklets display all the commands it issues, so you always see what's doing
and, in case of a failure, you get an idea of where to go hacking and correct
the bug.

Download a hacklet and make it available for use in the current container:

    hacklets_fetch sane-defaults git://github.com/hacklets/sane-defaults.git

`sane-defaults` is the name of the hacklet, you can give it any name, but it's
a good practice to keep it the same as the remote one.  The second parameter is
the URL of the hacklet. This can be any bare repository.

Hacklets can only be used together when bundled in profiles. So let's create a new profile:

    hacklets_new_profile test

And now let's use the hacklet `sane-defaults`:

    hacklets_adopt sane-defaults

TODO: more docs, clearer, funnier, awesomer

# Developers' Tutorial

TODO

# List of Hacklets

TODO or "automatic" `world` and `universe` commands?

**Happy hackleting!**
