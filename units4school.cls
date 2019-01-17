%%
% Class Definition for the units4school Project --------
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{./units4school}[2019/01/15 first PassOptionsToClass]
% It seems overkill to define a class for this simple project, 
% the the class allows for options that can be passed from 
% the command line like this:
%	pdflatex "\PassOptionsToClass{answers}{./units4school}\input{units4school}"
% which *will* print the answers. In contrast, running:
%	pdflatex units4school.tex
% will *not* print the answers. 

\LoadClass{article}



\newif\ifprintanswers
\printanswersfalse

% Option whether or not answers will be printed:
\DeclareOption{answers}{\printanswerstrue}
%\DeclareOption{noanswers}{\printanswersfalse}
\ProcessOptions\relax 
% This last line finishes the option declarations of the class file.




\newcounter{exerciseID}

% The environment shall contain single questions. 
% The questions number will be printed on the left margin. 
% The exerciseID counter is used to number the questions 
% starting at one, and to control the number of questions.
\newenvironment{question}[1][] % optional argument to ignore exercise points if provided
{
	\refstepcounter{exerciseID}%
	\trivlist%
		\item[\llap{\theexerciseID.}]{}%
}% end of begin environment question.
{\endtrivlist}% end question environment


%% Backward compatibility :
\newcommand{\omitsolution}{}
