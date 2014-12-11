%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% FILE: Env/env_unity3d.pl
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
name_dev(env_unity3d).	%% NEW

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
	report_message(system(1), 'Building Unity3D World Configuration'),

        member([idrun,SIDRun], L), string_to_term(SIDRun, IDRun),
        
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
	report_message(system(0), 'INITIALIZATION COMPLETED!').
	
	
finalizeInterfaces(_)   :- 
	report_message(system(0), 'FINALIZING INTERFACES!'),
	finalizeUnity3D(_,_),	% Finalize Unity3D
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
                       'Connection to UNITY3D port established successfully').


% Finalize communication with Unity3D
finalizeUnity3D(_, _) :-
	listen_to(socket, comm_unity3d, comm_unity3d), !,	% check it is open
	send_command_to_unity3d(end, _),  % SEND "end" to Unity3D
	sleep(1),
	closeUnity3dCom.
finalizeUnity3D(_, _).	% Unity3D was already down

closeUnity3dCom :-
        retract(listen_to(socket, comm_unity3d, comm_unity3d)), % de-register interface
        close(comm_unity3d).

% printKbInstructions: Print instructions on how to enter keyboard input
printKbInstructions :-	
    writeln('*********************************************************'), 
    writeln('* NOTE: This is the UNITY3D environment'), 
    writeln('*   It handles the following actions: '), 
    writeln('*      pickItem(I), dropItem(I), pour(Fluid)'), 
    writeln('*********************************************************'), nl.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% B - HANDLERS FOR EACH STREAM/SOCKET THAT IS BEING HEARD:  handle_stream/1
%
% HERE YOU SHOULD WRITE HOW TO HANDLE DATA COMING FROM EACH OF THE
% INTERFACES/CHANNELS USED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Handle data comming from Unity3D: 'start', 'pause', 'halt'. 
handle_stream(comm_unity3d) :- 
        read_response_from_unity3d(Data),
        string_to_atom(Data, A),
        (A=end_of_file ->
        	% Close socket communication with Unity (but device manager keeps running with no GUI)
             closeUnity3dCom   
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

execute2(pickItem(I), _, _, 1) :- 
	report_message(action, ['Executing action: *',pickItem(I),'*']), nl,
		send_command_to_wumpus(pickItem(I), _),
        	send_command_to_wumpus(write(pickItem(I)), _).
execute2(pickItem(I), _, _, failed) :- !.

execute2(dropItem(I), _, _, 1) :- 
	report_message(action, ['Executing action: *',dropItem(I),'*']), nl,
		send_command_to_wumpus(dropItem(I), _),
       	send_command_to_wumpus(write(dropItem(I)), _).
execute2(dropItem(I), _, _, failed) :- !.

execute2(pour(Fluid), _, _, 1) :- 
	report_message(action, ['Executing action: *',pour(Fluid),'*']), nl,
		send_command_to_wumpus(pour(Fluid), _).
       	send_command_to_wumpus(write(pour(Fluid)), _).
execute2(pour(Fluid), _, _, failed) :- !.

execute2(Action, _, _, ok) :- 
        report_message(action, ['Executing action: *',Action,'*']),
        send_command_to_wumpus(write(Action), _).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MANAGEMENT OF THE VIRTUAL WUMPUS WORLD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% COMMUNICATION WITH UNITY3D%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Available actions:
%	robot(x,y) pit(x,y) gold(x,y) wumpus(x,y) reset set(x,y,string) 
%	write(M) : writes M in the action form
%	write(M) : writes M in the action form

% Send Command to UNITY3D and wait for Response from UNITY3D
send_command_to_unity3d(_, ok) :- \+ unity3dOn, !.
send_command_to_unity3d(Command, Response) :-
	any_to_string(Command, SCommand),
	write(comm_unity3d, SCommand),
	nl(comm_unity3d),
	flush(comm_unity3d), !, Response=ok.
%	read_response_from_unity3d(Response).  % Read acknowledgment from UNITY3D
send_command_to_unity3d(_, failed).

% Read a line from UNITY3D
read_response_from_unity3d(_) :- \+ unity3dOn, !.
read_response_from_unity3d(Command) :-
	read_string(comm_unity3d, end_of_line,_, Command).


% Wumpus applet is running
unity3dOn :- listen_to(socket, comm_unity3d, comm_unity3d).
	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EOF:  Env/env_wumpus.pl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
