require "st-syntax.k"
require "st-configuration.k"

module ST-SEMANTIC-CASE 

    imports ST-SYNTAX
    imports ST-CONFIGURATION

    rule <k> CASE I1:Value OF I2:Id . I4:Id, I3:CaseInts : S1:StatementLists END_CASE; => CASE I1 OF enum(I4, M), I3 : S1 END_CASE; ...</k>
        <env>... I2 |-> L ...</env>
        <store>... L |-> enum(_, M:Map) ...</store>
    rule <k> CASE I1:Value OF I2:Id . I4:Id, I3:CaseInts : S1:StatementLists ELSE S2:StatementLists END_CASE; => CASE I1 OF enum(I4, M), I3 : S1 ELSE S2 END_CASE; ...</k>
        <env>... I2 |-> L ...</env>
        <store>... L |-> enum(_, M:Map) ...</store>
    rule <k> CASE I1:Value OF I2:Id . I4:Id, I3:CaseInts : S1:StatementLists  CB:CaseBlock END_CASE; => CASE I1 OF enum(I4, M), I3 : S1 CB END_CASE; ...</k>
        <env>... I2 |-> L ...</env>
        <store>... L |-> enum(_, M:Map) ...</store>
    rule <k> CASE I1:Value OF I2:Id . I4:Id, I3:CaseInts : S1:StatementLists  CB:CaseBlock ELSE S2:StatementLists END_CASE; => CASE I1 OF enum(I4, M), I3 : S1  CB ELSE S2 END_CASE; ...</k>
        <env>... I2 |-> L ...</env>
        <store>... L |-> enum(_, M:Map) ...</store>

    rule <k> CASE I1:Value OF I2:Id . I5:Id, I3:CaseInts : S1:StatementLists END_CASE; => CASE I1 OF I4, I3 : S1 END_CASE; ...</k>
        <env>... I2 |-> L ...</env>
        <store>... L |-> CreateStruct(_:VarDeclarations, _:Id, _:Id, _:IdVals, M:Map) 
                   {M[I5]}:>Int |-> I4:Value ...</store>
    rule <k> CASE I1:Value OF I2:Id . I5:Id, I3:CaseInts : S1:StatementLists ELSE S2:StatementLists END_CASE; => CASE I1 OF I4, I3 : S1 ELSE S2 END_CASE; ...</k>
        <env>... I2 |-> L ...</env>
        <store>... L |-> CreateStruct(_:VarDeclarations, _:Id, _:Id, _:IdVals, M:Map) 
                   {M[I5]}:>Int |-> I4:Value ...</store>
    rule <k> CASE I1:Value OF I2:Id . I5:Id, I3:CaseInts : S1:StatementLists  CB:CaseBlock END_CASE; => CASE I1 OF I4, I3 : S1 CB END_CASE; ...</k>
        <env>... I2 |-> L ...</env>
        <store>... L |-> CreateStruct(_:VarDeclarations, _:Id, _:Id, _:IdVals, M:Map) 
                   {M[I5]}:>Int |-> I4:Value ...</store>
    rule <k> CASE I1:Value OF I2:Id . I5:Id, I3:CaseInts : S1:StatementLists  CB:CaseBlock ELSE S2:StatementLists END_CASE; => CASE I1 OF I4, I3 : S1  CB ELSE S2 END_CASE; ...</k>
        <env>... I2 |-> L ...</env>
        <store>... L |-> CreateStruct(_:VarDeclarations, _:Id, _:Id, _:IdVals, M:Map) 
                   {M[I5]}:>Int |-> I4:Value ...</store>

    rule <k> CASE I1:Value OF I2:Id, I3:CaseInts : S1:StatementLists END_CASE; => CASE I1 OF I4, I3 : S1 END_CASE; ...</k>
        <env>... I2 |-> L ...</env>
        <store>... L |-> I4:Value ...</store>
    rule <k> CASE I1:Value OF I2:Id, I3:CaseInts : S1:StatementLists ELSE S2:StatementLists END_CASE; => CASE I1 OF I4, I3 : S1 ELSE S2 END_CASE; ...</k>
        <env>... I2 |-> L ...</env>
        <store>... L |-> I4:Value ...</store>
    rule <k> CASE I1:Value OF I2:Id, I3:CaseInts : S1:StatementLists  CB:CaseBlock END_CASE; => CASE I1 OF I4, I3 : S1 CB END_CASE; ...</k>
        <env>... I2 |-> L ...</env>
        <store>... L |-> I4:Value ...</store>
    rule <k> CASE I1:Value OF I2:Id, I3:CaseInts : S1:StatementLists  CB:CaseBlock ELSE S2:StatementLists END_CASE; => CASE I1 OF I4, I3 : S1  CB ELSE S2 END_CASE; ...</k>
        <env>... I2 |-> L ...</env>
        <store>... L |-> I4:Value ...</store>

    rule CASE I1:Value OF I2:Value, _:CaseInts : S:StatementLists END_CASE; => {S} requires I1 ==K I2
    rule CASE I1:Value OF I2:Value, I3:CaseInts : S:StatementLists END_CASE; => CASE I1 OF I3 : S END_CASE; requires I1 =/=K I2
    rule CASE I1:Value OF I2:Value, _:CaseInts : S:StatementLists ELSE _:StatementLists END_CASE; => {S} requires I1 ==K I2
    rule CASE I1:Value OF I2:Value, I3:CaseInts : S1:StatementLists ELSE S2:StatementLists END_CASE; => CASE I1 OF I3 : S1 ELSE S2 END_CASE; requires I1 =/=K I2
    rule CASE I1:Value OF I2:Value, _:CaseInts : S:StatementLists _:CaseBlock END_CASE; => {S} requires I1 ==K I2
    rule CASE I1:Value OF I2:Value, I3:CaseInts : S:StatementLists CB:CaseBlock END_CASE; => CASE I1 OF I3 : S CB END_CASE; requires I1 =/=K I2
    rule CASE I1:Value OF I2:Value, _:CaseInts : S:StatementLists _:CaseBlock ELSE _:StatementLists END_CASE; => {S} requires I1 ==K I2 
    rule CASE I1:Value OF I2:Value, I3:CaseInts : S1:StatementLists CB:CaseBlock ELSE S2:StatementLists END_CASE; => CASE I1 OF I3 : S1 CB ELSE S2 END_CASE; requires I1 =/=K I2

    rule CASE I1:Int OF I2:Int .. I3:Int, _:CaseInts : S:StatementLists END_CASE; => {S} requires (I1 >=Int I2 andBool I1<=Int I3)
    rule CASE I1:Int OF I2:Int .. I3:Int, I4:CaseInts : S:StatementLists END_CASE; => CASE I1 OF I4 : S END_CASE; requires notBool (I1 >=Int I2 andBool I1<=Int I3)
    rule CASE I1:Int OF I2:Int .. I3:Int, _:CaseInts : S:StatementLists ELSE _:StatementLists END_CASE; => {S} requires (I1 >=Int I2 andBool I1<=Int I3)
    rule CASE I1:Int OF I2:Int .. I3:Int, I4:CaseInts : S1:StatementLists ELSE S2:StatementLists END_CASE; => CASE I1 OF I4 : S1 ELSE S2 END_CASE; requires notBool (I1 >=Int I2 andBool I1<=Int I3)
    rule CASE I1:Int OF I2:Int .. I3:Int, _:CaseInts : S:StatementLists _:CaseBlock END_CASE; => {S} requires (I1 >=Int I2 andBool I1<=Int I3)
    rule CASE I1:Int OF I2:Int .. I3:Int, I4:CaseInts : S:StatementLists CB:CaseBlock END_CASE; => CASE I1 OF I4 : S CB END_CASE; requires notBool (I1 >=Int I2 andBool I1<=Int I3)
    rule CASE I1:Int OF I2:Int .. I3:Int, _:CaseInts : S:StatementLists _:CaseBlock ELSE _:StatementLists END_CASE; => {S} requires (I1 >=Int I2 andBool I1<=Int I3)
    rule CASE I1:Int OF I2:Int .. I3:Int, I4:CaseInts : S1:StatementLists CB:CaseBlock ELSE S2:StatementLists END_CASE; => CASE I1 OF I4 : S1 CB ELSE S2 END_CASE; requires notBool (I1 >=Int I2 andBool I1<=Int I3)

    rule CASE _:Int OF .CaseInts : _:StatementLists END_CASE; => .
    rule CASE _:Int OF .CaseInts : _:StatementLists ELSE S:StatementLists END_CASE; => {S} 
    rule CASE I1:Int OF .CaseInts : _:StatementLists CB:CaseBlock END_CASE; => CASE I1 OF CB END_CASE;
    rule CASE I1:Int OF .CaseInts : _:StatementLists CB:CaseBlock ELSE S:StatementLists END_CASE; => CASE I1 OF CB ELSE S END_CASE;

endmodule