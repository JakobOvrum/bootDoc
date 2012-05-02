bootDoc
===================================
[DDoc](http://dlang.org/ddoc.html) theme using [Bootstrap](http://twitter.github.com/bootstrap/) for styling.
*bootDoc* uses JavaScript to extend and improve DDoc's capabilities, such as by adding a module overview tree and
by enabling fully qualified page anchors.

The theme is designed to work with any project by putting all project-specific information in separate configuration
files.

Features
-----------------------------------
 * Easily configurable for any project, designed to work as a git-submodule.
 * Sidebar with a package explorer tree and a tree of the symbols in the current module.
 * Configurable titlebar, with a goto-symbol form.
 * Fully qualified page anchor names; individual symbols can be linked without conflicting with similarly named symbols in the same module.
 * Neat styling using [Bootstrap](http://twitter.github.com/bootstrap/).

Demonstration
-----------------------------------
The [LuaD documentation](http://jakobovrum.github.com/LuaD/) uses *bootDoc*.
A set of *bootDoc* generated pages for Phobos will come soon.

Usage with Github Pages
-----------------------------------

 * Create a gh-pages branch to host the generated documentation ([instructions here](http://help.github.com/pages/)).
  - For the purposes of this guide, we will assume this is an empty branch in its own repository in a subdirectory of the repository containing the source files.
  - For example, if your project repository is in a directory `myproj`, we will assume your gh-pages repository is in `myproj/gh-pages`.
  - The working directory of the following commands is assumed to be this new directory (e.g. `myproj/gh-pages`).
 * Add *bootDoc* as a git-submodule to your gh-pages repository:
   ```
   git submodule add git://github.com/JakobOvrum/bootDoc.git bootDoc
   ```
 * Copy `settings.ddoc` and `modules.ddoc` from `bootDoc` to the current directory:
   ```
   cp bootDoc/settings.ddoc settings.ddoc;
   cp bootDoc/modules.ddoc modules.ddoc;
   ```
 * Edit `settings.ddoc` and `modules.ddoc` to match your project's profile.
 * Run the generation script, passing the root location of your sources: `rdmd bootDoc/generate.d ..`.
  - The list of modules is read from `modules.ddoc`. For example, using the above command, if your `modules.ddoc` has one entry `$(MODULE example.example)`, then `example_example.html` will be generated from `../example/example.d` (aka `myproj/example/example.d`).
  - If you have an index file tracked on the gh-pages branch instead of among the sources, pass it to the generation script using `--extra=index.d`. Any number of extra files can be passed this way.
 * Push your newly generated HTML files.
  - To update the documentation, run the generation script again.

Usage in General
-----------------------------------
DDoc is configured using the files `bootdoc.ddoc`, `settings.ddoc` and `modules.ddoc`.
The latter two are templates; copy them to your project directory before editing them.
`settings.ddoc` contains general information about your project; its values are
documented [here](https://github.com/JakobOvrum/LuaD/wiki/settings.ddoc). `modules.ddoc` contains
a candyDoc-style list of all the modules in your project, and is documented
[here](https://github.com/JakobOvrum/LuaD/wiki/modules.ddoc).

Pages are generated using the included script `generate.d`. Run it without arguments to
see an overview of how to use it.