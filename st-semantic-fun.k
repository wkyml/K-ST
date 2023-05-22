require "st-syntax.k"
require "st-configuration.k"
require "st-semantic-common.k"

module ST-SEMANTIC-FUN

     imports ST-SYNTAX
     imports ST-CONFIGURATION
     imports ST-SEMANTIC-COMMON

     rule <k> PROGRAM I:Id Vds:VarDefinitions S:StatementLists END_PROGRAM => . ...</k>
         <env> Env => Env[I <- L] </env>
         <store>... .Map => L |-> plambda(I, void, Vds, S, .Map) ...</store>
         <type>... .Map => L |-> Program </type>
         <constant>... .Map => L |-> false ...</constant>
         <nextLoc> L => L +Int 1 </nextLoc>   requires notBool I in_keys (Env)  [structural]

    rule <k> FUNCTION I:Id : T:TypeName Vds:VarDefinitions S:StatementLists END_FUNCTION => . ...</k>
         <env> Env => Env[I <- L] </env>
         <store>... .Map => L |-> funlambda(I, T, Vds, S) ...</store>
         <type>... .Map => L |-> Function </type>
         <constant>... .Map => L |-> false ...</constant>
         <nextLoc> L => L +Int 1 </nextLoc> requires notBool I in_keys (Env)    [structural]

    rule <k> FUNCTION_BLOCK I:Id Vds:VarDefinitions S:StatementLists END_FUNCTION_BLOCK => . ...</k>
         <env> Env => Env[I <- L] </env>
         <store>... .Map => L |-> fblambda(I, void, Vds, S, .Map) ...</store>
         <type>... .Map => L |-> FunctionBlock </type>
         <constant>... .Map => L |-> false ...</constant>
         <nextLoc> L => L +Int 1 </nextLoc> requires notBool I in_keys (Env)    [structural]

     rule <k> plambda(MAIN, void, Vds:VarDefinitions, S:StatementLists, _:Map)(E:AllExps) ~> K
            => renew ~> runpfblambda(MAIN, void, Vds, S, .Map)(E) </k>
         <control>
               <fstack> .List => ListItem(info(MAIN, void, K, Allenv, C)) ...</fstack>
               <env> Env => Genv </env>
               C
         </control>
         <allenv> Allenv => Env </allenv>
         <genv> Genv </genv>

    rule <k> funlambda(I:Id, T:TypeName, Vds:VarDefinitions, S:StatementLists)(E:AllExps) ~> K
            => renew ~> ClearEnv(I) ~> runpfblambda(I, T, VAR I : T; END_VAR Vds, S, .Map)(E)</k>
         <control>   
               <fstack> .List => ListItem(info(I, T, K, Allenv, C)) ...</fstack>
               <env> Env => Genv </env>
               C
         </control>        
         <allenv> Allenv => Env </allenv>
         <genv> Genv </genv> requires T =/=K void

    rule <k> ufblambda(I:Id, void, Vds:VarDefinitions, S:StatementLists, .Map)(E:AllExps) ~> K
            => renew ~> runpfblambda(I, void, Vds, S, .Map)(E) </k>
         <control>
               <fstack> .List => ListItem(info(I, void, K, Allenv, C)) ...</fstack>
               <env> Env => Genv </env>
               C
         </control>
         <allenv> Allenv => Env </allenv>
         <genv> Genv </genv>

    rule <k> ufblambda(I:Id, void, Vds:VarDefinitions, S:StatementLists, M:Map)(E:AllExps) ~> K 
            => renew ~> runpfblambda(I, void, Vds, S, M)(E)</k>
         <control>   
               <fstack> .List => ListItem(info(I, void, K, Allenv, C)) ...</fstack>
               <env> Env => M </env>
               C
         </control>
         <allenv> Allenv => Env </allenv>  requires M =/=K .Map

    rule runpfblambda(MAIN, void, VAR_INPUT Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(.AllExps) 
         => VAR Vdls END_VAR ~> runpfblambda(MAIN, void, Vds, S, .Map)(.AllExps)
    rule runpfblambda(I:Id, T1:TypeName, VAR_INPUT I1:Id, Is:Ids : T:TypeName := _:Expression; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(Es:AllExps) 
         => runpfblambda(I, T1, VAR_INPUT I1, Is : T; Vdls END_VAR Vds, S, .Map)(Es) requires I =/=K MAIN
    rule <k>runpfblambda(I:Id, T1:TypeName, VAR_INPUT I1:Id, Is:Ids : T:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(E1:Id, Es:AllExps) 
         => VAR I1 : T := getVal(E1); END_VAR ~> runpfblambda(I, T1, VAR_INPUT Is : T; Vdls END_VAR Vds, S, .Map)(Es)</k>
         <allenv>... E1 |-> L ...</allenv>
         <type>... L |-> T2:TypeName ...</type> requires I =/=K MAIN andBool T ==K T2
    rule runpfblambda(I:Id, T1:TypeName, VAR_INPUT I1:Id, Is:Ids : T:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(E1:Value, Es:AllExps) 
         => VAR I1 : T := getVal(E1); END_VAR ~> runpfblambda(I, T1, VAR_INPUT Is : T; Vdls END_VAR Vds, S, .Map)(Es) requires I =/=K MAIN
    rule runpfblambda(I:Id, T1:TypeName, VAR_INPUT I1:Id, Is:Ids : T:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(I2:Id := E1:Expression, Es:AllExps) 
         => VAR I1 : T := getVal(E1); END_VAR ~> runpfblambda(I, T1, VAR_INPUT Is : T; Vdls END_VAR Vds, S, .Map)(Es) requires I2 ==K I1 andBool I =/=K MAIN
    rule runpfblambda(I:Id, T1:TypeName, VAR_INPUT .Ids : _:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(Es:AllExps) 
         => runpfblambda(I, T1, VAR_INPUT Vdls END_VAR Vds, S, .Map)(Es) requires I =/=K MAIN
    rule runpfblambda(I:Id, T1:TypeName, VAR_INPUT .VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(Es:AllExps) 
         => runpfblambda(I, T1, Vds, S, .Map)(Es) requires I =/=K MAIN

    rule runpfblambda(I:Id, T1:TypeName, VAR_INPUT CONSTANT I1:Id, Is:Ids : T:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(E1:Id, Es:AllExps) 
         => VAR CONSTANT I1 : T := getVal(E1); END_VAR ~> runpfblambda(I, T1, VAR_INPUT CONSTANT Is : T; Vdls END_VAR Vds, S, .Map)(Es) 
    rule runpfblambda(I:Id, T1:TypeName, VAR_INPUT CONSTANT I1:Id, Is:Ids : T:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(E1:Value, Es:AllExps) 
         => VAR CONSTANT I1 : T := getVal(E1); END_VAR ~> runpfblambda(I, T1, VAR_INPUT CONSTANT Is : T; Vdls END_VAR Vds, S, .Map)(Es) 
    rule runpfblambda(I:Id, T1:TypeName, VAR_INPUT CONSTANT I1:Id, Is:Ids : T:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(I2:Id := E1:Expression, Es:AllExps) 
         => VAR CONSTANT I1 : T := getVal(E1); END_VAR ~> runpfblambda(I, T1, VAR_INPUT CONSTANT Is : T; Vdls END_VAR Vds, S, .Map)(Es) requires I2 ==K I1
    rule runpfblambda(I:Id, T1:TypeName, VAR_INPUT CONSTANT .Ids : _:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(Es:AllExps) 
         => runpfblambda(I, T1, VAR_INPUT CONSTANT Vdls END_VAR Vds, S, .Map)(Es)
    rule runpfblambda(I:Id, T1:TypeName, VAR_INPUT CONSTANT .VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(Es:AllExps) 
         => runpfblambda(I, T1, Vds, S, .Map)(Es)

    rule runpfblambda(I:Id, void, VAR_OUTPUT Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(Es:AllExps)
        => VAR Vdls:VarDeclarations END_VAR ~> runpfblambda(I, void, Vds, S, .Map)(Es)


    rule <k> runpfblambda(I:Id, T1:TypeName, VAR_IN_OUT I1:Id, Is:Ids : T:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(I2:Id, Es:AllExps) 
         => runpfblambda(I, T1, VAR_IN_OUT Is : T; Vdls END_VAR Vds, S, .Map)(Es) </k>
         <env> Env => Env[I1 <- L] </env>
         <allenv>... I2 |-> L ...</allenv> 
         <type>... L |-> T2:TypeName ...</type> requires notBool (I1 in_keys (Env)) andBool T ==K T2 
    rule <k> runpfblambda(I:Id, T1:TypeName, VAR_IN_OUT I1:Id, Is:Ids : T:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(I3:Id := I2:Id, Es:AllExps) 
         => runpfblambda(I, T1, VAR_IN_OUT Is : T; Vdls END_VAR Vds, S, .Map)(Es) </k>
         <env> Env => Env[I1 <- L] </env>
         <allenv>... I2 |-> L ...</allenv> 
         <type>... L |-> T2:TypeName ...</type> requires notBool (I1 in_keys (Env)) andBool (T ==K T2) andBool I1 ==K I3 
    rule runpfblambda(I:Id, T1:TypeName, VAR_IN_OUT .Ids : _:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(Es:AllExps) 
         => runpfblambda(I, T1, VAR_IN_OUT Vdls END_VAR Vds, S, .Map)(Es) 
    rule runpfblambda(I:Id, T1:TypeName, VAR_IN_OUT .VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(Es:AllExps) 
         => runpfblambda(I, T1, Vds, S, .Map)(Es) 

    rule runpfblambda(I:Id, T1:TypeName, VAR Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(Es:AllExps) 
         => VAR Vdls END_VAR ~> runpfblambda(I, T1, Vds, S, .Map)(Es)

    rule runpfblambda(I:Id, T1:TypeName, VAR CONSTANT Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(Es:AllExps) 
         => VAR CONSTANT Vdls END_VAR ~> runpfblambda(I, T1, Vds, S, .Map)(Es)

    rule <k> runpfblambda(I:Id, T1:TypeName, VAR_EXTERNAL I1:Id, Is:Ids : T:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(Es:AllExps)
         => runpfblambda(I, T1, VAR_EXTERNAL Is : T; Vdls END_VAR Vds, S, .Map)(Es) </k>
         <env> Env => Env[I1 <- L] </env>
         <gvenv>... I1 |-> L ...</gvenv> 
         <type>... L |-> T2:TypeName ...</type> requires notBool (I1 in_keys (Env)) andBool T ==K T2 
    rule runpfblambda(I:Id, T1:TypeName, VAR_EXTERNAL .Ids : _:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(Es:AllExps) 
         => runpfblambda(I, T1, VAR_EXTERNAL Vdls END_VAR Vds, S, .Map)(Es)
    rule runpfblambda(I:Id, T1:TypeName, VAR_EXTERNAL .VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(Es:AllExps) 
         => runpfblambda(I, T1, Vds, S, .Map)(Es)

    rule runpfblambda(I:Id, T1:TypeName, VAR_TEMP Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, .Map)(Es:AllExps)
        => VAR Vdls:VarDeclarations END_VAR ~> runpfblambda(I, T1, Vds, S, .Map)(Es)

    rule runpfblambda(I:Id, void, VAR_INPUT I1:Id, Is:Ids : T:TypeName := _:Expression; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(Es:AllExps) 
         => runpfblambda(I, void, VAR_INPUT I1, Is : T; Vdls END_VAR Vds, S, M)(Es)   requires M =/=K .Map
    rule runpfblambda(I:Id, void, VAR_INPUT I1:Id, Is:Ids : T:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(E1:Id, Es:AllExps) 
         => I1 := getVal(E1); ~> runpfblambda(I, void, VAR_INPUT Is : T; Vdls END_VAR Vds, S, M)(Es) requires M =/=K .Map
    rule runpfblambda(I:Id, void, VAR_INPUT I1:Id, Is:Ids : T:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(E1:Value, Es:AllExps) 
         => I1 := getVal(E1); ~> runpfblambda(I, void, VAR_INPUT Is : T; Vdls END_VAR Vds, S, M)(Es) requires M =/=K .Map
    rule runpfblambda(I:Id, void, VAR_INPUT I1:Id, Is:Ids : T:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(I2:Id := E1:Expression, Es:AllExps) 
         => I1 := getVal(E1); ~> runpfblambda(I, void, VAR_INPUT Is : T; Vdls END_VAR Vds, S, M)(Es) requires (M =/=K .Map) andBool (I2 ==K I1)
    rule runpfblambda(I:Id, void, VAR_INPUT .Ids : _:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(Es:AllExps) 
         => runpfblambda(I, void, VAR_INPUT Vdls END_VAR Vds, S, M)(Es) requires M =/=K .Map
    rule runpfblambda(I:Id, void, VAR_INPUT .VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(Es:AllExps) 
         => runpfblambda(I, void, Vds, S, M)(Es) requires M =/=K .Map

    rule runpfblambda(I:Id, void, VAR_OUTPUT _:Ids : _:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(Es:AllExps) 
         => runpfblambda(I, void, VAR_OUTPUT Vdls END_VAR Vds, S, M)(Es) requires M =/=K .Map
    rule runpfblambda(I:Id, void, VAR_OUTPUT I1:Id, Is:Ids : T:TypeName := E:Expression; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(Es:AllExps) 
         => runpfblambda(I, void, VAR_OUTPUT Is : T := E; Vdls END_VAR Vds, S, M)(Es) requires M =/=K .Map
    rule runpfblambda(I:Id, void, VAR_OUTPUT .Ids : _:TypeName := _:Expression; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(Es:AllExps) 
         => runpfblambda(I, void, VAR_OUTPUT Vdls END_VAR Vds, S, M)(Es) requires M =/=K .Map
    rule runpfblambda(I:Id, void, VAR_OUTPUT .VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(Es:AllExps) 
         => runpfblambda(I, void, Vds, S, M)(Es) requires M =/=K .Map

    rule <k> runpfblambda(I:Id, void, VAR_IN_OUT I1:Id, Is:Ids : T:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(I2:Id, Es:AllExps) 
         => runpfblambda(I, void, VAR_IN_OUT Is : T; Vdls END_VAR Vds, S, M)(Es) </k>
         <env>... I1 |-> (_ => L)  </env>
         <allenv>... I2 |-> L ...</allenv> 
         <type>... L |-> T1:TypeName ...</type> requires T ==K T1 andBool M =/=K .Map
    rule <k> runpfblambda(I:Id, void, VAR_IN_OUT I1:Id, Is:Ids : T:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(I3:Id := I2:Id, Es:AllExps) 
         => runpfblambda(I, void, VAR_IN_OUT Is : T; Vdls END_VAR Vds, S, M)(Es) </k>
         <env>... I1 |-> (_ => L)  </env>
         <allenv>... I2 |-> L ...</allenv> 
         <type>... L |-> T1:TypeName ...</type> requires T ==K T1 andBool M =/=K .Map andBool I1 ==K I3
    rule runpfblambda(I:Id, void, VAR_IN_OUT .Ids : _:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(Es:AllExps) 
         => runpfblambda(I, void, VAR_IN_OUT Vdls END_VAR Vds, S, M)(Es) requires M =/=K .Map
    rule runpfblambda(I:Id, void, VAR_IN_OUT .VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(Es:AllExps) 
         => runpfblambda(I, void, Vds, S, M)(Es) requires M =/=K .Map

    rule runpfblambda(I:Id, void, VAR _:Ids : _:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(Es:AllExps) 
         => runpfblambda(I, void, VAR Vdls END_VAR Vds, S, M)(Es) requires M =/=K .Map
    rule runpfblambda(I:Id, void, VAR I1:Id, Is:Ids : T:TypeName := E:Expression; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(Es:AllExps) 
         => I1 := E; ~> runpfblambda(I, void, VAR Is : T := E; Vdls END_VAR Vds, S, M)(Es) requires M =/=K .Map
    rule runpfblambda(I:Id, void, VAR .Ids : _:TypeName := _:Expression; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(Es:AllExps) 
         => runpfblambda(I, void, VAR Vdls END_VAR Vds, S, M)(Es) requires M =/=K .Map
    rule runpfblambda(I:Id, void, VAR .VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(Es:AllExps) 
         => runpfblambda(I, void, Vds, S, M)(Es) requires M =/=K .Map

    rule runpfblambda(I:Id, T1:ElementaryTypeName, VAR CONSTANT _:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(Es:AllExps) 
         => runpfblambda(I, T1, Vds, S, M)(Es) requires M =/=K .Map

    rule runpfblambda(I:Id, void, VAR_EXTERNAL _:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(Es:AllExps) 
         => runpfblambda(I, void, Vds, S, M)(Es) requires M =/=K .Map

    rule runpfblambda(I:Id, void, VAR_TEMP I1:Id, Is:Ids : T:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(Es:AllExps) 
         => I1 := Undefined(T); ~> runpfblambda(I, void, VAR_TEMP Is : T; Vdls END_VAR Vds, S, M)(Es) requires M =/=K .Map
    rule runpfblambda(I:Id, void, VAR_TEMP I1:Id, Is:Ids : T:TypeName := E:Expression; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(Es:AllExps) 
         => I1 := E; ~> runpfblambda(I, void, VAR_TEMP Is : T := E; Vdls END_VAR Vds, S, M)(Es) requires M =/=K .Map
    rule runpfblambda(I:Id, void, VAR_TEMP .Ids : _:TypeName; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(Es:AllExps) 
         => runpfblambda(I, void, VAR_TEMP Vdls END_VAR Vds, S, M)(Es) requires M =/=K .Map
    rule runpfblambda(I:Id, void, VAR_TEMP .Ids : _:TypeName := _:Expression; Vdls:VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(Es:AllExps) 
         => runpfblambda(I, void, VAR_TEMP Vdls END_VAR Vds, S, M)(Es) requires M =/=K .Map
    rule runpfblambda(I:Id, void, VAR_TEMP .VarDeclarations END_VAR Vds:VarDefinitions, S:StatementLists, M:Map)(Es:AllExps) 
         => runpfblambda(I, void, Vds, S, M)(Es) requires M =/=K .Map

    rule runpfblambda(I:Id, T:TypeName, .VarDefinitions, S1:Statement S:StatementLists, M:Map)(.AllExps)
          => S1 ~> runpfblambda(I, T, .VarDefinitions, S, M)(.AllExps)
    rule <k> runpfblambda(_:Id, void, .VarDefinitions, .StatementLists, _:Map)(.AllExps)
          => print(Is) ~> RETURN; ...</k>
         <print> Is:AllExps => .AllExps </print>
    rule <k> runpfblambda(I:Id, T:TypeName, .VarDefinitions, .StatementLists, _:Map)(.AllExps)
          => print(Is) ~> RETURN I; ...</k>
         <print> Is:AllExps => .AllExps </print> requires (T =/=K void)

    rule <k> VAR_GLOBAL I1:Id : I2:Id; END_VAR => var I1 : fblambda(I3, void, Vds, S, M); ~> etogv(I1) ...</k>
        <env>... I2 |-> L ...</env>
        <store>... L |-> fblambda(I3:Id, void, Vds:VarDefinitions, S:StatementLists, M:Map) ...</store> requires I2 ==K I3

    rule <k> VAR I1:Id : I2:Id; END_VAR => var I1 : fblambda(I3, void, Vds, S, M); ...</k>
        <env>... I2 |-> L ...</env>
        <store>... L |-> fblambda(I3:Id, void, Vds:VarDefinitions, S:StatementLists, M:Map) ...</store> requires I2 ==K I3

    rule <k> var I1:Id : fblambda(I3:Id, void, Vds:VarDefinitions, S:StatementLists, M:Map); => . ...</k>
        <env> Env => Env[I1 <- L] </env>
        <store> ... .Map => L |-> ufblambda(I1, void, Vds, S, M) ...</store>
        <type> ... .Map => L |-> I3 </type>
        <constant>... .Map => L |-> false </constant>
        <nextLoc> L => L +Int 1 </nextLoc>      requires notBool (I1 in_keys (Env))

    rule <k> RETURN; ~> _ => RETURN NULL; </k>
          <fstack> ListItem(info(I, void, _, _, _)) ...</fstack>
          <env> Env </env>
          <allenv>... {I}:>Id |-> L ...</allenv>
          <store>... L |-> ufblambda(_:Id, void, _:VarDefinitions, _:StatementLists, .Map => Env) ...</store>

    rule <k> RETURN; ~> _ => RETURN NULL; </k>
          <fstack> ListItem(info(I, void, _, _, _)) ...</fstack>
          <allenv>... {I}:>Id |-> L ...</allenv>
          <store>... L |-> ufblambda(_:Id, void, _:VarDefinitions, _:StatementLists, M:Map) ...</store> requires M =/=K .Map

    rule <k> RETURN; ~> _ => RETURN NULL; </k>
          <fstack> ListItem(info(I, _, _, _, _)) ...</fstack>
          <env> Env </env>
          <allenv>... {I}:>Id |-> L ...</allenv>
          <store>... L |-> plambda(_:Id, void, _:VarDefinitions, _:StatementLists ,_:Map => Env)  ...</store>

    rule <k> RETURN; ~> _ => RETURN I; </k>
          <fstack> ListItem(info(I, T, _, _, _)) ...</fstack>  requires {T}:>ElementaryTypeName =/=K void

    rule <k> RETURN V:Value; => V ~> K </k>
          <control>
               <fstack> ListItem(info(_, _, K, M, C)) => .List ...</fstack>
               <env> _ => Allenv </env>
               (_ => C)
          </control>
          <allenv> Allenv => M </allenv>

    rule <k> renew => . ...</k>
          <enummap> _ => .Map </enummap>
          <count> _ => 0 </count>
          <break> _ => .List </break>
          <print> _ => .AllExps </print>

    rule <k> execute => letogv(Is) </k>
         <gvid> Is:Ids => .Ids </gvid>            [structural]

    rule <k> letogv(.Ids) => MAIN(.AllExps); ~> finish </k>
         <env> Env </env>
         <allenv> .Map => Env </allenv>
         <genv> .Map => Env </genv>               [structural]

    rule <k> finish => print(Is) </k>
         <print> Is:AllExps => .AllExps </print>
         <env> Env => Env Gvenv </env>
         <gvenv> Gvenv </gvenv>

endmodule