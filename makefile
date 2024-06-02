#	
FILE     := units4school
OBJDIR   := build
PDFFILE  := $(OBJDIR)/$(FILE).pdf
LOG      := $(OBJDIR)/LOG
QUESTIONS:= $(addprefix $(OBJDIR)/, Q1 Q2 Q3 Q4 Q5 Q6 Q7 Q8 Q9 Q10 Q11 Q12 Q13 Q14 Q15 Q16)
srcfiles := table.units.ods table.prefix.ods table.constants.ods

# Variable `soffice` holds a link to LibreOffice's command-line tool:
# On a Mac this has to be the full path to soffice. On the iMac I have this was:
# soffice := /Volumes/DISKNAME/Applications/LibreOffice.app/Contents/MacOS/soffice
# However, on the new Mac I got thereafter this was no longer necessary
soffice  := soffice

.PHONY: export out pdf print  

# This phony target force make to generate new questions every run:
.PHONY: $(OBJDIR)/Q1

#dvi: $(OBJDIR)/$(FILE).dvi
#ps:  $(OBJDIR)/$(FILE).ps
#pdf: out_$(FILE).pdf
print: print_$(FILE).pdf





$(OBJDIR):
	@mkdir $(OBJDIR)

# Create the editable ods-tables 
# (?) from their order-only ( | ) sources.
# You will have to add one column in front with "#"s in the 
# ods-files to disable some rows.
# To be used as ...10.ods  or ...11.ods :
$(OBJDIR)/table.prefix.%.ods: table.prefix.ods | $(OBJDIR)
	@cp $< $@
$(OBJDIR)/table.units.%.ods: table.units.ods | $(OBJDIR)
	@cp $< $@
$(OBJDIR)/table.constants.%.ods: table.constants.ods | $(OBJDIR)
	@cp $< $@

# Generic rule to create the readable csv-files for R:
# 'soffice' is a command-line tool to convert from LibreOffice to textfile.
# The bit 1 (or 2) >/dev/null at end of line will suppress printing to the terminal.
$(OBJDIR)/table.%.csv: $(OBJDIR)/table.%.ods
	@$(soffice) --headless --convert-to csv:"Text - txt - csv (StarCalc)":59,ANSI,0 --outdir $(OBJDIR)/ $< 1>/dev/null 2>/dev/null
# The intermediate target table.%.csv will be deleted automatically;
# this is why a line "rm table.prefix.10.csv ..." might appear.
# The resulting csv-file will be moved to $(OBJDIR) in the next step.


# Copy the csv file to $(OBJDIR) and at the same time replace
# the string '\pi' with '\numpi'. This is a workaround, see 
# units4school.tex for its handling of \numpi.
# Also, order-only dependency on $(OBJDIR); the directory just 
# has to be present there:
#$(OBJDIR)/table.%.csv: table.%.csv | $(OBJDIR)
#	@# mv $< $@
#	@sed "s/\pi/numpi/g" $< > $@
# This has become expendable since the redefinition of \mu_0 
# as a numeric value.


10.ods := $(addprefix $(OBJDIR)/,$(addsuffix .10.ods,$(basename $(srcfiles))))
11.ods := $(addprefix $(OBJDIR)/,$(addsuffix .11.ods,$(basename $(srcfiles))))
12.ods := $(addprefix $(OBJDIR)/,$(addsuffix .12.ods,$(basename $(srcfiles))))
13.ods := $(addprefix $(OBJDIR)/,$(addsuffix .13.ods,$(basename $(srcfiles))))

# Precious files will not be deleted in a single run (overzealous deletion):
.PRECIOUS:  $(10.ods) $(11.ods) $(12.ods) $(13.ods) 

10.csv := $(addsuffix .csv,$(basename $(10.ods)))
11.csv := $(addsuffix .csv,$(basename $(11.ods)))
12.csv := $(addsuffix .csv,$(basename $(12.ods)))
13.csv := $(addsuffix .csv,$(basename $(13.ods)))


# Now, the actual build routines:
.PHONY: 10 11 12 13

10: questions.R $(10.csv)
	@echo "Generating questions ..."
	@Rscript questions.R 10
	@echo "Running LaTeX on input file (compilation log in $(LOG))..."
	@echo "\tpdflatex -output-directory=build $(FILE).tex"	
	@pdflatex -output-directory=build $(FILE).tex > $(LOG) 2>&1	
	@#mv $(OBJDIR)/$(FILE).pdf out_einheitenabfrage.pdf
	@pdfjam --landscape --nup 2x1 $(OBJDIR)/$(FILE).pdf $(OBJDIR)/$(FILE).pdf --outfile out_einheitenabfrage.pdf 1>/dev/null 2>/dev/null
	@pdflatex -output-directory=build "\PassOptionsToClass{answers}{./units4school}\input{$(FILE).tex}" > $(LOG) 2>&1
	@mv $(OBJDIR)/$(FILE).pdf out_einheitenloesungen.pdf

11: questions.R $(11.csv)
	@echo "Generating questions ..."
	@Rscript questions.R 11
	@echo "Running LaTeX on input file (compilation log in $(LOG))..."
	@echo "\tpdflatex -output-directory=build $(FILE).tex"	
	@pdflatex -output-directory=build $(FILE).tex > $(LOG) 2>&1	
	@#mv $(OBJDIR)/$(FILE).pdf out_einheitenabfrage.pdf
	@pdfjam --landscape --nup 2x1 $(OBJDIR)/$(FILE).pdf $(OBJDIR)/$(FILE).pdf --outfile out_einheitenabfrage.pdf 1>/dev/null 2>/dev/null
	@pdflatex -output-directory=build "\PassOptionsToClass{answers}{./units4school}\input{$(FILE).tex}" > $(LOG) 2>&1
	@mv $(OBJDIR)/$(FILE).pdf out_einheitenloesungen.pdf

12: questions.R $(12.csv)
	@echo "Generating questions ..."
	@Rscript questions.R 12
	@echo "Running LaTeX on input file (compilation log in $(LOG))..."
	@echo "\tpdflatex -output-directory=build $(FILE).tex"	
	@pdflatex -output-directory=build $(FILE).tex > $(LOG) 2>&1	
	@#mv $(OBJDIR)/$(FILE).pdf out_einheitenabfrage.pdf
	@pdfjam --landscape --nup 2x1 $(OBJDIR)/$(FILE).pdf $(OBJDIR)/$(FILE).pdf --outfile out_einheitenabfrage.pdf 1>/dev/null 2>/dev/null
	@pdflatex -output-directory=build "\PassOptionsToClass{answers}{./units4school}\input{$(FILE).tex}" > $(LOG) 2>&1
	@mv $(OBJDIR)/$(FILE).pdf out_einheitenloesungen.pdf

13: questions.R $(13.csv)
	@echo "Generating questions ..."
	@Rscript questions.R 13
	@echo "Running LaTeX on input file (compilation log in $(LOG))..."
	@echo "\tpdflatex -output-directory=build $(FILE).tex"	
	@pdflatex -output-directory=build $(FILE).tex > $(LOG) 2>&1	
	@#mv $(OBJDIR)/$(FILE).pdf out_einheitenabfrage.pdf
	@pdfjam --landscape --nup 2x1 $(OBJDIR)/$(FILE).pdf $(OBJDIR)/$(FILE).pdf --outfile out_einheitenabfrage.pdf 1>/dev/null 2>/dev/null
	@pdflatex -output-directory=build "\PassOptionsToClass{answers}{./units4school}\input{$(FILE).tex}" > $(LOG) 2>&1
	@mv $(OBJDIR)/$(FILE).pdf out_einheitenloesungen.pdf


# A simple print routine :
pdf: out_einheitenabfrage.pdf
out_einheitenabfrage.pdf: $(FILE).tex questions.R
	pdflatex -output-directory=build $(FILE).tex > $(LOG) 2>&1
	@mv $(OBJDIR)/$(FILE).pdf out_einheitenabfrage.pdf






.PHONY: clean distclean view export test  

# VIEW Mac routine
view: | out_einheitenloesungen.pdf
	@open out_einheitenloesungen.pdf

# This test routine will check if the necessary programs are installed:
test:
	@echo "...Looking for pdflatex..."
	pdflatex -v
	@echo "\n...Looking for R software..."
	R --version
	@echo "\n...Looking for pdfjam..."
	pdfjam --version
	@echo "\n...Looking for LibreOffice's soffice ..."
	soffice --version

clean: 
	@rm -f $(LOG) 
	@rm -f $(QUESTIONS)
	@rm -f out_$(FILE).pdf print_$(FILE).pdf
	@rm -f out_einheitenabfrage.pdf out_einheitenloesungen.pdf
	@rm -f $(OBJDIR)/$(FILE).pdf 
	@rm -f $(OBJDIR)/$(FILE).ps
	@rm -f $(OBJDIR)/$(FILE).dvi
	@rm -f $(OBJDIR)/$(FILE).aux
	@rm -f $(OBJDIR)/$(FILE).log
	@rm -f $(OBJDIR)/$(FILE).out
	@rm -f $(OBJDIR)/table.*.csv


distclean: clean
	@rm -f $(OBJDIR)/table.*.ods
