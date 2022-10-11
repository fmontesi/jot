from ..interfaces import CustomerInformationHolder
from ..main import CustomerCore
from assertions import Assertions
from console import Console

type TestParams {
	location:string
}

interface MyTestInterface {
RequestResponse:
	// ///@BeforeAll
	// op1,
	// ///@AfterAll
	// op2,

	// ///@Test
	// testBlah(void)(void) throws TestFailed(string),
	///@Test
	testGetCustomers(void)(void) throws TestFailed(string)
}

service main( params:TestParams ) {
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
			osc.getCustomers << {
				template = "/customers"
				method = "get"
			}
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
		// [ op1()() {
		// 	println@console( "op1 is called" )()
		// } ]
		// [ op2()() {
		// 	println@console( "op2 is called" )()
		// } ]

		[ testGetCustomers()() {
			getCustomers@customerCore({filter=""})(response)
			len = #response.customers
			equals@assertions( {
				actual = len
				expected = 8 // 9
			})()
			
		} ]

		// [ testBlah()() {
		// 	createCustomer@customerCore( {
		// 		firstName = "Max"
		// 		lastName = "Mustermann"
		// 		birthday = 16546
		// 		streetAddress = "Oberseestrasse 10"
		// 		postalCode = "8640"
		// 		city = "Rapperswil"
		// 		email = "max@example.com"
		// 		phoneNumber = "055 222 41 11"
		// 	} )( response )
		// 	equals@assertions( {
		// 		actual -> response
		// 		expected << {
		// 			customerId = response.customerId
		// 			firstName = "Max"
		// 			lastName = "Mustermann"
		// 			birthday = 16546
		// 			streetAddress = "Oberseestrasse 10"
		// 			postalCode = "8640"
		// 			city = "Rapperswil"
		// 			email = "max@example.com"
		// 			phoneNumber = "055 222 41 11"
		// 			moveHistory = void
		// 		}
		// 	} )()
		// } ]
	}
}