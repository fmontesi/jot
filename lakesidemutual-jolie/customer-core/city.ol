from domain import CityLookupService

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
		interfaces: CityLookupService
	}

	execution: concurrent

	main {

		[loadLookupMap(req)(res){
			nullProcess // TODO
		}]

		[getLookupMap(req)(res){
			nullProcess // TODO
		}]

		[getCitiesForPostalCode(req)(res){
			nullProcess // TODO
		}]

	}
}
