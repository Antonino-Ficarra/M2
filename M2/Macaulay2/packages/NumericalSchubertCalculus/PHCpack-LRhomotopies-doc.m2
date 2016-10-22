doc ///
  Key
    "LRhomotopies"
  Headline
    interface to the Littlewood-Richardson homotopies in PHCpack
  Description
    Text
      Interfaces the functionality of the software {\tt PHCpack}
      to solve Schubert problems with Littlewood-Richardson homotopies,
      a tool in {\em numerical Schubert calculus}.
      The software {\tt PHCpack} is available at
      @HREF"http://www.math.uic.edu/~jan/download.html"@.
      The site provides source code and its executable versions {\tt phc}.
      The user must have the executable program {\tt phc} available,
      preferably in the executation path.
  Caveat
    The program "phc" (at least version 2.4.02, but preferably higher)
    of PHCpack needs to in the path for execution.

    The current implementation resolves only one triple intersection
    condition (although the root count in LRrule is general).
///;

doc ///
  Key
    LRrule
    (LRrule,ZZ,Matrix)
  Headline
    calls phc -e to resolve a Schubert intersection condition
  Usage
    s = LRrule(n,m)
  Inputs
    n:ZZ
      the ambient dimension
    m:Matrix
      in the rows are the intersection conditions,
      the first element of each row is the number of times
      the intersection bracket must be taken.
  Outputs
    s:String
      contains an equation, with at the left the
      intersection condition and at the right the result.
  Description
    Text
      The LRrule computes the number of solutions to
      a Schubert intersection condition.
    Example
      R := ZZ;
      n := 7;
      m := matrix{{1, 2, 4, 6},{2, 3, 5, 7}};
      print LRrule(n,m);
    Text
      The Schubert condition [2 4 6]*[3 5 7]^2 resolves to 2[1 2 3]
      means that there are two 3-planes that satisfy the condition.
    
      If the right hand side of the equation returned by LRrule
      consists of one bracket of consecutive natural numbers starting
      at zero, then there are finitely many solutions.
      Otherwise, the problem may be underdetermined,
      consider the example:
    Example
      LRrule(7, matrix{{2,3,6,7},{1,3,5,7},{1,2,5,7}})
    Text
      Littlewood-Richardson homotopies work only for fully determined
      Schubert intersection conditions.
///;

doc ///
  Key
    [LRtriple,luckySeed]
  Headline
    option to set the seed of the random number generators
  Usage
    LRtriple(...,luckySeed=>ZZ)
  Description
    Text
      Use {\tt luckySeed=>12345} to set the seed to 12345.
///;

doc ///
  Key
    LRtriple
    (LRtriple,ZZ,Matrix)
  Headline
    runs the Littlewood-Richardson homotopies to solve a generic Schubert problem
  Usage
    LRtriple(n,m)
    LRtriple(n,m, luckySeed=>12345)
  Inputs
    n:ZZ
      the ambient dimension
    m:Matrix
      in the rows are the intersection conditions,
      the first element of each row is the number of times
      the intersection bracket must be taken.
  Outputs
    :Sequence
      first a string with the generic flags, the moved flags, 
      and the solution planes; then a string with the polynomial system
      solved; and thirdly a list of solutions.
  Description
    Text
      LRtriple applies the Littlewood-Richardson homotopies
      to solve a generic instance of a Schubert problem defined
      by at least three intersection conditions.

      Use the method parseTriplet to parse the three strings f, p, and s
      into proper Macaulay2 polynomials, solution lists, and complex matrices.

      The example below computes all 3-planes that satisfy [2 4 6]^3.
    Example
      R := ZZ; n := 6; m := matrix{{3, 2, 4, 6}};
      result := LRtriple(n,m);
      stdio << "the fixed flags :\n" << result_0;
      stdio << "polynomial system solved :\n" << result_1;
      stdio << "solutions :\n" << result_2;
///;

doc ///
  Key
    parseTriplet
    (parseTriplet,String,String,String)
  Headline
    Parses a flag, system, and solutions into Macaulay2 objects.
  Usage
    (R, pols, sols, fixedFlags, movedFlag, solutionPlanes) = parseTriplet(f, p, s)
  Inputs
    f:String
      represents the fixed flag
    p:String
      represents a polynomial system
    s:String
      solutions to the polynomial system
  Outputs
    R:Ring
      a polynomial ring with complex floating-point coefficients
      and in the variables used in the systems p
    pols:List
      list of polynomial equations in the ring R
    sols:List
      list of solutions of the system pols
    fixedFlags:List
      list of the fixed flags, as matrices of complex numbers
    movedFlag:List
      the moved flag, the flag not listed here is the identity matrix
    solutionPlanes:List
      list of complex matrices which store the solution planes
  Description
    Text
      The parseTriplet allows to process the output of LRtriple.
    Example
      (f, p, s) = LRtriple(6,matrix{{3, 2, 4, 6}});
      (R, pols, sols, fixed, moved, solplanes) = parseTriplet(f, p, s);
      vars(R)
      peek sols
      peek solplanes
///;

doc ///
  Key
    wrapTriplet
    (wrapTriplet,String,String,String)
  Headline
    Wraps a flag, system, and solutions into one string for phc -e.
  Usage
    w = wrapTriplet(f,p,s)
  Inputs
    f:String
      represents the fixed flag
    p:String
      represents a polynomial system
    s:String
      solutions to the polynomial system
  Outputs
    w:String
      suitable for input to cheater in phc -e
  Description
    Text
      To pass the output of LRtriple to the LRcheater,
      the flag, the polynomial system and its solutions
      are wrapped into one string.
///;

-- end; -- terminate reading because LRcheater does not work yet

doc ///
  Key
    LRcheater
    (LRcheater,ZZ,Matrix,String)
  Headline
    A cheater's homotopy to a real Schubert triple intersection problem
  Usage
    t = LRcheater(n,m,w)
  Inputs
    n:ZZ
      the ambient dimension
    m:Matrix
      in the rows are the intersection conditions,
      the first element of each row is the number of times
      the intersection bracket must be taken.
    w:String
      the outcome of LRtriple(n,m), wrapped into string.
  Outputs
    t:String
      solutions to a a real triple Schubert intersection problem.
  Description
    Text
      A cheater's homotopy between two polynomial systems connects
      a generic instance to a specific instance.

      The example below
      solves a generic instance of [2 4 6]^3, followed by a cheater
      homotopy to a real instance.
    Example
      R := ZZ;
      n := 6;
      m := matrix{{3, 2, 4, 6}};
      t := LRtriple(n,m);
      w := wrapTriplet(t);
      --result := LRcheater(n,m,w);
      --(rps, pols, sols, flag) = parseTriplet(result);
      --stdio << "real fixed flag :\n" << flag;
      --stdio << "polynomial system solved :\n" << pols;
      --stdio << "solutions :\n" << sols;
///;

end;  -- terminate reading

Usage
   s = LRrule(N,M)
   S = LRtriple(N,M)
   w = wrapTriplet(S)
   R = LRcheater(N,M,w)
Inputs
   N:ZZ
     positive
   M:Matrix
Outputs
   s:String
   S:Sequence
   w:String
   R:Sequence
Description
   Text
      The Littlewood-Richardson rule is provided in LRrule.

      LRrule takes on input a Schubert intersection like [2 4 6]^3
      and returns a string with the resolution of this condition.
   Example
      R = ZZ
      N = 7
      M = matrix{{1, 2, 4, 6},{2, 3, 5, 7}}
      print LRrule(N,M)
      S = LRtriple(N,M)
      w = wrapTriplet(S)
      print LRcheater(N,M,w)
Caveat
   The program "phc" built with version 2.4.02 (or higher)
   of PHCpack needs to be present in the path on the computer.
   Executables for various platforms and source code for phc
   are available from the web page of the author.
///
