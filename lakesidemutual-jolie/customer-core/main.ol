from .interfaces import CustomerInformationHolder
from console import Console
from string-utils import StringUtils
from .repository import CustomerCoreRepository, RepositoryParams

type CustomerCoreParams {
	location: string
	repository: RepositoryParams
}

service CustomerCore( params:CustomerCoreParams ) {
	embed Console as Console
	embed CustomerCoreRepository(params.repository) as repository
	embed StringUtils as StringUtils

	inputPort Input {
		location: params.location
		protocol: http {
			// debug = true
			// debug.showContent = true
			osc.getCustomers << {
				template = "/customers"
				method = "get"
			}
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
			findAll@repository(req)(repo)
			res.filter = "-"
			res.limit = #repo.result
			res.offset = 0
			res.size = #repo.result

            for( customer in repo.result ) {
				undef(customer.password)
                res.customers[#res.customers] << customer
            }
		}]

		[getCustomer(req)(res){
			findAllById@repository(req.ids)(repo)
            for ( customer in repo.result){
				undef(customer.password)
                res.customers[#res.customers] << customer
            }
		}]

		[updateCustomer(req)(res){
			nullProcess
		}]
		

		[createCustomer(req)(res){
			res << {
				customerId = "123"
				firstName = req.firstName
				lastName = req.lastName
				birthday = req.birthday
				streetAddress = req.streetAddress
				postalCode = req.postalCode
				city = req.city
				email = req.email
				phoneNumber = req.phoneNumber
				moveHistory = void
			}
		}]

		// changeAddress,

	}
}
