README
======

    units4school
    A Simple Tool to Generate Unit Tests for Physics Teachers
    
    Version: 	v0.20
    OS's:		Linux (Ubuntu, Debian,...) and Mac OS supported
    		    Windows is not supported as of today.
    Source: 	https://github.com/fborchers/units4school
    Date:		Dec. 2023
    Author:		F. Borchers
    Languages:	English, German


SUMMARY
-------

Teaching physics at high-school level can be challenging. Preparing the students for the final exams even more so. One way to make students study is regular testing: just like vocab tests in any of the languages. 
The tool `units4school` is an attempt to automate the generation of such tests. Questions will be generated and put together on an exam sheet (see summary.pdf for an example).
The key idea is that the generation of automatic answers will drastically reduce time and effort to mark the tests. It may even be possible to let students do it for each other.

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
to check if the prerequisites are installed as expected. Then run
	make 12
to generate a test and a printable version for the students. 



MODIFY (easy)
-------------

Clearly, asking the students to know the whole list of units, prefixes and constants is too much in the beginning. For this reason it is possible to modify the set of available questions. To do so there are several ways: (1) delete the lines you do not want to have in the test from their `csv`-files in build/, (2) delete the lines in their `ods` origins, or (3) make the line a comment with a `#` in the first column of the `ods`-file. 
For example, if the test should not contain questions about 'Trägheitsmoment', it must be commented out with a `#` (or deleted):

	#;Trägheitsmoment;$J$;;$J$;\SI{1}{\newton\meter\second\squared};;\SI{1}{\newton\meter\second\squared};\SI{1}{\kilogram\meter\squared};;$\frac{M}{\alpha}$;$J$;;\newton\meter\second\squared;xxx;;$J$;$\frac{M}{\alpha}$;;Trägheitsmoment;J;= M / alpha ;1 N m s;;\newton\meter\second\squared;\kilogram\meter\squared;

Furthermore, it is possible to exclude specific questions about specific units, prefixes or constants by deleting their answers from the corresponding `ods`.


PREREQUISITES
-------------

The following software is required to run units4school:  
	R, sed, LibreOffice, pdflatex, pdfjam

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

Lastly, `soffice` is the command line tool of LibreOffice. On a Linux machine it is available after installing LibreOffice. On Mac you will have to specify the full path to its binary in the makefile. For example on my machine (Mac OS 10.10) this is:
	Applications/LibreOffice.app/Contents/MacOS/soffice

For some reason the conversion utility of OpenOffice does not work (version 4.1.6). The problem is that Apache's OpenOffice's `soffice` comes without the command-line option --convert-to. Use LibreOffice instead, or better still, tell me how to do it with OpenOffice.

If---for whatever reason---the `soffice` routine fails you can use the csv-files provided in the corresponding branch.

