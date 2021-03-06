README
======

    units4school
    A Simple Tool to Generate Unit Tests for Physics Teachers
    
    Version: 	v0.07
    OS's:		Linux (Ubuntu, Debian,...) and Mac OS supported
    		    Windows is not supported as of today.
    Source: 	https://github.com/fborchers/units4school
    Date:		17.1.2019
    Author:		F. Borchers
    Languages:	German


SUMMARY
-------

Teaching physics at high-school level can be challenging. Preparing the students for the final exams even more so. One way to make students study is regular testing: just like vocab tests in language subjects. 
The tool `units4school` is an attempt to automate the generation of such tests. Questions will be generated and put together on an exam sheet (see summary.pdf for an example).
The key idea is that automatic answers will drastically reduce time and effort to mark the tests. It may even be possible to let students do it for each other.

Questions from three different topics will be used:
 + physical units 	(see table.units.ods)
 + unit prefixes 	(see table.prefixes.ods)  	and
 + physical constants 	(see table.constants.ods)

Mac Users will have to modify the makefile: Find 'soffice' in this README for instructions.


INSTALL AND USE
---------------

For the impatient: Run 

    make test
    make pdf  (once or repeatedly)
    make print

In Detail: Download the files into a directory, unzip and then run:
	make test
to check if everythings runs as expected. This will build the intermediate auxiliary files. If successful, `make test` returns 
	rm table.constants.csv table.units.csv
indicating a correct setup. Then run
	make pdf
	make print
to generate a test and a printable version for the students. 

Running `make pdf` again will produce another test replacing `out_units4school.pdf` (containing answers). Run this as many times as you like until you find a suitable test, but you may as well take the first one.
Then run `make print` to produce a printable A4 page without solutions. This will only convert the current test to a print-friendly version without the answers.


MODIFY (easy)
-------------

Clearly, asking the students to know the whole list of units, prefixes and constants is too much in the beginning. For that reason it is possible to modify the set of possible questions. To do so delete the lines you do not want to have in the test from their csv-files in build/ . 
For example, if the test should not contain questions about 'Trägheitsmoment', go to build/table.units.csv and delete the line

	Trägheitsmoment;$J$;$J$;\SI{1}{\newton\meter\second\squared};\SI{1}{\newton\meter\second\squared};\SI{1}{\kilogram\meter\squared};$\frac{M}{\alpha}$;$J$;\newton\meter\second\squared;xxx;$J$;$\frac{M}{\alpha}$;Trägheitsmoment;J;= M / alpha ;1 N m s;;\newton\meter\second\squared;\kilogram\meter\squared;

Furthermore, it is possible to exclude specific questions about specific units, prefixes or constants by deleting their answers from the csv (although it will be easier to delete the answers from the spreadsheed *.ods ).


PREREQUISITES
-------------

The following software is required to run units4school:  
	R, sed, LibreOffice, pdflatex

To check if you have the software installed run in a terminal:

	R --version  
	pdflatex --version

and

	soffice --help  
	sed

Download and install `R` from 
	https://www.r-project.org/
The program `sed` should have shipped with your Linux or Mac.

Next, `pdflatex` is part of any standard LaTeX distribution, check 
	https://www.latex-project.org/
It will be necessary to restart the computer after installing TeX, even with MacTeX on a Macintosh computer.

At last, `soffice` is the command line tool of LibreOffice. On a Linux machine it is available after installing LibreOffice. On Mac you will have to specify the full path to its binary in the makefile. For example on my machine (Mac OS 10.10) this is:
	/Applications/LibreOffice.app/Contents/MacOS/soffice

For some reason the conversion utility of OpenOffice does not work (version 4.1.6). The problem is that Apache's OpenOffice's `soffice` comes without the command-line option --convert-to. Use LibreOffice instead, or tell me how to do it with OpenOffice.

If -- for whatever reason -- the `soffice` routine fails you can use the csv-files from the corresponding branch.


CHANGELOG
---------

- v0.07  
  Supply a branch with csv-files just in case LibreOffice is missing.  
  Updated README, now with a CHANGELOG section and correct markdown markup.
- v0.06  
  Added a class definition `units4school`.  
  Fixed the `print` routine to prevent new questions.  
  Makefile now contains a `make test` to check installation.
- v0.05  
  First upload to github  
  Now with a `summary.pdf` with all the data summarized and an ple.
- v0.04  
  Working attempt number one
