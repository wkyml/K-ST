require "st-syntax.k"
module ST-SEMANTIC-NUM 

    imports ST-SYNTAX

    rule - I:Int => 0 -Int I
    rule - I:Float => 0.0 -Float I

    rule I1:Int ** I2:Int => I1 ^Int I2
//    rule I1:Float ** I2:Int => I1 ^Float Int2Float(I2,100,0)
//    rule I1:Int ** I2:Float => Int2Float(I1,100,0) ^Float I2
    rule I1:Float ** I2:Float => I1 ^Float I2
    rule SQR(I:Int) => I ^Int 2
    rule SQR(I:Float) => I ^Float 2.0

    rule I1:Int * I2:Int => I1 *Int I2
//    rule I1:Int * I2:Float => Int2Float(I1,100,0) *Float I2
//    rule I1:Float * I2:Int => I1 *Float Int2Float(I2,100,0) 
    rule I1:Float * I2:Float => I1 *Float I2
 
    rule I1:Int / I2:Int => I1 /Int I2   requires I2 =/=Int 0
//    rule I1:Int / I2:Float => Int2Float(I1,100,0) /Float I2    requires I2 =/=Float 0.0
//    rule I1:Float / I2:Int => I1 /Float Int2Float(I2,100,0)    requires Int2Float(I2,100,0) =/=Float 0.0
    rule I1:Float / I2:Float => I1 /Float I2    requires I2 =/=Float 0.0

    rule I1:Int MOD I2:Int => I1 modInt I2
    
    rule I1:Int + I2:Int => I1 +Int I2
    rule I1:Float + I2:Float => I1 +Float I2
//    rule I1:Int + I2:Float => Int2Float(I1,100,0) +Float I2
//    rule I1:Float + I2:Int => I1 +Float Int2Float(I2,100,0) 
    rule INC(I:Int) => I +Int 1
    rule INC(I:Float) => I +Float 1.0

    rule I1:Int - I2:Int => I1 -Int I2
    rule I1:Float - I2:Float => I1 -Float I2
//    rule I1:Int - I2:Float => Int2Float(I1,100,0) -Float I2
//    rule I1:Float - I2:Int => I1 -Float Int2Float(I2,100,0) 
    rule DEC(I:Int) => I -Int 1
    rule DEC(I:Float) => I -Float 1.0

    rule MAX(I1:Int, I2:Int) => maxInt(I1, I2)
//    rule MAX(I1:Float, I2:Int) => maxFloat(I1,Int2Float(I2,100,0))
//    rule MAX(I1:Int, I2:Float) => maxFloat(Int2Float(I1,100,0),I2)
    rule MAX(I1:Float, I2:Float) => maxFloat(I1,I2)

    rule MIN(I1:Int, I2:Int) => minInt(I1, I2)
//    rule MIN(I1:Float, I2:Int) => minFloat(I1,Int2Float(I2,100,0))
//    rule MIN(I1:Int, I2:Float) => minFloat(Int2Float(I1,100,0),I2)
    rule MIN(I1:Float, I2:Float) => minFloat(I1,I2)

    rule MUX(I:Int, _:Expression, Es:Expressions) => MUX(I -Int 1, Es) requires I >Int 0
    rule MUX(I:Int, E:Expression, _:Expressions) => E requires I ==Int 0

    rule ABS(I:Int) => absInt(I)
    rule ABS(I:Float) => absFloat(I)

    rule SQRT(I:Int) => SQRT(Int2Float(I, 100, 0))
    rule SQRT(I:Float) => sqrtFloat(I) 

    rule TRUNC(I:Float) => Float2Int(floorFloat(I)) requires I >=Float 0.0
    rule TRUNC(I:Float) => Float2Int(ceilFloat(I)) requires I <Float 0.0
 
    rule FRAC(I:Float) => I - TRUNC(I)

    rule FLOOR(I:Float) => floorFloat(I)

    rule LN(I:Int) =>  LN(Int2Float(I,100,0))
    rule LN(I:Float) => logFloat(I)

    rule LOG(I:Int) => LOG(Int2Float(I,100,0))
    rule LOG(I:Float) => logFloat(I) /Float logFloat(10.0)

    rule EXP(I:Int) => EXP(Int2Float(I,100,0))
    rule EXP(I:Float) => expFloat(I)

    rule SIN(I:Int) => SIN(Int2Float(I,100,0))
    rule SIN(I:Float) => sinFloat(I)

    rule COS(I:Int) => COS(Int2Float(I,100,0))
    rule COS(I:Float) => cosFloat(I)

    rule TAN(I:Int) => TAN(Int2Float(I,100,0))
    rule TAN(I:Float) => tanFloat(I) 

    rule ASIN(I:Int) => ASIN(Int2Float(I,100,0))
    rule ASIN(I:Float) => asinFloat(I)

    rule ACOS(I:Int) => ACOS(Int2Float(I,100,0))
    rule ACOS(I:Float) => acosFloat(I)

    rule ATAN(I:Int) => ATAN(Int2Float(I,100,0))
    rule ATAN(I:Float) => atanFloat(I)

    rule I1:Int . I2:Int => String2Int(substrString(Base2String(I1,2), I2, I2 +Int 1)) requires I2 <Int lengthString(Base2String(I1,2))

endmodule