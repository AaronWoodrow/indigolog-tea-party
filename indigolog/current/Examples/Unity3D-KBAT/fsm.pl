/* IndiGolog caching: fluents that are heavily used should be cached */
cache(locGirl).
cache(onTable(_)).
cache(holding(_)).
cache(_):-fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  0 - DEFINITIONS OF DOMAINS/SORTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- dynamic gridsize/1.

gridsize(8).

items([cup1, cup2, cup3, cup4, bear, sheep, cow, mouse, teapot, milk]).
item(I) :- rdomain(I, [cup1, cup2, cup3, cup4, bear, sheep, cow, mouse, teapot, milk]).
isNumber(N) :- rdomain(N, [0,1,2,3,4,5,6,7,8,9]).
%item(I) :- member(I, [cup, bear, jug(tea), jug(milk)]).
locate(L) :- member(L, [hand, table, shelf, tray]).
isSentence(S) :- member(S, ["none", "Hi, my name's Susie!", "Hello Susie.", "Would you like to have some tea?", "Yes, please.", "No, thank you.", "There you go. Enjoy!", "Oh, okay but you should really consider trying some. It's very good.", "Okay fiiiine, I'll have some.", "I think your teddy bear wants some.", "Mr. Teddy doesn't want any right now.", "Mr. Teddy are you thirsty? Yes? Okay here you go."]).
isState(N) :- member(N, [0,1,2,3,4,5]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  1 - ACTIONS AND PRECONDITIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

prim_action(doNothing).
poss(doNothing, true).

%%prim_action(moveToTable).
%%poss(moveToTable, true).

changeState(S1, S2).  %% changes state from S1 to S2.
poss(changeState(S,_), curState=S).

prim_action(set_curr(_)).
poss(set_curr(_), true).

prim_action(set_choice(_,_)).
poss(set_choice(_,_), true).

prim_action(unchoose(_,_)).
poss(unchoose(_,_), true).

prim_action(resetChoices).
poss(resetChoices, true).

prim_action(unsetAlive).
poss(unsetAlive, true).

%%% INDIGOLOG WANTS A 'SENSES' PREDICATE, even though I don't need it...%%%
prim_action(smell).
poss(smell, true).
senses(smell). 


/* Exogenous Actions Available */

%% chose('user's choice of sentence', 'treelevel of sentence')
exog_action(chose(1,_)).
exog_action(chose(2,_)).
exog_action(chose(3,_)).
exog_action(chose(4,_)).
%exog_action(take(cup2)).
%exog_action(drop(cup2)).
exog_action(moveExog(_)).
%% reset is to be implemented later
exog_action(resetGame).
%% explode('number')
exog_action(explode(_)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  2 - FUNCTIONAL FLUENTS AND CAUSAL LAWS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% alive: if false then program will exit.
fun_fluent(alive).
%causes(explode, alive, false, true).
causes(explode(N), alive, false, N=9).
causes(unsetAlive, alive, false, true).

% locGirl: current location of the girl
fun_fluent(locGirl).
%%causes(moveToTable, locGirl, table, true).
causes(moveExog(L), locGirl, L, true) :- locate(L).

% currState: the current state of conversation.
fun_fluent(currState).
causes(changeState(S1,S2), currState, S2, and(currState=S1, connected(S1,S2))).

% connected(S1,S2): there is a transition from S1 to S2.
fun_fluent(connected(S1,S2)).

% current_sentence is the last sentence the girl has spoken so far.
fun_fluent(current_sentence).
causes(set_curr(S), current_sentence, S, isSentence(S)).

% sentence('...') represent the different sentences that can be used in speech 
% 	and holds a number that represents the user choice available.
fun_fluent(sentence(S)) :- isSentence(S).
causes(set_choice(N,S), sentence(S), N, isSentence(S)).
causes(resetChoices, sentence(S), 0, true).

% userResponded(N,TreeLevel) is when the user responded with choice N at the point in the convo represented by TreeLevel.
%fun_fluent(userResponded(_,_)).
%causes(chose(N,TreeLevel), userResponded(N,TreeLevel), true, true).
%causes(unchoose(N,TreeLevel), userResponded(N,TreeLevel), false, userResponded(N,TreeLevel)=true).

% userResponded(N,TreeLevel) is when the user responded with choice N.
fun_fluent(userResponded(_)).
causes(chose(N), userResponded(N), true, true).
causes(unchoose(N), userResponded(N), false, userResponded(N)=true).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  3 - ABBREVIATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  4 - INITIAL STATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

initially(alive, true).
initially(locGirl, table).
initially(current_sentence, "none").
initially(sentence(S), 0) :- isSentence(S).
initially(userResponded(N,TreeLevel), false) :- isNumber(N), isNumber(TreeLevel).
initially(currState,0).
initially(connected(0,1)).
initially(connected(1,2)).
initially(connected(1,3)).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  5 - MAIN ROUTINE CONTROLLERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% THIS IS THE MAIN PROCEDURE FOR INDIGOLOG
proc(main,  mainControl(N)) :- controller(N), !.
proc(main,  mainControl(6)). % default one 

/*
proc(mainControl(4),
	prioritized_interrupts(
        [interrupt(alive=true, [pickItem(cup2), dropItem(cup2), pickItem(cup2),dropItem(cup2)])
		])   
).

proc(mainControl(5), [startconvo, wait,
	prioritized_interrupts(
        [interrupt([n, treelevel], and(alive=true, userResponded(n,treelevel)=true), [pickItem(cup2), resetChoices, unchoose(n,treelevel)])
		])]   
).
*/

proc(mainControl(6), [startconvo,
	prioritized_interrupts(
		%[interrupt([n,treelevel,s], and(userResponded(n,treelevel)=true, sentence(s)=n), [unchoose(n,treelevel),resetChoices,response(s,treelevel)]),
		[interrupt([n,s], and(userResponded(n)=true, sentence(s)=n), [unchoose(n),resetChoices,response(s,state)]),
		interrupt(alive=true, wait)] % waits for an exogenous action.
	)]   
).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  6 - AUXILIARLY PROGRAMS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% startconvo initiates conversation.
proc(startconvo, [set_curr("Hi, my name's Susie!"), set_choice(1,"Hello Susie.")]).

% response(S, N) affects what the girl says based on S and then sets the user's available options.
%	N is a number representing the convo tree level that S is on.
proc(response("Hello Susie.", 1), [set_curr("Would you like to have some tea?"),
	set_choice(1,"Yes, please."), set_choice(2,"No, thank you.")
]).

%%proc(response("Yes, please.", 2), [pickItem(cup3), dropItem(cup3), set_curr("There you go. Enjoy!")
%%]).
proc(response("Yes, please.", 2), [pourMe, set_curr("There you go. Enjoy!")
]).

proc(response("No, thank you.", 2), [set_curr("Oh, okay but you should really consider trying some. It's very good."),
	set_choice(1,"Okay fiiiine, I'll have some."), set_choice(2,"I think your teddy bear wants some.")
]).

%%proc(response("Okay fiiiine, I'll have some.", 3), [pickItem(cup3), dropItem(cup3), set_curr("There you go. Enjoy!")
%%]).
proc(response("Okay fiiiine, I'll have some.", 3), [pourMe, set_curr("There you go. Enjoy!")
]).

%%proc(response("I think your teddy bear wants some.", 3), [set_curr("Mr. Teddy are you thirsty? Yes? Okay here you go."), pickItem(cup1), dropItem(cup1)
%%]).
proc(response("I think your teddy bear wants some.", 3), [set_curr("Mr. Teddy are you thirsty? Yes? Okay here you go."), pourBear
]).


proc(empty_macro, pi(x, [?(contains(x)\=0), empty(x)])).
proc(transfer_macro, pi(x, [pi(y, [?(and(x\=y,(and(contains(x)\=0, contains(y)\=capacity(y))))), transfer(x,y)])])).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  PROLOG SPECIFIC TOOLS USED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INFORMATION FOR THE EXECUTOR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Translations of domain actions to real actions (one-to-one)
actionNum(X,X).	
	
		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EOF: Examples/Wumpus/wumpus.pl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%