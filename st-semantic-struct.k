require "st-syntax.k"
require "st-configuration.k"
require "st-semantic-common.k"
require "st-semantic-array.k"

module ST-SEMANTIC-STRUCT

    imports ST-SYNTAX
    imports ST-CONFIGURATION
    imports ST-SEMANTIC-COMMON

    rule <k> TYPE I:Id : STRUCT Vd:VarDeclarations END_STRUCT; END_TYPE => . ...</k>
        <env> Env => Env[I <- L] </env>
        <store> ... .Map => L |-> Vd ...</store>
        <type> ... .Map => L |-> Struct ...</type>
        <constant>... .Map => L |-> false </constant>
        <nextLoc> L => L +Int 1 </nextLoc>    requires notBool (I in_keys (Env))

    rule <k>VAR_GLOBAL I1:Id : I2:Id; END_VAR => CreateStruct(Vd, I1, I2, .IdVals, .Map) ~> etogv(I1) ~> setogv(I1)...</k>
        <env> ... I2 |-> L ...</env>
        <store> ... L |-> Vd:VarDeclarations ...</store>
    rule <k>VAR_GLOBAL I1:Id : I2:Id := (Es:IdVals); END_VAR => CreateStruct(Vd, I1, I2, Es, .Map) ~> etogv(I1) ~> setogv(I1) ...</k>
        <env> ... I2 |-> L ...</env>
        <store> ... L |-> Vd:VarDeclarations ...</store>

    rule <k>VAR I1:Id : I2:Id; END_VAR => call(CreateStruct(Vd, I1, I2, .IdVals, .Map)) ...</k>
        <env> ... I2 |-> L ...</env>
        <store> ... L |-> Vd:VarDeclarations ...</store>
    rule <k>VAR I1:Id : I2:Id := (Es:IdVals); END_VAR => call(CreateStruct(Vd, I1, I2, Es, .Map)) ...</k>
        <env> ... I2 |-> L ...</env>
        <store> ... L |-> Vd:VarDeclarations ...</store>


    rule <k> call(CreateStruct(Vd:VarDeclarations, I1:Id, I2:Id, Es:IdVals, M:Map)) => StructInits(Vd,I1) ~> Set(I1,Es)  ...</k>
        <env> Env => Env[I1 <- L] </env>
        <store>... .Map => L |-> CreateStruct(Vd, I1, I2, Es, M) ...</store>
        <type>... .Map => L |-> I2 ...</type>
        <constant>... .Map => L |-> false ...</constant>
        <nextLoc> L => L +Int 1 </nextLoc> requires notBool (I1 in_keys (Env))

    rule <k> StructInits(I1:Id : T:ElementaryTypeName; Vd:VarDeclarations, I2:Id) => StructInits(Vd, I2) ...</k>
        <enummap> Enummap => Enummap[I1 <- L] </enummap>
        <env> Env => Env[I2.I1 <- L] </env>
        <store> ... .Map => L |-> Undefined(T) </store>
        <type> ... .Map => L |-> T </type>
        <constant>... .Map => L |-> false ...</constant>
        <nextLoc> L => L +Int 1 </nextLoc> requires notBool (I2.I1 in_keys (Env))

    rule <k> StructInits(I1:Id, Is:Ids : T:ElementaryTypeName; Vd:VarDeclarations, I2:Id) => StructInits(Is : T; Vd, I2) ...</k>
        <enummap> Enummap => Enummap[I1 <- L] </enummap>
        <env> Env => Env[I2.I1 <- L] </env>
        <store> ... .Map => L |-> Undefined(T) </store>
        <type> ... .Map => L |-> T </type>
        <constant>... .Map => L |-> false ...</constant>
        <nextLoc> L => L +Int 1 </nextLoc> requires notBool (I2.I1 in_keys (Env))

    rule <k> StructInits(I1:Id : I2:Id; Vd:VarDeclarations, I3:Id) => var I3.I1 : enum(KItem, Map); ~> StructInits(Vd, I3) ...</k>
        <env>... I2 |-> L ...</env>
        <store>... L |-> enum(KItem, Map) ...</store>

    rule <k> StructInits(I1:Id, Is:Ids : I2:Id; Vd:VarDeclarations, I3:Id) => var I3.I1 : enum(KItem, Map); ~> StructInits(Is : I2; Vd, I3) ...</k>
        <env>... I2 |-> L ...</env>
        <store>... L |-> enum(KItem, Map) ...</store>

    rule <k> var I1:Id . I3:Id : enum(I2:KItem, M:Map); => . ...</k>
        <enummap> Enummap => Enummap[I3 <- L] </enummap>
        <env> Env => Env[I1.I3 <- L] </env>
        <store> ... .Map => L |-> enum(I2, M) ...</store>
        <type> ... .Map => L |-> Enum </type>
        <constant>... .Map => L |-> false </constant>
        <nextLoc> L => L +Int 1 </nextLoc> requires notBool (I3.I1 in_keys (Env))

    rule StructInits(I1:Id : T:ArrayTypeName; Vd:VarDeclarations, I3:Id) => VAR $3 : T; END_VAR ~> Set(I3.I1, $3) ~> StructInits(Vd, I3) 
    rule StructInits(I1:Id, Is:Ids : T:ArrayTypeName; Vd:VarDeclarations, I3:Id) => VAR $3 : T; END_VAR ~> Set(I3.I1, $3) ~> StructInits(Is : T; Vd, I3) 

    rule <k> Set(I1:Id . I2:Id, I3:Id) => Set(I1 . I2, V) ~> ClearEnv (I3) ...</k>
        <env> ... I3 |-> L ...</env>
        <store>... L |-> V:Value </store>

    rule <k> Set(I1:Id . I2:Id, V:Value) =>. ...</k>
        <enummap> Enummap => Enummap[I2 <- L] </enummap>
        <env> Env => Env[I1.I2 <- L] </env>
        <store> ... .Map => L |-> V ...</store>
        <type> ... .Map => L |-> Enum </type>
        <constant>... .Map => L |-> false </constant>
        <nextLoc> L => L +Int 1 </nextLoc> requires notBool (I1.I2 in_keys (Env))

    rule StructInits(.Ids : _:TypeName; Vd:VarDeclarations, I:Id) => StructInits(Vd, I)

    rule <k> StructInits(I1:Id : T:ElementaryTypeName := V:Value; Vd:VarDeclarations, I2:Id) => StructInits(Vd:VarDeclarations, I2:Id) ...</k>
        <enummap> Enummap => Enummap[I1 <- L] </enummap>
        <env> Env => Env[I2.I1 <- L] </env>
        <store> ... .Map => L |-> V </store>
        <type> ... .Map => L |-> T </type>
        <constant>... .Map => L |-> false </constant>
        <nextLoc> L => L +Int 1 </nextLoc>

    rule <k> StructInits(I1:Id, Is:Ids : T:ElementaryTypeName := V:Value; Vd:VarDeclarations, I2:Id) => StructInits(Is : T := V; Vd:VarDeclarations, I2:Id) ...</k>
        <enummap> Enummap => Enummap[I1 <- L] </enummap>
        <env> Env => Env[I2.I1 <- L] </env>
        <store> ... .Map => L |-> V </store>
        <type> ... .Map => L |-> T </type>
        <constant>... .Map => L |-> false </constant>
        <nextLoc> L => L +Int 1 </nextLoc> requires Limit(V, T)

    rule StructInits(.Ids : _:TypeName := _ :Value; Vd:VarDeclarations, I:Id) => StructInits(Vd, I)

    rule StructInits(.VarDeclarations, I:Id) => upgrade(I) 

    rule <k> upgrade(I:Id) => . ...</k>
         <enummap> Enummap => .Map </enummap>
         <env>... I |-> L ...</env>
         <store>... L |-> (CreateStruct(Vds:VarDeclarations, I1:Id, I2:Id, Ids:IdVals, _:Map) => CreateStruct(Vds, I1, I2, Ids, Enummap)) ...</store>

    rule <k> Set(I1:Id, I2:Id := I3:Value, Es:IdVals) => Set(I1, Es) ...</k>
        <env> ...I1.I2 |-> L ...</env>
        <store>... L |-> (_ => I3) ...</store>
        <type>... L |-> T:TypeName ...</type> requires Limit(I3, T)

    rule Set(_:Id, .IdVals) => .

    rule <k> setogv(I:Id) => . ...</k>
         <env> Env => Env -Map M </env>
         <gvenv> Gvenv => Gvenv M </gvenv>
         <store>... {Gvenv[I]}:>Int |-> CreateStruct(_:VarDeclarations, _:Id, _:Id, _:IdVals, M:Map) ...</store> 

endmodule