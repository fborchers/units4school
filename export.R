

# Read info from files :
# This silently assumes comment.char = "#", so use hashtag to add comments to the csv file. 
# Use ; as separator as this will be used by bash's soffice command.
units    <- read.table(file="build/table.units.csv" ,   sep=";",header=TRUE,colClasses = "character")
prefix   <- read.table(file="build/table.prefix.csv",   sep=";",header=FALSE,colClasses = "character")
constants<- read.table(file="build/table.constants.csv",sep=";",header=TRUE,colClasses = "character")



tabularwrap <- function(vector){
	# TeX code for the relationship to other constants (contains one '&') :
	if(vector[5] != ""){
		beziehungsformel <- paste("$",vector[10],"=\\;$& ",vector[5],sep="")
	}else {
		beziehungsformel <- "&"
	}
	# 		Name	Zeichen		Wert	Beziehung
	paste(vector[1],vector[3],vector[7],beziehungsformel,"\\\\",sep="& ")
}


##
## Initiate writing to file "build/table.constants.tex" :
##
#  writeLines("build/table.constants.tex",text="Name	& Zeichen	& Größenwert	& Bez \\\\ \\midrule")
write("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%","build/table.constants.tex")
write("%  Übersichtstabelle der physikalischen Konstanten, Vorsätze und Größen","build/table.constants.tex",append=TRUE)
write("%  Created by 'export.R' run in directory: ","build/table.constants.tex",append=TRUE)
write(paste("% ",getwd()),"build/table.constants.tex",append=TRUE)
write(paste("%  Date:",Sys.Date()),"build/table.constants.tex",append=TRUE)
write("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%","build/table.constants.tex",append=TRUE)

## Write all the lines from the csv-file to the tex-file:
# write those lines that are not empty: x[x != ""]
for(i in 2:length(constants[,1][constants[,1] != ""])){
	write(tabularwrap(constants[i,]),"build/table.constants.tex",append=TRUE)
}





##
## Initiate writing to file "build/table.prefix.tex" :

write("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%","build/table.prefix.tex")
write("%  Übersichtstabelle der physikalischen Konstanten, Vorsätze und Größen","build/table.prefix.tex",append=TRUE)
write("%  Created by 'export.R' run in directory: ","build/table.prefix.tex",append=TRUE)
write(paste("% ",getwd()),"build/table.prefix.tex",append=TRUE)
write(paste("%  Date:",Sys.Date()),"build/table.prefix.tex",append=TRUE)
write("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%","build/table.prefix.tex",append=TRUE)

## Write all the lines from the csv-file to the tex-file:
# write those lines that are not empty: x[x != ""]
for(i in 2:length(prefix[,1][prefix[,1] != ""])){
	write(paste(prefix[i,1],"\t & ",prefix[i,2],"\t & ",prefix[i,3]," \\\\",sep=""),"build/table.prefix.tex",append=TRUE)
}






##
## Initiate writing to file "build/table.units.tex" :

write("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%","build/table.units.tex")
write("%  Übersichtstabelle der physikalischen Größen","build/table.units.tex",append=TRUE)
write("%  Created by 'export.R' run in directory: ","build/table.units.tex",append=TRUE)
write(paste("% ",getwd()),"build/table.units.tex",append=TRUE)
write(paste("%  Date:",Sys.Date()),"build/table.units.tex",append=TRUE)
write("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%","build/table.units.tex",append=TRUE)



for(i in 2:length(units[,1][units[,1] != ""])){
	#			Name		Zeichen		Einheit	SI-Einheit		Definition
	write(paste(units$NAME[i],units$ZEICHEN[i],units$EINHEIT[i],if(units$Name.Einheit[i] !=""){paste("\\footnotesize (",units$Name.Einheit[i],")",sep="")}else{paste("")},units$LSG.EINHEIT[i],paste("$",units$Zeichen[i],"=\\;$ &",units$DEFINITION[i])," \\\\",sep="\t& "),"build/table.units.tex",append=TRUE)
	#if(i%%4 ==1){write("\\midrule","build/table.units.tex",append=TRUE)}
}