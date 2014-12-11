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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  1 - ACTIONS AND PRECONDITIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

prim_action(doNothing).
poss(doNothing, true).

%%prim_action(moveToTable).
%%poss(moveToTable, true).

prim_action(pourGirl).
poss(pourGirl, true). %% Change once i see this works

prim_action(pourMe).
poss(pourMe, true). %% Change once i see this works

prim_action(pourBear).
poss(pourBear, true). %% Change once i see this works

prim_action(drinkTea).
poss(drinkTea, true). %% Change once i see this works

prim_action(pickItem(_)).
%poss(pickItem(I), and(onTable(I)=true, neg(some(h,D,holding(h)=true)))) :- domain(D,items).
poss(pickItem(I), and(loc(I)=locGirl, neg(some(h,D,loc(h)=hand)))) :- domain(D, items).

prim_action(dropItem(_)).
%poss(dropItem(I), holding(I)=true).
poss(dropItem(I), loc(I)=hand).

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

prim_action(transfer(_,_)).	 % transfer water from P to P2 without spilling
poss(transfer(_, _), true).

prim_action(empty(_)).	% Empty all the contents of P
poss(empty(_), true).


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

% loc(Item): current location of Item.
fun_fluent(loc(Item)) :- item(Item).
causes(pickItem(Item), loc(Item), hand, locGirl=loc(Item)).
causes(dropItem(Item), loc(Item), locGirl, loc(Item)=hand).

% When the user tries to pick up Item exogenously.
%fun_fluent(takeExogOccurred).
%causes(take(_), takeExogOccurred, true, true).
%causes(pickItem(_), takeExogOccurred, false, takeExogOccurred=true).

% When the user tries to drop Item exogenously.
%fun_fluent(dropExogOccurred).
%causes(drop(_), dropExogOccurred, true, true).
%causes(dropItem(_), dropExogOccurred, false, dropExogOccurred=true).

% onTable(I): whether item I is on the table
%fun_fluent(onTable(I)) :- item(I).
%causes(pickItem(I), onTable(I), false, true).
%causes(dropItem(I), onTable(I), true, true).

% holding(I): whether girl is holding item I
%fun_fluent(holding(I)) :- item(I).
%causes(pickItem(I), holding(I), true, holding(I)=false).
%causes(dropItem(I), holding(I), false, holding(I)=true).

% current_sentence is the last sentence the girl has spoken so far.
fun_fluent(current_sentence).
causes(set_curr(S), current_sentence, S, isSentence(S)).

% sentence('...') represent the different sentences that can be used in speech 
% 	and holds a number that represents the user choice available.
fun_fluent(sentence(S)) :- isSentence(S).
causes(set_choice(N,S), sentence(S), N, isSentence(S)).
causes(resetChoices, sentence(S), 0, true).

% userResponded(N,TreeLevel) is when the user responded with choice N at the point in the convo represented by TreeLevel.
fun_fluent(userResponded(_,_)).
causes(chose(N,TreeLevel), userResponded(N,TreeLevel), true, true).
causes(unchoose(N,TreeLevel), userResponded(N,TreeLevel), false, userResponded(N,TreeLevel)=true).

% Pot X contains W amount of water.
fun_fluent(contains(_)).
causes(transfer(P,P2), contains(P2), W, calc_change1(contains(P),contains(P2),capacity(P2),W) ) :- P \= P2.
causes(transfer(P,P2), contains(P), W, calc_change2(contains(P),contains(P2),capacity(P2),W) ) :- P\= P2.
causes(empty(X), contains(X), 0, true).

% helper predicate.
% calculate the amount, delta, that the pot will be recieving/losing (what is added or removed)
% This handles the case where a transfer is between two distinct pots and how each of the pots will
% change (receiving and giving pot).
%calc_change(X,P,P2,Change) :- (P \= P2, X = P2, W=contains(P), W2=contains(P2), C=capacity(P2), Diff is C - W2, min(Diff, W, Delta), Change is W2 + Delta);
%						(P \= P2, X = P, W=contains(P), W2=contains(P2), C=capacity(P2), Diff is C - W2, min(Diff, W, Delta), Change is W - Delta).
calc_change1(W1,W2,C,Change) :- (Diff is C - W2, min(Diff, W1, Delta), Change is W2 + Delta).					
calc_change2(W1,W2,C,Change) :- (Diff is C - W2, min(Diff, W1, Delta), Change is W1 - Delta).

fun_fluent(capacity(_)). 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  3 - ABBREVIATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

min(M,N,M) :- M =< N, !.
min(M,N,N) :- N =< M.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  4 - INITIAL STATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% ASSUMING FOR NOW, ONLY PLACE FOR ITEMS IS ON THE TABLE. CHANGE AFTER TESTING %%%
initially(alive, true).
initially(locGirl, table).
initially(loc(I), table) :- (I=cup1 ; I= cup2 ; I=cup3 ; I=cup4 ; I=teapot ; I=bear).
initially(loc(I), shelf) :- (I=sheep ; I=cow ; I=mouse).
%initially(onTable(I), true) :- (I=cup1 ; I= cup2 ; I=cup3 ; I=cup4 ; I=teapot).
%initially(holding(I), false) :- item(I).
%initially(takeExogOccurred, false).
%initially(dropExogOccurred, false).
initially(current_sentence, "none").
initially(sentence(S), 0) :- isSentence(S).
initially(userResponded(N,TreeLevel), false) :- isNumber(N), isNumber(TreeLevel).
initially(contains(teapot), 10).
initially(contains(cup1), 0).
initially(contains(cup2), 2).
initially(contains(cup3), 0).
initially(contains(cup4), 0).
initially(capacity(teapot), 10).
initially(capacity(cup1), 2).
initially(capacity(cup2), 2).
initially(capacity(cup3), 2).
initially(capacity(cup4), 2).
	
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
		[interrupt([n,treelevel,s], and(userResponded(n,treelevel)=true, sentence(s)=n), [unchoose(n,treelevel),resetChoices,response(s,treelevel)]),
		interrupt(and(contains(teapot)>5, contains(cup2)\=capacity(cup2)), [pourGirl, transfer(teapot,cup2)]),
		interrupt(contains(cup2)>0, [drinkTea, empty(cup2)]), 
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