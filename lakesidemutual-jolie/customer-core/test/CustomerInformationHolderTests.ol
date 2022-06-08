from ..interfaces.CustomerInformationHolder
from values import ComparisonRequest

interface AssertionsInterface {
RequestResponse:
	equals(ComparisonRequest)(void) throws AssertionError(ValueDiff)
}

service Assertions {
	execution: concurrent

	embed Values as values

	inputPort Input {
		location: "local"
		interfaces: AssertionsInterface
	}

	main {
		equals( request )() {
			if( !equals@values( request ) ) {
				throw( AssertionError, diff@values( request ) )
			}
		}
	}
}

type TestParams {
	location:string
}

service Main( params:TestParams ) {
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

	main {
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
				customerId = 123
				firstName = "Max"
				lastName = "Mustermann"
				birthday = 16546
				streetAddress = "Oberseestrasse 10"
				postalCode = "8640"
				city = "Rapperswil"
				email = "max@example.com"
				phoneNumber = "055 222 41 11"
				moveHistory = void
			}
		} )
	}
}