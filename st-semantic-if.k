require "st-syntax.k"
require "st-semantic-bool.k" 

module ST-SEMANTIC-IF 

    imports ST-SYNTAX
    imports ST-SEMANTIC-BOOL
    
    rule IF true THEN S:StatementLists END_IF; => {S}                              [structural]
    rule IF false THEN _:StatementLists END_IF; => .                             [structural]
    rule IF true THEN S:StatementLists _:ElseIfBlock END_IF; => {S}                [structural]
    rule IF false THEN _:StatementLists ELSE S:StatementLists END_IF; => {S}           [structural]
    rule IF false THEN _:StatementLists ELSIF E:Expression THEN S:StatementLists END_IF; => IF E THEN S END_IF;  [structural]
    rule IF false THEN _:StatementLists ELSIF E:Expression THEN S:StatementLists EIB:ElseIfBlock END_IF; => IF E THEN S EIB END_IF;  [structural]

endmodule