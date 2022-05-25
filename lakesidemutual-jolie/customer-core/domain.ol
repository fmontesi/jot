///@ValueObject
type Address {
	id:long
	streetAddress:string
	postalCode:string
	city:string
}

///@ValueObject
type CustomerId:string

interface CustomerIdAPI {
RequestResponse:
	random(void)(CustomerId)
}

///@Entity
type CustomerProfile {
	firstName:string
	lastName:string
	birthday:??? // TODO
	currentAddress:Address
	email:string
	phoneNumber:string
	moveHistory {
		address*:Address
	}
}

/*
type MoveToAddressCustomerProfileRequest {
	customerProfile:CustomerProfile
	address:Address
}

interface CustomerProfileAPI {
RequestResponse:
	moveToAddress(MoveToAddressCustomerProfileRequest)(CustomerProfile)
}
*/

///@AggregateRoot
type Customer {
	///@Identifier
	id:CustomerId
	customerProfile:CustomerProfile
}

///@ValueObject
type MoveToAddressRequest {
	customerId:CustomerId
	address:Address
}

///@ValueObject
type UpdateCustomerProfileRequest {
	customerId:CustomerId
	updatedCustomerProfile:CustomerProfile
}

interface CustomerAPI {
RequestResponse:
	moveToAddress(MoveToAddressRequest)(void),
	updateCustomerProfile(UpdateCustomerProfileRequest)(void)
}

interface CustomerFactoryAPI {
RequestResponse:
	createCustomer(CustomerProfile)(CustomerAggregate)
	//, formatPhoneNumber
}

/*
///@DDDService
interface CityLookupService {
RequestResponse:
	loadLookupMap(???)(???),
	getLookupMap(???)(???),
	getCitiesForPostalCode(???)(???)
}
*/