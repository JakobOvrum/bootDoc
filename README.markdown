bootDoc
===================================
[DDoc](http://dlang.org/ddoc.html) theme using [Bootstrap](http://twitter.github.com/bootstrap/) for styling.

Features
-----------------------------------


Demonstration
-----------------------------------
The [LuaD documentation](http://jakobovrum.github.com/LuaD/) uses **bootDoc**.
A set of **bootDoc** generated pages for Phobos will come soon.

Usage with Github Pages
-----------------------------------

 * Create a `gh-pages` branch to host the generated documentation ([instructions here](http://help.github.com/pages/)).
  - For the purposes of this guide, we will assume this is an empty branch in its own repository in a subdirectory of the repository containing the source files. For example, if your project repository is in a directory `foo`, we will assume your `gh-pages` repository is in `foo/gh-pages`.
 * Add **bootDoc** as a git-submodule to your `gh-pages` repository (`git submodule add git://github.com/JakobOvrum/bootDoc.git bootDoc`).
 * Copy `settings.ddoc`, `modules.ddoc` from `bootDoc` to the current directory:
{{{
    cp bootDoc/settings.ddoc settings.ddoc
    cp bootDoc/modules.ddoc modules.ddoc
}}}
 * Edit `settings.ddoc` and `modules.ddoc` to match your project's profile.
 * Run the generation script, passing the root location of your sources: `rdmd bootDoc/generate.d ..`.
  - The list of modules is read from `modules.ddoc`. For example, if your `modules.ddoc` has one entry `$(MODULE example.example)`, then `example_example.html` will be generated from `foo/example/example.d` using the above command.
  - If you have an index file tracked on the `gh-pages` branch instead of among the sources, pass it to the generation script using `--extra=index.d`. Any number of extra files can be passed this way.
