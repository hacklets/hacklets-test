A hacklet is a set of files which, after installation, will be put
in the current directory.

You can install as many hacklets in a directory as you wish. If a hacklet
contains a file which conflicts with another hacklet's file, the hacklet will
not be installed.

So hacklets can be used to configure your applications and share those
configurations with others, or as a synchronization tool across multiple
machnines.

You can use any git repository as a hacklet, it will work out of the box,
without any changes at all.

But you can add further customizations. See the Wiki for details.

This is a list of existing hacklets. Feel free to add your own:

* https://github.com/flavius/dotfiles-env
* https://github.com/flavius/dotfiles-vim

# How to install

Hacklets is in development, as such, I do not recommend using it right away,
unless you know what you're doing.

The following commands are prefixed with `#` if they have to be executed as
`root`, or with `$` if they should be executed as the testing user.

`# adduser` - create testing user; enter your real name and e-mail address too
`# su - <newuser>`

This will bootstrap hacklet and install itself in your current directory (which
should be `~`):

    $ rm -rf ~.* ~*
    $ export PATH=~/bin/tmp/git-hacklet/bin:$PATH
    $ git clone --recursive git://github.com/flavius/hacklets.git /tmp/git-hacklet
    $ git hacklet install git-hacklet git://github.com/flavius/hacklets.git
    $ rm -rf /tmp/git-hacklet

After you're done, you can install any hacklet you wish. For example:

    $ git hacklet add dotfiles-env git://github.com/flavius/dotfiles-env.git

This will install the basic infrastructure, shell autoloading of features, etc.
It's highly recommended.

After you log out and log in back as `<newuser>`, the alias provided by the
hacklets project itself will be loaded, which includes the alias `hacklet='git
hacklet'`, so from now on I'll use the `hacklet` command, instead of `git
hacklet`

A vim hacklet (far from perfect), based on vundle, it will automatically
install some bundles too, and a `.vimrc`:

    $ hacklet install dotfiles-vim git://github.com/flavius/dotfiles-vim.git

**Happy hackleting!**
