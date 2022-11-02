from .dtos import CustomersResponse

type GetCustomerRequest {
	ids:string
	fields?:string
}

interface CustomerInformationHolder {
RequestResponse:
	getCustomer( GetCustomerRequest )( CustomersResponse )
}