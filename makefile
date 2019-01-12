#	
FILE     := einheitenabfrage
OBJDIR   := build
LOG      := $(OBJDIR)/LOG
QUESTIONS:= $(addprefix $(OBJDIR)/, Q1 Q2 Q3 Q4 Q5 Q6 Q7 Q8 Q9 Q10 Q11 Q12 Q13 Q14 Q15)
csvfiles := $(OBJDIR)/table.units.csv $(OBJDIR)/table.prefix.csv $(OBJDIR)/table.constants.csv

.PHONY: questions dvi ps pdf out print test clean distclean

# This phony target force make to generate new questions every run:
.PHONY: $(OBJDIR)/Q1

questions: $(QUESTIONS)
dvi: $(OBJDIR)/$(FILE).dvi
ps:  $(OBJDIR)/$(FILE).ps
pdf: out_$(FILE).pdf
print: print_$(FILE).pdf

.PRECIOUS: $(QUESTIONS) $(csvfiles)


$(OBJDIR):
	mkdir $(OBJDIR)

# Generic rule to create the readable csv-files for R:
# 'soffice' is a command-line tool to convert from LibreOffice to textfile.
# The bit 1 (or 2) >/dev/null at end of line will suppress printing to the terminal.
# #1>/dev/null 2>/dev/null
table.%.csv: table.%.ods
	@soffice --headless --convert-to csv:"Text - txt - csv (StarCalc)":59,ANSI,0 $< 

# cp the csv file to build/ and at the same time replace
# the string '\pi' with '\numpi', see
$(OBJDIR)/table.%.csv: table.%.csv | $(OBJDIR)
	@# mv $< $@
	@sed "s/\pi/numpi/g" $< > $@

# generc rule to make a question:
# test.R routine will make all 15 questions at once
$(OBJDIR)/Q1: $(csvfiles) questions.R
	@#echo "Generating questions ..."
	@Rscript questions.R

# General rule to generate the pdf file:
# LaTeX routine:
#build/%.dvi: %.tex $(QUESTIONS)
#	@echo "Running LaTeX on input file (compilation log in $(LOG))..."
#	@echo "\t latex -output-directory=build $<"
#	@latex -output-directory=build $< > $(LOG) 2>&1
#build/%.ps: build/%.dvi 
#	@echo "Converting $< to Postscript..."
#	@dvips -o $@ $< >> $(LOG) 2>&1
$(OBJDIR)/%.pdf: %.tex $(QUESTIONS)
	@#echo "Converting $< to PDF..."
	@#ps2pdf $< $@ >> $(LOG) 2>&1
	@#echo "\t pdflatex -output-directory=build $<"
	@pdflatex -output-directory=build $< > $(LOG) 2>&1
out_%.pdf: $(OBJDIR)/%.pdf
	@cp $< $@
print_%.pdf: $(OBJDIR)/%.pdf
	@# Again, 1>/dev/null 2>/dev/null will suppress messages. 
	@pdfnup --landscape --nup 2x1 $< $< --outfile $@ 1>/dev/null 2>/dev/null




test:
	echo $(QUESTIONS) 
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
