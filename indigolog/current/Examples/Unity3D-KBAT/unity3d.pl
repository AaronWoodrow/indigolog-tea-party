%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE    : Examples/Unity3D-KBAT/unity3d.pl
%
%       Axiomatization of the Wumpus World 
%       under the BAT with possible values evaluator
%
%  AUTHOR : Stavros Vassos & Sebastian Sardina (2005)
%  email  : {ssardina,stavros}@cs.toronto.edu
%  WWW    : www.cs.toronto.edu/cogrobo
%  TYPE   : system independent code
%  TESTED : SWI Prolog 5.0.10 http://www.swi-prolog.org
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                             May 18, 2001
%
% This software was developed by the Cognitive Robotics Group under the
% direction of Hector Levesque and Ray Reiter.
% 
%        Do not distribute without permission.
%        Include this notice in any copy made.
% 
% 
%         Copyright (c) 2000 by The University of Toronto,
%                        Toronto, Ontario, Canada.
% 
%                          All Rights Reserved
% 
% Permission to use, copy, and modify, this software and its
% documentation for non-commercial research purpose is hereby granted
% without fee, provided that the above copyright notice appears in all
% copies and that both the copyright notice and this permission notice
% appear in supporting documentation, and that the name of The University
% of Toronto not be used in advertising or publicity pertaining to
% distribution of the software without specific, written prior
% permission.  The University of Toronto makes no representations about
% the suitability of this software for any purpose.  It is provided "as
% is" without express or implied warranty.
% 
% THE UNIVERSITY OF TORONTO DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS
% SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
% FITNESS, IN NO EVENT SHALL THE UNIVERSITY OF TORONTO BE LIABLE FOR ANY
% SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
% RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF
% CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
% CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%  A possible-value basic action theory (KBAT) is described with:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* IndiGolog caching: fluents that are heavily used should be cached */
cache(locGirl).
cache(_):-fail.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  0 - DEFINITIONS OF DOMAINS/SORTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

item(I) :- member(I, [cup, teddy, jug(tea), jug(milk)]).
location(loc(L)) :- member(L, [table, shelf, tray]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  1 - ACTIONS AND PRECONDITIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% ASSUMING FOR NOW, ONLY PLACE FOR ITEMS IS ON THE TABLE. CHANGE AFTER TESTING %%%

%%prim_action(pour(Fluid)).
%%poss(pour(Fluid), and(holding(jug(Fluid))=true, onTable(cup)=true, locGirl=loc(table)).

%%prim_action(drink(_)).
%%poss(drink(_), and(onTable(cup), neg(isEmpty(cup)))).

%%prim_action(eat(Food)).
%%poss(eat(Food), onTable(Food)).

prim_action(pickItem(_)).
poss(pickItem(I), and(onTable(I)=true, holding(_)=false)).

prim_action(dropItem(_)).
poss(dropItem(I), holding(I)=true).

prim_action(poop).
poss(poop, true).

%%prim_action(talk(Sentence)).
%%poss().

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  2 - FUNCTIONAL FLUENTS AND CAUSAL LAWS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% ASSUMING FOR NOW, ONLY PLACE FOR ITEMS IS ON THE TABLE. CHANGE AFTER TESTING %%%

% locGirl: current location of the girl
fun_fluent(locGirl).
causes(poop, locGirl, loc(table), true).

% onTable(I): whether item I is on the table
fun_fluent(onTable(I)) :- item(I).
causes(pickItem(I), onTable(I), false, true).
causes(dropItem(I), onTable(I), true, true).

% holding(I): whether girl is holding item I
fun_fluent(holding(I)) :- item(I).
causes(pickItem(I), holding(I), true, true).
causes(dropItem(I), holding(I), false, true).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  3 - ABBREVIATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  4 - INITIAL STATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% ASSUMING FOR NOW, ONLY PLACE FOR ITEMS IS ON THE TABLE. CHANGE AFTER TESTING %%%

initially(locGirl, loc(table)).
initially(onTable(I), true) :- (I=cup ; I=jug(tea)).
initially(holding(I), false).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  5 - MAIN ROUTINE CONTROLLERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% THIS IS THE MAIN PROCEDURE FOR INDIGOLOG
proc(main,  mainControl(N)) :- controller(N), !.
proc(main,  mainControl(4)). % default one

proc(mainControl(4),
   % [pickItem(jug(tea)), pour(tea), dropItem(jug(tea))]
	% [pickItem(jug(tea)), dropItem(jug(tea))]
	[poop]
).

proc(mainControl(5),
[]
).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  6 - EXTRA AUXILIARLY PROGRAMS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  PROLOG SPECIFIC TOOLS USED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  OLD STUFF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INFORMATION FOR THE EXECUTOR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Translations of domain actions to real actions (one-to-one)

actionNum(X,X).	
	
		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EOF: Examples/Unity3D-KBAT/unity3d.pl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


/* IndiGolog caching: fluents that are heavily used should be cached */
cache(locGirl). %%% UNITY %%%
cache(_):-fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  0 - DEFINITIONS OF DOMAINS/SORTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- dynamic gridsize/1.

gridsize(8).

item(I) :- member(I, [cup, teddy, jug(tea), jug(milk)]).	%%% UNITY %%%
locate(loc(L)) :- member(L, [table, shelf, tray]).	%%% UNITY %%%
isSentence(S) :- member(S, ["none", "Hi, my name's Susie!", "Hello Susie.", "Would you like to have some tea?", "Yes, please.", "No, thank you.", "There you go. Enjoy!", "Oh, okay but you should really consider trying some. It's very good."]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  1 - ACTIONS AND PRECONDITIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% UNITY ACTIONS AND PRECONDS %%%%
prim_action(doNothing).
poss(doNothing, true).

prim_action(moveToTable).
poss(moveToTable, true).

prim_action(pickItem(_)).
poss(pickItem(I), and(onTable(I)=true, holding(_)=false)).

prim_action(dropItem(_)).
poss(dropItem(I), holding(I)=true).

%%prim_action(talk(_)).
%%poss(talk(_), true).

prim_action(set_curr(_)).
poss(set_curr(_), true).

prim_action(set_choice(_,_)).
poss(set_choice(_,_), true).

prim_action(unchoose(_,_)).
poss(unchoose(_,_), true).

prim_action(resetChoices).
poss(resetChoices, true).

prim_action(unsetAlive).	%% DELETE WHEN DONE TESTING
poss(unsetAlive, true).	%% DELETE WHEN DONE TESTING

%%%%%%% END UNITY ACTS AND PRECONDS %%%%%%

/* Exogenous Actions Available */

/**** UNITY3D EXOG ACTIONS ****/

exog_action(chose(1,TreeLevel)).
exog_action(chose(2,TreeLevel)).
exog_action(chose(3,TreeLevel)).
exog_action(chose(4,TreeLevel)).
exog_action(explode(N)).

/**** END UNITY3D EXOG ****/


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  2 - FUNCTIONAL FLUENTS AND CAUSAL LAWS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% UNITY FLUENTS %%%%
%%% ASSUMING FOR NOW, ONLY PLACE FOR ITEMS IS ON THE TABLE. CHANGE AFTER TESTING %%%

% alive: if false then program will exit.
fun_fluent(alive).
%causes(explode, alive, false, true).
causes(explode(N), alive, false, N=9).
causes(unsetAlive, alive, false, true).	%%DELETE AFTER TESTING

% locGirl: current location of the girl
fun_fluent(locGirl).
causes(moveToTable, locGirl, loc(table), true).

% onTable(I): whether item I is on the table
fun_fluent(onTable(I)) :- item(I).
causes(pickItem(I), onTable(I), false, true).
causes(dropItem(I), onTable(I), true, true).

% holding(I): whether girl is holding item I
fun_fluent(holding(I)) :- item(I).
causes(pickItem(I), holding(I), true, true).
causes(dropItem(I), holding(I), false, true).

%% moreToSay: true if there is a verbal response to the user.
%%fun_fluent(moreToSay).
%%causes(respond

% current_sentence is the last sentence the girl has spoken so far.
fun_fluent(current_sentence).
causes(set_curr(S), current_sentence, S, isSentence(S)).

% sentence('...') represent the different sentences that can be used in speech 
% 	and holds a number that represents the user choice available.
fun_fluent(sentence(S)) :- isSentence(S).
causes(set_choice(N,S), sentence(S), N, isSentence(S)).
causes(resetChoices, sentence(S), 0, true).

% userResponded(N,TreeLevel) is when the user typed choice N at the point in the convo represented by TreeLevel.
fun_fluent(userResponded(N,TreeLevel)).
causes(chose(N,TreeLevel), userReponded(N,TreeLevel), true, true).
causes(unchoose(N,TreeLevel), userResponded(N,TreeLevel), false, userResponded(N,TreeLevel)=true).

%%%% END UNITY FLUENTS %%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  3 - ABBREVIATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  4 - INITIAL STATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% UNITY INITIAL STATE %%%%

%%% ASSUMING FOR NOW, ONLY PLACE FOR ITEMS IS ON THE TABLE. CHANGE AFTER TESTING %%%
initially(alive, true).
initially(locGirl, loc(tray)).
initially(onTable(I), true) :- (I=cup ; I=jug(tea)).
initially(holding(I), false).

initially(current_sentence, "none").
initially(sentence(S), 0) :- isSentence(S).
initially(userResponded(N,TreeLevel), false).

%%%% END UNITY INITIAL STATE %%%%
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  5 - MAIN ROUTINE CONTROLLERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% THIS IS THE MAIN PROCEDURE FOR INDIGOLOG
proc(main,  mainControl(N)) :- controller(N), !.
proc(main,  mainControl(4)). % default one

%%%% UNITY CONTROLLERS %%%%%%%%%%%%%%%

proc(mainControl(4),
	prioritized_interrupts(
        [interrupt(alive=true, [pickItem(cup), dropItem(cup), pickItem(cup),dropItem(cup)])
		])   
).

proc(mainControl(5),
	prioritized_interrupts(
        [interrupt(alive=true, [pickItem(cup), unsetAlive, dropItem(cup)])
		])   
).

proc(mainControl(6), [startconvo,
	prioritized_interrupts(
		[interrupt([n,treelevel,s], and(userResponded(n,treelevel)=true, sentence(s)=n), [unchoose(n,treelevel),resetChoices,response(s,treelevel)]), 
		interrupt(alive=true, doNothing)]
	)]   
).


%%%% END UNITY CONTROLLERS %%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  6 - EXTRA AUXILIARLY PROGRAMS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% UNITY AUXILIARY PROGRAMS %%%%%%%%%%

% startconvo initiates conversation.
proc(startconvo, [set_curr("Hi, my name's Susie!"), set_choice(1,"Hello Susie.")]).

% response(S, N) affects what the girl says based on S and then sets the user's available options.
%	N is a number representing the convo tree level that S is on.
proc(response("Hello Susie.", 1), [set_curr("Would you like to have some tea?"),
	set_choice(1,"Yes, please."), set_choice(2,"No, thank you.")
]).

proc(response("Yes, please.", 2), [pickItem(cup), dropItem(cup), set_curr("There you go. Enjoy!")
]).

proc(response("No, thank you.", 2), [set_curr("Oh, okay but you should really consider trying some. It's very good.")
]).

%%%%%%% END UNITY AUXILIARY PROGRAMS %%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  PROLOG SPECIFIC TOOLS USED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  OLD STUFF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INFORMATION FOR THE EXECUTOR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Translations of domain actions to real actions (one-to-one)
actionNum(X,X).	
	
		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EOF: Examples/Wumpus/wumpus.pl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
