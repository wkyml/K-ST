
module BIT-EXTERNAL

    imports DOMAINS

    syntax Bit ::= Int "#" String
    syntax Bits ::= r"((16[\\#][0-9A-F]+)|(8[\\#][0-7]+)|(2[\\#][0-1]+))"                [token]
    syntax String ::= BitsToString(Bits)        [function, functional, hook(STRING.token2string)]
    syntax Bit ::= Bits2Bit(Bits)               [function, functional]
    syntax Bit ::= Int2Bit(Int)                 [function, functional]
    rule Bits2Bit(B:Bits) => String2Int(substrString(BitsToString(B),0,findString(BitsToString(B),"#",0))) # substrString(BitsToString(B),(findString(BitsToString(B),"#",0) +Int 1),lengthString(BitsToString(B)))   [structural,anywhere]
    rule B:Bits => String2Int(substrString(BitsToString(B),0,findString(BitsToString(B),"#",0))) # substrString(BitsToString(B),(findString(BitsToString(B),"#",0) +Int 1),lengthString(BitsToString(B)))   
    rule Int2Bit(I:Int) => 2 # Base2String(I, 2)

    syntax String ::= FormalBit(Bit,Int)              [function,functional]
    rule FormalBit(I1:Int # S:String, 8) => substrString("00000000" +String Base2String(String2Base(S,I1),2), lengthString("00000000" +String Base2String(String2Base(S,I1),2)) -Int 8, lengthString("00000000" +String Base2String(String2Base(S,I1),2)))
    rule FormalBit(I1:Int # S:String, 16) => substrString("0000000000000000" +String Base2String(String2Base(S,I1),2), lengthString("0000000000000000" +String Base2String(String2Base(S,I1),2)) -Int 16, lengthString("0000000000000000" +String Base2String(String2Base(S,I1),2)))
    rule FormalBit(I1:Int # S:String, 32) => substrString("00000000000000000000000000000000" +String Base2String(String2Base(S,I1),2), lengthString("00000000000000000000000000000000" +String Base2String(String2Base(S,I1),2)) -Int 32, lengthString("00000000000000000000000000000000" +String Base2String(String2Base(S,I1),2)))
    rule FormalBit(I1:Int # S:String, 64) => substrString("0000000000000000000000000000000000000000000000000000000000000000" +String Base2String(String2Base(S,I1),2), lengthString("0000000000000000000000000000000000000000000000000000000000000000" +String Base2String(String2Base(S,I1),2)) -Int 64, lengthString("0000000000000000000000000000000000000000000000000000000000000000" +String Base2String(String2Base(S,I1),2)))

endmodule
