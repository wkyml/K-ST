require "st-syntax.k"

module ST-CONFIGURATION 

    imports ST-SYNTAX

    configuration <T> 
    
        <k color="red"> ($PGM:Unit ~> execute) </k>
        <control color="orange">
            <fstack color="brown"> .List </fstack>
            <gvid color="gray"> .Ids </gvid>
            <env color="Fuchsia"> .Map </env> 
            <enummap color="cyan"> .Map </enummap>
            <count color="blue"> 0:Int </count>
            <break color="yellow"> .List </break>
            <print> .AllExps </print>
        </control>
        <allenv color="violet"> .Map </allenv>
        <genv color="tomato"> .Map </genv>
        <gvenv color="pink"> .Map </gvenv>
        <store color="coral"> .Map </store>
        <type color="lime"> .Map </type>
        <constant color="green"> .Map </constant>
        <input stream = "stdin"> .List </input>
        <output stream = "stdout"> .List </output>
        <cover> .Map </cover>
        <nextLoc color="slateblue"> 0:Int </nextLoc>
    </T>
 
 
 
 
endmodule