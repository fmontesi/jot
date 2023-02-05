from .dtos import CustomerResponse, CustomerProfileUpdateRequest, CustomerId

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
	getCustomer( GetCustomerRequest )( CustomerResponse ) throws CustomerNotFound,
	updateCustomer( UpdateCustomerRequest )( CustomerResponse )  
}
