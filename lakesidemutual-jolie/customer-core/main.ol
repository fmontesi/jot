from interface import CustomerInformationHolder
type CustomerCoreParams {
	location:string
}

service CustomerCore( params:CustomerCoreParams ) {
	inputPort Input {
		location: params.location
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
			// osc.createCustomer << {
			// 	template = "/customers"
			// 	method = "post"
			// }
		}
		interfaces: CustomerInformationHolder
	}
}
