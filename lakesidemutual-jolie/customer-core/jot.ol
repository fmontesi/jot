from file import File
from reflection import Reflection
from .jotutils import JotUtils
from string_utils import StringUtils
from console import Console
from runtime import Runtime
type Params {
	testsPath: string
	params: undefined
}

service Jot( params:Params ) {
	embed File as files
	embed JotUtils as jotUtils
	embed Reflection as reflection
	embed StringUtils as stringUtils
	embed Console as console
	embed Runtime as runtime

    outputPort Operation {
    }

	main {
		list@files( {
			directory = params.testsPath
			regex = ".*\\.ol"
			recursive = true
		} )( foundFiles )
		for( filepath in foundFiles.result ) {
			findTestOperations@jotUtils( params.testsPath + "/" + filepath )( result ) // this should check that @Test-annotated ops are RequestResponse
			for( testServiceInfo in result.services ) {
				if( #testServiceInfo.tests > 0 ) {
					testParams = void
					for (p in params.params._){
						if (p.name == filepath) {
							testParams << p.params
						}
					}
					// load the testService in the outputPort testService
					loadEmbeddedService@runtime( {
						filepath = params.testsPath + "/" + filepath
						type = "Jolie"
						service = result.services.name
						params << testParams
					} )( Operation.location )

					for( op in testServiceInfo.beforeAll ) {
						invokeRRUnsafe@reflection( { operation = op, outputPort="Operation" } )()
					}
					for( test in testServiceInfo.tests ) {
						for( beforeEach in testService.beforeEach ) {
							invokeRRUnsafe@reflection( { operation = beforeEach, outputPort="Operation" } )()
						}
						scope(t){
							install(default => println@console("Test failed on operation: " + test + " error: " + t.default)())
							invokeRRUnsafe@reflection( { operation = test, outputPort="Operation" } )()
						}

						for( afterEach in testService.afterEach ) {
							invokeRRUnsafe@reflection( { operation = afterEach, outputPort="Operation" } )()
						}
					}
					// invokeRRUnsafe@reflection( ... )
					for( op in testServiceInfo.afterAll ) {
						invokeRRUnsafe@reflection( { operation = op, outputPort="Operation" } )()
					}
				}
			}
		}
		// findTestOperations@jotUtils( foundFiles )

		// we now get the names of all services with tests...
		// we embed these services and we run the tests...
	}
}