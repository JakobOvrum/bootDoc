#!/usr/bin/env rdmd

import core.sync.mutex;
import std.algorithm;
import std.array;
import std.exception;
import std.file;
import std.getopt;
import std.parallelism;
import std.path;
import std.process;
import std.range;
import std.regex;
import std.stdio;
import std.string;

struct Module
{
	string name;
}

const(Module)[] parseModuleFile(string path)
{
	enforce(exists(path), xformat("Module file could not be found (%s)", path));

	auto modPattern = regex(`\$\(MODULE\s+([^,)]+)`);

	string[] modules;
	foreach(line; File(path).byLine())
	{
		if(auto m = match(line, modPattern))
			modules ~= m.captures[1].idup;
	}

	return modules.map!(modName => Module(modName.replace(".", "/") ~ ".d"))().array();
}

string generatedName(string modName, string separator)
{
	return modName.stripExtension().replace("/", separator) ~ ".html";
}

auto usage = `Generate bootDoc documentation pages for a project
documented with DDoc.

Usage:
%s "path to project root" [options]
Options (defaults in brackets):
  --bootdoc=<path>     path to bootDoc directory
                       (containing the file bootdoc.ddoc). ["bootDoc"]
  --modules=<path>     path to candyDoc-style list of modules.
                       ["modules.ddoc"]
  --settings=<path>    path to settings file. ["settings.ddoc"]
  --separator=<string> package separator for output HTML files. ["."]
  --verbose            print information during the generation process.
  --parallel           generate in parallel mode. Substantially decreases
                       generation speed on multi-core machines.
  --dmd=<string>       name of compiler frontend to use for generation. ["dmd"]
  --extra=<path>       path to extra module. Can be used multiple times.
  --output=<path>      path to output generated files to.

Options not listed above are passed to the D compiler on generation.

Description:
Generates bootDoc-themed DDoc documentation for a list of D modules.
The modules are read from the specified candyDoc-style module list,
as well as taken from any --extra arguments passed. Each module name
is converted to a relative path, which is then searched in the
specified project root.

Example module file:
    MODULES =
        $(MODULE example.example)

Example generation:
    rdmd bootDoc/generate.d .. --separator=_

The above will read modules.ddoc from the working directory,
then generate documentation for all listed modules. The module
example.example is searched for at the path ../example/example.d
and its HTML output is put in example_example.html. The output
is configured with settings.ddoc, read from the working directory.
`;

int main(string[] args)
{
	string bootDoc = "bootDoc";
	string moduleFile = "modules.ddoc";
	string settingsFile = "settings.ddoc";
	string separator = ".";
	string dmd = "dmd";
	bool verbose = false;
	bool parallelMode = false;
	string[] extras;
	string outputDir = ".";

	getopt(args, config.passThrough,
		"bootdoc", &bootDoc,
		"modules", &moduleFile,
		"settings", &settingsFile,
		"separator", &separator,
		"verbose", &verbose,
		"parallel", &parallelMode,
		"dmd", &dmd,
		"extra", (string _, string path){ extras ~= path; },
		"output", &outputDir
	);

	if(args.length < 2)
	{
		writefln(usage, args[0]);
		return 2;
	}

	immutable root = args[1];
	immutable passThrough =
		args.length > 2 ?
		args[2 .. $].map!(arg => xformat(`"%s"`, arg))().array().join(" ") :
		null;

	immutable bootDocFile = xformat("%s/bootdoc.ddoc", bootDoc);
	Mutex outputMutex = new Mutex();

	bool generate(Module mod, string inputPath)
	{
		auto outputName = buildPath(outputDir, generatedName(mod.name, separator));

		auto command = xformat(`%s -c -o- -I"%s" -Df"%s" "%s" "%s" "%s" "%s" `,
			dmd, root, outputName, inputPath, settingsFile, bootDocFile, moduleFile);

		if(passThrough !is null)
		{
			command ~= passThrough;
		}

		if(verbose)
		{
			outputMutex.lock();

			scope (exit)
				outputMutex.unlock();

			writefln("%s => %s\n  [%s]\n", mod.name, outputName, command);
		}

		return system(command) == 0;
	}

	const modList = parseModuleFile(moduleFile);

	if(parallelMode)
	{
		enum workUnitSize = 1;

		foreach(mod; parallel(modList, workUnitSize))
			generate(mod, xformat("%s/%s", root, mod.name));

		foreach(name; parallel(extras, workUnitSize))
			generate(Module(baseName(name)), name);
	}
	else
	{
		foreach(mod; modList)
			generate(mod, xformat("%s/%s", root, mod.name));

		foreach(name; extras)
			generate(Module(baseName(name)), name);
	}

	return 0;
}
