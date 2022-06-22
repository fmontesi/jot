from ..interfaces import CustomerInformationHolder
from ..main import CustomerCore
from assertions import Assertions
from jot import TestInterface
from console import Console

type TestParams {
	location:string
}

interface MyTestInterface {
RequestResponse:
	///@BeforeAll
	op1,
	///@BeforeAll
	op2,

	///@Test
	testBlah(void)(void) throws TestFailed(string)
}

service Main( params:TestParams ) {
	embed CustomerCore( params )
	embed Assertions as assertions
	embed Console as console

	execution: sequential

	outputPort customerCore {
		location: params.location
		protocol: http {
			// osc.getCustomer << {
			// 	template = "/customers/{ids}"
			// 	method = "get"
			// }
			osc.createCustomer << {
				template = "/customers"
				method = "post"
			}
			format = "json"
		}
		interfaces: CustomerInformationHolder
	}

	inputPort Input {
		location: "local"
		interfaces: MyTestInterface
	}

	main {
		[ beforeAll()() {
			println@console( "beforeAll" )()
		} ]

		[ afterAll()() {
			println@console( "afterAll" )()
		} ]

		[ beforeEach( request )() {
			println@console( "beforeEach " + request.testName )()
		} ]

		[ afterEach( request )() {
			println@console( "afterEach " + request.testName )()
		} ]

		[ testBlah()() {
			createCustomer@customerCore( {
				firstName = "Max"
				lastName = "Mustermann"
				birthday = 16546
				streetAddress = "Oberseestrasse 10"
				postalCode = "8640"
				city = "Rapperswil"
				email = "max@example.com"
				phoneNumber = "055 222 41 11"
			} )( response )
			equals@assertions( {
				actual -> response
				expected << {
					customerId = response.customerId
					firstName = "Mx"
					lastName = "Mustermann"
					birthday = 16546
					streetAddress = "Oberseestrasse 10"
					postalCode = "8640"
					city = "Rapperswil"
					email = "max@example.com"
					phoneNumber = "055 222 41 11"
					moveHistory = {}
				}
			} )()
		} ]
	}
}