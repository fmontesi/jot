from customer-core.interfaces import CustomerInformationHolder as CustomerInformationHolder_CustomerCore
from customer-management.interfaces import CustomerInformationHolder as CustomerInformationHolder_CustomerManagement
from assertions import Assertions
from console import Console
from string-utils import StringUtils

interface MyTestInterface {
RequestResponse:
	///@BeforeAll
	setup(void)(void) throws TestFailed(string),
	///@Test
	testGetCustomer(void)(void) throws TestFailed(string)
}

service Main {
	embed Assertions as assertions
	embed Console as console
	embed StringUtils as su

	execution: sequential

	outputPort customerCore {
		location: "socket://customer-core:8080"
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
		interfaces: CustomerInformationHolder_CustomerCore
	}

	outputPort customerManagement {
		location: "socket://customer-management:8080"
		protocol: http {
			osc.getCustomer << {
				template = "/customers/{ids}"
				method = "get"
			}
		}
		interfaces: CustomerInformationHolder_CustomerManagement
	}

	inputPort Input {
		location: "local"
		interfaces: MyTestInterface
	}

	main {
		[ setup()() {
			nullProcess
		} ]

		[ testGetCustomer()() {
			request.ids[0] = "zbej74yalh"
			getCustomer@customerCore( request )( responseFromCustomerCore )
			getCustomer@customerManagement( request )( responseFromCustomerManagement )
			equals@assertions( {
				actual << responseFromCustomerCore.customers[0].customerId
				expected << responseFromCustomerManagement.customerId
			} )()
		} ]
	}
}
