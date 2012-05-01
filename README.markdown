bootDoc
===================================
[DDoc](http://dlang.org/ddoc.html) theme using [Bootstrap](http://twitter.github.com/bootstrap/) for styling.

Features
-----------------------------------

Demonstration
-----------------------------------

Usage with Github
-----------------------------------

 * Create a new subdirectory in your project for generated documentation (`mkdir docs`).
 * Add **bootDoc** as a git-submodule to your repository:

    git submodule add git://github.com/JakobOvrum/bootDoc.git docs/bootDoc
	
  - If you are not using **bootDoc** inside another git repository, use clone:

    git clone git://github.com/JakobOvrum/bootDoc.git

 * Copy `settings.ddoc`, `modules.ddoc` and `Makefile` from `bootDoc` to the current directory:

    cp bootDoc/settings.ddoc settings.ddoc
    cp bootDoc/modules.ddoc modules.ddoc
	cp bootDoc/Makefile Makefile

 * Edit the `Makefile` to match your project's profile.
 * Edit `settings.ddoc` and `modules.ddoc` to match your project's profile.
 * Run `make` to generate the documentation pages.