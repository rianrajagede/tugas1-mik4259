#define	N	2

bool b;
bool w = 1;
bool s[2] = {1, 1};
int nCrit = 0;

active [N] proctype X() {
	bool ci;
	do
		::true ->
			ci = w;
			//P(s.ci)
			do
				::(true) ->
					atomic{
						if
							::(s[ci]) ->
								s[ci] = 0;
								break;
							::else -> skip;
						fi;
					}
			od;
			if
				::(ci == w) -> 
					//P(s.-ci)
					do
						::(true) ->
							atomic{
								if
									::(s[!ci]) ->
										s[!ci] = 0;
										break
									::else -> skip
								fi;
							}
					od;
					b = 1;
					do
						::(b) ->

							b = 0;
							//V(s.-ci)
							s[!ci] = 1;
							//P(s.-ci)
							do
								::(true) ->
									atomic{
										if
											::(s[!ci]) ->
												s[!ci] = 0;
												break;
											::else -> skip;
										fi;
									}
							od;

						::(!b) -> break;
					od;
					w = !w;
					//V(s.-ci)
					s[!ci] = 1;
				::else -> goto critical;
			fi;
			critical : nCrit++; assert(nCrit == 1); nCrit--;
			b = 0;
			//V(s.ci)
			s[ci] = 1;
	od
}