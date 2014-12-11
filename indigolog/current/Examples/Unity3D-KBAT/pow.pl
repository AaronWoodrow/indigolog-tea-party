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

prim_action(display(_)).
poss(display(_)).

prim_action(transfer(_,_)).	 % transfer water from P to P2 without spilling
poss(transfer(_, _), true).

prim_action(empty(_)).	% Empty all the contents of P
poss(empty(_), true).

prim_action(pickItem(_)).
%poss(pickItem(I), and(onTable(I)=true, neg(some(h,D,holding(h)=true)))) :- domain(D,items).
poss(pickItem(I), and(loc(I)=locGirl, neg(some(h,D,loc(h)=hand)))) :- domain(D, items).



%%% INDIGOLOG WANTS A 'SENSES' PREDICATE, even though I don't need it...%%%
prim_action(smell).
poss(smell, true).
senses(smell). 


/* Exogenous Actions Available */

%% reset is to be implemented later
exog_action(resetGame).
%% explode('number')
exog_action(explode(_)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  2 - FUNCTIONAL FLUENTS AND CAUSAL LAWS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


%% QUESTION! DOES USING A FLUENT IN AN OUTSIDE PROLOG RULE (LIKE CALC_CHANGE) STILL GET SUBBED WITH ITS VALUE BY THE INTERPRETER???

fun_fluent(capacity(_)). %% DO I NEED THIS HERE IF IT DOESN'T CHANGE?

% alive: if false then program will exit.
fun_fluent(alive).
%causes(explode, alive, false, true).
causes(explode(N), alive, false, N=9).
causes(unsetAlive, alive, false, true).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  3 - ABBREVIATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

min(M,N,M) :- M =< N, !.
min(M,N,N) :- N =< M.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  4 - INITIAL STATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

initially(contains(p1), 5).
initially(contains(p2), 0).
initially(capacity(p1), 5).
initially(capacity(p2), 2).

initially(alive, true).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  5 - MAIN ROUTINE CONTROLLERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% THIS IS THE MAIN PROCEDURE FOR INDIGOLOG
proc(main,  mainControl(N)) :- controller(N), !.
proc(main,  mainControl(7)). % default one

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


proc(mainControl(6), [startconvo,
	prioritized_interrupts(
		[interrupt([n,treelevel,s], and(userResponded(n,treelevel)=true, sentence(s)=n), [unchoose(n,treelevel),resetChoices,response(s,treelevel)]), 
		interrupt(alive=true, wait)] % waits for an exogenous action.
	)]   
).
*/

proc(mainControl(7), [?(contains(p1)=5), ?(contains(p2)=0), transfer(p1,p2), empty(p2), transfer(p1,p2), empty(p2), transfer(p1,p2), ?(contains(p1)=0),?(contains(p2)=1)]).
proc(mainControl(8), [?(contains(p1)=5), ?(contains(p2)=0), search([transfer(p1,p2),?(contains(p2)=2)],"SEARCHING FOR TRANSFER PLAN OF ACTION.....")]).
proc(mainControl(9), [search([rndet(empty_macro,transfer_macro), ?(contains(p2)=1)])]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  6 - AUXILIARLY PROGRAMS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
