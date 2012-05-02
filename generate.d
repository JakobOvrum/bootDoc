import std.algorithm;
import std.array;
import std.file;
import std.getopt;
import std.path;
import std.process;
import std.range;
import std.regex;
import std.stdio;
import std.string;

string[] parseModuleFile(string path)
{
	if(!exists(path))
	{
		throw new Exception(format("Module file could not be found (%s)", path));
	}
	
	auto modPattern = regex(`\$\(MODULE\s+([^,)]+)`);
	
	string[] modules;
	foreach(line; File(path).byLine())
	{
		auto m = match(line, modPattern);
		if(m)
			modules ~= m.captures[1].idup;
	}
	
	return modules.map!(modName => modName.replace(".", "/") ~ ".d")().array();
}

string generatedPath(in char[] modName, in char[] separator)
{
	return (modName.stripExtension().replace("/", separator) ~ ".html").idup;
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
  --separator=<string> package separator for output HTML files. ["_"]
  --verbose            print information during the generation process.
  --dmd=<string>       name of compiler frontend to use for generation. ["dmd"]
  --extra=<path>       path to extra module. Can be used multiple times.

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
    rdmd bootDoc/generate.d ..

The above will read modules.ddoc from the working directory,
then generate documentation for all listed modules. The module
example.example is searched for at the path ../example/example.d
and its HTML output is put in example_example.html. The output
is configured with settings.ddoc, read from the working directory.
`;

void main(string[] args)
{
	string bootDoc = "bootDoc";
	string moduleFile = "modules.ddoc";
	string settingsFile = "settings.ddoc";
	string separator = "_";
	string dmd = "dmd";
	bool verbose = false;
	
	string[] extras;
	getopt(args,
		"bootdoc", &bootDoc,
		"modules", &moduleFile,
		"settings", &settingsFile,
		"separator", &separator,
		"verbose", &verbose,
		"dmd", &dmd,
		"extra", (string _, string path){ extras ~= path; }
	);
	
	if(args.length < 2)
	{
		writefln(usage, args[0]);
		return;
	}
	
	string root = args[1];
	
	auto modPaths = parseModuleFile(moduleFile);
	
	auto bootDocFile = format("%s/bootdoc.ddoc", bootDoc);
	
	bool generate(in char[] path, bool prependRoot)
	{
		auto outputPath = generatedPath(path, separator);
		
		auto inputPath = prependRoot? format("%s/%s", root, path) : path;
		
		auto command = format(`%s -c -o- -I"%s" -Df"%s" "%s" "%s" "%s" "%s"`,
			dmd, root, outputPath, inputPath, moduleFile, settingsFile, bootDocFile);
		
		if(verbose) writefln("%s => %s\n  [%s]\n", path, outputPath, command);
		
		if(system(command) != 0)
			return false;
		
		return true;
	}
	
	foreach(path; modPaths)
	{
		if(!generate(path, true))
			return;
	}
	
	foreach(path; extras)
	{
		if(!generate(path, false))
			return;
	}
}
