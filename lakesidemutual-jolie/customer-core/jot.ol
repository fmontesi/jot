from file import File

type Params {
	testsPath:string
}

type FindTestOperationsResponse {
	services* {
		name:string
		beforeAll*:string
		afterAll*:string
		beforeEach*:string
		afterEach*:string
		tests*:string
	}
}

interface JotUtilsInterface {
RequestResponse:
	findTestOperations(string)(FindTestOperationsResponse)
}

service JotUtils {
	inputPort Input {
		location: "local"
		interfaces: JotUtilsInterface
	}
	foreign java {
		class: "jot.JotUtils"
	}
}

service Jot( params:Params ) {
	embed File as files

	main {
		list@files( {
			directory = params.testsPath
			regex = ".*\\.ol"
			recursive = true
		} )( foundFiles )
		for( filepath in foundFiles.result ) {
			findTestOperations@jotUtils( filepath )( result ) // this should check that @Test-annotated ops are RequestResponse
			for( testServiceInfo in result.services ) {
				if( #testServiceInfo.tests > 0 ) {
					// load the testService in the outputPort testService
					for( op in testServiceInfo.beforeAll ) {
						unsafeInvokeRR@reflection( { operation = op } )()
					}
					for( test in testServiceInfo.tests ) {
						for( beforeEach in testService.beforeEach ) {
							unsafeInvokeRR@reflection( { operation = beforeEach, data.testName = test } )()
						}
						unsafeInvokeRR@reflection( { operation = test } )()
						for( afterEach in testService.afterEach ) {
							unsafeInvokeRR@reflection( { operation = afterEach, data.testName = test } )()
						}
					}
					// unsafeInvokeRR@reflection( ... )
					for( op in testServiceInfo.afterAll ) {
						unsafeInvokeRR@reflection( { operation = op } )()
					}
				}
			}
		}
		// findTestOperations@jotUtils( foundFiles )
		/// 

		// we now get the names of all services with tests...
		// we embed these services and we run the tests...
	}
}