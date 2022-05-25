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
		}
	}
}