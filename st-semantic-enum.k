require "st-syntax.k"
require "st-configuration.k"

module ST-SEMANTIC-ENUM

    imports ST-SYNTAX
    imports ST-CONFIGURATION

    rule TYPE X:Id : (Is:EnumBlock); END_TYPE => EnumFields(X, $1, Is)
    rule TYPE X:Id : (Is:EnumBlock) := X1:Id; END_TYPE => EnumFields(X, X1, Is)

    rule <k> EnumFields(X1:Id, X2:Id, X3:Id, Xs:Ids) => EnumFields(X1, X2, Xs) ...</k>
        <enummap> EnumMap => EnumMap[L1 <- X3] </enummap>
        <count> L1 => L1 +Int 1 </count>    requires notBool (X3 in values(EnumMap)) andBool X3 =/=K X1

    rule EnumFields(X1:Id, X2:Id, X3:Id := B1:Bits, Xs:IdVals) => EnumFields(X1, X2, X3 := Bits2Bit(B1), Xs)

    rule EnumFields(X1:Id, X2:Id, X3:Id := I1:Int # S1:String, Xs:IdVals) => EnumFields(X1, X2, X3 := String2Base(S1,I1), Xs) 

    rule <k> EnumFields(X1:Id, X2:Id, X3:Id := I1:Int, Xs:IdVals) => EnumFields(X1, X2, Xs) ...</k>
        <enummap> EnumMap => EnumMap[I1 <- X3] </enummap>    requires notBool (X3 in values(EnumMap)) andBool notBool (I1 in_keys (EnumMap)) andBool I1 >=Int 0 andBool I1 <Int 65535 andBool X3 =/=K X1

    rule EnumFields(X:Id, X2:Id, .IdVals) => EnumFields(X:Id, X2:Id, .Ids) 

    rule <k> EnumFields(X:Id, $1, .Ids) => . ...</k>
        <env> Env => Env[X <- L] </env>
        <gvenv> Gvenv </gvenv>
        <store>... .Map => L |-> enum(EnumMap[0], EnumMap[X <- 65536]) </store>
        <enummap> EnumMap => .Map </enummap>
        <count> _ => 0 </count>
        <type>... .Map => L |-> Enum </type>
        <constant>... .Map => L |-> false </constant>
        <nextLoc> L => L +Int 1 </nextLoc>        requires notBool (X in_keys (Env)) andBool (0 in_keys (EnumMap)) andBool (notBool (X in_keys (Gvenv)))

    rule <k> EnumFields(X:Id, X2:Id, .Ids) => . ...</k>
        <env> Env => Env[X <- L] </env>
        <gvenv> Gvenv </gvenv>
        <store>... .Map => L |-> enum(X2, EnumMap[X <- 65536]) </store>
        <enummap> EnumMap => .Map </enummap>
        <count> _ => 0 </count>
        <type>... .Map => L |-> Enum </type>
        <constant>... .Map => L |-> false </constant>
        <nextLoc> L => L +Int 1 </nextLoc>        requires notBool (X in_keys (Env)) andBool (X2 in values(EnumMap)) andBool (notBool (X in_keys (Gvenv)))


    rule <k> VAR_GLOBAL I1:Id : I2:Id; END_VAR => var I1 : enum(KItem, Map); ~> settype(I1, I2) ~> etogv(I1) ...</k>
        <env>... I2 |-> L ...</env>
        <store>... L |-> enum(KItem, Map) ...</store>
        <type>... L |-> Enum ...</type>

    rule <k> VAR_GLOBAL I1:Id : I2:Id := E:Expression; END_VAR => var I1 : enum(KItem, Map); ~> settype(I1, I2) ~> I1 := E; ~> etogv(I1) ...</k>
        <env>... I2 |-> L ...</env>
        <store>... L |-> enum(KItem, Map) ...</store>
        <type>... L |-> Enum ...</type>

    rule <k> VAR I1:Id : I2:Id := E:Expression; END_VAR => var I1 : enum(KItem, Map); ~> settype(I1, I2) ~> I1 := E; ...</k>
        <env>... I2 |-> L ...</env>
        <store>... L |-> enum(KItem, Map) ...</store>
        <type>... L |-> Enum ...</type>

    rule <k> VAR I1:Id : I2:Id; END_VAR => var I1 : enum(KItem, Map); ~> settype(I1, I2) ...</k>
        <env>... I2 |-> L ...</env>
        <store>... L |-> enum(KItem, Map) ...</store>
        <type>... L |-> Enum ...</type>

    rule <k> var I1:Id : enum(I2:KItem, M:Map); => . ...</k>
        <env> Env => Env[I1 <- L] </env>
        <gvenv> Gvenv </gvenv>
        <store> ... .Map => L |-> enum(I2, M) ...</store>
        <type> ... .Map => L |-> Enum </type>
        <constant>... .Map => L |-> false </constant>
        <nextLoc> L => L +Int 1 </nextLoc>      requires notBool (I1 in_keys (Env)) andBool (notBool (I1 in_keys (Gvenv)))

    rule <k> settype(I1:Id, I2:Id) => . ...</k>
         <env>... I1 |-> L ...</env>
         <type>... L |-> (Enum => I2) ...</type>

    rule enum(I1:Id, M1:Map) = enum(I2:Id, M2:Map) => true requires I1 ==K I2 andBool M1 ==K M2
    rule enum(I1:Id, M1:Map) = enum(I2:Id, M2:Map) => false requires I1 =/=K I2 andBool M1 ==K M2
    rule enum(I1:Id, M1:Map) <> enum(I2:Id, M2:Map) => true requires I1 =/=K I2 andBool M1 ==K M2
    rule enum(I1:Id, M1:Map) <> enum(I2:Id, M2:Map) => false requires I1 ==K I2 andBool M1 ==K M2

endmodule