
boxer(avetik_abrahamyan,germany__armenia,int36,int178,middleweight__supermiddleweight,int49,int44,int29,int5,worldChampionmiddleweight__worldChampionSupermiddleweight).
boxer(joachim_alcine,canada,int40,int179,superLightweight__middleweight,int45,int35,int21,int8,worldChampionSuperWelters).
boxer(luigi_guiseppe_ambrosio,american,dead,int164,lightweight,int106,int91,int28,int8,worldChampionlightweight ).
boxer(maximillien_baer,american,dead,int188,heavyweight,int81,int68,int52,int13,worldChampionheavyweight ).
boxer(robert_baker,american,dead,int187,heavyweight,int68,int51,int20,int16,null).
boxer(celestino_caballero,panama,int40,int170,superBantamweight__featherweight,int43,int37,int24,int6,worldChampionsuperBantamweight).
boxer(george_chuvalo,canada,int79,int183,heavyweight,int93,int73,int64,int12,canadaChampionheavyweight).
boxer(henry_cooper,england,dead,int190,heavyweight,int55,int40,int27,int14,europeChampianheavyweight__championEnglandheavyweight).
boxer(tsuyoshi_hamada,japan,int56,int170,superLightweight,int24,int21,int19,int2,worldChampionsuperLightweight__asiaChampionsuperLightweight__japanChampionsuperLightweight).
boxer(kiyoshi_hatanaka,japan,int49,int169,superFlyweight__superBantamweight,int25,int22,int15,int2,worldChampionsuperBantamweight__japanChampionsuperFlyweight).
boxer(kenneth_howard_Norton,american,dead,int191,heavyweight,int50,int42,int33,int7,worldChampionheavyweight__championAmeriqueDuNordheavyweight ).
boxer(muhammad_ali,american,dead,int191,heavyweight,int61,int56,int37,int5,worldChampionheavyweightWBA__championOlympiqueAuxJeuxDeRome__vainqueurDesGoldenGloves).

% get information about specific peoples
nationality(X,L) :- boxer(N,X,_,_,_,_,_,_,_,_),memberchk(N,L).
age(X,L) :- boxer(N,_,X,_,_,_,_,_,_,_),X \= dead,memberchk(N,L).
height(X,L) :- boxer(N,_,_,X,_,_,_,_,_,_),memberchk(N,L).
rated_at(X,L) :- boxer(N,_,_,_,X,_,_,_,_,_),memberchk(N,L).
fights(X,L) :- boxer(N,_,_,_,_,X,_,_,_,_),memberchk(N,L).
wins(X,L) :- boxer(N,_,_,_,_,_,X,_,_,_),memberchk(N,L).
wKO(X,L) :- boxer(N,_,_,_,_,_,_,X,_,_),memberchk(N,L).
losses(X,L) :- boxer(N,_,_,_,_,_,_,_,X,_),memberchk(N,L).
titles(X,L) :- boxer(N,_,_,_,_,_,_,_,_,X),memberchk(N,L).
is_boxer(X) :- boxer(X,_,_,_,_,_,_,_,_,_).
% get boxer's names of specific criteria x : critere n : noms
% return who gonna be eliminated 

% c = >25 ou <25 int examlpe; int examlpe
% c = tn , r (reponse) = (oui/non)

not_member(_, []) :- !.
not_member(X, [Head|Tail]) :-X \= Head,not_member(X, Tail).

member(I,[I|R]).  
member(I,[D|T]):- member(I,T).

% < begin nationality >
nationality2(C,R,N) :- boxer(N,X,_,_,_,_,_,_,_,_),
split_string(X,"__","",Ns),R=no,
member(C,Ns).

nationality2(C,R,N) :- boxer(N,X,_,_,_,_,_,_,_,_),
split_string(X,"__","",Ns),R=yes,
not_member(C,Ns).
% </end nationality>

% < begin age >

% person is dead
age2(C,N) :- boxer(N,_,X,_,_,_,_,_,_,_),
string_length(C,Clen),Lenc is Clen - 1,
sub_string(C,_,Lenc,0,Numc), number_string(Nmc,Numc),
sub_string(C,0,1,_,Op),Op = "l",
Nmc = 0,
X = dead.

age2(C,N) :- boxer(N,_,X,_,_,_,_,_,_,_),X \= dead,
string_length(C,Clen),Lenc is Clen - 1,
string_length(X,Xlen),Lenx is Xlen - 3,
sub_string(C,_,Lenc,0,Numc), number_string(Nmc,Numc),
sub_string(X,_,Lenx,0,Numx), number_string(Nmx,Numx),
sub_string(C,0,1,_,Op),Op = "l",
Nmc >= Nmx.

age2(C,N) :- boxer(N,_,X,_,_,_,_,_,_,_),X \= dead,
string_length(C,Clen),Lenc is Clen - 1,
string_length(X,Xlen),Lenx is Xlen - 3,
sub_string(C,_,Lenc,0,Numc), number_string(Nmc,Numc),
sub_string(X,_,Lenx,0,Numx), number_string(Nmx,Numx),
sub_string(C,0,1,_,Op),Op = "g",
Nmc < Nmx.
% </end age >

% < begin height >
height2(C,N) :- boxer(N,_,_,X,_,_,_,_,_,_),
string_length(C,Clen),Lenc is Clen - 1,
string_length(X,Xlen),Lenx is Xlen - 3,
sub_string(C,_,Lenc,0,Numc), number_string(Nmc,Numc),
sub_string(X,_,Lenx,0,Numx), number_string(Nmx,Numx),
sub_string(C,0,1,_,Op),Op = "l",
Nmc >= Nmx.

height2(C,N) :- boxer(N,_,_,X,_,_,_,_,_,_),
string_length(C,Clen),Lenc is Clen - 1,
string_length(X,Xlen),Lenx is Xlen - 3,
sub_string(C,_,Lenc,0,Numc), number_string(Nmc,Numc),
sub_string(X,_,Lenx,0,Numx), number_string(Nmx,Numx),
sub_string(C,0,1,_,Op),Op = "g",
Nmc < Nmx.
% </end height >

% < begin rated_at >
rated_at2(C,R,N) :- boxer(N,_,_,_,X,_,_,_,_,_),
split_string(X,"__","",Ns),R=yes,
memberchk(C,Ns).

rated_at2(C,R,N) :- boxer(N,_,_,_,X,_,_,_,_,_),
split_string(X,"__","",Ns),R=no,
not_member(C,Ns).
% </end rated_at >

% < begin fights >
fights2(C,N) :- boxer(N,_,_,_,_,X,_,_,_,_),
string_length(C,Clen),Lenc is Clen - 1,
string_length(X,Xlen),Lenx is Xlen - 3,
sub_string(C,_,Lenc,0,Numc), number_string(Nmc,Numc),
sub_string(X,_,Lenx,0,Numx), number_string(Nmx,Numx),
sub_string(C,0,1,_,Op),Op = "l",
Nmc >= Nmx.

fights2(C,N) :- boxer(N,_,_,_,_,X,_,_,_,_),
string_length(C,Clen),Lenc is Clen - 1,
string_length(X,Xlen),Lenx is Xlen - 3,
sub_string(C,_,Lenc,0,Numc), number_string(Nmc,Numc),
sub_string(X,_,Lenx,0,Numx), number_string(Nmx,Numx),
sub_string(C,0,1,_,Op),Op = "g",
Nmc < Nmx.
% </end fights >

% < begin wins>
wins2(C,N) :- boxer(N,_,_,_,_,_,X,_,_,_),
string_length(C,Clen),Lenc is Clen - 1,
string_length(X,Xlen),Lenx is Xlen - 3,
sub_string(C,_,Lenc,0,Numc), number_string(Nmc,Numc),
sub_string(X,_,Lenx,0,Numx), number_string(Nmx,Numx),
sub_string(C,0,1,_,Op),Op = "l",
Nmc >= Nmx.

wins2(C,N) :- boxer(N,_,_,_,_,_,X,_,_,_),
string_length(C,Clen),Lenc is Clen - 1,
string_length(X,Xlen),Lenx is Xlen - 3,
sub_string(C,_,Lenc,0,Numc), number_string(Nmc,Numc),
sub_string(X,_,Lenx,0,Numx), number_string(Nmx,Numx),
sub_string(C,0,1,_,Op),Op = "g",
Nmc < Nmx.
% </end wins >

% < begin wKO >
wKO2(C,N) :- boxer(N,_,_,_,_,_,_,X,_,_),
string_length(C,Clen),Lenc is Clen - 1,
string_length(X,Xlen),Lenx is Xlen - 3,
sub_string(C,_,Lenc,0,Numc), number_string(Nmc,Numc),
sub_string(X,_,Lenx,0,Numx), number_string(Nmx,Numx),
sub_string(C,0,1,_,Op),Op = "l",
Nmc >= Nmx.

wKO2(C,N) :- boxer(N,_,_,_,_,_,_,X,_,_),
string_length(C,Clen),Lenc is Clen - 1,
string_length(X,Xlen),Lenx is Xlen - 3,
sub_string(C,_,Lenc,0,Numc), number_string(Nmc,Numc),
sub_string(X,_,Lenx,0,Numx), number_string(Nmx,Numx),
sub_string(C,0,1,_,Op),Op = "g",
Nmc < Nmx.
% </end wKO >

% < begin losses >
losses2(C,N) :- boxer(N,_,_,_,_,_,_,_,X,_),
string_length(C,Clen),Lenc is Clen - 1,
string_length(X,Xlen),Lenx is Xlen - 3,
sub_string(C,_,Lenc,0,Numc), number_string(Nmc,Numc),
sub_string(X,_,Lenx,0,Numx), number_string(Nmx,Numx),
sub_string(C,0,1,_,Op),Op = "l",
Nmc >= Nmx.

losses2(C,N) :- boxer(N,_,_,_,_,_,_,_,X,_),
string_length(C,Clen),Lenc is Clen - 1,
string_length(X,Xlen),Lenx is Xlen - 3,
sub_string(C,_,Lenc,0,Numc), number_string(Nmc,Numc),
sub_string(X,_,Lenx,0,Numx), number_string(Nmx,Numx),
sub_string(C,0,1,_,Op),Op = "g",
Nmc < Nmx.
% </fin losses >

% <begin titles>
titles2(C,R,N) :- boxer(N,_,_,_,_,_,_,_,_,X),
split_string(X,"__","",Ns),R=yes,
memberchk(C,Ns).

titles2(C,R,N) :- boxer(N,_,_,_,_,_,_,_,_,X),
split_string(X,"__","",Ns),R=no,
not_member(C,Ns).
% </end titles>
% what is learned by users

boxeur(mohamed,american,int5,int511,5,int5,int555,int5,int5,5).