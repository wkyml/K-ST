require "st-syntax.k"
require "st-semantic-while.k"
require "st-semantic-bool.k"

module ST-SEMANTIC-REPEAT 

    imports ST-SYNTAX
    imports ST-SEMANTIC-WHILE

    rule REPEAT S:StatementLists UNTIL E:Expression END_REPEAT; => exec({S} WHILE (NOT E) DO S END_WHILE;)  [structural]
    

endmodule