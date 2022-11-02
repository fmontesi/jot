from customer-core.interfaces import CustomerInformationHolder as CustomerCoreCustomerInformationHolder
from .interfaces import CustomerInformationHolder 

type Params {
	location: string
	customerCoreLocation: string
}

service CustomerManagement( params: Params ) {
	outputPort customerCore {
		location: params.customerCoreLocation
		protocol: http {
			osc.getCustomer << {
				template = "/customers/{ids}"
				method = "get"
			}
		}
		interfaces: CustomerCoreCustomerInformationHolder
	}

	inputPort Input {
		location: params.location
		protocol: http {
			osc.getCustomer << {
				template = "/customers/{ids}"
				method = "get"
			}
		}
		interfaces: CustomerInformationHolder
	}

	main {
		getCustomer( request )( response ) {
			getCustomer@customerCore( request )( response )
		}
	}
}