#define N	5	/*Number of Proc*/

short flag[N]={0};
int nCrit = 0;

active [N] proctype p(){
	do
		::true->
			l1:	skip;
			l2:	flag[_pid] = 1;
			l3:	do
					::true -> 
						atomic{
							int i;
							bool stop = 1;
							for(i : 0 .. N-1){
								if
									::(flag[i] < 3) -> skip
									::else -> 
										stop = 0;
										break;
								fi;
							}
							if
								::stop -> break;
								::else -> skip;
							fi;
						}
				od;
			l4:	flag[_pid] = 3;
			bool checkL5 = 0;
			atomic{
				int i;
				for(i : 0 .. N-1){
					if
						::(flag[i] == 1) -> 
							checkL5 = 1;
							break;
						::else -> skip
					fi;
				}
			};
			l5:	if
					::checkL5 ->
						l6:	flag[_pid] = 2;
						l7:	do
								::true ->
									atomic{
										int i;
										bool stop = 0;
										for(i : 0 .. N-1){
											if
												::(flag[i] == 4) -> 
													stop = 1;
													break;
												::else -> skip
											fi;
										}
										if
											::stop -> break;
											::else -> skip;
										fi;
									}
							od;
					::else -> skip
				fi;
			l8:	flag[_pid] = 4;
			l9:	do
					::true ->
						atomic{
							int i;
							bool stop = 1;
							for(i : 0 .. _pid-1){
								if
									::(flag[i] < 2) -> skip
									::else ->
										stop = 0;
										break
								fi
							}
							if
								::stop -> break;
								::else -> skip;
							fi
						}
				od;
			l10: nCrit++; assert(nCrit == 1); nCrit--;
			l11:	do
						::true ->
							atomic{
								int i;
								bool stop = 1;
								for(i : _pid+1 .. N-1){
									if
										::((flag[i] == 0) || (flag[i] == 1) || (flag[i] == 4)) -> skip
										::else ->
											stop = 0;
											break
									fi;
								}
								if
									::stop -> break;
									::else -> skip;
								fi;
							}
					od
			l12: flag[_pid] = 0;
	od
}