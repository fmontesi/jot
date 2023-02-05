from ..customer-core.interfaces import CustomerInformationHolder as CustomerCoreCustomerInformationHolder
from .interfaces import CustomerInformationHolder 
from console import Console
from string-utils import StringUtils

type CustomerManagementParams {
	location: string
	customerCoreLocation: string
}

service CustomerManagement( params: CustomerManagementParams ) {

	embed Console as console
	embed StringUtils as stringUtils

	outputPort customerCore {
		location: params.customerCoreLocation
		protocol: http {
			osc.getCustomer << {
				template = "/customers/{ids}"
				method = "get"
			}
			osc.updateCustomer << {
				template = "/customers/{customerId}"
				method = "put"
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
           		statusCodes.CustomerNotFound = 404
			}
			osc.updateCustomer << {
				template = "/customers/{customerId}"
				method = "put"
			}
		}
		interfaces: CustomerInformationHolder
	}

	main {
		getCustomer( request )( response ) {
			scope ( getCustomer ){
				getCustomer@customerCore( request )( customerCoreResponse )
				if (#customerCoreResponse.customers > 0 && customerCoreResponse.customers.customerId != ""){
					response << customerCoreResponse.customers[0]
				} else {
					throw( CustomerNotFound )
				}
			}
		}
		updateCustomer( request )( response ) {
			updateCustomer@customerCore( request )( response )
		}
	}
}