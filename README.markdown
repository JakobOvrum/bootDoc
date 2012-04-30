bootDoc
===================================
[DDoc](http://dlang.org/ddoc.html) theme using [Bootstrap](http://twitter.github.com/bootstrap/) for styling.

Usage
-----------------------------------

 * Create a new subdirectory in your project for generated documentation (`mkdir docs`).
 * Enter the new directory (`cd docs`).
 * Add **bootDoc** as a git-submodule to your project:

    git submodule add git://github.com/JakobOvrum/bootDoc.git
	
  - If you are not using **bootDoc** inside another git repository, use clone:

    git clone git://github.com/JakobOvrum/bootDoc.git

 * Copy `settings.ddoc` and `modules.ddoc` from `bootDoc` to the current directory:

    cp bootDoc/settings.ddoc settings.ddoc
    cp bootDoc/modules.ddoc modules.ddoc

 * Edit `settings.ddoc` and `modules.ddoc` to match your project's profile.
