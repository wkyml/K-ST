require "st-syntax.k"

module ST-SEMANTIC-TRANS

    imports ST-SYNTAX

    syntax Int ::= String2Sign(String)             [function,functional]
    rule String2Sign("0") => 1
    rule String2Sign("1") => -1

    rule BOOL_TO_INT(true) => 1
    rule BOOL_TO_INT(false) => 0
    rule BOOL_TO_UINT(true) => 1
    rule BOOL_TO_UINT(false) => 0
    rule BOOL_TO_STRING(true) => "TRUE"           
    rule BOOL_TO_STRING(false) => "FALSE"
    rule BOOL_TO_TIME(true) => T# 0 d 0 h 0 m 0 s 1 ms
    rule BOOL_TO_TIME(false) => T# 0 d 0 h 0 m 0 s 0 ms
    rule BOOL_TO_TOD(true) => TOD# 00 : 00 : 00 . 001
    rule BOOL_TO_TOD(false) => TOD# 00 : 00 : 00 . 000
    rule BOOL_TO_DATE(true) => D# 1970 - 01 - 02
    rule BOOL_TO_DATE(false) => D# 1970 - 01 - 01
    rule BOOL_TO_DT(true) => DT# 1970 - 01 - 01 - 00 : 00 : 01
    rule BOOL_TO_DT(false) => DT# 1970 - 01 - 01 - 00 : 00 : 00
 
    rule BYTE_TO_BOOL(I:Int # S:String) => INT_TO_BOOL(String2Base(S,I))
    rule INT_TO_BOOL(I:Int) => false requires I ==Int 0
    rule INT_TO_BOOL(I:Int) => true requires notBool I ==Int 0
    rule STRING_TO_BOOL(S:String) => true requires S ==String "TRUE"
    rule STRING_TO_BOOL(S:String) => false requires S =/=String "TRUE"
    rule TIME_TO_BOOL(T# I1:Int d I2:Int h I3:Int m I4:Int s I5:Int ms) => true requires (I1 =/=Int 0) orBool (I2 =/=Int 0) orBool (I3 =/=Int 0) orBool (I4 =/=Int 0) orBool (I5 =/=Int 0)
    rule TIME_TO_BOOL(T# I1:Int d I2:Int h I3:Int m I4:Int s I5:Int ms) => false requires (I1 ==Int 0) andBool (I2 ==Int 0) andBool (I3 ==Int 0) andBool (I4 ==Int 0) andBool (I5 ==Int 0)
    rule TOD_TO_BOOL(TOD# I1:Int : I2:Int : I3:Int . I4:Int) => true requires (I1 =/=Int 0) orBool (I2 =/=Int 0) orBool (I3 =/=Int 0) orBool (I4 =/=Int 0)
    rule TOD_TO_BOOL(TOD# I1:Int : I2:Int : I3:Int . I4:Int) => false requires (I1 ==Int 0) andBool (I2 ==Int 0) andBool (I3 ==Int 0) andBool (I4 ==Int 0)
    rule DATE_TO_BOOL(D# I1:Int - I2:Int - I3:Int) => true requires (I1 >Int 1970) orBool (I1 ==Int 1970 andBool I2 >Int 1) orBool (I1 ==Int 1970 andBool I2 ==Int 1 andBool I3 >Int 1)
    rule DATE_TO_BOOL(D# I1:Int - I2:Int - I3:Int) => false (I1 ==Int 1970 andBool I2 ==Int 1 andBool I3 ==Int 1)
    rule DT_TO_BOOL(DT# I1:Int - I2:Int - I3:Int - I4:Int : I5:Int : I6:Int) => true requires (I1 >Int 1970) orBool (I1 ==Int 1970 andBool I2 >Int 1) orBool (I1 ==Int 1970 andBool I2 ==Int 1 andBool I3 >Int 1) orBool (I1 ==Int 1970 andBool I2 ==Int 1 andBool I3 ==Int 1 andBool (I4 =/=Int 0 orBool I5 =/=Int 0 orBool I6 =/=Int 0))
    rule DT_TO_BOOL(DT# I1:Int - I2:Int - I3:Int - I4:Int : I5:Int : I6:Int) => false requires I1 ==Int 1970 andBool I2 ==Int 1 andBool I3 ==Int 1 andBool I4 ==Int 0 andBool I5 ==Int 0 andBool I6 ==Int 0

    rule INT_TO_DINT(I:Int) => I requires (I >=Int -32768) andBool (I <=Int 32767)
    rule INT_TO_LINT(I:Int) => I requires (I >=Int -32768) andBool (I <=Int 32767)
    rule INT_TO_SINT(I:Int) => String2Sign(substrString(FormalBit(2 # Base2String(absInt(I),2),8),0,1)) *Int String2Base(substrString(FormalBit(2 # Base2String(absInt(I),2),8),1,8),2) requires (I >=Int -32768) andBool (I <=Int 32767)
    
    rule DINT_TO_INT(I:Int) => String2Sign(substrString(FormalBit(2 # Base2String(absInt(I),2),16),0,1)) *Int String2Base(substrString(FormalBit(2 # Base2String(absInt(I),2),16),1,16),2) requires (I >=Int -2147483648) andBool (I <=Int 2147483647) 
    rule DINT_TO_SINT(I:Int) => String2Sign(substrString(FormalBit(2 # Base2String(absInt(I),2),8),0,1)) *Int String2Base(substrString(FormalBit(2 # Base2String(absInt(I),2),8),1,8),2) requires (I >=Int -2147483648) andBool (I <=Int 2147483647) 
    rule DINT_TO_LINT(I:Int) => I requires (I >=Int -2147483647) andBool (I <=Int 2147483647)

    rule SINT_TO_INT(I:Int) => I requires (I >=Int -128) andBool (I <=Int 127)
    rule SINT_TO_DINT(I:Int) => I requires (I >=Int -128) andBool (I <=Int 127)
    rule SINT_TO_LINT(I:Int) => I requires (I >=Int -128) andBool (I <=Int 127)

    rule LINT_TO_INT(I:Int) => String2Sign(substrString(FormalBit(2 # Base2String(absInt(I),2),16),0,1)) *Int String2Base(substrString(FormalBit(2 # Base2String(absInt(I),2),16),1,16),2) requires (I >=Int (-2 ^Int 63)) andBool (I <=Int (2 ^Int 63 -Int 1)) 
    rule LINT_TO_DINT(I:Int) => String2Sign(substrString(FormalBit(2 # Base2String(absInt(I),2),32),0,1)) *Int String2Base(substrString(FormalBit(2 # Base2String(absInt(I),2),32),1,32),2) requires (I >=Int (-2 ^Int 63)) andBool (I <=Int (2 ^Int 63 -Int 1)) 
    rule LINT_TO_SINT(I:Int) => String2Sign(substrString(FormalBit(2 # Base2String(absInt(I),2),8),0,1)) *Int String2Base(substrString(FormalBit(2 # Base2String(absInt(I),2),8),1,8),2) requires (I >=Int (-2 ^Int 63)) andBool (I <=Int (2 ^Int 63 -Int 1))


    rule UINT_TO_UDINT(I:Int) => I requires (I >=Int 0) andBool (I <=Int 65535)
    rule UINT_TO_USINT(I:Int) => String2Base(substrString(FormalBit(2 # Base2String(absInt(I),2),8),0,8),2) requires (I >=Int 0) andBool (I <=Int 65535)
    rule UINT_TO_ULINT(I:Int) => I requires (I >=Int 0) andBool (I <=Int 65535)

    rule UDINT_TO_UINT(I:Int) => String2Base(substrString(FormalBit(2 # Base2String(absInt(I),2),16),0,16),2) requires (I >=Int 0) andBool (I <=Int 4294967295)
    rule UDINT_TO_USINT(I:Int) => String2Base(substrString(FormalBit(2 # Base2String(absInt(I),2),8),0,8),2) requires (I >=Int 0) andBool (I <=Int 4294967295)
    rule UDINT_TO_ULINT(I:Int) => I requires (I >=Int 0) andBool (I <=Int 4294967295)

    rule USINT_TO_UINT(I:Int) => I requires (I >=Int 0) andBool (I <=Int 255)
    rule USINT_TO_UDINT(I:Int) => I requires (I >=Int 0) andBool (I <=Int 255)
    rule USINT_TO_ULINT(I:Int) => I requires (I >=Int 0) andBool (I <=Int 255)

    rule ULINT_TO_UINT(I:Int) => String2Base(substrString(FormalBit(2 # Base2String(absInt(I),2),16),0,16),2) requires (I >=Int 0) andBool (I <=Int (2 ^Int 64 -Int 1))
    rule ULINT_TO_USINT(I:Int) => String2Base(substrString(FormalBit(2 # Base2String(absInt(I),2),8),0,8),2) requires (I >=Int 0) andBool (I <=Int (2 ^Int 64 -Int 1))
    rule ULINT_TO_UDINT(I:Int) => String2Base(substrString(FormalBit(2 # Base2String(absInt(I),2),32),0,32),2) requires (I >=Int 0) andBool (I <=Int (2 ^Int 64 -Int 1))

    rule REAL_TO_INT(I:Float) => Float2Int(I) requires (-3.402823 *Float 10.0 ^Float 38.0 <=Float I) andBool(I <=Float 3.402823 *Float 10.0 ^Float 38.0) andBool (-32768 <=Int Float2Int(I)) andBool (Float2Int(I) <=Int 32767)
    rule REAL_TO_DINT(I:Float) => Float2Int(I) requires (-3.402823 *Float 10.0 ^Float 38.0 <=Float I) andBool(I <=Float 3.402823 *Float 10.0 ^Float 38.0) andBool (-2147483648 <=Int Float2Int(I)) andBool (Float2Int(I) <=Int 2147483647)
    rule REAL_TO_SINT(I:Float) => Float2Int(I) requires (-3.402823 *Float 10.0 ^Float 38.0 <=Float I) andBool(I <=Float 3.402823 *Float 10.0 ^Float 38.0) andBool (-128 <=Int Float2Int(I)) andBool (Float2Int(I) <=Int 127)
    rule REAL_TO_LINT(I:Float) => Float2Int(I) requires (-3.402823 *Float 10.0 ^Float 38.0 <=Float I) andBool(I <=Float 3.402823 *Float 10.0 ^Float 38.0) andBool (-2 ^Int 63 <=Int Float2Int(I)) andBool (Float2Int(I) <=Int 2 ^Int 63 -Int 1)

    rule LREAL_TO_INT(I:Float) => Float2Int(I) requires (-1.7976931348623157 *Float 10.0 ^Float 308.0 <=Float I) andBool(I <=Float 1.7976931348623157 *Float 10.0 ^Float 308.0) andBool (-32768 <=Int Float2Int(I)) andBool (Float2Int(I) <=Int 32767)
    rule LREAL_TO_DINT(I:Float) => Float2Int(I) requires (-1.7976931348623157 *Float 10.0 ^Float 308.0 <=Float I) andBool(I <=Float 1.7976931348623157 *Float 10.0 ^Float 308.0) andBool (-2147483648 <=Int Float2Int(I)) andBool (Float2Int(I) <=Int 2147483647)
    rule LREAL_TO_SINT(I:Float) => Float2Int(I) requires (-1.7976931348623157 *Float 10.0 ^Float 308.0 <=Float I) andBool(I <=Float 1.7976931348623157 *Float 10.0 ^Float 308.0) andBool (-128 <=Int Float2Int(I)) andBool (Float2Int(I) <=Int 127)
    rule LREAL_TO_LINT(I:Float) => Float2Int(I) requires (-1.7976931348623157 *Float 10.0 ^Float 308.0 <=Float I) andBool(I <=Float 1.7976931348623157 *Float 10.0 ^Float 308.0) andBool (-2 ^Int 63 <=Int Float2Int(I)) andBool (Float2Int(I) <=Int 2 ^Int 63 -Int 1)    

    rule UINT_TO_BYTE(I:Int) => 2 # FormalBit(2 # Base2String(I,2),8)  requires I >=Int 0 andBool I <=Int 65535
    rule UINT_TO_WORD(I:Int) => 2 # FormalBit(2 # Base2String(I,2),16)  requires I >=Int 0 andBool I <=Int 65535
    rule UINT_TO_DWORD(I:Int) => 2 # FormalBit(2 # Base2String(I,2),32)  requires I >=Int 0 andBool I <=Int 65535
    rule UINT_TO_LWORD(I:Int) => 2 # FormalBit(2 # Base2String(I,2),64)  requires I >=Int 0 andBool I <=Int 65535

    rule UDINT_TO_BYTE(I:Int) => 2 # FormalBit(2 # Base2String(I,2),8)  requires I >=Int 0 andBool I <=Int 4294967295
    rule UDINT_TO_WORD(I:Int) => 2 # FormalBit(2 # Base2String(I,2),16)  requires I >=Int 0 andBool I <=Int 4294967295
    rule UDINT_TO_DWORD(I:Int) => 2 # FormalBit(2 # Base2String(I,2),32)  requires I >=Int 0 andBool I <=Int 4294967295
    rule UDINT_TO_LWORD(I:Int) => 2 # FormalBit(2 # Base2String(I,2),64)  requires I >=Int 0 andBool I <=Int 4294967295

    rule USINT_TO_BYTE(I:Int) => 2 # FormalBit(2 # Base2String(I,2),8)  requires I >=Int 0 andBool I <=Int 255
    rule USINT_TO_WORD(I:Int) => 2 # FormalBit(2 # Base2String(I,2),16)  requires I >=Int 0 andBool I <=Int 255
    rule USINT_TO_DWORD(I:Int) => 2 # FormalBit(2 # Base2String(I,2),32)  requires I >=Int 0 andBool I <=Int 255
    rule USINT_TO_LWORD(I:Int) => 2 # FormalBit(2 # Base2String(I,2),64)  requires I >=Int 0 andBool I <=Int 255

    rule ULINT_TO_BYTE(I:Int) => 2 # FormalBit(2 # Base2String(I,2),8)  requires I >=Int 0 andBool I <=Int 2 ^Int 64 -Int 1
    rule ULINT_TO_WORD(I:Int) => 2 # FormalBit(2 # Base2String(I,2),16)  requires I >=Int 0 andBool I <=Int 2 ^Int 64 -Int 1
    rule ULINT_TO_DWORD(I:Int) => 2 # FormalBit(2 # Base2String(I,2),32)  requires I >=Int 0 andBool I <=Int 2 ^Int 64 -Int 1
    rule ULINT_TO_LWORD(I:Int) => 2 # FormalBit(2 # Base2String(I,2),64)  requires I >=Int 0 andBool I <=Int 2 ^Int 64 -Int 1

    rule BYTE_TO_UINT(I:Int # S:String) => String2Base(FormalBit(I:Int # S:String,16),2) requires String2Base(S,I) <=Int 255
    rule BYTE_TO_UDINT(I:Int # S:String) => String2Base(FormalBit(I:Int # S:String,32),2) requires String2Base(S,I) <=Int 255
    rule BYTE_TO_USINT(I:Int # S:String) => String2Base(FormalBit(I:Int # S:String,8),2) requires String2Base(S,I) <=Int 255
    rule BYTE_TO_ULINT(I:Int # S:String) => String2Base(FormalBit(I:Int # S:String,64),2) requires String2Base(S,I) <=Int 255

    rule WORD_TO_UINT(I:Int # S:String) => String2Base(FormalBit(I:Int # S:String,16),2) requires String2Base(S,I) <=Int 65535
    rule WORD_TO_UDINT(I:Int # S:String) => String2Base(FormalBit(I:Int # S:String,32),2) requires String2Base(S,I) <=Int 65535
    rule WORD_TO_USINT(I:Int # S:String) => String2Base(FormalBit(I:Int # S:String,8),2) requires String2Base(S,I) <=Int 65535
    rule WORD_TO_ULINT(I:Int # S:String) => String2Base(FormalBit(I:Int # S:String,64),2) requires String2Base(S,I) <=Int 65535

    rule DWORD_TO_UINT(I:Int # S:String) => String2Base(FormalBit(I:Int # S:String,16),2) requires String2Base(S,I) <=Int 4294967295
    rule DWORD_TO_UDINT(I:Int # S:String) => String2Base(FormalBit(I:Int # S:String,32),2) requires String2Base(S,I) <=Int 4294967295
    rule DWORD_TO_USINT(I:Int # S:String) => String2Base(FormalBit(I:Int # S:String,8),2) requires String2Base(S,I) <=Int 4294967295
    rule DWORD_TO_ULINT(I:Int # S:String) => String2Base(FormalBit(I:Int # S:String,64),2) requires String2Base(S,I) <=Int 4294967295

    rule LWORD_TO_UINT(I:Int # S:String) => String2Base(FormalBit(I:Int # S:String,16),2) requires String2Base(S,I) <=Int 2 ^Int 64 -Int 1
    rule LWORD_TO_UDINT(I:Int # S:String) => String2Base(FormalBit(I:Int # S:String,32),2) requires String2Base(S,I) <=Int 2 ^Int 64 -Int 1
    rule LWORD_TO_USINT(I:Int # S:String) => String2Base(FormalBit(I:Int # S:String,8),2) requires String2Base(S,I) <=Int 2 ^Int 64 -Int 1
    rule LWORD_TO_ULINT(I:Int # S:String) => String2Base(FormalBit(I:Int # S:String,64),2) requires String2Base(S,I) <=Int 2 ^Int 64 -Int 1

    rule STRING_TO_BYTE(S:String) => 2 # FormalBit(2 # Base2String(String2Int(S),2),8) requires findString(S,"#",0) ==Int -1
    rule STRING_TO_WORD(S:String) => 2 # FormalBit(2 # Base2String(String2Int(S),2),16) requires findString(S,"#",0) ==Int -1
    rule STRING_TO_DWORD(S:String) => 2 # FormalBit(2 # Base2String(String2Int(S),2),32) requires findString(S,"#",0) ==Int -1
    rule STRING_TO_LWORD(S:String) => 2 # FormalBit(2 # Base2String(String2Int(S),2),64) requires findString(S,"#",0) ==Int -1

    rule STRING_TO_BYTE(S:String) => 2 # FormalBit(2 # Base2String(String2Base(substrString(S, findString(S, "#", 0) +Int 1, lengthString(S)), String2Int(substrString(S, 0, findString(S, "#", 0)))), 2),8) requires findString(S,"#",0) =/=Int -1 
    rule STRING_TO_WORD(S:String) => 2 # FormalBit(2 # Base2String(String2Base(substrString(S, findString(S, "#", 0) +Int 1, lengthString(S)), String2Int(substrString(S, 0, findString(S, "#", 0)))), 2),16) requires findString(S,"#",0) =/=Int -1 
    rule STRING_TO_DWORD(S:String) => 2 # FormalBit(2 # Base2String(String2Base(substrString(S, findString(S, "#", 0) +Int 1, lengthString(S)), String2Int(substrString(S, 0, findString(S, "#", 0)))), 2),32) requires findString(S,"#",0) =/=Int -1 
    rule STRING_TO_LWORD(S:String) => 2 # FormalBit(2 # Base2String(String2Base(substrString(S, findString(S, "#", 0) +Int 1, lengthString(S)), String2Int(substrString(S, 0, findString(S, "#", 0)))), 2),64) requires findString(S,"#",0) =/=Int -1 


    rule STRING_TO_INT(S:String) => String2Int(S)       requires String2Int(S) >=Int -32768 andBool String2Int(S) <=Int 32767
    rule STRING_TO_DINT(S:String) => String2Int(S)       requires String2Int(S) >=Int -2147483648 andBool String2Int(S) <=Int 2147483647
    rule STRING_TO_SINT(S:String) => String2Int(S)       requires String2Int(S) >=Int -128 andBool String2Int(S) <=Int 127
    rule STRING_TO_LINT(S:String) => String2Int(S)       requires String2Int(S) >=Int -2 ^Int 63 andBool String2Int(S) <=Int 2 ^Int 63 -Int 1

    rule STRING_TO_UINT(S:String) => String2Int(S)       requires String2Int(S) >=Int 0 andBool String2Int(S) <=Int 65535
    rule STRING_TO_UDINT(S:String) => String2Int(S)       requires String2Int(S) >=Int 0 andBool String2Int(S) <=Int 4294967295
    rule STRING_TO_USINT(S:String) => String2Int(S)       requires String2Int(S) >=Int 0 andBool String2Int(S) <=Int 255
    rule STRING_TO_ULINT(S:String) => String2Int(S)       requires String2Int(S) >=Int 0 andBool String2Int(S) <=Int 2 ^Int 64 -Int 1

    rule STRING_TO_REAL(S:String) => String2Float(S)      requires (-3.402823 *Float 10.0 ^Float 38.0 <=Float String2Float(S)) andBool(String2Float(S) <=Float 3.402823 *Float 10.0 ^Float 38.0)
    rule STRING_TO_LREAL(S:String) => String2Float(S)      requires (-1.7976931348623157 *Float 10.0 ^Float 308.0 <=Float String2Float(S)) andBool(String2Float(S) <=Float 1.7976931348623157 *Float 10.0 ^Float 308.0)

    rule BYTE_TO_STRING(I:Int # S:String) => Int2String(I) +String "#" +String S requires String2Base(S,I) <=Int 255
    rule WORD_TO_STRING(I:Int # S:String) => Int2String(I) +String "#" +String S requires String2Base(S,I) <=Int 65535
    rule DWORD_TO_STRING(I:Int # S:String) => Int2String(I) +String "#" +String S requires String2Base(S,I) <=Int 4294967295
    rule LWORD_TO_STRING(I:Int # S:String) => Int2String(I) +String "#" +String S requires String2Base(S,I) <=Int 2 ^Int 64 -Int 1

    rule INT_TO_STRING(I:Int) => Int2String(I) requires I >=Int -32768 andBool I <=Int 32767
    rule DINT_TO_STRING(I:Int) => Int2String(I) requires I >=Int -2147483648 andBool I <=Int 2147483647
    rule SINT_TO_STRING(I:Int) => Int2String(I) requires I >=Int -128 andBool I <=Int 127
    rule LINT_TO_STRING(I:Int) => Int2String(I) requires I >=Int -2 ^Int 63 andBool I <=Int 2 ^Int 63 -Int 1

    rule UINT_TO_STRING(I:Int) => Int2String(I) requires I >=Int 0 andBool I <=Int 65535
    rule UDINT_TO_STRING(I:Int) => Int2String(I) requires I >=Int 0 andBool I <=Int 4294967295
    rule USINT_TO_STRING(I:Int) => Int2String(I) requires I >=Int 0 andBool I <=Int 255
    rule ULINT_TO_STRING(I:Int) => Int2String(I) requires I >=Int 0 andBool I <=Int 2 ^Int 64 -Int 1

    rule REAL_TO_STRING(I:Float) => substrString(Float2String(I),0,findString(Float2String(I),".",0) +Int 1) +String substrString(Float2String(I),findString(Float2String(I),".",0) +Int 1,findString(Float2String(I),".",0) +Int 17) requires (-3.402823 *Float 10.0 ^Float 38.0 <=Float I) andBool(I <=Float 3.402823 *Float 10.0 ^Float 38.0)
    rule LREAL_TO_STRING(I:Float) => substrString(Float2String(I),0,findString(Float2String(I),".",0) +Int 1) +String substrString(Float2String(I),findString(Float2String(I),".",0) +Int 1,findString(Float2String(I),".",0) +Int 17) requires (-1.7976931348623157 *Float 10.0 ^Float 308.0 <=Float I) andBool(I <=Float 1.7976931348623157 *Float 10.0 ^Float 308.0)

    rule TIME_TO_STRING(T# I1:Int d I2:Int h I3:Int m I4:Int s I5:Int ms) => "T#" +String Int2String(I1) +String "d" +String Int2String(I2) +String "h" +String Int2String(I3) +String "m" +String Int2String(I4) +String "s" +String Int2String(I5) +String "ms"
    rule TOD_TO_STRING(TOD# I1:Int : I2:Int : I3:Int . I4:Int ) => "TOD#" +String Int2String(I1) +String ":" +String Int2String(I2) +String ":" +String Int2String(I3) +String "." +String Int2String(I4)
    rule DATE_TO_STRING(D# I1:Int - I2:Int - I3:Int) => "D#" +String Int2String(I1) +String "-" +String Int2String(I2) +String "-" +String Int2String(I3)
    rule DT_TO_STRING(DT# I1:Int - I2:Int - I3:Int - I4:Int : I5:Int : I6:Int) => "DT#" +String Int2String(I1) +String "-" +String Int2String(I2) +String "-" +String Int2String(I3) +String "-" +String Int2String(I4) +String ":" +String Int2String(I5) +String ":" +String Int2String(I6)

    rule STRING_TO_TOD(S:String) => TOD# String2Int(substrString(S,findString(S,"#",0) +Int 1,findString(S,":",4))) : String2Int(substrString(S,findString(S,":",4) +Int 1,findString(S,":",findString(S,":",4) +Int 1))) : String2Int(substrString(S,findString(S,":",findString(S,":",4) +Int 1) +Int 1,lengthString(S))) . 0 requires findString(S,".",0) ==Int -1
    rule STRING_TO_TOD(S:String) => TOD# String2Int(substrString(S,findString(S,"#",0) +Int 1,findString(S,":",4))) : String2Int(substrString(S,findString(S,":",4) +Int 1,findString(S,":",findString(S,":",4) +Int 1))) : String2Int(substrString(S,findString(S,":",findString(S,":",4) +Int 1) +Int 1,findString(S,".",0))) . String2Int(substrString(S,findString(S,".",0) +Int 1,lengthString(S))) requires findString(S,".",0) >=Int 0
    rule STRING_TO_TIME(S:String) => T# String2Int(substrString("0" +String S,maxInt(0,Int2One(findString(("0" +String S),"d",0)) *Int (findString(("0" +String S),"#",0) +Int 1)),maxInt(1,findString(("0" +String S),"d",0)))) d String2Int(substrString("0" +String S,maxInt(0,findString(("0" +String S),"h",0) -Int 2),maxInt(1,findString(("0" +String S),"h",0)))) h String2Int(substrString("0" +String S,maxInt(0,findString(("0" +String S),"m",0) -Int 2),maxInt(1,findString(("0" +String S),"m",0)))) m String2Int(substrString("0" +String S,maxInt(0,findString(("0" +String S),"s",0) -Int 2),maxInt(1,findString(("0" +String S),"s",0)))) s String2Int(substrString("0" +String S,maxInt(0,findString(("0" +String S),"ms",0) -Int 3),maxInt(1,findString(("0" +String S),"ms",0)))) ms requires (findString(("0" +String S),"m",0) ==Int -1 orBool findString(("0" +String S),"m",0) =/=Int findString(("0" +String S),"ms",0)) andBool (findString(("0" +String S),"s",0) ==Int -1 orBool findString(("0" +String S),"s",0) =/=Int (findString(("0" +String S),"ms",0) +Int 1))
    rule STRING_TO_TIME(S:String) => T# String2Int(substrString("0" +String S,maxInt(0,Int2One(findString(("0" +String S),"d",0)) *Int (findString(("0" +String S),"#",0) +Int 1)),maxInt(1,findString(("0" +String S),"d",0)))) d String2Int(substrString("0" +String S,maxInt(0,findString(("0" +String S),"h",0) -Int 2),maxInt(1,findString(("0" +String S),"h",0)))) h 0 m String2Int(substrString("0" +String S,maxInt(0,findString(("0" +String S),"s",0) -Int 2),maxInt(1,findString(("0" +String S),"s",0)))) s String2Int(substrString("0" +String S,maxInt(0,findString(("0" +String S),"ms",0) -Int 3),maxInt(1,findString(("0" +String S),"ms",0)))) ms requires (findString(("0" +String S),"m",0) =/=Int -1 andBool findString(("0" +String S),"m",0) ==Int findString(("0" +String S),"ms",0)) andBool (findString(("0" +String S),"s",0) ==Int -1 orBool findString(("0" +String S),"s",0) =/=Int (findString(("0" +String S),"ms",0) +Int 1))
    rule STRING_TO_TIME(S:String) => T# String2Int(substrString("0" +String S,maxInt(0,Int2One(findString(("0" +String S),"d",0)) *Int (findString(("0" +String S),"#",0) +Int 1)),maxInt(1,findString(("0" +String S),"d",0)))) d String2Int(substrString("0" +String S,maxInt(0,findString(("0" +String S),"h",0) -Int 2),maxInt(1,findString(("0" +String S),"h",0)))) h String2Int(substrString("0" +String S,maxInt(0,findString(("0" +String S),"m",0) -Int 2),maxInt(1,findString(("0" +String S),"m",0)))) m 0 s String2Int(substrString("0" +String S,maxInt(0,findString(("0" +String S),"ms",0) -Int 3),maxInt(1,findString(("0" +String S),"ms",0)))) ms requires (findString(("0" +String S),"m",0) ==Int -1 orBool findString(("0" +String S),"m",0) =/=Int findString(("0" +String S),"ms",0)) andBool (findString(("0" +String S),"s",0) =/=Int -1 andBool findString(("0" +String S),"s",0) ==Int (findString(("0" +String S),"ms",0) +Int 1))
    rule STRING_TO_TIME(S:String) => T# String2Int(substrString("0" +String S,maxInt(0,Int2One(findString(("0" +String S),"d",0)) *Int (findString(("0" +String S),"#",0) +Int 1)),maxInt(1,findString(("0" +String S),"d",0)))) d String2Int(substrString("0" +String S,maxInt(0,findString(("0" +String S),"h",0) -Int 2),maxInt(1,findString(("0" +String S),"h",0)))) h 0 m 0 s String2Int(substrString("0" +String S,maxInt(0,findString(("0" +String S),"ms",0) -Int 3),maxInt(1,findString(("0" +String S),"ms",0)))) ms requires (findString(("0" +String S),"m",0) =/=Int -1 andBool findString(("0" +String S),"m",0) ==Int findString(("0" +String S),"ms",0)) andBool (findString(("0" +String S),"s",0) =/=Int -1 andBool findString(("0" +String S),"s",0) ==Int (findString(("0" +String S),"ms",0) +Int 1))
    rule STRING_TO_DATE(S:String) => D# String2Int(substrString(S,findString(S,"#",0) +Int 1, findString(S,"-",0))) - String2Int(substrString(S,findString(S,"-",0) +Int 1,findString(S,"-",findString(S,"-",0) +Int 1))) - String2Int(substrString(S,findString(S,"-",findString(S,"-",0) +Int 1) +Int 1,lengthString(S)))
    rule STRING_TO_DT(S:String) => DT# String2Int(substrString(S,findString(S,"#",0) +Int 1, findString(S,"-",0))) - String2Int(substrString(S,findString(S,"-",0) +Int 1,findString(S,"-",findString(S,"-",0) +Int 1))) - String2Int(substrString(S,findString(S,"-",findString(S,"-",0) +Int 1) +Int 1, findString(S,"-",findString(S,"-", findString(S,"-",0) +Int 1) +Int 1))) - String2Int(substrString(S,findString(S,"-",findString(S,"-",findString(S,"-",0) +Int 1) +Int 1) +Int 1, findString(S,":",0))) : String2Int(substrString(S,findString(S,":",0) +Int 1,findString(S,":",findString(S,":",0) +Int 1))) : String2Int(substrString(S,findString(S,":",findString(S,":",0) +Int 1) +Int 1, lengthString(S)))

    rule INT_TO_REAL(I:Int) => Int2Float(I, 100, 0) requires I >=Int -32768 andBool I <=Int 32767
    rule DINT_TO_REAL(I:Int) => Int2Float(I, 100, 0) requires I >=Int -2147483648 andBool I <=Int 2147483647
    rule SINT_TO_REAL(I:Int) => Int2Float(I, 100, 0) requires I >=Int -128 andBool I <=Int 127
    rule LINT_TO_REAL(I:Int) => Int2Float(I, 100, 0) requires I >=Int -2 ^Int 63 andBool I <=Int 2 ^Int 63 -Int 1

    rule INT_TO_LREAL(I:Int) => Int2Float(I, 100, 0) requires I >=Int -32768 andBool I <=Int 32767
    rule DINT_TO_LREAL(I:Int) => Int2Float(I, 100, 0) requires I >=Int -2147483648 andBool I <=Int 2147483647
    rule SINT_TO_LREAL(I:Int) => Int2Float(I, 100, 0) requires I >=Int -128 andBool I <=Int 127
    rule LINT_TO_LREAL(I:Int) => Int2Float(I, 100, 0) requires I >=Int -2 ^Int 63 andBool I <=Int 2 ^Int 63 -Int 1

    rule UINT_TO_REAL(I:Int) => Int2Float(I, 100, 0) requires I >=Int 0 andBool I <=Int 65535
    rule UDINT_TO_REAL(I:Int) => Int2Float(I, 100, 0) requires I >=Int 0 andBool I <=Int 4294967295
    rule USINT_TO_REAL(I:Int) => Int2Float(I, 100, 0) requires I >=Int 0 andBool I <=Int 255
    rule ULINT_TO_REAL(I:Int) => Int2Float(I, 100, 0) requires I >=Int 0 andBool I <=Int 2 ^Int 64 -Int 1

    rule UINT_TO_LREAL(I:Int) => Int2Float(I, 100, 0) requires I >=Int 0 andBool I <=Int 65535
    rule UDINT_TO_LREAL(I:Int) => Int2Float(I, 100, 0) requires I >=Int 0 andBool I <=Int 4294967295
    rule USINT_TO_LREAL(I:Int) => Int2Float(I, 100, 0) requires I >=Int 0 andBool I <=Int 255
    rule ULINT_TO_LREAL(I:Int) => Int2Float(I, 100, 0) requires I >=Int 0 andBool I <=Int 2 ^Int 64 -Int 1

    rule REAL_TO_UINT(I:Float) => Float2Int(I) requires (-3.402823 *Float 10.0 ^Float 38.0 <=Float I) andBool(I <=Float 3.402823 *Float 10.0 ^Float 38.0) andBool (0 <=Int Float2Int(I)) andBool (Float2Int(I) <=Int 65535)
    rule REAL_TO_UDINT(I:Float) => Float2Int(I) requires (-3.402823 *Float 10.0 ^Float 38.0 <=Float I) andBool(I <=Float 3.402823 *Float 10.0 ^Float 38.0) andBool (0 <=Int Float2Int(I)) andBool (Float2Int(I) <=Int 4294967295)
    rule REAL_TO_USINT(I:Float) => Float2Int(I) requires (-3.402823 *Float 10.0 ^Float 38.0 <=Float I) andBool(I <=Float 3.402823 *Float 10.0 ^Float 38.0) andBool (0 <=Int Float2Int(I)) andBool (Float2Int(I) <=Int 255)
    rule REAL_TO_ULINT(I:Float) => Float2Int(I) requires (-3.402823 *Float 10.0 ^Float 38.0 <=Float I) andBool(I <=Float 3.402823 *Float 10.0 ^Float 38.0) andBool (0 <=Int Float2Int(I)) andBool (Float2Int(I) <=Int 2 ^Int 64 -Int 1)

    rule UINT_TO_INT(I:Int) => I requires 0 <=Int I andBool I <=Int 32767
    rule UINT_TO_DINT(I:Int) => I requires 0 <=Int I andBool I <=Int 65535
    rule UINT_TO_SINT(I:Int) => I requires 0 <=Int I andBool I <=Int 127
    rule UINT_TO_LINT(I:Int) => I requires 0 <=Int I andBool I <=Int 65535

    rule UDINT_TO_INT(I:Int) => I requires 0 <=Int I andBool I <=Int 32767
    rule UDINT_TO_DINT(I:Int) => I requires 0 <=Int I andBool I <=Int 2147483647
    rule UDINT_TO_SINT(I:Int) => I requires 0 <=Int I andBool I <=Int 127
    rule UDINT_TO_LINT(I:Int) => I requires 0 <=Int I andBool I <=Int 4294967295

    rule USINT_TO_INT(I:Int) => I requires 0 <=Int I andBool I <=Int 255
    rule USINT_TO_DINT(I:Int) => I requires 0 <=Int I andBool I <=Int 255
    rule USINT_TO_SINT(I:Int) => I requires 0 <=Int I andBool I <=Int 127
    rule USINT_TO_LINT(I:Int) => I requires 0 <=Int I andBool I <=Int 255

    rule ULINT_TO_INT(I:Int) => I requires 0 <=Int I andBool I <=Int 32767
    rule ULINT_TO_DINT(I:Int) => I requires 0 <=Int I andBool I <=Int 2147483647
    rule ULINT_TO_SINT(I:Int) => I requires 0 <=Int I andBool I <=Int 127
    rule ULINT_TO_LINT(I:Int) => I requires 0 <=Int I andBool I <=Int (2 ^Int 63 -Int 1)

    rule REAL_TO_LREAL(I:Float) => I requires (-3.402823 *Float 10.0 ^Float 38.0 <=Float I) andBool(I <=Float 3.402823 *Float 10.0 ^Float 38.0)
    rule LREAL_TO_REAL(I:Float) => I requires (-3.402823 *Float 10.0 ^Float 38.0 <=Float I) andBool(I <=Float 3.402823 *Float 10.0 ^Float 38.0)

    rule BOOL # I:Int => INT_TO_BOOL(I)
    rule BOOL # I:Bool => I
    rule SINT # I:Int => LINT_TO_SINT(I)
    rule USINT # I:Int => ULINT_TO_USINT(I)
    rule BYTE # I:Bit => 2 # FormalBit(I, 8)
    rule BYTE # I:Int => 2 # FormalBit(Int2Bit(I), 8)
    rule INT # I:Int => LINT_TO_INT(I)
    rule UINT # I:Int => ULINT_TO_UINT(I)
    rule WORD # I:Bit => 2 # FormalBit(I, 16)
    rule WORD # I:Int => 2 # FormalBit(Int2Bit(I), 16)
    rule DINT # I:Int => LINT_TO_DINT(I)
    rule UDINT # I:Int => ULINT_TO_UDINT(I)
    rule DWORD # I:Bit => 2 # FormalBit(I, 32)
    rule DWORD # I:Int => 2 # FormalBit(Int2Bit(I), 32)
    rule REAL # I:Float => LREAL_TO_REAL(I)

endmodule