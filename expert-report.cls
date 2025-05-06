\ProvidesClass{expert-report}[2025/05/03 v0.1 Federal Trade Commission Expert Report Class]

% Add final option
\newif\if@final
\@finalfalse
\DeclareOption{final}{\@finaltrue}

% Force titlepage option
\PassOptionsToClass{titlepage}{article}

% Pass unknown options to the article class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}

% Load the Base Class
\ProcessOptions\relax
\LoadClass{article}

%%%% Packages %%%% 
\usepackage[
    left=1in,
    right=1in,
    top=1.75in,
    bottom=1.75in]{geometry}
\usepackage{setspace}
\usepackage{parskip}
\usepackage{fmtcount}   % For converting counter to integer
\usepackage{fancyhdr}   % For fancy headers/footers
\usepackage{etoolbox}   % For more programming capabilities: pretocmd and apptocmd commands
\usepackage{tabularray} % For advanced table formatting
\usepackage{xcolor}     % For color support


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Style Settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This section sets the style for the expert report class, including section
% numbering and line spacing.

%% Roman numerals for section numbering
\renewcommand{\thesection}{\Roman{section}}
\renewcommand{\thesubsection}{\thesection.\Alph{subsection}}
\renewcommand{\thesubsubsection}{\thesubsection.\arabic{subsubsection}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paragraph Numbering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This section provides paragraph numbering functionality, allowing for
% paragraphs to be numbered in a document. The numbering can be toggled on or
% off using the `\noparnum` command.

% Create a new counter, set it to 0
\newcounter{parcount}
\setcounter{parcount}{0}

% Only display number if "parcbool" is true
\newbool{parcbool}
\booltrue{parcbool}

% If "parconeshot" is true, "parcbool" should be made true after printing the next paragraph
\newbool{parconeshot}
\boolfalse{parconeshot}

% Creates command "noparnum" that activates the numbering and oneshot behavior
\newcommand\noparnum{%
    \boolfalse{parcbool}%
    \booltrue{parconeshot}%
}

% Number paragraphs if parcbool is true and make it true otherwise
\AddToHook{para/begin}{\ifbool{parcbool}{%
        \refstepcounter{parcount}%
        \makebox[0.5in][l]{\decimal{parcount}.}%
    }{%
        \ifbool{parconeshot}{%   
            \booltrue{parcbool}%
            \boolfalse{parconeshot}%
        }{}%
    }}

% No paragraph numbers in sections
\pretocmd{\@ssect}{\boolfalse{parcbool}}{}{}
\apptocmd{\@ssect}{\booltrue{parcbool}}{}{}
\pretocmd{\@sect}{\boolfalse{parcbool}}{}{}
\apptocmd{\@sect}{\booltrue{parcbool}}{}{}

% No paragraph numbers in footnotes
\pretocmd{\@makefntext}{\boolfalse{parcbool}}{}{}
\apptocmd{\@makefntext}{\booltrue{parcbool}}{}{}

% No paragraph numbers in lists
\BeforeBeginEnvironment{itemize}{\boolfalse{parcbool}}
\AfterEndEnvironment{itemize}{\booltrue{parcbool}}
\BeforeBeginEnvironment{enumerate}{\boolfalse{parcbool}}
\AfterEndEnvironment{enumerate}{\booltrue{parcbool}}
\BeforeBeginEnvironment{description}{\boolfalse{parcbool}}
\AfterEndEnvironment{description}{\booltrue{parcbool}}

% No paragraph numbers in math
\BeforeBeginEnvironment{equation}{\boolfalse{parcbool}}
\AfterEndEnvironment{equation}{\booltrue{parcbool}}
\BeforeBeginEnvironment{gather}{\boolfalse{parcbool}}
\AfterEndEnvironment{gather}{\booltrue{parcbool}}
\BeforeBeginEnvironment{multline}{\boolfalse{parcbool}}
\AfterEndEnvironment{multline}{\booltrue{parcbool}}

% One shot overrides
%\pretocmd{\@makefntext}{\noparnum}{}{}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title Page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This section defines the title page for the expert report class, including
% plantiffs, defendants, action number, title, and date.
\renewcommand{\maketitle}{%
    \newgeometry{margin=1in, top=1.75in}% Set margins for the title page
    \boolfalse{parcbool}% Disable paragraph numbering for the title page
    \begin{titlepage}%
        \let\footnotesize\small
        \let\footnoterule\relax
        \let \footnote \thanks
        \begin{center}%
            {\makecaption}%
            \vspace{3.5em}%
            {\bf \@title \par}%
            \vspace{1em}%
            {\@date \par}% % Set date in \large size.
        \end{center}\par
        \@thanks
        \vfil\null
    \end{titlepage}%
    \restoregeometry% Restore the original margins
    \setcounter{footnote}{0}%
    \global\let\thanks\relax
    \global\let\maketitle\relax
    \global\let\@thanks\@empty
    \global\let\@author\@empty
    \global\let\@date\@empty
    \global\let\@title\@empty
    \global\let\title\relax
    \global\let\author\relax
    \global\let\date\relax
    \global\let\and\relax
    \booltrue{parcbool}% Re-enable paragraph numbering after the title page
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Table of Contents
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This section defines the table of contents for the expert report class, which
% removes the title and paragraph numbering from the table of contents page.
\renewcommand{\tableofcontents}{%
    \boolfalse{parcbool}% Disable paragraph numbering for the table of contents
    \@starttoc{toc}%
    \booltrue{parcbool}% Re-enable paragraph numbering after the table of contents
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DRAFT Notice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% We add a draft notice to the top of the document and change the margins if
% the final option is not specified.

% Define the nonfinal pagestyle with a draft notice in red
\def\ps@nonfinal{%
    \def\@evenhead{\hfill\slshape\color{red}{DRAFT -- \today}}%
    \def\@oddhead{\hfill\slshape\color{red}{DRAFT -- \today}}%
    \let\@mkboth\@gobbletwo
    \let\sectionmark\@gobble
    \let\subsectionmark\@gobble
}

\if@final\else
    \pagestyle{nonfinal}%
    \geometry{left=0.75in, right=3in, top=1.75in, bottom=1.75in}%
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adapted from LaWTeX by Christopher de Coro
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%==============================================================================
%% \subsection{Title Page commands}
%%
%% \noindent _\firstparty_, _\secondparty_ --- Sets the name of the first and second parties in the title page or caption.
%%
%% \noindent _\firstpartytitle_, _\secondpartytitle_ --- Set the title (Plaintiff, Defendants, etc.) of the parties.
%%
%% \noindent _\plaintiff_, _\defendant_, _\appellant_, _\appellee_, _\petitioner_, _\respondant_ --- Set both the name and title of each party. 
%% Note that each of these also has a plural version (e.g., _\plaintiffs_).
%%
%% \noindent _\makecaption_ --- Creates a trial-brief style caption, as opposed to a cover page.
%%
%==============================================================================

\newcommand{\sectionline}{\vbox{\baselineskip=1.5pt \hbox{\rule{\linewidth}{.7pt}}\hbox{\rule{\linewidth}{.7pt}}}}
\newcommand{\smallrule}{\rule{.3\linewidth}{.7pt}}

\newcommand{\firstparty}[1]{\def\@firstparty{#1}}
\newcommand{\firstpartytitle}[1]{\def\@firstpartytitle{#1}}
\newcommand{\plaintiff}[1]{\firstparty{#1}\firstpartytitle{Plaintiff}}
\newcommand{\plaintiffs}[1]{\firstparty{#1}\firstpartytitle{Plaintiffs}}
\newcommand{\appellant}[1]{\firstparty{#1}\firstpartytitle{Appellant}}
\newcommand{\appellants}[1]{\firstparty{#1}\firstpartytitle{Appellants}}
\newcommand{\petitioner}[1]{\firstparty{#1}\firstpartytitle{Petitioner}}
\newcommand{\petitioners}[1]{\firstparty{#1}\firstpartytitle{Petitioners}}

\newcommand{\secondparty}[1]{\def\@secondparty{#1}}
\newcommand{\secondpartytitle}[1]{\def\@secondpartytitle{#1}}
\newcommand{\defendant}[1]{\secondparty{#1}\secondpartytitle{Defendant}}
\newcommand{\defendants}[1]{\secondparty{#1}\secondpartytitle{Defendants}}
\newcommand{\appellee}[1]{\secondparty{#1}\secondpartytitle{Appellee}}
\newcommand{\appellees}[1]{\secondparty{#1}\secondpartytitle{Appellees}}
\newcommand{\respondent}[1]{\secondparty{#1}\secondpartytitle{Respondent}}
\newcommand{\respondents}[1]{\secondparty{#1}\secondpartytitle{Respondents}}

\newcommand*{\actionnumber}[1]{\def\@actionnumber{#1}}
\newcommand{\court}[1]{\def\@court{#1}}

\def\@firstparty{\@latex@warning@no@line{No \noexpand\firstparty given}}
\def\@firstpartytitle{Plaintiff}
\def\@secondparty{\@latex@warning@no@line{No \noexpand\secondparty given}}
\def\@secondpartytitle{Defendant}
\def\@actionnumber{\@latex@warning@no@line{No \noexpand\actionnumber given}}
\def\@court{\@latex@warning@no@line{No \noexpand\court given}}

\newcommand{\makecaption}{{
            \begin{singlespace}
                \bf\scshape \@court \\~\\ 
                \vspace{1.5em}
                \rm 
                \begin{tblr}{
                    colspec={Q[1,l]|Q[1,c]},
                    rowspec={Q[m]},
                    width=\linewidth,
                    }
                    \cline{1-1}
                    {
                    ~
                    
                    \raggedright\@firstparty, 
                    
                    ~
                    
                    {\leftskip=1in plus 1.fill minus .5in%
                    \textit{\@firstpartytitle,}\par}
                    
                    \hspace*{1in}v.
                    
                    ~ 
                    
                    \raggedright\@secondparty, 
                    
                    ~
                    
                    {\leftskip=1in plus 1.fill minus .5in%
                    \textit{\@secondpartytitle.}\par}
                    ~
                    } & {\@actionnumber} \\
                    \cline{1}
                \end{tblr}
            \end{singlespace}
        }}
