restart
needsPackage "NAGtools"
--setDefault(Software=>M2)
setRandomSeed 0
needsPackage "ExampleIdeals"
///
n = 6
///
S = gens cyclicRoots(n,CC)
R = ring S
polys = flatten entries S
ind = flatten apply(#polys,i-> -- parameteric coefficients 
    apply(exponents polys#i, t->(i,t))
    )
AR = CC[apply(ind,i->A_i)][gens R] 
polysP = for i to #polys-1 list -- parameteric coefficients 
         sum(exponents polys#i, t->A_(i,t)*AR_(t))
SP = matrix{polysP}

c0 = point{ 
    flatten apply(polys,f->(
	    r := # exponents f;
	    t := apply(r-1, i->random CC);
	    t | { -sum t }
	    )) 
    }
coordinates c0
pre0 = point{toList(n:1_CC)}
coordinates pre0
end ----------------------------------------------------------------------------

restart
n = 5
load "NumericalAlgebraicGeometry/SYSTEMS/monodromy/sparse-system-via-polynomials.m2"
stop = (n,L)->n>1
getDefault Software
{*
setDefault(Software=>PHCPACK)
*}
elapsedTime sols = solveViaMonodromy(SP,c0,{pre0},
    StoppingCriterion=>stop);

---------- PHCpack timing ------------------------
restart
loadPackage "PHCpack"

needsPackage "ExampleIdeals"
n = 10
I = cyclicRoots(n,CC);
R = CC[x_1..x_(numgens ring I)]
toR = map(R,ring I,vars R)
elapsedTime (mv,q,qsols) = mixedVolume(I_*/toR,StartSystem => true);

