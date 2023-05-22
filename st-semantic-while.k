require "st-syntax.k"
require "st-semantic-if.k"
require "st-configuration.k"

module ST-SEMANTIC-WHILE 

    imports ST-SYNTAX
    imports ST-SEMANTIC-IF
    imports ST-CONFIGURATION

    rule WHILE E:Expression DO S:StatementLists END_WHILE; => IF E THEN exec({S} WHILE E DO S END_WHILE;) END_IF; 

    rule <k> exec(S:StatementLists) ~> K => {{S} EXIT;}</k>
         <break> .List => ListItem(loopinfo(K)) ...</break>

    rule <k> EXIT; ~> _ => K </k>
         <break> ListItem(loopinfo(K)) => .List ...</break>

endmodule