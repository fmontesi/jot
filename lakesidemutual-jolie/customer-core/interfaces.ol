from .dtos import CitiesResponse

interface CityReferenceDataHolder {
RequestResponse:
	getCitiesForPostalCode(string)(CitiesResponse)
}

type GetCustomerRequest {
	filter?:string //< default: ""
	limit?:int //< default: 10
	offset?:int //< default: 0
	fields?:string //< default: ""
}

type GetCustomerRequest {
	ids:string
	fields?:string
}

type UpdateCustomerRequest {
	customerId:CustomerId
	requestDto:CustomerProfileUpdateRequest
}

interface CustomerInformationHolder {
RequestResponse:
	getCustomers(GetCustomersRequest)(PaginatedCustomerResponse),
	getCustomer(GetCustomerRequest)(CustomersResponse),
	updateCustomer(UpdateCustomerRequest)(CustomerResponse),
	// changeAddress,
	// createCustomer
}