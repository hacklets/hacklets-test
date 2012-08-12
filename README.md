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

### Cand I rename this or that?
You can rename pretty much any directory (TODO: implement this), except the
`profile/` prefix for profiles. Please note that strange things may happen if
you rename critical parts, like the default name of the **backend directory**,
strange things which may, or may not be what you wanted :-)

# Installation

TODO

# Tutorial

TODO

# Developers' Tutorial

TODO

# List of Hacklets

TODO or "automatic" `world` and `universe` commands?

**Happy hackleting!**
