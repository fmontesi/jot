from ..interfaces import CustomerInformationHolder
from ..main import CustomerCore, CustomerCoreParams
from assertions import Assertions
from console import Console

type TestParams: CustomerCoreParams

interface MyTestInterface {
RequestResponse:
	/// @Test
	testGetCustomer(void)(void) throws TestFailed(string)
}

service main( params:TestParams ) {
	embed Assertions as assertions
	embed Console as console

	execution: sequential

	outputPort customerCore {
		location: params.location
		protocol: http {
			osc.getCustomer << {
				template = "/customers/{ids}"
				method = "get"
			}
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

	outputPort customerManagement {
		location: params.location
		protocol: http {
			osc.getCustomer << {
				template = "/customers/{ids}"
				method = "get"
			}
		}
		interfaces: CustomerInformationHolder
	}

	inputPort Input {
		location: "local"
		interfaces: MyTestInterface
	}

	main {
		[ testGetCustomer()() {
			request.ids[0] = "zbej74yalh"
			getCustomer@customerCore( request )( responseFromCustomerCore )
			getCustomer@customerManagement( request )( responseFromCustomerManagement )
			equals@assertions( {
				actual << responseFromCustomerCore
				expected << responseFromCustomerManagement
			})()
		} ]
	}
}