package jot.JotUtils;

import jolie.runtime.JavaService;
import jolie.runtime.Value;
import jolie.runtime.embedding.RequestResponse;
import jolie.lang.parse.util;

public class JotUtils extends JavaService {

    @RequestResponse()
    public Value findTestOperations(Value value) {
        String source_path = value.strValue();
        // parse the source
        // next time, continue from here, parse the source
        ParsingUtils.parseProgram( ... )
        return null;
    }
}
