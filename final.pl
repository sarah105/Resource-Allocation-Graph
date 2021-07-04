processes([p1,p2,p3,p4]).

available_resources([[r1, 0], [r2, 0]]).

allocated(p1, [r2]).
allocated(p2, [r1]).
allocated(p3, [r1]).
allocated(p4, [r2]).

requested(p1, [r1]).
requested(p3, [r2]).


add_to_available(L,A,R):-
    add_to_available(L,A,[],R).

add_to_available([],[],T,T):-!.
add_to_available(L,[],T,R):-
    add_to_available(L,T,[],R),!.

add_to_available([H|T1],[[H,T2]|T3],Tem,Res):-
    R is T2 + 1,
    append(Tem,[[H,R]],NewTem),
    add_to_available(T1,T3,NewTem,Res),!.

add_to_available(A,[H|T],Tem,Res):-
    append(Tem,[H],NewTem),
    add_to_available(A,T,NewTem,Res).

check_available([],[],1):-!.
check_available([H|T1],[[H,T2]|T3],Flag):-
    T2 > 0,
    check_available(T1,T3,Flag),!.
check_available([H|_],[[H,_]|_],Flag):-
    Flag is 0 , !.
check_available(A,[_|T],Flag):-
    check_available(A,T,Flag).


size([],Tem,Tem).
size([_|T],Tem,R):-
    NewTem is Tem + 1,
    size(T,NewTem,R).

safe_state(X):-
    processes(Y),
    available_resources(Available),
    size(Y,0,Size),
    check(Y,Available,Size,0,X).

check([],_,_,_,[]):-!.
check(_,_,X,Y,[]):-
    Y is (X * (X + 1))/2,!.

check([H|P],Available,ProcessesNum,_,[H|Tem]):-
   not(requested(H,_)),
   allocated(H,A),
   add_to_available(A,Available,New),
   NewProcessesNum is ProcessesNum - 1,
   check(P,New, NewProcessesNum,0,Tem),!.


check([H|P],Available,ProcessesNum,_,[H|Tem]):-
   requested(H,R),
   check_available(R,Available,True),
   True is 1,
   allocated(H,A),
   add_to_available(A,Available,New),
   NewProcessesNum is ProcessesNum - 1,
   check(P,New,NewProcessesNum,0,Tem),!.

check([H|P],Available,ProcessesNum,NotRun,Tem):-
    append(P,[H],New),
    NewNotRun is NotRun + 1,
    check(New,Available,ProcessesNum,NewNotRun ,Tem),!.

























