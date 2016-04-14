short flag[2]
short numOfCrit

proctype P0(){
	int i = 0
	do
		::true ->
			noncrit0:
			flag[i] = 1
			((flag[0] < 3) && (flag[1] < 3)) -> skip
			
			flag[i] = 3
			if
				::((flag[0] == 1) || (flag[1] == 1)) -> 
					flag[i] = 2;
					((flag[0] == 4) || (flag[1] == 4)) -> skip
			fi
			flag[i] = 4

			crit0:
				numOfCrit++
			numOfCrit--
			((flag[1] == 0 || flag[1] == 1 || flag[1] == 4)) -> skip
			flag[i] = 0
	od
}

proctype P1(){
	int i = 1
	do
		::true ->
			noncrit1:
			flag[i] = 1
			((flag[0] < 3) && (flag[1] < 3)) -> skip
			
			flag[i] = 3
			if
				::((flag[0] == 1) || (flag[1] == 1)) -> 
					flag[i] = 2;
					((flag[0] == 4) || (flag[1] == 4)) -> skip
			fi;
			flag[i] = 4

			(flag[0] < 2) -> skip
			crit1:
				numOfCrit++
			
			flag[i] = 0
	od;
}

active proctype monitor(){
	assert(numOfCrit < 2)
}

init {
	flag[0] = 0
	flag[1] = 0
	numOfCrit = 0
	run P0()
	run P1()
}
