#	
FILE     := units4school
OBJDIR   := build
PDFFILE  := $(OBJDIR)/$(FILE).pdf
LOG      := $(OBJDIR)/LOG
QUESTIONS:= $(addprefix $(OBJDIR)/, Q1 Q2 Q3 Q4 Q5 Q6 Q7 Q8 Q9 Q10 Q11 Q12 Q13 Q14 Q15)
csvfiles := $(OBJDIR)/table.units.csv $(OBJDIR)/table.prefix.csv $(OBJDIR)/table.constants.csv

# Variable `soffice` holds a link to LibreOffice's command-line tool:
# On a Mac this has to be the full path to soffice.
soffice  := soffice

.PHONY: pdf out print test clean distclean

# This phony target force make to generate new questions every run:
.PHONY: $(OBJDIR)/Q1

#dvi: $(OBJDIR)/$(FILE).dvi
#ps:  $(OBJDIR)/$(FILE).ps
pdf: out_$(FILE).pdf
print: print_$(FILE).pdf

test: $(QUESTIONS) 


# Precious files will not be deleted in a single run (overzealous deletion):
.PRECIOUS: $(QUESTIONS) $(csvfiles) $(PDFFILE)


$(OBJDIR):
	@mkdir $(OBJDIR)

# Generic rule to create the readable csv-files for R:
# 'soffice' is a command-line tool to convert from LibreOffice to textfile.
# The bit 1 (or 2) >/dev/null at end of line will suppress printing to the terminal.
table.%.csv: table.%.ods
	@$(soffice) --headless --convert-to csv:"Text - txt - csv (StarCalc)":59,ANSI,0 $< 1>/dev/null 2>/dev/null

# Copy the csv file to $(OBJDIR) and at the same time replace
# the string '\pi' with '\numpi'. This is a workaround, see 
# units4school.tex for its handling of \numpi.
#
# Also, order-only dependency on $(OBJDIR); the directory just has to be there:
$(OBJDIR)/table.%.csv: table.%.csv | $(OBJDIR)
	@# mv $< $@
	@sed "s/\pi/numpi/g" $< > $@

# generc rule to make a question:
# test.R routine will make all 15 questions at once (save runtime):
$(OBJDIR)/Q1: $(csvfiles) questions.R
	@#echo "Generating questions ..."
	@Rscript questions.R


# General rule to generate the pdf file:
# File out_%.pdf shall contain the answers of the test, so that's
# why the option 'answers' is passed on to LaTeX:
out_%.pdf: %.tex $(QUESTIONS)
	@pdflatex -output-directory=build "\PassOptionsToClass{answers}{./units4school}\input{$<}" > $(LOG) 2>&1
	@mv $(OBJDIR)/$*.pdf $@
# If 'out' had been called, only then will $(OBJDIR)/%.aux have changed.
# File print_%.pdf shall not contain any answers, so no options passed:
print_%.pdf: %.tex $(OBJDIR)/%.aux
	@pdflatex -output-directory=build $< > $(LOG) 2>&1
	@# Again, 1>/dev/null 2>/dev/null will suppress messages. 
	@pdfnup --landscape --nup 2x1 $(OBJDIR)/$*.pdf $(OBJDIR)/$*.pdf --outfile $@ 1>/dev/null 2>/dev/null




clean: 
	@rm -f $(LOG) 
	@rm -f $(QUESTIONS)
	@rm -f out_$(FILE).pdf print_$(FILE).pdf
	@rm -f $(OBJDIR)/$(FILE).pdf 
	@rm -f $(OBJDIR)/$(FILE).ps
	@rm -f $(OBJDIR)/$(FILE).dvi
	@rm -f $(OBJDIR)/$(FILE).aux
	@rm -f $(OBJDIR)/$(FILE).log
	@rm -f $(OBJDIR)/$(FILE).out

distclean: clean
	@rm -f $(OBJDIR)/table.*.csv
	@rm -f table.*.csv