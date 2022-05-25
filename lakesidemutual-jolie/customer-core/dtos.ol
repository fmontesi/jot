type Address {
	streetAddress:string
	postalCode:string
	city:string
}

type Email:string(regex("^(.+)@(.+)$"))
type PhoneNumber:string(regex(???))

type CustomerProfileUpdateRequest {
	firstName:string
	lastName:string
	birthday:???
	streetAddress:string
	postalCode:string
	city:string
	email:Email
	phoneNumber:PhoneNumber
}

type CustomerResponse {
	customerId:string
	firstName:string
	lastName:string
	birthday:???
	streetAddress:string
	postalCode:string
	city:string
	email:Email
	phoneNumber:PhoneNumber
	moveHistory {
		address*:Address
	}
}

type CustomersResponse {
	customers*:Customer
}

type PaginatedCustomerResponse {
	filter:string
	limit:int
	offset:int
	size:int
	customers*:Customer
}

type CustomerNotFoundExceptionType:string

type City:string

type CitiesResponse {
	cities*:City
}
