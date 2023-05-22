require "st-semantic-while.k"
require "st-syntax.k"

module ST-SEMANTIC-FOR

    imports ST-SYNTAX
    imports ST-SEMANTIC-WHILE
    
//    rule FOR E1:Id TO E2:Expression DO S:StatementLists END_FOR; => exec( IF E1 <> E2 THEN {S} END_IF; WHILE E1 <> E2 DO E1 := E1 + 1; {S} END_WHILE;)       [structural]
//    rule FOR E1:Id TO E2:Expression BY E3:Expression DO S:StatementLists END_FOR; => exec(IF E1 <> E2 THEN {S} END_IF; WHILE E1 <> E2 DO E1 := E1 + E3; {S} END_WHILE;)  [structural]
    rule FOR E1:Id := E:Expression TO E2:Expression DO S:StatementLists END_FOR; => E1 := E; ~> exec(WHILE E1 <= E2 DO E1 := E1 + 1; {S} END_WHILE;)       [structural]
    rule FOR E1:Id := E:Expression TO E2:Expression BY E3:Expression DO S:StatementLists END_FOR; => E1 := E; ~> exec(WHILE E1 <= E2 DO E1 := E1 + E3; {S} END_WHILE;)  [structural]

endmodule
