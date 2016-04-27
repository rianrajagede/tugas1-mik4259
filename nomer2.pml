#define	N	5	/*Number of Proc*/

bool b;
bool w = 1;
bool s[2] = {1, 1};
int nCrit = 0;

active [N] proctype P() {
	bool ci;
	do
		::(true) ->
			ci = w;
			/* P(s.ci) */
			atomic{
				(s[ci]); s[ci] = 0;
			}
			if
				::(ci == w) -> 
					/* P(s.-ci) */
					atomic{ (s[!ci]); s[!ci] = 0; }
					b = 1;
					do
						::b ->
							b = 0;
							/* V(s.-ci) */
							s[!ci] = 1;
							/* P(s.-ci) */
							atomic{ (s[!ci]); s[!ci] = 0; }

						::!b -> break;
					od;
					w = !w;
					/* V(s.-ci) */
					s[!ci] = 1;
				::else -> goto critical;
			fi;
			/* BEGINING OF CRITICAL SECTION */
			critical : nCrit++; assert(nCrit == 1); nCrit--;
			/* END OF CRITICAL SECTION */
			b = 1;
			/* V(s.ci) */
			s[ci] = 1;
	od
}