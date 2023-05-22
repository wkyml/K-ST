require "st-syntax.k"
require "st-configuration.k"
require "st-semantic-common.k"

module ST-SEMANTIC-ARRAY 

    imports ST-SYNTAX
    imports ST-CONFIGURATION
    imports ST-SEMANTIC-COMMON

    syntax Statements ::= "var" AllExp ";"
                | "var" Id ":" ArrayTypeName ";"
                | "var" Id ":" ArrayTypeName ":=" Expression ";"
                | "<{" "}>"
                | "<{" Statements "}>"
                | "if" "(" Expression ")" Statements "else" Statements   [avoid, strict(1)]
                | "if" "(" Expression ")" Statements
                | "while" "(" Expression ")" Statements
                | "for" "(" Statements Expression ";" AllExp ")" Statements

    rule <{}> => .      [structural]
    rule <k> <{ S }> => S ~> Rho ...</k> <env> Rho </env>   [structural]
    rule <k> Rho => . ...</k> <env> _ => Rho </env>         [structural]

    rule if (E) <{S}> => if (E) <{S}> else <{}>                             [macro]
    rule for(Start Cond; Step) <{S}> => <{Start while (Cond) <{S Step;}>}>  [macro]
    rule for(Start Cond; Step) <{}> => <{Start while (Cond) <{Step;}>}>     [macro]
    rule var X:Id := E; => var X; X := E;                                   [macro]

    rule <k> var X:Id; => . ...</k>
        <env> Env => Env[X <- L] </env>
       <store>... .Map => L |-> undefined ...</store>
       <nextLoc> L => L +Int 1 </nextLoc>
    
    syntax KItem ::= "undefined"
    
    rule VAR_GLOBAL X:Id : ARRAY [I1:Int .. I2:Int] OF At:ElementaryTypeName; END_VAR => VAR X : ARRAY [I1 .. I2] OF At; END_VAR ~> etogv(X)   [structural]

    rule <k> VAR X:Id : ARRAY [I1:Int .. I2:Int] OF At:ElementaryTypeName; END_VAR => var X : ARRAY [I1 .. I2] OF At; ...</k>
        <env> Env </env>   
        <gvenv> Gvenv </gvenv>  requires (notBool (X in_keys (Env))) andBool (notBool (X in_keys (Gvenv)))         [structural]

    rule <k> VAR X:Id : ARRAY [I1:Int .. I2:Int] OF At:ElementaryTypeName := [ Es:Expressions ]; END_VAR => var X : ARRAY [I1 .. I2] OF At := [ Es ]; ...</k>
        <env> Env </env>   
        <gvenv> Gvenv </gvenv>  requires (notBool (X in_keys (Env))) andBool (notBool (X in_keys (Gvenv)))         [structural]

    rule <k> var X:Id : ARRAY [I1:Int .. I2:Int] OF At:ElementaryTypeName; => . ...</k>
      <env> Env => Env[X <- L] </env>
      <store> ... .Map => L |-> array(At, L +Int 1, I2 -Int I1 +Int 1, I1)
                          (L +Int 1) ... (L +Int I2 -Int I1 +Int 1) |-> Undefined(At) ...</store>
      <type> ... .Map => L |-> ARRAY [I1 .. I2] OF At 
                  (L +Int 1) ... (L +Int I2 -Int I1 +Int 1) |-> At ...</type>
      <constant>... .Map => (L) ... (L +Int I2 -Int I1 +Int 1) |-> false ...</constant>
      <nextLoc> L => L +Int 1 +Int I2 -Int I1 +Int 1 </nextLoc>
      requires I2 -Int I1 +Int 1 >=Int 0       [structural]

   rule <k> var X:Id : ARRAY [I1:Int .. I2:Int] OF At:ElementaryTypeName := [ Es:Expressions ]; => . ...</k>
      <env> Env => Env[X <- L] </env>
      <store> ... .Map => L |-> array(At, L +Int 1, I2 -Int I1 +Int 1, I1)
                          (L +Int 1) ... (L +Int I2 -Int I1 +Int 1) |-> [Es] ...</store>
      <type> ... .Map => L |-> ARRAY [I1 .. I2] OF At 
                  (L +Int 1) ... (L +Int I2 -Int I1 +Int 1) |-> At ...</type>
      <constant>... .Map => (L) ... (L +Int I2 -Int I1 +Int 1) |-> false ...</constant>
      <nextLoc> L => L +Int 1 +Int I2 -Int I1 +Int 1 </nextLoc>
      requires I2 -Int I1 +Int 1 >=Int 0       [structural]

    rule VAR_GLOBAL X:Id : ARRAY [As1:ArrayBlocks] OF ARRAY [As2:ArrayBlocks] OF T:TypeName; END_VAR => VAR_GLOBAL X : ARRAY [As1, As2] OF T; END_VAR       [structural]
    rule VAR X:Id : ARRAY [As1:ArrayBlocks] OF ARRAY [As2:ArrayBlocks] OF T:TypeName; END_VAR => VAR X : ARRAY [As1, As2] OF T; END_VAR       [structural]

    rule <k> VAR X:Id : ARRAY [I1:Int .. I2:Int, As:ArrayBlocks] OF At:ElementaryTypeName; END_VAR => var X:Id : ARRAY [I1 .. I2, As] OF At:ElementaryTypeName; ...</k>
        <env> Env </env>   requires notBool (X in_keys (Env)) [structural]

    rule var X:Id : ARRAY [I1:Int .. I2:Int, As:ArrayBlocks] OF At:ElementaryTypeName;
    => var X : ARRAY [I1 .. I2] OF At;
        <{
          var $1 := X;
          for (var $2 := I1; $2 <= I2; $2 := $2 + 1) <{
           var X : ARRAY [As] OF At;
           $1[$2] := X;
          }>
        }> ~> settype(X, ARRAY [I1 .. I2, As] OF At)    [structural]

    context _::Value[HOLE::Expression, _::Expressions]
    rule V:Value[N1:Int, N2:Expression, Es:Expressions] => V[N1][N2, Es]            [structural, anywhere] 
    rule array(_, L, L1, I)[N:Int] => lookup(L +Int N -Int I)   requires N >=Int I andBool (L +Int N -Int I) <Int (L +Int L1)         [structural, anywhere]                           

    rule if (true) S else _ => S
    rule if (false) _ else S => S
    rule while (E) S => if (E) <{S while(E) S}>  [structural]

    syntax Map ::= Int "..." Int "|->" TypeName     [function]
    syntax Map ::= Int "..." Int "|->" Expression     [function]


    rule N...M |-> _:TypeName => .Map  requires N >Int M
    rule N...M |-> _:Expression => .Map  requires N >Int M
    rule N...M |-> V:Value => N |-> V (N +Int 1)...M |-> V  requires N <=Int M
    rule N...M |-> T:TypeName => N |-> T (N +Int 1)...M |-> T  requires N <=Int M 
    rule N...M |-> Undefined(T:TypeName) => N |-> Undefined(T) (N +Int 1)...M |-> Undefined(T)  requires N <=Int M
    rule N...M |-> [E:Value, Es:Expressions] => N |-> E (N +Int 1)...M |-> [Es]  requires N <=Int M
    rule N...M |-> [I:Int(E:Value), Es:Expressions] => N |-> E (N +Int 1)...M |-> [I -Int 1(E), Es]  requires N <=Int M andBool I >Int 0
    rule N...M |-> [I:Int(_:Value), Es:Expressions] => N...M |-> [Es]  requires N <=Int M andBool I ==Int 0

endmodule