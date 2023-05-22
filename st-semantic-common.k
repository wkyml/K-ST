require "st-syntax.k"
require "st-configuration.k"
require "st-semantic-num.k"
require "st-semantic-bool.k"
require "st-semantic-string.k"
require "st-semantic-if.k"
require "st-semantic-while.k"
require "st-semantic-for.k"
require "st-semantic-repeat.k"
require "st-semantic-bit.k"
require "st-semantic-time.k"
require "st-semantic-trans.k"
 
module ST-SEMANTIC-COMMON

    imports ST-SYNTAX
    imports ST-CONFIGURATION
    imports ST-SEMANTIC-NUM
    imports ST-SEMANTIC-BOOL
    imports ST-SEMANTIC-STRING
    imports ST-SEMANTIC-IF
    imports ST-SEMANTIC-WHILE
    imports ST-SEMANTIC-REPEAT
    imports ST-SEMANTIC-BIT
    imports ST-SEMANTIC-TIME
    imports ST-SEMANTIC-TRANS

    rule VAR_GLOBAL CONSTANT I1:Id, Is:Ids : T:ElementaryTypeName; Vdls:VarDeclarations END_VAR => VAR_GLOBAL I1 : T; END_VAR ~> gsetconstant(I1) ~> VAR_GLOBAL CONSTANT Is : T; Vdls END_VAR
    rule VAR_GLOBAL CONSTANT I1:Id, Is:Ids : T:Id; Vdls:VarDeclarations END_VAR => VAR_GLOBAL I1 : T; END_VAR ~> gsetconstant(I1) ~> VAR_GLOBAL CONSTANT Is : T; Vdls END_VAR
    rule VAR_GLOBAL CONSTANT I1:Id, Is:Ids : T:TypeName := E:Expression; Vdls:VarDeclarations END_VAR => VAR_GLOBAL I1 : T := E; END_VAR ~> gsetconstant(I1) ~> VAR_GLOBAL CONSTANT Is : T; Vdls END_VAR
    rule VAR_GLOBAL CONSTANT .Ids : _:TypeName; Vdls:VarDeclarations END_VAR => VAR_GLOBAL CONSTANT Vdls END_VAR
    rule VAR_GLOBAL CONSTANT .Ids : _:TypeName := _:Expression; Vdls:VarDeclarations END_VAR => VAR_GLOBAL CONSTANT Vdls END_VAR
    rule VAR_GLOBAL CONSTANT .VarDeclarations END_VAR => .

    rule VAR CONSTANT I1:Id, Is:Ids : T:ElementaryTypeName; Vdls:VarDeclarations END_VAR => VAR I1 : T; END_VAR ~> setconstant(I1) ~> VAR CONSTANT Is : T; Vdls END_VAR
    rule VAR CONSTANT I1:Id, Is:Ids : T:Id; Vdls:VarDeclarations END_VAR => VAR I1 : T; END_VAR ~> setconstant(I1) ~> VAR CONSTANT Is : T; Vdls END_VAR
    rule VAR CONSTANT I1:Id, Is:Ids : T:TypeName := E:Expression; Vdls:VarDeclarations END_VAR => VAR I1 : T := E; END_VAR ~> setconstant(I1) ~> VAR CONSTANT Is : T; Vdls END_VAR
    rule VAR CONSTANT .Ids : _:TypeName; Vdls:VarDeclarations END_VAR => VAR CONSTANT Vdls END_VAR
    rule VAR CONSTANT .Ids : _:TypeName := _:Expression; Vdls:VarDeclarations END_VAR => VAR CONSTANT Vdls END_VAR
    rule VAR CONSTANT .VarDeclarations END_VAR => .

    
    rule VAR Vd1:VarDeclaration Vd2:VarDeclaration Vds:VarDeclarations END_VAR  => VAR Vd1 END_VAR ~> VAR Vd2 Vds END_VAR  [structural]
    rule VAR_GLOBAL Vd1:VarDeclaration Vd2:VarDeclaration Vds:VarDeclarations END_VAR  => VAR_GLOBAL Vd1 END_VAR ~> VAR_GLOBAL Vd2 Vds END_VAR  [structural]

    rule VAR I1:Id, I2:Id, Is:Ids : T:TypeName; END_VAR =>  VAR I1 : T; END_VAR ~> VAR I2, Is : T; END_VAR
    rule VAR I1:Id, I2:Id, Is:Ids : T:TypeName := E:Expression; END_VAR => VAR I1 : T := E; END_VAR ~> VAR I2, Is : T := E; END_VAR
    rule VAR I1:Id : T:ElementaryTypeName := E:Expression; END_VAR => VAR I1 : T; END_VAR ~> I1 := E;
    rule <k> VAR I1:Id : I2:Id := getVal(I3:Id); END_VAR => VAR I1 : I2; END_VAR ~> I1 := getVal(I3); ...</k>
         <env>... I2 |-> L ...</env>
         <store>... L |-> _:VarDeclarations ...</store>
    rule VAR .VarDeclarations END_VAR => .
    rule VAR I1:Id AT %IX _:Float : T:ElementaryTypeName; END_VAR => VAR I1 : T; END_VAR ~> I1 := read(T);
    rule VAR I1:Id AT %IX _:Float : T:ElementaryTypeName := E:Expression; END_VAR => VAR I1 : T; END_VAR ~> I1 := read(T); ~> I1 := E;
    rule <k> VAR I1:Id AT %QX _:Float : T:ElementaryTypeName; END_VAR => VAR I1 : T; END_VAR ...</k>
         <print> Is:AllExps => I1,Is </print>
    rule <k> VAR I1:Id AT %QX _:Float : T:ElementaryTypeName := E:Expression; END_VAR => VAR I1 : T; END_VAR ~> I1 := E; ...</k>
         <print> Is:AllExps => I1,Is </print>


    rule VAR_GLOBAL I1:Id, I2:Id, Is:Ids : T:TypeName; END_VAR =>  VAR_GLOBAL I1 : T; END_VAR ~> VAR_GLOBAL I2, Is : T; END_VAR
    rule VAR_GLOBAL I1:Id, I2:Id, Is:Ids : T:TypeName := E:Expression; END_VAR => VAR_GLOBAL I1 : T := E; END_VAR ~> VAR_GLOBAL I2, Is : T := E; END_VAR
    rule VAR_GLOBAL I1:Id : T:ElementaryTypeName := E:Expression; END_VAR => VAR I1 : T; END_VAR ~> I1 := E; ~> etogv(I1)
    rule VAR_GLOBAL I1:Id AT %IX I2:Float : T:ElementaryTypeName; END_VAR => VAR I1 AT %IX I2 : T; END_VAR ~> etogv(I1)
    rule VAR_GLOBAL I1:Id AT %IX I2:Float : T:ElementaryTypeName := E:Expression; END_VAR => VAR I1 AT %IX I2 : T := E; END_VAR ~> etogv(I1)
    rule VAR_GLOBAL I1:Id AT %QX I2:Float : T:ElementaryTypeName; END_VAR => VAR I1 AT %QX I2 : T; END_VAR ~> etogv(I1)
    rule VAR_GLOBAL I1:Id AT %QX I2:Float : T:ElementaryTypeName := E:Expression; END_VAR => VAR I1 AT %QX I2 : T := E; END_VAR ~> etogv(I1)

    rule VAR_GLOBAL I1:Id : T:ElementaryTypeName; END_VAR => VAR I1 : T; END_VAR ~> etogv(I1)

    //本地普通变量声明
    rule <k> VAR I1:Id : T:ElementaryTypeName; END_VAR => . ...</k>
        <env> Env => Env[I1 <- L] </env>
        <gvenv> Gvenv </gvenv>
        <store> ... .Map => L |-> Undefined(T) ...</store>
        <type> ... .Map => L |-> T ...</type>
        <constant>... .Map => L |-> false ...</constant>
        <nextLoc> L => L +Int 1 </nextLoc>     requires (notBool (I1 in_keys (Env))) andBool (notBool (I1 in_keys (Gvenv)))

     rule <k> etogv(I:Id) => . ...</k>
          <gvid> Is:Ids => I,Is </gvid>

    rule <k> letogv(I:Id, Is:Ids) => ClearEnv(I) ~> letogv(Is) ...</k>
         <env>... I |-> L ...</env>
         <gvenv> Gvenv => Gvenv[I <- L] </gvenv> 

    rule <k> setconstant(I:Id) => . ...</k>
         <env>... I |-> L ...</env>
         <constant>... L |-> (_ => true) ...</constant>

    rule <k> gsetconstant(I:Id) => . ...</k>
         <gvenv>... I |-> L ...</gvenv>
         <constant>... L |-> (_ => true) ...</constant>
    
    

    rule Undefined(_:SolidityInt) => 0                                 [structural,anywhere]
    rule Undefined(_:SolidityUint) => 0                                [structural,anywhere]
    rule Undefined(_:FloatType) => 0.0                                 [structural,anywhere]
    rule Undefined(BOOL) => false                                       [structural,anywhere]
    rule Undefined(TIME) => T# 0 d 0 h 0 m 0 s 0 ms                    [structural,anywhere]
    rule Undefined(DATE) => D# 0 - 0 - 0                               [structural,anywhere]
    rule Undefined(TIME_OF_DAY) => TOD# 0 : 0 : 0 . 0                  [structural,anywhere]
    rule Undefined(DATE_AND_TIME) => DT# 0 - 0 - 0 - 0 : 0 : 0         [structural,anywhere]
    rule Undefined(STRING) => ""                                       [structural,anywhere]
    rule Undefined(WSTRING) => ""                                      [structural,anywhere]
    rule Undefined(STRING[I:Int]) => ""  requires I <=Int 254 andBool I >=Int 0   [structural,anywhere]
    rule Undefined(WSTRING[I:Int]) => ""  requires I <=Int 254 andBool I >=Int 0  [structural,anywhere]
    rule Undefined(BYTE) => 2 # FormalBit(2 # "0", 8)                  [structural,anywhere]
    rule Undefined(WORD) => 2 # FormalBit(2 # "0", 16)                 [structural,anywhere]
    rule Undefined(DWORD) => 2 # FormalBit(2 # "0", 32)                [structural,anywhere]
    rule Undefined(LWORD) => 2 # FormalBit(2 # "0", 64)                [structural,anywhere]


    rule Limit(I:Int, INT) => true requires I >=Int -32768 andBool I <=Int 32767 [structural,anywhere]
    rule Limit(I:Int, INT) => false requires notBool (I >=Int -32768 andBool I <=Int 32767) [structural,anywhere]
    rule Limit(I:Int, SINT) => true requires I >=Int -128 andBool I <=Int 127 [structural,anywhere]
    rule Limit(I:Int, SINT) => false requires notBool (I >=Int -128 andBool I <=Int 127) [structural,anywhere]
    rule Limit(I:Int, DINT) => true requires I >=Int -2147483648 andBool I <=Int 2147483647 [structural,anywhere]
    rule Limit(I:Int, DINT) => false requires notBool (I >=Int -2147483648 andBool I <=Int 2147483647) [structural,anywhere]
    rule Limit(I:Int, LINT) => true requires I >=Int -2 ^Int 63 andBool I <=Int 2 ^Int 63 -Int 1 [structural,anywhere]
    rule Limit(I:Int, LINT) => false requires notBool (I >=Int -2 ^Int 63 andBool I <=Int 2 ^Int 63 -Int 1) [structural,anywhere]
    rule Limit(I:Int, UINT) => true requires I >=Int 0 andBool I <=Int 65535 [structural,anywhere]
    rule Limit(I:Int, USINT) => true requires I >=Int 0 andBool I <=Int 255 [structural,anywhere]
    rule Limit(I:Int, UDINT) => true requires I >=Int 0 andBool I <=Int 4294967295 [structural,anywhere]
    rule Limit(I:Int, ULINT) => true requires I >=Int 0 andBool I <=Int 2 ^Int 64 -Int 1 [structural,anywhere]
    rule Limit(F:Float, REAL) => true requires (-3.402823 *Float 10.0 ^Float 38.0 <=Float F) andBool(F <=Float 3.402823 *Float 10.0 ^Float 38.0) [structural,anywhere]
    rule Limit(F:Float, LREAL) => true requires (-1.7976931348623157 *Float 10.0 ^Float 308.0 <=Float F) andBool(F <=Float 1.7976931348623157 *Float 10.0 ^Float 308.0) [structural,anywhere]
    rule Limit(_:Bool, BOOL) => true                                  [structural,anywhere]
    rule Limit(S:String, STRING) => true requires lengthString(S) <=Int 254 [structural,anywhere]
    rule Limit(S:String, WSTRING) => true requires lengthString(S) <=Int 254 [structural,anywhere]
    rule Limit(S:String, STRING[I:Int]) => true requires lengthString(S) <=Int I  [structural,anywhere]
    rule Limit(S:String, WSTRING[I:Int]) => true requires lengthString(S) <=Int I [structural,anywhere]
    rule Limit(_:Time, TIME) => true                                  [structural,anywhere]
    rule Limit(_:TimeOfDate, TIME_OF_DAY) => true                     [structural,anywhere]
    rule Limit(_:Date, DATE) => true                                  [structural,anywhere]
    rule Limit(_:DateAndTime, DATE_AND_TIME) => true                  [structural,anywhere]
    rule LimitP(_:Int, _:SolidityInt) => true                         [structural,anywhere]
    rule cut(I:Int, INT) => signExtendBitRangeInt(I, 0, 16)           [structural,anywhere]
    rule cut(I:Int, SINT) => signExtendBitRangeInt(I, 0, 8)           [structural,anywhere]
    rule cut(I:Int, DINT) => signExtendBitRangeInt(I, 0, 32)          [structural,anywhere]
    rule cut(I:Int, LINT) => signExtendBitRangeInt(I, 0, 64)          [structural,anywhere]
 


    rule <k> X:Id => V ...</k>
        <env>... X |-> L ...</env>
        <store>... L |-> V:Value ...</store>      [lookup]
    rule <k> X1:Id . X2:Id => V ...</k>
        <env>... X1.X2 |-> L ...</env>
        <store>... L |-> V:Value ...</store>      [lookup]
    rule <k> X1:Id . X2:Id => Search(X1 . X2) ...</k>
         <env> Env </env> requires notBool (X1.X2 in_keys (Env)) [lookup]

    rule <k> Search(X1:Id . X2:Id) => V . X2 ...</k> 
         <env>... X1 |-> L ...</env>
         <store>... L |-> V:Value ...</store> 
    rule enum(_:KItem, M:Map) . X2:Id => enum(X2, M) requires X2 in values(M)    [lookup]
    rule <k> plambda(_:Id, void, _:VarDefinitions, _:StatementLists, M:Map) . X2:Id => V ...</k>
         <store>... {M[X2]}:>Int |-> V:Value ...</store>                                 [lookup]
    rule <k> ufblambda(_:Id, void, _:VarDefinitions, _:StatementLists, M:Map) . X2:Id => V ...</k>
         <store>... {M[X2]}:>Int |-> V:Value ...</store>                                 [lookup]
    rule <k> CreateStruct(_:VarDeclarations, _:Id, _:Id, _:IdVals, M:Map) . X2:Id => V ...</k>
         <store>... {M[X2]}:>Int |-> V:Value ...</store>                                 [lookup]

    
    
    rule getVal(V:Value) => V
    rule <k> getVal(X:Id) => V ...</k>
        <allenv>... X |-> L ...</allenv>
        <store>... L |-> V:Value ...</store>      [lookup]
    rule <k> getVal(X1:Id . X2:Id) => enum(X2, M) ...</k>
        <allenv>... X1 |-> L ...</allenv>
        <store>... L |-> enum(_:KItem, M:Map) ...</store> requires X2 in values(M)    [lookup]
    rule <k> getVal(X1:Id . X2:Id) => V  ...</k>
        <allenv>... X1 |-> L ...</allenv>
        <store>... L |-> CreateStruct(_:VarDeclarations, _:Id, _:Id, _:IdVals, M:Map) 
                   {M[X2]}:>Int |-> V:Value  ...</store> //requires X1 =/=K I1 
    rule <k> getVal(X1:Id . X2:Id) => V  ...</k>
        <allenv>... X1 |-> L ...</allenv>
        <store>... L |-> ufblambda(_, _, _, _, M:Map) 
                   {M[X2]}:>Int |-> V:Value  ...</store>  

    

    context (HOLE => lvalue(HOLE)) := _
    
    rule <k> loc(L) := V:Value => V ...</k> 
        <store>... L |-> (_ => V) ...</store>  
        <type> Type </type>   
        <constant> Constant </constant> requires (notBool (L in_keys (Type))) orBool (notBool (L in_keys (Constant))) [structural,assignment]

     rule <k> loc(L) := V:ElementaryValue => V ...</k> 
        <store>... L |-> (_ => V) ...</store>  
        <type>... L |-> T:TypeName ...</type>
        <constant>... L |-> false ...</constant> requires T =/=K BYTE andBool T =/=K BOOL andBool T =/=K WORD andBool T =/=K DWORD andBool T =/=K LWORD andBool Limit(V,T) [structural,assignment]

     rule <k> loc(L) := V:ElementaryValue => print("WARNING: Variable " +String Id2String(X) +String " overflow \n") ~> loc(L) := cut(V, T) ...</k> 
        <env>... X |-> L ...</env>
        <store>... L |-> (_ => V) ...</store>  
        <type>... L |-> T:TypeName ...</type>
        <constant>... L |-> false ...</constant> requires T =/=K BYTE andBool T =/=K BOOL andBool T =/=K WORD andBool T =/=K DWORD andBool T =/=K LWORD andBool (notBool Limit(V,T)) andBool LimitP(V,T) [structural,assignment]

    rule <k> loc(L) := V:Bool => V ...</k> 
        <store>... L |-> (_ => V) ...</store>  
        <type>... L |-> BOOL ...</type>
        <constant>... L |-> false ...</constant> [structural,assignment]

   rule <k> loc(L) := 0 => false ...</k> 
        <store>... L |-> (_ => false) ...</store>  
        <type>... L |-> BOOL ...</type>
        <constant>... L |-> false ...</constant> [structural,assignment]

   rule <k> loc(L) := 1 => true ...</k> 
        <store>... L |-> (_ => true) ...</store>  
        <type>... L |-> BOOL ...</type>
        <constant>... L |-> false ...</constant> [structural,assignment]

    rule <k> loc(L) := V:Bit => V ...</k> 
        <store>... L |-> (_ => 2 # FormalBit(V, BitLeng(T))) ...</store>  
        <type>... L |-> T:BitType ...</type>    
        <constant>... L |-> false ...</constant> [structural,assignment]

    rule <k> loc(L) := V:Int => V ...</k> 
        <store>... L |-> (_ => 2 # FormalBit(Int2Bit(V), BitLeng(T))) ...</store>  
        <type>... L |-> T:BitType ...</type>    
        <constant>... L |-> false ...</constant> [structural,assignment]

    rule <k> loc(L) := array(T:ElementaryTypeName, I1:Int, I2:Int, I3:Int) => array(T, I1, I2, I3) ...</k>
         <store> ... L |-> (_ => array(T, I1, I2, I3)) ...</store>
         <type>... L |-> T1:ElementaryTypeName ...</type> 
         <constant>... L |-> false ...</constant> requires T ==K T1  [structural,assignment]

    rule <k> loc(L) := enum(T:KItem, M:Map) => enum(T, M) ...</k>
        <store>... L |-> (enum(_:KItem, M1:Map) => enum(T, M)) ...</store>  
        <constant>... L |-> false ...</constant> requires M ==K M1  [structural,assignment]

    rule <k> loc(L) := CreateStruct(A, B, I1:Id, C, M1:Map) => TRUE ...</k>
         <store>... L |-> (CreateStruct(_, _, I2:Id, _, M2:Map) => CreateStruct(A, B, I1, C, M1)) ...</store>
         <constant>... L |-> false ...</constant> requires I1 ==K I2 [structural,assignment]

//    rule <k> Set(M1:Map, M2:Map) => Set(M1[keys_list(M1)[0] <- undef], M2[keys_list(M1)[0] <- undef]) ...</k>
//         <store>... {M1[keys_list(M1)[0]]}:>Int |-> (_ => V)
//                    {M2[keys_list(M1)[0]]}:>Int |-> V:Value ...</store> requires M1 =/=K .Map andBool M2 =/=K .Map

//    rule Set(.Map, .Map) => TRUE

    
    rule _:Value; => .
    rule <k> lookup(L) => V ...</k> <store>... L |-> V:Value ...</store>  [lookup]
    rule <k> lvalue(X:Id => loc(L)) ...</k> <env>... X |-> L:Int ...</env>   [structural]
    rule <k> lvalue(X1:Id . X2:Id => loc(L)) ...</k> <env>... X1.X2 |-> L:Int ...</env>   [structural]
    rule <k> lvalue(X1:Id . X2:Id => loc({M[X2]}:>Int)) ...</k> 
         <env> Env </env>   
         <store>... {Env[X1]}:>Int |-> CreateStruct(_:VarDeclarations, _:Id, _:Id, _:IdVals, M:Map) ...</store>  requires notBool X1.X2 in_keys (Env) [structural]
    context lvalue(_::Expression[HOLE::Expression, _::Expressions])
    context lvalue(HOLE::Expression[_::Expressions])
    rule lvalue(lookup(L:Int) => loc(L))  [structural]


    rule <k> ClearEnv (I:Id) => . ...</k>
        <env> Env => Env[ I <- undef] </env>

    rule <k> settype(I:Id, I2:ArrayTypeName) => . ...</k>
         <env>... I |-> L ...</env>
         <type>... L |-> (_ => I2) ...</type>

    rule <k> read(_:SolidityInt) => I ...</k>
         <input> ListItem(I:Int) => .List ...</input>    [read]
    rule <k> read(_:SolidityUint) => I ...</k>
         <input> ListItem(I:Int) => .List ...</input>    [read]
    rule <k> read(_:FloatType) => String2Float(substrString(I,0,lengthString(I) -Int 1)) ...</k>
         <input> ListItem(I:String) => .List ...</input>    [read]
    rule <k> read(BOOL) => STRING_TO_BOOL(substrString(I,0,lengthString(I) -Int 1)) ...</k>
         <input> ListItem(I:String) => .List ...</input>    [read]
    rule <k> read(BOOL) => STRING_TO_BOOL(substrString(I,0,lengthString(I) -Int 1)) ...</k>
         <input> ListItem(I:String) => .List ...</input>    [read]
    rule <k> read(_:StringType) => substrString(I,0,lengthString(I) -Int 1) ...</k>
         <input> ListItem(I:String) => .List ...</input>    [read] 
    rule <k> read(BYTE) => STRING_TO_BYTE(substrString(I,0,lengthString(I) -Int 1)) ...</k>
         <input> ListItem(I:String) => .List ...</input>    [read]
    rule <k> read(WORD) => STRING_TO_WORD(substrString(I,0,lengthString(I) -Int 1)) ...</k>
         <input> ListItem(I:String) => .List ...</input>    [read]
    rule <k> read(DWORD) => STRING_TO_DWORD(substrString(I,0,lengthString(I) -Int 1)) ...</k>
         <input> ListItem(I:String) => .List ...</input>    [read]
    rule <k> read(LWORD) => STRING_TO_LWORD(substrString(I,0,lengthString(I) -Int 1)) ...</k>
         <input> ListItem(I:String) => .List ...</input>    [read]
    rule <k> read(DATE) => STRING_TO_DATE(substrString(I,0,lengthString(I) -Int 1)) ...</k>
         <input> ListItem(I:String) => .List ...</input>    [read]
    rule <k> read(TIME) => STRING_TO_TIME(substrString(I,0,lengthString(I) -Int 1)) ...</k>
         <input> ListItem(I:String) => .List ...</input>    [read]
    rule <k> read(TIME_OF_DAY) => STRING_TO_TOD(substrString(I,0,lengthString(I) -Int 1)) ...</k>
         <input> ListItem(I:String) => .List ...</input>    [read]
    rule <k> read(DATE_AND_TIME) => STRING_TO_DT(substrString(I,0,lengthString(I) -Int 1)) ...</k>
         <input> ListItem(I:String) => .List ...</input>    [read]

    rule <k> print(I:Id, Is:AllExps) => print(Id2String(I) +String ":=" +String Int2String(V) +String "\n") ~> print(Is) ...</k>
         <env>... I |-> L ...</env>
         <store>... L |-> V:Int ...</store>
    rule <k> print(I:Id, Is:AllExps) => print(Id2String(I) +String ":=" +String Float2String(V) +String "\n") ~> print(Is) ...</k>
         <env>... I |-> L ...</env>
         <store>... L |-> V:Float ...</store>
    rule <k> print(I:Id, Is:AllExps) => print(Id2String(I) +String ":=" +String V +String "\n") ~> print(Is) ...</k>
         <env>... I |-> L ...</env>
         <store>... L |-> V:String ...</store>
    rule <k> print(I:Id, Is:AllExps) => print(Id2String(I) +String ":=" +String "TRUE" +String "\n") ~> print(Is) ...</k>
         <env>... I |-> L ...</env>
         <store>... L |-> true ...</store>
    rule <k> print(I:Id, Is:AllExps) => print(Id2String(I) +String ":=" +String "FALSE" +String "\n") ~> print(Is) ...</k>
         <env>... I |-> L ...</env>
         <store>... L |-> false ...</store>
    rule <k> print(I:Id, Is:AllExps) => print(Id2String(I) +String ":=" +String Int2String(I1) +String "#" +String S1 +String "\n") ~> print(Is) ...</k>
         <env>... I |-> L ...</env>
         <store>... L |-> I1:Int # S1:String ...</store>
    rule <k> print(I:Id, Is:AllExps) => print(Id2String(I) +String ":=" +String "T#" +String Int2String(I1) +String "d" +String Int2String(I2) +String "h" +String Int2String(I3) +String "m" +String Int2String(I4) +String "s" +String Int2String(I5) +String "ms" +String "\n") ~> print(Is) ...</k>
         <env>... I |-> L ...</env>
         <store>... L |-> T# I1:Int d I2:Int h I3:Int m I4:Int s I5:Int ms ...</store>
    rule <k> print(I:Id, Is:AllExps) => print(Id2String(I) +String ":=" +String "TOD#" +String Int2String(I1) +String ":" +String Int2String(I2) +String ":" +String Int2String(I3) +String "." +String Int2String(I4) +String "\n") ~> print(Is) ...</k>
         <env>... I |-> L ...</env>
         <store>... L |-> TOD# I1:Int : I2:Int : I3:Int . I4:Int ...</store>
    rule <k> print(I:Id, Is:AllExps) => print(Id2String(I) +String ":=" +String "D#" +String Int2String(I1) +String "-" +String Int2String(I2) +String "-" +String Int2String(I3) +String "\n") ~> print(Is) ...</k>
         <env>... I |-> L ...</env>
         <store>... L |-> D# I1:Int - I2:Int - I3:Int ...</store>
    rule <k> print(I:Id, Is:AllExps) => print(Id2String(I) +String ":=" +String "DT#" +String Int2String(I1) +String "-" +String Int2String(I2) +String "-" +String Int2String(I3) +String "-" +String Int2String(I4) +String ":" +String Int2String(I5) +String ":" +String Int2String(I6) +String "\n") ~> print(Is) ...</k>
         <env>... I |-> L ...</env>
         <store>... L |-> DT# I1:Int - I2:Int - I3:Int - I4:Int : I5:Int : I6:Int ...</store>
    rule <k> print(S:String) => . ...</k>
         <output>... .List => ListItem(S) </output>
    rule print(.AllExps) => .      [structural]

    rule <k> recordcover(I:Id); => . ...</k>
         <cover> Cover => Cover[I <- 1] </cover> requires notBool I in_keys (Cover)
    
    rule <k> recordcover(I:Id); => . ...</k>
         <cover>... I |-> (I1:Int => I1 +Int 1) ...</cover> 

endmodule
