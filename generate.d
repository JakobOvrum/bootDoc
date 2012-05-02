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

auto usage = `Generate bootDoc documentation pages.

Usage:
%s "path to project root" [options]
Options:
	--modulefile path to candyDoc-style list of modules. [default: "modules.ddoc"]
	--verbose    print information during the generation process.
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
