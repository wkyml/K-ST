require "st-syntax.k"

module ST-SEMANTIC-BOOL

    imports ST-SYNTAX

    rule TRUE => true             [macro]
    rule FALSE => false           [macro]

 
    rule NOT B:Bool => notBool(B)

    rule I1:Int < I2:Int => I1 <Int I2
    rule I1:Int <= I2:Int => I1 <=Int I2
    rule I1:Int > I2:Int => I1 >Int I2
    rule I1:Int >= I2:Int => I1 >=Int I2
    rule I1:Int = I2:Int => I1 ==Int I2
    rule I1:Int <> I2:Int => I1 =/=Int I2

//    rule I1:Int < I2:Float => Int2Float(I1,100,0) <Float I2
//    rule I1:Int <= I2:Float => Int2Float(I1,100,0) <=Float I2
//    rule I1:Int > I2:Float => Int2Float(I1,100,0) >Float I2
//    rule I1:Int >= I2:Float => Int2Float(I1,100,0) >=Float I2
//    rule I1:Int = I2:Float => Int2Float(I1,100,0) ==Float I2
//    rule I1:Int <> I2:Float => Int2Float(I1,100,0) =/=Float I2

//    rule I1:Float < I2:Int => I1 <Float Int2Float(I2,100,0)
//    rule I1:Float <= I2:Int => I1 <=Float Int2Float(I2,100,0)
//    rule I1:Float > I2:Int => I1 >Float Int2Float(I2,100,0)
//    rule I1:Float >= I2:Int => I1 >=Float Int2Float(I2,100,0)
//    rule I1:Float = I2:Int => I1 ==Float Int2Float(I2,100,0)
//    rule I1:Float <> I2:Int => I1 =/=Float Int2Float(I2,100,0)

    rule I1:Float < I2:Float => I1 <Float I2
    rule I1:Float <= I2:Float => I1 <=Float I2
    rule I1:Float > I2:Float => I1 >Float I2
    rule I1:Float >= I2:Float => I1 >=Float I2
    rule I1:Float = I2:Float => I1 ==Float I2
    rule I1:Float <> I2:Float => I1 =/=Float I2

    rule I1:Bool = I2:Bool => I1 ==Bool I2
    rule I1:Bool <> I2:Bool => I1 =/=Bool I2

    rule true & E:Expression => E
    rule false & _:Expression => false
    rule E:Expression & true => E
    rule _:Expression & false => false

    rule true AND E:Expression => E
    rule false AND _:Expression => false
    rule E:Expression AND true => E
    rule _:Expression AND false => false

    rule true AND_THEN E:Expression => E
    rule false AND_THEN _:Expression => false

    rule B1:Bool XOR B2:Bool => B1 xorBool B2

    rule true OR _:Expression => true
    rule false OR E:Expression => E
    rule _:Expression OR true => true
    rule E :ExpressionOR false => E
    
    rule true OR_ELSE _:Expression => true
    rule false OR_ELSE E:Expression => E

    rule SEL(false, E:Expression, _:Expression) => E
    rule SEL(true, _:Expression, E:Expression) => E

    rule false = I:Int => true requires I ==Int 0
    rule false = I:Int => false requires I =/=Int 0
    rule true = I:Int => true requires I ==Int 1
    rule true = I:Int => false requires I =/=Int 1

    
 
endmodule