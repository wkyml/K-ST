require "st-syntax.k"

module ST-SEMANTIC-STRING 

    imports ST-SYNTAX

    rule S1:String = S2:String => S1 ==String S2
    rule S1:String <> S2:String => S1 =/=String S2
    rule S1:String > S2:String => S1 >String S2
    rule S1:String >= S2:String => S1 >=String S2
    rule S1:String < S2:String => S1 <String S2
    rule S1:String <= S2:String => S1 <=String S2

    rule CONCAT(S1:String, S2:String) =>  S1 +String S2

    rule INSERT(S1:String, S2:String, I:Int) => substrString(S1,0,I) +String S2 +String substrString(S1, I, lengthString(S1))

    rule DELETE(S:String, I1:Int, I2:Int) => substrString(S,0,I2 -Int 1) +String substrString(S, I2 -Int 1 +Int I1, lengthString(S))

    rule REPLACE(S1:String, S2:String, I1:Int, I2:Int) => substrString(S1,0,I2 -Int 1) +String S2 +String substrString(S1,I2 -Int 1 +Int I1,lengthString(S1))

    rule FIND(S1:String, S2:String) => findString(S1,S2,0)

    rule LEN(S:String) => lengthString(S)

    rule LEFT(S:String, I:Int) => substrString(S,0,I)

    rule RIGHT(S:String, I:Int) => substrString(S,lengthString(S) -Int I ,lengthString(S))

    rule MID(S:String, I1:Int, I2:Int) => substrString(S, I1 -Int 1, I1 +Int I2 -Int 1)

 
endmodule