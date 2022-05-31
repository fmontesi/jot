type CityLookupServiceParams {
	location:string
}

service CityLookupService( params:CityLookupServiceParams ) {
	inputPort Input {
		location: params.location
		protocol: http {
			osc.getCitiesForPostalCode << {
				template = "/cities/{postalCode}"
				method = "get"
			}
		}
	}
}
