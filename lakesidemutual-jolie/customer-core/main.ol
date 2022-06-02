from interfaces import CustomerInformationHolder
from console import Console
from string_utils import StringUtils
type CustomerCoreParams {
	location:string
}

service CustomerCore( /*params:CustomerCoreParams*/ ) {

	embed Console as Console
	embed StringUtils as StringUtils
	
	inputPort Input {
		location: "socket://localhost:5555"
		protocol: http {
			osc.getCustomer << {
				template = "/customers/{ids}"
				method = "get"
			}
			osc.updateCustomer << {
				template = "/customers/{customerId}"
				method = "put"
			}
			// osc.changeAddress << {
			// 	template = "/customers/{customerId}/address"
			// 	method = "put"
			// }
			osc.createCustomer << {
				template = "/customers"
				method = "post"
			}
		}
		interfaces: CustomerInformationHolder
	}

	execution: concurrent

	main {

		[getCustomers(req)(res){
			nullProcess
		}]

		[getCustomer(req)(res){
			valueToPrettyString@StringUtils(req)(prettyReq)
			println@Console(prettyReq)()
			// query string breakssssss 
			// res = {
			// 	customers=void
			// }
			
		}]

		[updateCustomer(req)(res){
			nullProcess
		}]
		

		[createCustomer(req)(res){
			res = {
				customerId = "123"
				firstName = req.firstName
				lastName = req.lastName
				birthday = {
					seconds = req.birthday.seconds
					nanos = req.birthday.nanos
				}
				streetAddress = req.streetAddress
				postalCode = req.postalCode
				city = req.city
				email = req.email
				phoneNumber = req.phoneNumber
				moveHistory {
				}
			}
		}]

		// changeAddress,

	}
}
