require "bit-external.k"
require "time-external.k"

module ST-SYNTAX 

    imports DOMAINS

    imports BIT-EXTERNAL
    imports TIME-EXTERNAL

    syntax ControlCell
    syntax ControlCellFragment
    syntax Id ::= "MAIN"     [token]
    syntax Id ::= "$1" | "$2" | "$3"
    syntax Bool ::= "TRUE"       [token]
    syntax Bool ::= "FALSE"      [token]
    syntax Bool ::= Limit(Expression, TypeName)                              [functional,function]
    syntax Bool ::= LimitP(Expression, TypeName)                             [functional,function]
    syntax KItem ::= "execute"
    syntax KItem ::= "finish"
    syntax KItem ::= "renew"
    syntax KItem ::= info(Id, TypeName, K, Map, ControlCellFragment)
    syntax KItem ::= loopinfo(K)

    syntax Unit ::= TypeDefinition 
                | ProgramDefinition
                | GlobalVarDefinition
                | FunctionDefinition
                | FunctionBlockDefinition
                > Unit Unit    [right]
    
    //枚举类型声明、结构体声明
    syntax TypeDefinition ::= "TYPE" TypeBlocks "END_TYPE"
    syntax TypeBlocks ::= List{TypeBlock, ""}
    syntax TypeBlock ::= Id ":" "(" EnumBlock ")" ";"
                  | Id ":" "(" EnumBlock ")" ":=" Id ";"
                  | Id ":" "STRUCT" VarDeclarations "END_STRUCT" ";"
    syntax EnumBlock ::= Ids | IdVals
    syntax Ids ::= List{Id, ","}
    syntax IdVal ::= Id ":=" Expression                  [strict(2)]
    syntax IdVals ::= List{IdVal, ","}

    //全局变量
    syntax GlobalVarDefinition ::= "VAR_GLOBAL" VarDeclarations "END_VAR"
                | "VAR_GLOBAL" "CONSTANT" VarDeclarations "END_VAR"

    syntax VarDeclarations ::= List{VarDeclaration, ""}
    syntax InOut ::= "AT" "%IX" Expression
                | "AT" "%QX" Expression
    syntax VarDeclaration ::= Ids ":" TypeName ";"
                | Ids ":" TypeName ":=" "(" IdVals ")" ";"
                > Ids ":" TypeName ":=" Expression ";"      [strict(3)]
                > InOutDeclaration

    syntax InOutDeclaration ::= Id InOut ":" TypeName ";"
                | Id InOut ":" TypeName ":=" Expression ";" [strict(3)]
      

    syntax FunctionDefinition ::= "FUNCTION" Id ":" TypeName VarDefinitions StatementLists "END_FUNCTION"

    syntax FunctionBlockDefinition ::= "FUNCTION_BLOCK" Id VarDefinitions StatementLists "END_FUNCTION_BLOCK"

    syntax ProgramDefinition ::= "PROGRAM" Id VarDefinitions StatementLists "END_PROGRAM"

    syntax VarDefinitions ::= List{VarDefinition, ""}
    syntax VarDefinition ::= VarType "CONSTANT" VarDeclarations "END_VAR"
                | VarType VarDeclarations "END_VAR"
    syntax VarType ::= "VAR" | "VAR_INPUT" | "VAR_IN_OUT" | "VAR_TEMP" | "VAR_EXTERNAL" | "VAR_OUTPUT"

    syntax TypeName ::= ElementaryTypeName | ArrayTypeName | Id | "Enum" | "Struct" | "Array" | "Program" | "Function" | "FunctionBlock"
    syntax ElementaryTypeName ::= TimeType | StringType | "BOOL" | SolidityInt | SolidityUint | FloatType | BitType | "void" 
    syntax StringType ::= "STRING" | "WSTRING"
                | "STRING" "[" Expression "]"              [strict]
                | "WSTRING" "[" Expression "]"             [strict]
    syntax TimeType ::= "TIME" | "DATE" | "TIME_OF_DAY" | "DATE_AND_TIME"
    syntax SolidityInt ::= "INT" | "DINT" | "SINT" | "LINT"
    syntax SolidityUint ::= "UINT" | "UDINT" | "USINT" | "ULINT"
    syntax FloatType ::= "REAL" | "LREAL"
    syntax BitType ::= "BYTE" | "WORD" | "DWORD" | "LWORD"
    syntax ArrayTypeName ::= "ARRAY" "[" ArrayBlocks "]" "OF" TypeName
    syntax ArrayBlocks ::= Expression ".." Expression                   [strict]
                | ArrayBlocks "," ArrayBlocks                           [right]

    syntax Block ::= "{" "}"
                | "{" StatementLists "}"
    syntax Statement ::= Block | OtherStatement
    syntax OtherStatement ::= "IF" Expression "THEN" StatementLists ElseIfBlock "END_IF" ";"          [strict(1),avoid]
                | "IF" Expression "THEN" StatementLists "END_IF" ";"                                  [strict(1)]
                | "CASE" Expression "OF" CaseBlock "END_CASE" ";"                                     [strict(1)]
                | "CASE" Expression "OF" CaseBlock "ELSE" StatementLists "END_CASE" ";"               [strict(1)]
                | "WHILE" Expression "DO" StatementLists "END_WHILE" ";"                              
                | "FOR" Expression "TO" Expression "DO" StatementLists "END_FOR" ";"                  [strict(1,2)]
                | "FOR" Expression "TO" Expression "BY" Expression "DO" StatementLists "END_FOR" ";"  [strict(1,2,3)]
                | "FOR" Id ":=" Expression "TO" Expression "DO" StatementLists "END_FOR" ";"          [strict(2,3)]
                | "FOR" Id ":=" Expression "TO" Expression "BY" Expression "DO" StatementLists "END_FOR" ";"  [strict(2,3,4)]
                | "REPEAT" StatementLists "UNTIL" Expression "END_REPEAT" ";"                         
                | AllExp ";"                                                                      [strict]
                | "RETURN" ";"
                | "RETURN" Expression ";"                                                             [strict]
                | "EXIT" ";"
                | "recordcover" "(" Id ")" ";"
                 
    syntax Statement ::= "var" Id ":" "enum" "(" KItem "," Map ")" ";"
                | "var" Id "." Id ":" "enum" "(" KItem "," Map ")" ";"
                | "var" Id ":" "fblambda" "(" Id "," TypeName "," VarDefinitions "," StatementLists "," Map ")" ";"
                | "var" Id ":" "ufblambda" "(" Id "," TypeName "," VarDefinitions "," StatementLists "," Map ")" ";"
                | exec(StatementLists)

    syntax Statements ::= Statement 
                | Statements Statements    [right]
    syntax StatementLists ::= List{Statement, ""}

    syntax ElseIfBlock ::= "ELSE" StatementLists
                | "ELSIF" Expression "THEN" StatementLists                                      [strict(1)]
                | "ELSIF" Expression "THEN" StatementLists ElseIfBlock                          [strict(1)]
    syntax CaseBlock ::= CaseInts ":" StatementLists
                > CaseBlock CaseBlock                                                      [right]
    syntax CaseInts ::= List{CaseInt, ","}
    syntax CaseInt ::= Expression                                                                                                                   
                | Expression ".." Expression                                               [seqstrict] 

    syntax AllExps ::= List{AllExp, ","}
    syntax AllExp ::= NewExp | Expression
    syntax NewExp ::= Expression ":=" Expression                                           [strict(2),right]

    syntax Expressions ::= List{Expression, ","}
    
    syntax Expression ::= Id | Value | Bits | AllTimes
                | "[" Expressions "]"                                      [strict]
                | Id "." Id                                                [left]
                | Id "." Int                                               [strict(1),left]
                | Int "." Int                                              [left]
                | Value "." Id                                             [left]
                | TypeName "#" Expression                                  [strict(2)]
                | "[" Expressions "]"                                      [strict, left]
                > "(" Expression ")"                                       [bracket]
                > BuiltinFunctionCall
                > Expression "[" Expressions "]"                           [strict(1)]
                | Expression "(" AllExps ")"                               [strict(1)]
                > left: 
                "-" Expression                                             [strict]
                | "NOT" Expression                                         [strict]
                > left: 
                Expression "**" Expression                                 [strict]
                > left:
                Expression "*" Expression                                  [strict]
                | Expression "/" Expression                                [strict]
                | Expression "MOD" Expression                              [strict]
                > left:
                Expression "+" Expression                                  [strict]
                | Expression "-" Expression                                [strict]
                > left:
                Expression "<" Expression                                  [strict]
                | Expression ">" Expression                                [strict]
                | Expression "<=" Expression                               [strict]
                | Expression ">=" Expression                               [strict]
                > left: 
                Expression "=" Expression                                  [strict]
                | Expression "<>" Expression                               [strict]
                > left: 
                Expression "AND" Expression                                [strict]
                | Expression "&" Expression                                [strict]
                | Expression "AND_THEN" Expression                         [strict(1)]
                > left:
                Expression "XOR" Expression                                [strict]
                > left:
                Expression "OR" Expression                                 [strict]
                | Expression "OR_ELSE" Expression                          [strict(1)]

           
    syntax Expression ::= EnumFields(Id, Id, EnumBlock)
                | Set(Id, IdVals)
                | Set(Map, Map)
                | "Set" "(" Id "." Id "," Id ")"
                | "Set" "(" Id "." Id "," Value ")"
                | StructInits(VarDeclarations, Id)
                | Undefined(TypeName)
                | cut(Value, TypeName)
                | ClearEnv(Id)
                | lvalue(K)
                | lookup(Int)
                | getVal(Expression)                                       
                | upgrade(Id)
                | etogv(Id)
                | letogv(Ids)
                | setogv(Id)
                | settype(Id, Id)
                | settype(Id, ArrayTypeName)
                | setconstant(Id)
                | gsetconstant(Id)
                | Search(Expression)
                | call(Expression)
                | "read" "(" TypeName ")"
                | print(AllExps)
                

     syntax BuiltinFunctionCall ::= "ADD" "(" Expression "," Expression ")"       [strict,left]
                | "SUB" "(" Expression "," Expression ")"                         [strict,left]
                | "MUL" "(" Expression "," Expression ")"                         [strict,left]
                | "DIV" "(" Expression "," Expression ")"                         [strict,left]
                | "MOD" "(" Expression "," Expression ")"                         [strict,left]
                | "MOVE" "(" Expression ")"                                       [strict]
                | "INDEXOF" "(" Expression ")"                                    [strict]
                | "NEG" "(" Expression ")"                                        [strict]
                | "INC" "(" Expression ")"                                        [strict]
                | "DEC" "(" Expression ")"                                        [strict]
                | "TRUNC" "(" Expression ")"                                      [strict]
                | "FRAC" "(" Expression ")"                                       [strict]
                | "ABS" "(" Expression ")"                                        [strict]
                | "FLOOR" "(" Expression ")"                                      [strict]
                | "SQR" "(" Expression ")"                                        [strict]
                | "SQRT" "(" Expression ")"                                       [strict]
                | "LN" "(" Expression ")"                                         [strict]
                | "LOG" "(" Expression ")"                                        [strict]
                | "EXP" "(" Expression ")"                                        [strict]
                | "SIN" "(" Expression ")"                                        [strict]
                | "COS" "(" Expression ")"                                        [strict]
                | "TAN" "(" Expression ")"                                        [strict]
                | "ASIN" "(" Expression ")"                                       [strict]
                | "ACOS" "(" Expression ")"                                       [strict]
                | "ATAN" "(" Expression ")"                                       [strict]
                | "EXPT" "(" Expression "," Expression ")"                        [strict,left]
                | "SHL" "(" Expression "," Expression ")"                         [strict,left]
                | "SHR" "(" Expression "," Expression ")"                         [strict,left]
                | "SEL" "(" Expression "," Expression "," Expression ")"          [strict(1), left]
                | "MAX" "(" Expression "," Expression ")"                         [strict,left]
                | "MIN" "(" Expression "," Expression ")"                         [strict,left]
                | "LIMIT" "(" Expression "," Expression "," Expression ")"        [strict,left]
                | "MUX" "(" Expression "," Expressions ")"                     [strict(1),left]
                | "CONCAT" "(" Expression "," Expression ")"                      [strict,left]
                | "INSERT" "(" Expression "," Expression "," Expression ")"       [strict,left]
                | "DELETE" "(" Expression "," Expression "," Expression ")"       [strict,left]
                | "REPLACE" "(" Expression "," Expression "," Expression "," Expression ")"  [strict,left]
                | "FIND" "(" Expression "," Expression ")"                        [strict,left]
                | "LEN" "(" Expression ")"                                        [strict,left]
                | "LEFT" "(" Expression "," Expression ")"                        [strict,left]
                | "RIGHT" "(" Expression "," Expression ")"                       [strict,left]
                | "MID" "(" Expression "," Expression "," Expression ")"          [strict,left]
                | "ROL" "(" Expression "," Expression ")"                         [strict,left]
                | "ROR" "(" Expression "," Expression ")"                         [strict,left]
                | "GT" "(" Expression "," Expression ")"                          [strict,left]
                | "LT" "(" Expression "," Expression ")"                          [strict,left]
                | "GE" "(" Expression "," Expression ")"                          [strict,left]
                | "LE" "(" Expression "," Expression ")"                          [strict,left]
                | "EQ" "(" Expression "," Expression ")"                          [strict,left]
                | "NE" "(" Expression "," Expression ")"                          [strict,left]
                | "ADR" "(" Expression ")"                                        [strict,left]              //地址
                | "AND" "(" Expression "," Expression ")"                         [strict,left]
                | "OR" "(" Expression "," Expression ")"                          [strict,left]
                | "BOOL_TO_INT" "(" Expression ")"                                [strict]
                | "BOOL_TO_UINT" "(" Expression ")"                               [strict]
                | "BOOL_TO_STRING" "(" Expression ")"                                   [strict]
                | "BOOL_TO_TIME" "(" Expression ")"                                     [strict]
                | "BOOL_TO_TOD" "(" Expression ")"                                      [strict]
                | "BOOL_TO_DATE" "(" Expression ")"                                     [strict]
                | "BOOL_TO_DT" "(" Expression ")"                                       [strict]
                | "BYTE_TO_BOOL" "(" Expression ")"                                     [strict]
                | "INT_TO_BOOL" "(" Expression ")"                                      [strict]
                | "STRING_TO_BOOL" "(" Expression ")"                                   [strict]
                | "TIME_TO_BOOL" "(" Expression ")"                                     [strict]
                | "TOD_TO_BOOL" "(" Expression ")"                                      [strict]
                | "DATE_TO_BOOL" "(" Expression ")"                                     [strict]
                | "DT_TO_BOOL" "(" Expression ")"                                       [strict]
                | "INT_TO_DINT" "(" Expression ")"                                      [strict]
                | "INT_TO_SINT" "(" Expression ")"                                      [strict]
                | "INT_TO_LINT" "(" Expression ")"                                      [strict]
                | "DINT_TO_INT" "(" Expression ")"                                      [strict]
                | "DINT_TO_SINT" "(" Expression ")"                                     [strict]
                | "DINT_TO_LINT" "(" Expression ")"                                     [strict]
                | "SINT_TO_INT" "(" Expression ")"                                      [strict]
                | "SINT_TO_DINT" "(" Expression ")"                                     [strict]
                | "SINT_TO_LINT" "(" Expression ")"                                     [strict]
                | "LINT_TO_INT" "(" Expression ")"                                      [strict]
                | "LINT_TO_DINT" "(" Expression ")"                                     [strict]
                | "LINT_TO_SINT" "(" Expression ")"                                     [strict]
                | "UINT_TO_UDINT" "(" Expression ")"                                    [strict]
                | "UINT_TO_USINT" "(" Expression ")"                                    [strict]
                | "UINT_TO_ULINT" "(" Expression ")"                                    [strict]
                | "UDINT_TO_UINT" "(" Expression ")"                                    [strict]
                | "UDINT_TO_USINT" "(" Expression ")"                                   [strict]
                | "UDINT_TO_ULINT" "(" Expression ")"                                   [strict]
                | "USINT_TO_UINT" "(" Expression ")"                                    [strict]
                | "USINT_TO_UDINT" "(" Expression ")"                                   [strict]
                | "USINT_TO_ULINT" "(" Expression ")"                                   [strict]
                | "ULINT_TO_UINT" "(" Expression ")"                                    [strict]
                | "ULINT_TO_UDINT" "(" Expression ")"                                   [strict]
                | "ULINT_TO_USINT" "(" Expression ")"                                   [strict]
                | "REAL_TO_INT" "(" Expression ")"                                      [strict]
                | "REAL_TO_DINT" "(" Expression ")"                                     [strict]
                | "REAL_TO_SINT" "(" Expression ")"                                     [strict]
                | "REAL_TO_LINT" "(" Expression ")"                                     [strict]
                | "LREAL_TO_INT" "(" Expression ")"                                     [strict]
                | "LREAL_TO_DINT" "(" Expression ")"                                    [strict]
                | "LREAL_TO_SINT" "(" Expression ")"                                    [strict]
                | "LREAL_TO_LINT" "(" Expression ")"                                    [strict]
                | "UINT_TO_BYTE" "(" Expression ")"                                     [strict]
                | "UINT_TO_WORD" "(" Expression ")"                                     [strict]
                | "UINT_TO_DWORD" "(" Expression ")"                                    [strict]
                | "UINT_TO_LWORD" "(" Expression ")"                                    [strict]
                | "UDINT_TO_BYTE" "(" Expression ")"                                    [strict]
                | "UDINT_TO_WORD" "(" Expression ")"                                    [strict]
                | "UDINT_TO_DWORD" "(" Expression ")"                                   [strict]
                | "UDINT_TO_LWORD" "(" Expression ")"                                   [strict]
                | "USINT_TO_BYTE" "(" Expression ")"                                    [strict]
                | "USINT_TO_WORD" "(" Expression ")"                                    [strict]
                | "USINT_TO_DWORD" "(" Expression ")"                                   [strict]
                | "USINT_TO_LWORD" "(" Expression ")"                                   [strict]
                | "ULINT_TO_BYTE" "(" Expression ")"                                    [strict]
                | "ULINT_TO_WORD" "(" Expression ")"                                    [strict]
                | "ULINT_TO_DWORD" "(" Expression ")"                                   [strict]
                | "ULINT_TO_LWORD" "(" Expression ")"                                   [strict]
                | "BYTE_TO_UINT" "(" Expression ")"                                     [strict]
                | "BYTE_TO_UDINT" "(" Expression ")"                                    [strict]
                | "BYTE_TO_USINT" "(" Expression ")"                                    [strict]
                | "BYTE_TO_ULINT" "(" Expression ")"                                    [strict]
                | "WORD_TO_UINT" "(" Expression ")"                                     [strict]
                | "WORD_TO_UDINT" "(" Expression ")"                                    [strict]
                | "WORD_TO_USINT" "(" Expression ")"                                    [strict]
                | "WORD_TO_ULINT" "(" Expression ")"                                    [strict]
                | "DWORD_TO_UINT" "(" Expression ")"                                    [strict]
                | "DWORD_TO_UDINT" "(" Expression ")"                                   [strict]
                | "DWORD_TO_USINT" "(" Expression ")"                                   [strict]
                | "DWORD_TO_ULINT" "(" Expression ")"                                   [strict]
                | "LWORD_TO_UINT" "(" Expression ")"                                    [strict]
                | "LWORD_TO_UDINT" "(" Expression ")"                                   [strict]
                | "LWORD_TO_USINT" "(" Expression ")"                                   [strict]
                | "LWORD_TO_ULINT" "(" Expression ")"                                   [strict]
                | "STRING_TO_BYTE" "(" Expression ")"                                   [strict]
                | "STRING_TO_WORD" "(" Expression ")"                                   [strict]
                | "STRING_TO_DWORD" "(" Expression ")"                                  [strict]
                | "STRING_TO_LWORD" "(" Expression ")"                                  [strict]
                | "STRING_TO_INT" "(" Expression ")"                                    [strict]
                | "STRING_TO_SINT" "(" Expression ")"                                   [strict]
                | "STRING_TO_DINT" "(" Expression ")"                                   [strict]
                | "STRING_TO_LINT" "(" Expression ")"                                   [strict]
                | "STRING_TO_UINT" "(" Expression ")"                                   [strict]
                | "STRING_TO_USINT" "(" Expression ")"                                  [strict]
                | "STRING_TO_UDINT" "(" Expression ")"                                  [strict]
                | "STRING_TO_ULINT" "(" Expression ")"                                  [strict]
                | "STRING_TO_REAL" "(" Expression ")"                                   [strict]
                | "STRING_TO_LREAL" "(" Expression ")"                                  [strict]
                | "BYTE_TO_STRING" "(" Expression ")"                                   [strict]
                | "WORD_TO_STRING" "(" Expression ")"                                   [strict]
                | "DWORD_TO_STRING" "(" Expression ")"                                  [strict]
                | "LWORD_TO_STRING" "(" Expression ")"                                  [strict]
                | "INT_TO_STRING" "(" Expression ")"                                    [strict]
                | "DINT_TO_STRING" "(" Expression ")"                                   [strict]
                | "SINT_TO_STRING" "(" Expression ")"                                   [strict]
                | "LINT_TO_STRING" "(" Expression ")"                                   [strict]
                | "UINT_TO_STRING" "(" Expression ")"                                   [strict]
                | "UDINT_TO_STRING" "(" Expression ")"                                  [strict]
                | "USINT_TO_STRING" "(" Expression ")"                                  [strict]
                | "ULINT_TO_STRING" "(" Expression ")"                                  [strict]
                | "REAL_TO_STRING" "(" Expression ")"                                   [strict]
                | "LREAL_TO_STRING" "(" Expression ")"                                  [strict]
                | "TIME_TO_STRING" "(" Expression ")"                                   [strict]
                | "TOD_TO_STRING" "(" Expression ")"                                    [strict]
                | "DATE_TO_STRING" "(" Expression ")"                                   [strict]
                | "DT_TO_STRING" "(" Expression ")"                                     [strict]
                | "STRING_TO_TIME" "(" Expression ")"                                   [strict]
                | "STRING_TO_TOD" "(" Expression ")"                                    [strict]
                | "STRING_TO_DATE" "(" Expression ")"                                   [strict]
                | "STRING_TO_DT" "(" Expression ")"                                     [strict]
                | "INT_TO_REAL" "(" Expression ")"                                      [strict]
                | "DINT_TO_REAL" "(" Expression ")"                                     [strict]
                | "SINT_TO_REAL" "(" Expression ")"                                     [strict]
                | "LINT_TO_REAL" "(" Expression ")"                                     [strict]
                | "UINT_TO_REAL" "(" Expression ")"                                     [strict]
                | "UDINT_TO_REAL" "(" Expression ")"                                    [strict]
                | "USINT_TO_REAL" "(" Expression ")"                                    [strict]
                | "ULINT_TO_REAL" "(" Expression ")"                                    [strict]
                | "INT_TO_LREAL" "(" Expression ")"                                     [strict]
                | "DINT_TO_LREAL" "(" Expression ")"                                    [strict]
                | "SINT_TO_LREAL" "(" Expression ")"                                    [strict]
                | "LINT_TO_LREAL" "(" Expression ")"                                    [strict]
                | "UINT_TO_LREAL" "(" Expression ")"                                    [strict]
                | "UDINT_TO_LREAL" "(" Expression ")"                                   [strict]
                | "USINT_TO_LREAL" "(" Expression ")"                                   [strict]
                | "ULINT_TO_LREAL" "(" Expression ")"                                   [strict] 
                | "REAL_TO_UINT" "(" Expression ")"                                     [strict]
                | "REAL_TO_UDINT" "(" Expression ")"                                    [strict]
                | "REAL_TO_ULINT" "(" Expression ")"                                    [strict]
                | "REAL_TO_USINT" "(" Expression ")"                                    [strict]  
                | "UINT_TO_INT" "(" Expression ")"                                      [strict]
                | "UINT_TO_DINT" "(" Expression ")"                                     [strict]
                | "UINT_TO_SINT" "(" Expression ")"                                     [strict]
                | "UINT_TO_LINT" "(" Expression ")"                                     [strict]
                | "UDINT_TO_INT" "(" Expression ")"                                      [strict]
                | "UDINT_TO_DINT" "(" Expression ")"                                     [strict]
                | "UDINT_TO_SINT" "(" Expression ")"                                     [strict]
                | "UDINT_TO_LINT" "(" Expression ")"                                     [strict]
                | "USINT_TO_INT" "(" Expression ")"                                      [strict]
                | "USINT_TO_DINT" "(" Expression ")"                                     [strict]
                | "USINT_TO_SINT" "(" Expression ")"                                     [strict]
                | "USINT_TO_LINT" "(" Expression ")"                                     [strict]
                | "ULINT_TO_INT" "(" Expression ")"                                      [strict]
                | "ULINT_TO_DINT" "(" Expression ")"                                     [strict]
                | "ULINT_TO_SINT" "(" Expression ")"                                     [strict]
                | "ULINT_TO_LINT" "(" Expression ")"                                     [strict]  
                | "REAL_TO_LREAL" "(" Expression ")"                                     [strict]
                | "LREAL_TO_REAL" "(" Expression ")"                                     [strict]               

    syntax Value ::= ElementaryValue | InValue | EnumValue
    syntax ElementaryValue ::= Int | Float | String | Bit | AllTime | Bool
    syntax EnumValue ::= enum(KItem, Map)
    syntax InValue ::= "NULL"
                | CreateStruct(VarDeclarations, Id, Id, IdVals, Map)
                | array (ElementaryTypeName, Int, Int, Int)
                | funlambda(Id, TypeName, VarDefinitions, StatementLists)
                | fblambda(Id, ElementaryTypeName, VarDefinitions, StatementLists, Map)
                | ufblambda(Id, ElementaryTypeName, VarDefinitions, StatementLists, Map)
                | plambda(Id, ElementaryTypeName, VarDefinitions, StatementLists, Map)
                | runpfblambda(Id, TypeName, VarDefinitions, StatementLists, Map) 
                | loc(Int)
    syntax Values ::= List{Value, ","}
    syntax KResult ::= Value 

    rule U1:Unit U2:Unit => U1 ~> U2
    rule V1:VarDefinition V2:VarDefinition => V1 ~> V2
    rule S1:Statements S2:Statements => S1 ~> S2
    rule {S1:Statement Ss:StatementLists} => S1 ~> {Ss}
    rule {.StatementLists} => .
    rule {} => .

    rule NEG(E:Expression) => - E
    rule EXPT(E1:Expression, E2:Expression) => E1 ** E2
    rule MUL(E1:Expression, E2:Expression) => E1 * E2
    rule DIV(E1:Expression, E2:Expression) => E1 / E2
    rule ADD(E1:Expression, E2:Expression) => E1 + E2
    rule SUB(E1:Expression, E2:Expression) => E1 - E2
    rule MOD(E1:Expression, E2:Expression) => E1 MOD E2
    rule MOVE(E:Expression) => E
    rule GT(E1:Expression, E2:Expression) => E1 > E2
    rule LT(E1:Expression, E2:Expression) => E1 < E2
    rule GE(E1:Expression, E2:Expression) => E1 >= E2
    rule LE(E1:Expression, E2:Expression) => E1 <= E2
    rule EQ(E1:Expression, E2:Expression) => E1 = E2
    rule NE(E1:Expression, E2:Expression) => E1 <> E2
    rule LIMIT(E1:Expression, E2:Expression, E3:Expression) => MIN(MAX(E2, E1), E3)
    rule AND(E1:Expression, E2:Expression) => E1 AND E2
    rule OR(E1:Expression, E2:Expression) => E1 OR E2

    rule TYPE Tyb1:TypeBlock Tyb2:TypeBlock Tybs:TypeBlocks END_TYPE => TYPE Tyb1 END_TYPE ~> TYPE Tyb2 Tybs END_TYPE

 
endmodule