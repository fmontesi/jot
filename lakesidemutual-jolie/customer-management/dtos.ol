type CustomerId:string

type Address {
	streetAddress:string
	postalCode:string
	city:string
}

type Email:string(regex(".*@.*\\..*"))
type PhoneNumber:string//(regex(???))

type CustomerProfileUpdateRequest {
	firstName:string
	lastName:string
	// birthday:Instant
	birthday:string
	streetAddress:string
	postalCode:string
	city:string
	email:Email
	phoneNumber:PhoneNumber
}

type CustomerResponse {
	customerId? :string
	firstName? :string
	lastName? :string
	birthday? :string
	streetAddress? :string
	postalCode? :string
	city? :string
	email? :Email
	phoneNumber? :PhoneNumber
	moveHistory? {
		address*:Address
	}
}

type CustomersResponse {
	customers*:CustomerResponse
}