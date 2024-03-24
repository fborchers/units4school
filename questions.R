# Question Generator for 'units4school' --------
#
# For version info consult the file VERSION


# Read arguments from command-line (this will be transferred 
# from the makefile call) :
args <- commandArgs(T)[1]
# args <- 12 # (for testing only, comment out to run!).


# This R script consists of four parts: 
# the input from the *.ods tables,
# the generation of question combinations,
# an output routine to create LaTeX code, and
# the actual printing of the questions to files.




#### ##    ## ########  ##     ## ######## 
 ##  ###   ## ##     ## ##     ##    ##    
 ##  ####  ## ##     ## ##     ##    ##    
 ##  ## ## ## ########  ##     ##    ##    
 ##  ##  #### ##        ##     ##    ##    
 ##  ##   ### ##        ##     ##    ##    
#### ##    ## ##         #######     ##    


# PART 1 --- Read info from files :

# The read routine 'read.table' silently assumes comment.char = "#", 
# so use hashtag to add comments to the csv file, or at the beginning
# of a line comment out the whole line.
# The call of 'read.table' will use a ';' as separator as 
# this will be used by bash's 'soffice' command (see below).

file1 <- paste("build/table.units.",args,".csv",sep="")
units    <- read.table(file=file1,sep=";",header=TRUE,colClasses = "character")

file1 <- paste("build/table.prefix.",args,".csv",sep="")
prefix   <- read.table(file=file1,   sep=";",header=FALSE,colClasses = "character")

file1 <- paste("build/table.constants.",args,".csv",sep="")
constants<- read.table(file=file1,sep=";",header=TRUE,colClasses = "character")

# Now the three arrays of 'units', 'prefix' and 'constants'
# contain all the information to be used.






 ######  ##    ## ####### ###### ######## ####  ######  ##    ##    
##    ## ##    ## ##     ##    ##   ##     ##  ##    ## ###   ##    
##    ## ##    ## ##     ##         ##     ##  ##    ## ####  ##    
##    ## ##    ## ######  ######    ##     ##  ##    ## ## ## ##    
## ## ## ##    ## ##           ##   ##     ##  ##    ## ##  ####    
##   ##  ##    ## ##     ##    ##   ##     ##  ##    ## ##   ###    
 #### ##  ######  ####### ######    ##    ####  ######  ##    ##

# PART II --- Generate valid question combinations :

# Generate N (a lot of) random question parameters as a simple list. 
# This will set the probability distribution of the three
# question:
questions <- sample(c("unit","unit","unit","prefix","prefix","constant"),1000,replace=TRUE)


# Hard-code the number of question types for each of the three
# questions (unit, prefix or constant).
numunits <- 5 # manually: no of questions in units.ods minus 1.
numprefix<- 4 # manually: no of questions in prefix.ods minus 1.
numconsts<- 3 # manually.
# numquestions defined manually below.

# For each of the 50 question parameters a type has to be chosen. 
# The question type is the corresponding column of the *.ods table. 
# This is different for all the different *.ods tables.
type <- function (string){
  if(string == "unit"){
    # be careful, there is a hard coded reference (wissenschaftl. Schreibw) below:
    qtype <- sample(3*(0:numunits)+2, 1)}
  else if (string == "prefix"){  
    qtype <- sample(3*(0:numprefix)+2, 1)}
  else if (string == "constant"){
    qtype <- sample(3*(0:numconsts)+2, 1)}
} # and now apply this to add a column 'questiontype':

# Continue to choose the line (Zeile) 'arow' to ask. 
# The lines of the *.ods tables contain different units, 
# prefixes or constants. Here we randomly choose one line 
# and extract a possible question from there.
# The value length(...[,1]) is equal to the last line of the file:
zeile <- function (arow){
  if(arow[1]=="unit"){
    sample(2:length(units[,1]),1)
  }
  else if (arow[1]=="prefix"){
    sample(2:length(prefix[,1]), 1)
  }
  else if (arow[1]=="constant"){
    sample(2:length(constants[,1]),1)
  }
}# end definition of function zeile. 


# Apply the functions 'type' and 'zeile' to the N questions
# in the 'questions' column:
questionmatrix <- cbind(questions,lapply(questions,type),lapply(cbind(questions,lapply(questions,type)),zeile))
# For each line the upper command creates two lines. One of
# those two lines has a NULL value for the line. For this reason 
# use the top length(questions) lines only:
questionmatrix <- unique(questionmatrix[1:length(questions),])
# Now remove the lines duplicated wrt unit/prefix/constant and row:
questionmatrix <- questionmatrix[!duplicated(questionmatrix[,0-2]), ]
# Set the columns names of the matrix as follows:
colnames(questionmatrix) <- c("question","questiontype","questionrow")


# Routine to check whether or not a question (ie. a line from the question-
# matrix dubbed 'qq' in this context) has an answer. To do this we check 
# the tables of units, prefixes and constants. 
# The tables are organised in such a way that each answer is stored 
# in the cell to the right, i.e. check questiontype+1 :
hasSolution <- function (qq){
  # if it's a unit question:
  if(qq$question == "unit"){
    if(units[qq$questionrow,qq$questiontype+1]!=""){TRUE}
    else {FALSE}
  }
  else if (qq$question == "prefix"){
    if(prefix[qq$questionrow,qq$questiontype+1]!=""){TRUE}
    else {FALSE}
  }
  else if (qq$question == "constant"){
    if(constants[qq$questionrow,qq$questiontype+1]!=""){TRUE}
    else {FALSE}
  }
}# end function hasSolution.




# Now apply the hasSolution function to the questionmatrix. This 
# will create a vector of TRUE/FALSE values:
solutions <- apply(questionmatrix,MARGIN=1,hasSolution)
# Then use the solution vector to filter the questions that have answers:
questionmatrix <- questionmatrix[solutions,1:3]
# Now the 'questionmatrix' consists of three columns. They
# are 'type' 'question' and 'answer' like the following:
#  [1,]  "unit"     2    13         
#  [2,]  "constant" 2    6          
#  [3,]  "prefix"   3    4    
# The length varies around 30 because some questions (those without
# an answer) have been filtered out. 

# For debuggin only :
#write.table(questionmatrix,file="data")







 #######  ##     ## ######## ########  ##     ## ######## 
##     ## ##     ##    ##    ##     ## ##     ##    ##    
##     ## ##     ##    ##    ##     ## ##     ##    ##    
##     ## ##     ##    ##    ########  ##     ##    ##    
##     ## ##     ##    ##    ##        ##     ##    ##    
##     ## ##     ##    ##    ##        ##     ##    ##    
 #######   #######     ##    ##         #######     ##    

# PART III --- Output LaTeX source code :

# define a print-to-file routine:
Qtofile <- function(file,text){
  write("\\begin{question}",file,append=TRUE)
  write(text,file,append=TRUE)
  write("\\end{question}",file,append=TRUE)
  # This '\omitsolution' is for LaTeX's happiness only,
  # answers are printed in a different way (see answerwrap below).
  write("\\omitsolution",file,append=TRUE)
}# end Qtofile.


# define a wrap-as-answer routine:
answerwrap <- function(text){
  paste("\\ifprintanswers {\\dotfill \\color{AccentColor}",text,"}\\else \\dotfill \\fi
")
}# end answerwrap.




# Functions to use with the QU/QP operators ---

# This function will determine the power of ten used for the
# 'technische Schreibweise':
findEngineeringPower <- function(potenz){
  if(potenz>0)floor(potenz/3)*3
  else if(potenz<0)-ceiling(-potenz/3)*3
  else if(potenz==0) 0
}# end function definition findTechnicalPrefix

# Extract the prefix as string from the power of ten:
getEngineeringPrefix <- function(potenz){
  pos <- match(potenz,c(-18,-15,-12,-9,-6,-3,-2,-1,0,2,3,6,9,12,15))
  c("\\atto","\\femto","\\pico","\\nano","\\micro","\\milli","\\centi","\\deci","","\\hecto","\\kilo","\\mega","\\giga","\\tera","\\peta")[pos]
}


# This function will produce the engineering notation as a
# LaTeX siunitx-compatible string:
tSw <- function(zahl,potenz=0,einheit=""){
  zahl <- zahl * 10^(potenz)
  s<-as.numeric(strsplit(format(zahl, scientific=T),"e")[[1]])
  # This split is from https://stat.ethz.ch/pipermail/r-help/2006-July/108808.html
  zahl <- s[1]*10^(s[2]%%3)
  power<- as.integer(s[2]-(s[2]%%3))
  prefix <- getEngineeringPrefix(power)
  if(einheit=="") paste("Einheit fehlt")
  else paste("\\SI{",zahl,"}{",prefix,einheit,"}",sep="")
} # end function tSw.



# This function will produce the scientific notation and
# return a LaTeX siunitx-compatible string:
wSw <- function(zahl, potenz=0, verschiebung=0,einheit=""){
  zahl <- zahl * 10^(potenz)
  zahl <- formatC(zahl, format = "e", digits = 3)
  if(einheit=="") paste("\\num{",zahl,"}",sep="")
  else paste("\\SI{",zahl,"}{",einheit,"}",sep="")
} # end function wSw.





 #######  ##     ## 
##     ## ##     ## 
##     ## ##     ## 
##     ## ##     ## 
##  ## ## ##     ## 
##    ##  ##     ## 
 ##### ##  #######  

QU <- function(file,params){
  # refresh file, i.e. overwrite its content:
  writeLines(file,text="")
  questiontype <- params$questiontype
  qunit        <- params$questionrow
  # For debugging add a comment in the file:
  write(paste("%Einheit vom Typ:",questiontype,"Zeile",qunit),file,append=TRUE)
  # generate the text of the question:
  if(questiontype==14){ # "Gib in wissenschaftl. Schreibweise an":
    # Generate a number (with 4 significant digits) and append a unit:
    power  <- sample(c(4,3,2,-1,-2,-3),1)
    digits <- 4-power
    # now generate one (n=1) random number with runif(n, min = 0, max = 1):
    # This disgusting construction sprintf(paste("%.",digits will
    # produce a string with four relevant digits:
    number <- sprintf(paste("%.",digits,"f",sep=""),runif(1,0.1,0.998)*10^(power))
    einheit<- units[qunit,questiontype]
    # Put the question together as one string:
    questiontext <- paste("\\SI{",number,"}{",einheit,"}",sep="")
    # append the question text from units[,]:
    questiontext <- paste(units[1,questiontype],questiontext)
    # and the answer to the question: 
    answertext   <- answerwrap(wSw(zahl=as.numeric(number),einheit=einheit))
  }else{ # any other question: 
    questiontext <- units[qunit,questiontype]
    footnotetext <- units[qunit,questiontype+2]
    # append the question text from units[,]:
    questiontext <- paste(units[1,questiontype],footnotetext,": ",questiontext,sep="")
    answertext   <- answerwrap(units[qunit,questiontype+1])
  }# end if questiontype.
  # write question to file:
  Qtofile(file,text=paste(questiontext,answertext))
}# end definition of function QU.





 #######  ########  
##     ## ##     ## 
##     ## ##     ## 
##     ## ########  
##  ## ## ##        
##    ##  ##        
 ##### ## ##        

QP <- function(file="build/Q1",params){
  # refresh file:
  writeLines(file,text="")
  questiontype <- params$questiontype
  questionprefix <- params$questionrow
  # For debugging add a comment in the file:
  write(paste("% Vorsatz: Typ",questiontype,"Zeile",questionprefix),file,append=TRUE)
  # questions of the type: 'Gib in wissensch. Schreibweise an...' 
  if(questiontype==11){
    power <- as.numeric(prefix[questionprefix,questiontype])
    write(paste("% ",prefix[questionprefix,questiontype],typeof(power),sep=" "),file,append=TRUE)
    # Extract a unit from the ones available under 'LSG...' :
    einheit<- strsplit(prefix[questionprefix,questiontype+1],",")[[1]]
    einheit<- einheit[sample(1:length(einheit),1)]
    # Generate a random number to ask in this question:
    zahl <- round(runif(1,0.1,0.998),3)*10^(sample(c(-2,-1,0,1,2,3),1))
    vorsatz <- prefix[questionprefix,questiontype]
    questiontext <- paste("\\SI{",zahl,"}{",getEngineeringPrefix(vorsatz),einheit,"}",sep="")
    footnotetext <- prefix[questionprefix,questiontype+2]
    questiontext <- paste(prefix[1,questiontype],footnotetext,": ",questiontext,sep="")
    answertext <- answerwrap(wSw(zahl=zahl,potenz = power,einheit=einheit))
  }else if(questiontype==14){# 'Gib in techn. Schreibweise an...'
    power <- as.numeric(prefix[questionprefix,questiontype])
    write(paste("% ",prefix[questionprefix,questiontype],typeof(power),sep=" "),file,append=TRUE)
    # Extract a unit from the ones available under 'LSG...' :
    einheit<- strsplit(prefix[questionprefix,questiontype+1],",")[[1]]
    einheit<- einheit[sample(1:length(einheit),1)]
    # Generate a random number to ask in this question:
    zahl <- round(runif(1,0.1,0.998),3)*10^(sample(c(1,2,3),1))
    questiontext <- wSw(zahl=zahl,potenz=power, einheit=einheit)
    footnotetext <- prefix[questionprefix,questiontype+2]
    questiontext <- paste(prefix[1,questiontype],footnotetext,": ",questiontext,sep="")
    answertext <- answerwrap(tSw(zahl=zahl,potenz = power,einheit=einheit))
  }else{ # any other question can be treated regularly: 
    questiontext <- prefix[questionprefix,questiontype]
    footnotetext <- prefix[questionprefix,questiontype+2]
    questiontext <- paste(prefix[1,questiontype],footnotetext,": ",questiontext,sep="")
    answertext <- answerwrap(prefix[questionprefix,questiontype+1])
  }# end if questiontype.
  # write question to file:
  Qtofile(file,text=paste(questiontext,answertext))
}# end definition of function QP.

# Debug:
#QP(file="build/Q1",params=questionmatrix[3,2:3])



 #######   ######  
##     ## ##    ## 
##     ## ##       
##     ## ##       
##  ## ## ##       
##    ##  ##    ## 
 ##### ##  ######  

QC <- function(file,params){
  # refresh file:
  writeLines(file,text="")
  questiontype <- params$questiontype
  qconstant <- params$questionrow
  # For debugging add a comment in the file:
  write(paste("%Konstante von Typ:",questiontype,"Zeile:",qconstant),file,append=TRUE)
  while(questiontype ==6 && constants[qconstant,questiontype] == "")
  {qconstant <- sample(2:length(constants[,1]),1)}
  questiontext <- constants[qconstant,questiontype]
  footnotetext <- constants[qconstant,questiontype+2]
  questiontext <- paste(constants[1,questiontype],footnotetext,": ",questiontext,sep="")
  answertext <- answerwrap(constants[qconstant,questiontype+1])
  Qtofile(file,text=paste(questiontext,answertext)) 
}# end definition of function QC.








########  ########  #### ##    ## ######## 
##     ## ##     ##  ##  ###   ##    ##    
##     ## ##     ##  ##  ####  ##    ##    
########  ########   ##  ## ## ##    ##    
##        ##   ##    ##  ##  ####    ##    
##        ##    ##   ##  ##   ###    ##    
##        ##     ## #### ##    ##    ##    

# PART IV --- Print a lot of questions to files :

numquestions <- 20

for(i in 1:numquestions){
  # Get question from questionmatrix: 
  type <- questionmatrix[i,1]
  # if it's going to be a unit question :
  if(type =="unit") {
    QU(file=paste("build/Q",i,sep=""),params=questionmatrix[i,2:3])
  }
  # or else a prefix question:
  else if(type=="prefix"){
    QP(file=paste("build/Q",i,sep=""),params=questionmatrix[i,2:3])
  }
  # or else a constant question:
  else if(type=="constant") {
    QC(file=paste("build/Q",i,sep=""),params=questionmatrix[i,2:3])
  }
  else {}# should not occurr.
}# end for.




