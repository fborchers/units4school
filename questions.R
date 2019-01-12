
# library(stringr)

# Read info from files :
# This silently assumes comment.char = "#", so use hashtag to add comments to the csv file. 
# Use ; as separator as this will be used by bash's soffice command.
units    <- read.table(file="build/table.units.csv" ,   sep=";",header=TRUE,colClasses = "character")
prefix   <- read.table(file="build/table.prefix.csv",   sep=";",header=FALSE,colClasses = "character")
constants<- read.table(file="build/table.constants.csv",sep=";",header=TRUE,colClasses = "character")

# print to screen after loading (for testing purposes only):
# print("prefix:")
# print(prefix)
# print(units)


# output LaTeX source code:

# define a print-to-file routine:
Qtofile <- function(file,text){
#	write(paste("%% questiontype is:",questiontype),file,append=true)
	write("\\begin{question}",file,append=TRUE)
	write(text,file,append=TRUE)
	write("\\end{question}",file,append=TRUE)
	write("\\omitsolution",file,append=TRUE)
}

# define a wrap-as-answer routine:
answerwrap <- function(text){
	paste("\\ifprintanswers {\\dotfill \\color{AccentColor}",text,"}\\else \\dotfill \\fi
")
} 

QP <- function(file="build/Q1",text="asdf"){
	# refresh file:
	writeLines(file,text="")
	# generate a random number for questiontype: 
	questiontype <- sample(1:3, 1)
	# generate a random number for the prefix:
	questionprefix <- sample(2:length(prefix[,1]), 1)
	questiontext <- paste(prefix[1,questiontype],prefix[questionprefix,questiontype])
	answertext <- answerwrap(prefix[questionprefix,questiontype%%3+1])
	# write question to file:
	Qtofile(file,text=paste(questiontext,answertext))
}


QU <- function(file,text){
	# refresh file:
	writeLines(file,text="")
	# generate a random number for questiontype: 
	# 5 hard coded: columns 1 3 5 7 9 11 with valid questions.
	questiontype <- sample(2*(0:5)+1, 1)
	# generate a random number for the unit to ask:
	qunit <- sample(2:length(units[,1]),1)
	# generate the text of the question:
	if(questiontype==9){ # "Gib in wissenschaftl. Schreibweise an":
		# Generate a number (4 Nachkommastellen) and append a unit:
		power  <- sample(c(4,3,2,-1,-2,-3),1)
		digits <- 4-power
		number <- sprintf(paste("%.",digits,"f",sep=""),runif(1,0.1,0.999)*10^(power))
		questiontext <- paste("\\SI{",number,"}{",units[qunit,questiontype],"}",sep="")# appending a unit.
		questiontext <- paste(units[1,questiontype],questiontext)# append the question text from units[,].
		answertext   <- answerwrap(paste("\\SI{",sprintf("%.2f",as.numeric(number)/10^(power-1)),"e",power-1,"}{",units[qunit,questiontype],"}"))
	}else{ # any other question: 
		questiontext <- units[qunit,questiontype]
		questiontext <- paste(units[1,questiontype],questiontext)# append the question text from units[,].
		answertext   <- answerwrap(units[qunit,questiontype+1])
	}# end if questiontype.
	# write question to file:
	Qtofile(file,text=paste(questiontext,answertext))
}

QC <- function(file,text){
	# refresh file:
	writeLines(file,text="")
	# generate a random number for questiontype: 
	questiontype <- sample(2*(0:3)+1, 1)
	# generate a random number for the constant to ask:
	qconstant <- sample(2:length(constants[,1]),1)
	while(questiontype ==5 && constants[qconstant,questiontype] == "")
		{qconstant <- sample(2:length(constants[,1]),1)}
	questiontext <- paste(constants[1,questiontype],constants[qconstant,questiontype])
	answertext <- answerwrap(constants[qconstant,questiontype+1])
	Qtofile(file,text=paste(questiontext,answertext))

}


# Print fifteen questions to files:
for(i in 1:15){
	# randomly choose to ask a question...
	type <- sample(c("unit","prefix","constant"),1)
	if(type =="unit") {
		QU(file=paste("build/Q",i,sep=""))
	}
	# or  a prefix question:
	else if(type=="prefix") {
		QP(file=paste("build/Q",i,sep=""))
	}
	else {
		QC(file=paste("build/Q",i,sep=""))
	}	
}