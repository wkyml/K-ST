require "st-syntax.k"

module ST-SEMANTIC-BIT 

    imports ST-SYNTAX

    syntax Int ::= BitLeng(BitType)     [function,functional]
    rule BitLeng(BYTE) => 8
    rule BitLeng(WORD) => 16
    rule BitLeng(DWORD) => 32
    rule BitLeng(LWORD) => 64    

    rule (I1:Int # S1:String) + (I2:Int # S2:String) => I1 # Base2String((String2Base(S1,I1) +Int String2Base(S2,I2)),I1)
    rule (I1:Int # S:String) + I2:Int => I1 # Base2String((String2Base(S,I1) +Int I2),I1)
    rule I1:Int + (I2:Int # S:String) => I1 +Int String2Base(S,I2)
    rule I1:Float + (I2:Int # S:String) => I1 +Float Int2Float(String2Base(S,I2),100,0)

    rule (I1:Int # S1:String) - (I2:Int # S2:String) => I1 # Base2String((String2Base(S1,I1) -Int String2Base(S2,I2)),I1) requires (String2Base(S1,I1) >=Int String2Base(S2,I2))
    rule (I1:Int # S:String) - I2:Int => I1 # Base2String((String2Base(S,I1) -Int I2),I1) requires (String2Base(S,I1) >=Int I2)
    rule I1:Int - (I2:Int # S:String) => I1 -Int String2Base(S,I2)
    rule I1:Float - (I2:Int # S:String) => I1 -Float Int2Float(String2Base(S,I2),100,0)

    rule (I1:Int # S1:String) * (I2:Int # S2:String) => I1 # Base2String((String2Base(S1,I1) *Int String2Base(S2,I2)),I1)
    rule (I1:Int # S:String) * I2:Int => I1 # Base2String((String2Base(S,I1) *Int I2),I1)
    rule I1:Int * (I2:Int # S:String) => I1 *Int String2Base(S,I2)
    rule I1:Float * (I2:Int # S:String) => I1 *Float Int2Float(String2Base(S,I2),100,0)
    rule (I1:Int # S:String) * I2:Float => I1 # Base2String(Float2Int(floorFloat(Int2Float(String2Base(S,I1),100,0) *Float I2)),I1)

    rule (I1:Int # S1:String) / (I2:Int # S2:String) => I1 # Base2String((String2Base(S1,I1) /Int String2Base(S2,I2)),I1)   requires String2Base(S2,I2) =/=Int 0
    rule (I1:Int # S:String) / I2:Int => I1 # Base2String((String2Base(S,I1) /Int I2),I1)  requires I2 =/=Int 0
    rule I1:Int / (I2:Int # S:String) => I1 /Int String2Base(S,I2)       requires String2Base(S,I2) =/=Int 0
    rule I1:Float / (I2:Int # S:String) => I1 /Float Int2Float(String2Base(S,I2),100,0)  requires Int2Float(String2Base(S,I2),10,0) =/=Float 0.0
    rule (I1:Int # S:String) / I2:Float => I1 # Base2String(Float2Int(floorFloat(Int2Float(String2Base(S,I1),100,0) /Float I2)),I1) requires I2 =/=Float 0.0

    rule MOD((I1:Int # S1:String),(I2:Int # S2:String)) => I1 # Base2String((String2Base(S1,I1) modInt String2Base(S2,I2)),I1)   requires String2Base(S2,I2) >=Int 0
    rule MOD((I1:Int # S:String), I2:Int) => I1 # Base2String((String2Base(S,I1) modInt I2),I1)   requires I2 >=Int 0
    rule MOD(I1:Int,(I2:Int # S:String)) => (I1 modInt String2Base(S,I2))   requires String2Base(S,I2) >=Int 0

    rule NOT I:Int # S:String => (I # S) XOR (I # replaceAll(S,"0","1"))

    rule (I1:Int # S1:String) AND (I2:Int # S2:String) => I1 # Base2String((String2Base(S1,I1) &Int String2Base(S2,I2)),I1)
    rule (I1:Int # S1:String) XOR (I2:Int # S2:String) => I1 # Base2String((String2Base(S1,I1) xorInt String2Base(S2,I2)),I1)
    rule (I1:Int # S1:String) OR (I2:Int # S2:String) => I1 # Base2String((String2Base(S1,I1) |Int String2Base(S2,I2)),I1)

    rule SHL((I1:Int # S:String), I2:Int) => I1 # Base2String((String2Base(S,I1) <<Int I2), I1) requires I2 >=Int 0
    rule SHR((I1:Int # S:String), I2:Int) => I1 # Base2String((String2Base(S,I1) >>Int I2), I1) requires I2 >=Int 0

    //需要对S进行填充
    rule ROL((2 # S:String), I2:Int) => 2 # substrString(S,I2,lengthString(S)) +String substrString(S,0,I2) requires I2 >=Int 0
    rule ROR((2 # S:String), I2:Int) => 2 # substrString(S,lengthString(S) -Int I2,lengthString(S)) +String substrString(S,0,lengthString(S) -Int I2) requires I2 >=Int 0

    rule (I1:Int # S1:String) > E:Expression => String2Base(S1,I1) > E
    rule E:Expression > (I1:Int # S1:String) => E > String2Base(S1,I1)

    rule (I1:Int # S1:String) < E:Expression => String2Base(S1,I1) < E
    rule E:Expression < (I1:Int # S1:String) => E < String2Base(S1,I1)

    rule (I1:Int # S1:String) >= E:Expression => String2Base(S1,I1) >= E
    rule E:Expression >= (I1:Int # S1:String) => E >= String2Base(S1,I1)

    rule (I1:Int # S1:String) <= E:Expression => String2Base(S1,I1) <= E
    rule E:Expression <= (I1:Int # S1:String) => E <= String2Base(S1,I1)

    rule (I1:Int # S1:String) = E:Expression => String2Base(S1,I1) = E
    rule E:Expression = (I1:Int # S1:String) => E = String2Base(S1,I1)

    rule (I1:Int # S1:String) <> E:Expression => String2Base(S1,I1) <> E
    rule E:Expression <> (I1:Int # S1:String) => E <> String2Base(S1,I1)

    rule MAX(I1:Int # S1:String, I2:Int # S2:String) => I1 # S1 requires String2Base(S1,I1) >=Int String2Base(S2,I2)
    rule MAX(I1:Int # S1:String, I2:Int # S2:String) => I2 # S2 requires String2Base(S1,I1) <Int String2Base(S2,I2)
    rule MAX(I1:Int # S:String, I2:Int) => I1 # S requires String2Base(S,I1) >=Int I2
    rule MAX(I1:Int # S:String, I2:Int) => I2 requires String2Base(S,I1) <Int I2
    rule MAX(I1:Int, I2:Int # S:String) => I1 requires I1 >=Int String2Base(S,I2)
    rule MAX(I1:Int, I2:Int # S:String) => I2 # S requires I1 <Int String2Base(S,I2)
    rule MAX(I1:Int # S:String, I2:Float) => I1 # S requires Int2Float(String2Base(S,I1),100,0) >=Float I2
    rule MAX(I1:Int # S:String, I2:Float) => I2 requires Int2Float(String2Base(S,I1),100,0) <Float I2
    rule MAX(I1:Float, I2:Int # S:String) => I1 requires I1 >=Float Int2Float(String2Base(S,I2),100,0)
    rule MAX(I1:Float, I2:Int # S:String) => I2 # S requires I1 <Float Int2Float(String2Base(S,I2),100,0)

    rule MIN(I1:Int # S1:String, I2:Int # S2:String) => I1 # S1 requires String2Base(S1,I1) <=Int String2Base(S2,I2)
    rule MIN(I1:Int # S1:String, I2:Int # S2:String) => I2 # S2 requires String2Base(S1,I1) >Int String2Base(S2,I2)
    rule MIN(I1:Int # S:String, I2:Int) => I1 # S requires String2Base(S,I1) <=Int I2
    rule MIN(I1:Int # S:String, I2:Int) => I2 requires String2Base(S,I1) >Int I2
    rule MIN(I1:Int, I2:Int # S:String) => I1 requires I1 <=Int String2Base(S,I2)
    rule MIN(I1:Int, I2:Int # S:String) => I2 # S requires I1 >Int String2Base(S,I2)
    rule MIN(I1:Int # S:String, I2:Float) => I1 # S requires Int2Float(String2Base(S,I1),100,0) <=Float I2
    rule MIN(I1:Int # S:String, I2:Float) => I2 requires Int2Float(String2Base(S,I1),100,0) >Float I2
    rule MIN(I1:Float, I2:Int # S:String) => I1 requires I1 <=Float Int2Float(String2Base(S,I2),100,0)
    rule MIN(I1:Float, I2:Int # S:String) => I2 # S requires I1 >Float Int2Float(String2Base(S,I2),100,0)
endmodule