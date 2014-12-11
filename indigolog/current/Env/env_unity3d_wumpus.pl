%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% FILE: Env/env_unity3d_wumpus.pl
%
%  AUTHOR    : Sebastian Sardina
%  Time-stamp: <2005-04-24 20:37:47 ssardina>
%  EMAIL     : ssardina@cs.toronto.edu
%  WWW       : www.cs.toronto.edu/~ssardina
%  TESTED    : SWI Prolog 5.0.10 http://www.swi-prolog.org
%  TYPE CODE : system *dependent* predicates (SWI)
%
% This files provides a *simulated* wumpus world
%
% This environment is self-contained (automatically it loads the required
%  libraries). It should be called as follows:
%
%   pl host=<HOST> port=<PORT> -b env_wumpus.pl -e start
%	idrun=<id for the run> idscenario=<id to load for fixed world>
%	size=<size of grid> ppits=<prob of pits> nogolds=<no of golds>
%	ipwumpus=<applet ip> portwumpus=<applet port>
%
% For example:
%
%   pl host='cluster1.cs.toronto.edu' port=9022 -b env_wumpus.pl -e start
%	idrun=test(10) idscenario=random
%	size=8 ppits=15 nogolds=1
%	ipwumpus='cluster1.cs.toronto.edu' portwumpus=9002
%
% where HOST/PORT is the address of the environment manager socket.
%
% Written for ECLiPSe Prolog (http://www.icparc.ic.ac.uk/eclipse/)
% and SWI Prolog (http://www.swi-prolog.org) running under Linux 6.2-8.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                             March 22, 2003
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
% This file assumes that the following is defined in env_gen.pl:
%
% -- start/0     : initialization of the environment (called when loaded)
% -- finalize/0  : finalization of the environment (called when exiting)
% -- main_dir/1  : obtain the root IndiGolog directory
% -- report_exog_event(A, M): 
%                  report exogenous event A with message M to the
%                  environment manager
% -- All compatibility libraries depending on the architecture such us:
%    -- compat_swi/compat_ecl compatibility libraries providing:
%
% -- The following two dynamic predicates should be available:
%    -- listen_to(Type, Name, Channel) 
%            listen to Channel of Type (stream/socket) with Name
%    -- terminate/0
%            order the termination of the application
%
%
% -- The following should be implemented here:
%
%  -- name_dev/1              : mandatory *
%  -- initializeInterfaces(L) : mandatory *
%  -- finalizeInterfaces(L)   : mandatory *
%  -- execute/4               : mandatory *
%  -- handle_steam/1          : as needed
%  -- listen_to/3             : as needed
%
% FROM PROLOG DEPENDENT USER LIBRARY (SWI, ECLIPSE, LIBRARY):
%
% -- call_to_exec(+System, +Command, -Command2)
%      Command2 executes Command in plataform System
%
%
% Also, this device manager requires:
%
%    -- wish for running TCL/TK applications
%    -- exog.tcl TCL/TK script
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- include(env_gen).      % INCLUDE THE CORE OF THE DEVICE MANAGER

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONSTANTS TO BE USED
%
% name_dev/1 : state the name of the device manager (e.g., simulator, rcx)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Name of the environment: <SIMULATOR>
% Set name of the environment here.
% THIS CONSTANT IS MANDATORY, DO NOT DELETE!
%%name_dev(env_simwumpus). %% NEW COMMENTED OUT
name_dev(env_unity3d_wumpus).	%% NEW

% Set verbose debug level
:- set_debug_level(3).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A - INITIALIZATION AND FINALIZATION OF INTERFACES
%     initializeInterfaces/1 and finalizeInterfaces/1
%
% HERE YOU SHOULD INITIALIZE AND FINALIZE EACH OF THE INTERFACES TO BE USED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
initializeInterfaces(L) :- 
        printKbInstructions,
	ground(L),
	set_debug_level(3),
	   % 0 - BUILD A VIRTUAL SCNEARIO OF THE WUMPUS WORLD
	   % build_random_wumpus_world(RX,RY,robDir,NoArrows,ProbPits,NoGolds),
	   % Probability of pit is between 0 and 100
	%%report_message(system(1), 'Building WUMPUS World Configuration'),
	report_message(system(1), 'Building Unity3D World Configuration'),

        %%member([idrun,SIDRun], L), string_to_term(SIDRun, IDRun),
        %%member([idscenario, SIDScenario], L), string_to_term(SIDScenario, IDScenario),
          % Get Size, PPits and NoGolds if available (always available for random!)
	%%(member([size,SSize], L) -> string_to_number(SSize, Size) ; true),
	%%(member([ppits,SPPits], L) -> string_to_number(SPPits, PPits) ; true),
	%%(member([nogolds,SNoGolds], L) -> string_to_number(SNoGolds, NoGolds) ; true),
          % Decide how to build the world: random or predefined
        %%(IDScenario=random -> 
		% Robot at (1,1) aiming right with 1 arrow
		%%ground(PPits), ground(NoGolds),ground(Size), % Have to be known!
		%%build_random_wumpus_world(1,1,right,1,PPits,NoGolds,Size)
	%%;
		% Build a fixed world using id IDScenario (get size, ppits and nogolds)
	        %%build_fixed_wumpus_world(IDScenario,[Size,PPits,NoGolds])
	%%),
	report_message(system(1), 'Building Unity3D World COMPLETED!'),
	   % 1 - Obtain IP and Port from L
        member([ipunity3d,SIP], L),   
        string_to_atom(SIP, IP),
        member([portunity3d, SP], L),  % Get Host and Port of Unity3D from L
        string_to_number(SP, Port),
           % 2 - Initialize the WUMPUS WORLD Applet
	report_message(system(0), 'INITIALIZING INTERFACES!'),
	report_message(system(1), 'Initializing Unity3D interface'),
        %%initializeWumpusWorldApplet(IP, Port),
	initializeUnity3D(IP, Port),
	%%report_message(system(1), 'Initializing STATISTICS interface'),
	%%initializeStatistics(IDRun, Size, PPits,NoGolds),
	report_message(system(0), 'INITIALIZATION COMPLETED!').
	
	
finalizeInterfaces(_)   :- 
	report_message(system(0), 'FINALIZING INTERFACES!'),
	finalizeUnity3D(_,_),	% Finalize Unity3D
	%%finalizeStatistics,
	report_message(system(0), 'FINALIZATION COMPLETED!').
	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A.1 - UNITY3D INTERFACE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize communication with Unity3D
initializeUnity3D(Host, Port):-
        report_message(system(3),
		['Establishing connection to Unity3D:',Host,'/',Port]), !,
        socket(internet, stream, comm_unity3d),
        connect(comm_unity3d, Host/Port),
        assert(listen_to(socket, comm_unity3d, comm_unity3d)),
	report_message(system(1),
                       'Connection to UNITY3D port established successfully'),
       %%% send_command_to_unity3d(reset, _),
	%%%report_message(system(3), 'WUMPUS WORLD GRID RESETTED'),
	%%robot(RX,RY,_,_,_), 
	%%wumpus(WX,WY,_),
       %% send_command_to_wumpus(robot(RX,RY), _),
        %%send_command_to_wumpus(wumpus(WX,WY), _), 
	%%report_message(system(3),'ROBOT and WUMPUS PLACED'),
	%%add_all_pits,
	%%report_message(system(3),'ALL PITS PLACED'),
	%%add_all_golds,
	%%report_message(system(3),'ALL GOLDS PLACED').
/***********************************
add_all_pits :-
	pit(PX,PY),	
        send_command_to_wumpus(pit(PX,PY), _), 
	fail.
add_all_pits.

add_all_golds :-
	gold(PX,PY),	
        send_command_to_wumpus(gold(PX,PY), _), 
	fail.
add_all_golds.
************************************/

% Finalize communication with Unity3D
finalizeUnity3D(_, _) :-
	listen_to(socket, comm_unity3d, comm_unity3d), !,	% check it is open
	send_command_to_unity3d(end, _),  % SEND "end" to Unity3D
	sleep(1),
	closeUnity3DCom.
finalizeUnity3D(_, _).	% Unity3D was already down

closeUnity3DCom :-
        retract(listen_to(socket, comm_unity3d, comm_unity3d)), % de-register interface
        close(comm_unity3d).

/************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A.2 - STATISTICS INTERFACE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For each run the following clause is asserted into file 'logwumpus':
%	wumpus_run(IDRun,[Size,PPits,NoGolds],InitGrid,FinalGrid,History,Time)
%
initializeStatistics(IDRun, Size,PPits,NoGolds) :-
	findall((PX,PY),pit(PX,PY),LPits),
	robot(RX,RY,RD,NA,RS),
	wumpus(WX,WY,WS),
	findall((GX,GY),gold(GX,GY),LGolds),
	assert(initgrid([robot(RX,RY,RD,NA,RS),wumpus(WX,WY,WS),
		         golds(LGolds),pits(LPits)])),
	assert(now([])),
	assert(idconf(IDRun,Size,PPits,NoGolds)),
	statistics(real_time,_).	
finalizeStatistics :-
	robot(RX,RY,RD,NA,RS),
	wumpus(WX,WY,WS),
	findall((GX,GY),gold(GX,GY),LGolds),
	assert(finalgrid([robot(RX,RY,RD,NA,RS),wumpus(WX,WY,WS),golds(LGolds)])),
	save_statistics.
	
save_statistics :-
	idconf(IDRun,Size,PPits,NoGolds),	% Get identification
	initgrid(InitGrid),
	finalgrid(FinalGrid),
	now(H),
	statistics(real_time,[_,Time]),
	open(logwumpus,append,R),
	write(R, wumpus_run(IDRun,[Size,PPits,NoGolds],InitGrid,FinalGrid,H,Time)),
	write(R, '.'),
	nl(R),
	flush_output(R),
	close(R).
**********************************/
% printKbInstructions: Print instructions on how to enter keyboard input
%%printKbInstructions :-	% NEW COMMENTED OUT
%%    writeln('*********************************************************'),	% NEW COMMENTED OUT
%%    writeln('* NOTE: This is the WUMPUS WORLD JAVA-APPLET SIMULATOR environment'), 	% NEW COMMENTED OUT
%%    writeln('*   It handles the following actions: '), 	% NEW COMMENTED OUT
%%    writeln('*      move(D), smell, senseGold, senseBreeze'), 	% NEW COMMENTED OUT
%%    writeln('*********************************************************'), nl.	% NEW COMMENTED OUT
printKbInstructions :-	%NEW
    writeln('*********************************************************'), 	%NEW
    writeln('* NOTE: This is the UNITY3D environment'), 	%NEW
    writeln('*   It handles the following action: '), 	%NEW
    writeln('*      move(D)'), 	%NEW
    writeln('*********************************************************'), nl.	%NEW




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% B - HANDLERS FOR EACH STREAM/SOCKET THAT IS BEING HEARD:  handle_stream/1
%
% HERE YOU SHOULD WRITE HOW TO HANDLE DATA COMMING FROM EACH OF THE
% INTERFACES/CHANNELS USED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Handle data comming from Unity3D: 'start', 'pause', 'halt'. 
handle_stream(comm_unity3d) :- 
        read_response_from_unity3d(Data),
        string_to_atom(Data, A),
        (A=end_of_file ->
        	% Close socket communication with Unity (but device manager keeps running with no GUI)
             closeUnity3DCom   
        ;
             report_exog_event(A, _)
	).
	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C - EXECUTION MODULE: execute/4
%
% This part implements the execution capabilities of the environment
%
% execute(Action, Type, N, S) : execute Action of Type and outcome S
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
execute(A, T, N, S) :- 
	execute2(A,T,N,S),
	retract(now(H)),
	(S=failed -> A2=failed(A) ; A2=A),
	assert(now([A2|H])).


execute2(moveFwd, _, _, 1) :- 
	retract(robot(X,Y,D,NA,alive)), !,
	(D=up    -> up(room(X,Y),room(X2,Y2))   ;
	 D=down  -> down(room(X,Y),room(X2,Y2)) ;
	 D=left  -> left(room(X,Y),room(X2,Y2)) ;
	 D=right -> right(room(X,Y),room(X2,Y2))
	),
        report_message(action, ['Executing action: *',moveFwd, '*']), nl,
        send_command_to_wumpus(robot(X2,Y2), _),
        send_command_to_wumpus(write(moveFwd), _),
	( (pit(X2,Y2) ; wumpus(X2,Y2,alive) ; \+ get_loc(X2,Y2) ) ->
		assert(robot(X2,Y2,D,NA,dead))	% Here the robot dies!!
	;
		assert(robot(X2,Y2,D,NA,alive))
	).
execute2(moveFwd, _, _, failed) :- !.
		

execute2(turn, _, _, 1) :- 
	retract(robot(X,Y,D,NA,alive)), !,
	(D=up    -> D2=right   ;
	 D=down  -> D2=left ;
	 D=left  -> D2=up  ;
	 D=right -> D2=down
	),
	assert(robot(X,Y,D2,NA,alive)),
        report_message(action, ['Executing action: *',turn, '*']), nl,
        send_command_to_wumpus(write(turn), _).
execute2(turn, _, _, failed) :- !.

execute2(shootFwd, _, _, 1) :- 
	retract(robot(XR,YR,D,NA,alive)), NA>0, !,
	NA2 is NA-1,
	assert(robot(XR,YR,D,NA2,alive)),
	wumpus(XW,YW,_),
	(in_line(room(XR,YR),D,room(XW,YW)) -> 
		retract(wumpus(XW,YW,_)),
		assert(wumpus(XW,YW,dead)),	% The Wumpus at XW,YW died
	        send_command_to_wumpus(set(XW,YW,wdead), _),
	        report_exog_event(scream,_)	% Throw exogenous event 'scream'
	; 
		true
	),
        report_message(action, ['Executing action: *',shootFwd, '*']), nl,
        send_command_to_wumpus(write(shootFwd), _).
execute2(shootFwd, _, _, failed) :- !.

% Using sensing and not exogenous action scream
execute2(shoot, _, _, Scream) :- 
	retract(robot(XR,YR,D,NA,alive)), NA>0, !,
	NA2 is NA-1,
	assert(robot(XR,YR,D,NA2,alive)),
	wumpus(XW,YW,_),
	(in_line(room(XR,YR),D,room(XW,YW)) -> 
		retract(wumpus(XW,YW,_)),
		assert(wumpus(XW,YW,dead)),	% The Wumpus at XW,YW died
		send_command_to_wumpus(set(XW,YW,wdead), _),
		Scream=1 			% Throw exogenous event 'scream'
	; 
		Scream=0
	),
	report_message(action, 
		['Executing sensing action: *',shoot,'* with outcome: ', Scream]),
	send_command_to_wumpus(write(shoot), _).
execute2(shoot, _, _, failed) :- !.
	

execute2(smell, _, _, Sensing) :- 
	robot(X,Y,_,_,alive), !,
	wumpus(X2,Y2,_),
	(adj(room(X,Y),room(X2,Y2)) -> Sensing=1 ; Sensing=0),
        report_message(action, 
		['Executing sensing action: *',smell,'* with outcome: ', Sensing]),
	nl,
        send_command_to_wumpus(write(smell(Sensing)), _).
execute2(smell, _, _, failed) :- !.

execute2(senseBreeze, _, _, Sensing) :- 
	robot(X,Y,_,_,alive), !,
	( (pit(X2,Y2),adj(room(X,Y),room(X2,Y2))) ->
		Sensing=1
	;
		Sensing=0
	),
        report_message(action, 
		['Executing sensing action: *',senseBreeze,'* with outcome: ',  
		Sensing]),
	nl,
        send_command_to_wumpus(write(senseBreeze(Sensing)), _).
execute2(senseBreeze, _, _, failed) :- !.

execute2(senseGold, _, _, Sensing) :- 
	robot(X,Y,_,_,alive), !,
	(gold(X,Y) -> Sensing=1 ; Sensing=0),
        report_message(action, 
		['Executing sensing action: *',senseGold,'* with outcome: ', 
		Sensing]),
	nl,
        send_command_to_wumpus(write(senseGold(Sensing)), _).
execute2(senseGold, _, _, failed) :- !.

execute2(pickGold, _, _, 1) :- !,
	robot(X,Y,_,_,alive), !,
	retractall(gold(X,Y)),
        report_message(action, 	['Executing action: *',pickGold,'*']),
	nl,
        send_command_to_wumpus(write(pickGold), _).
execute2(pickGold, _, _, failed) :- !.

execute2(Action, _, _, ok) :- 
        report_message(action, ['Executing action: *',Action,'*']),
        send_command_to_wumpus(write(Action), _).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MANAGEMENT OF THE VIRTUAL WUMPUS WORLD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- dynamic robot/5, wumpus/3, pit/2, gold/2, gridsize/1.

% domain/2: assigns a user-defined domain to a variable. 
domain(V, D) :- getdomain(D, L), member(V, L).
% L is the list-domain associated to name D
getdomain(D, L) :- is_list(D) -> L=D ; (P =.. [D,L], call(P)).


/* Map Definitions */
gridsize(8).
gridindex(L) :- 
	gridsize(S),
	findall(X,get_integer(1,X,S),L).
directions([up,down,left,right]).

up(room(X,Y),room(X,YN))    :- YN is Y+1. 
down(room(X,Y),room(X,YN))  :- YN is Y-1. 
right(room(X,Y),room(XN,Y)) :- XN is X+1. 
left(room(X,Y),room(XN,Y))  :- XN is X-1. 

% Get any location in the grid
get_random_loc(X,Y) :- gridsize(S), random(1,S,X), random(1,S,Y).

% Get every location in the grid one by one
get_loc(X,Y) :- gridsize(S), get_integer(1,X,S), get_integer(1,Y,S).


valid_room(room(I,J)) :- domain(I,gridindex), domain(J,gridindex).
adj(R1,R2) :- (up(R1,R2);down(R1,R2);left(R1,R2);right(R1,R2)),valid_room(R2).

adj(R1,R2,D) :- adj2(R1,R2,D), valid_room(R2).
adj2(R1,R2,up)    :- up(R1,R2).
adj2(R1,R2,down)  :- down(R1,R2).	
adj2(R1,R2,left)  :- left(R1,R2).	
adj2(R1,R2,right) :- right(R1,R2).	

% R2 is the next square of R1 in direction D
in_line(R1,_,R1).
in_line(R1,D,R2) :- adj(R1,R3,D), in_line(R3,D,R2).
	

% Builds a random wumpus world map with robot at (X,Y), 
% Eeach square has a probability PPits of having a pit
% There are a total of NGolds golds in the world
build_random_wumpus_world(X,Y,D,NA,PPits,NGolds,Size) :-
	clean_grid,
	assert(gridsize(Size)),
	assert(robot(X,Y,D,NA,alive)),
	repeat,
	get_random_loc(WX,WY), empty(WX,WY), assert(wumpus(WX,WY,alive)),!,
%	assert(wumpus(1,7,alive)),!,	% Put the Wumpus at some fix place
	add_pits(PPits),	
	add_n_golds(NGolds).
	
% Add pits with probability Prob
add_pits(Prob) :-
	get_loc(PX,PY),	% Get a position
	(empty(PX,PY) ->
		random(1,100,N), N=<Prob, assert(pit(PX,PY))
	;
		true
	),
	fail.
add_pits(_).

% Add N golds in the grid randomly		
add_n_golds(0).
add_n_golds(N) :- 
	repeat,
	get_random_loc(PX,PY),
	empty(PX,PY),
	assert(gold(PX,PY)), !,
	N2 is N-1,
	add_n_golds(N2).

clean_grid:-
	retractall(gridsize(_)),
	retractall(robot(_,_,_,_,_)),
	retractall(wumpus(_,_,_)),
%	retractall(pit(_,_)),
	retractall(gold(_,_)).

% There is no robot, no wumpus, no pit, and no gold at (PX,PY)	
empty(PX,PY) :-
	\+ robot(PX,PY,_,_,_), \+ wumpus(PX,PY,_), \+ pit(PX,PY), \+ gold(PX,PY).
	


% Build a fixed WUMPUS WORLD configuration
build_fixed_wumpus_world(IDScenario,[Size,PPits,NoGolds]) :-
	clean_grid,
	(IDScenario=none -> true ; consult('wumpus_testbed')),
	fixed_wumpus_world(IDScenario,[Size,PPits,NoGolds],IGrid),
	assert(gridsize(Size)),
	member(robot(IRX,IRY,IRD,INA,IRS), IGrid),
	member(wumpus(IWX,IWY,IWS), IGrid),
	member(golds(ILGolds), IGrid),
	member(pits(LPits), IGrid),
	assert(robot(IRX,IRY,IRD,INA,IRS)),
	assert(wumpus(IWX,IWY,IWS)),
	forall(member((X,Y),ILGolds), assert(gold(X,Y))),
	forall(member((X,Y),LPits), assert(pit(X,Y))).
	
	
fixed_wumpus_world(none,[10,10,1],[robot(1, 1, right, 1, alive), wumpus(2, 3, alive), golds([ (4, 6)]), pits([ (1, 2), (2, 7), (4, 4), (5, 2), (7, 4), (8, 3), (10, 1), (10, 10)])]).

fixed_wumpus_world(IDScenario,[Size,PPits,NoGolds],IGrid) :-
	wumpus_run(IDScenario,[Size,PPits,NoGolds],IGrid,_,_,_).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% COMMUNICATION WITH UNITY3D%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Available actions:
%	robot(x,y) pit(x,y) gold(x,y) wumpus(x,y) reset set(x,y,string) 
%	write(M) : writes M in the action form
%	write(M) : writes M in the action form

% Send Command to UNITY3D and wait for Response from UNITY3D
send_command_to_unity3d(_, ok) :- \+ unity3DOn, !.
send_command_to_unity3d(Command, Response) :-
	any_to_string(Command, SCommand),
	write(comm_unity3d, SCommand),
	nl(comm_unity3d),
	flush(comm_unity3d), !, Response=ok.
%	read_response_from_unity3d(Response).  % Read acknowledgment from UNITY3D
send_command_to_unity3d(_, failed).

% Read a line from UNITY3D
read_response_from_unity3d(_) :- \+ unity3DOn, !.
read_response_from_unity3d(Command) :-
	read_string(comm_unity3d, end_of_line,_, Command).


% Wumpus applet is running
unity3DOn :- listen_to(socket, comm_unity3d, comm_unity3d).
	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EOF:  Env/env_wumpus.pl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
