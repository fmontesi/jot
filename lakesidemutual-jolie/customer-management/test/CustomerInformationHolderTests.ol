from ..interfaces import CustomerInformationHolder
from ..main import CustomerManagement, CustomerManagementParams
from assertions import Assertions
from console import Console

type TestParams: CustomerManagementParams

interface MyTestInterface {
RequestResponse:
	// /// @Test
	testGetCustomer(void)(void) throws TestFailed(string),
	/// @Test
	testGetCustomerNotFound(void)(void) throws TestFailed(string),
	// /// @Test
	testUpdateCustomer(void)(void) throws TestFailed(string),
}

service TestCustomerManagement( params:TestParams ) {

	embed CustomerManagement( params )
	embed Assertions as assertions
	embed Console as console

	execution: sequential

	outputPort CustomerManagement {
		location: params.location
		protocol: http {
			osc.getCustomer << {
				template = "/customers/{ids}"
				method = "get"
				statusCodes.CustomerNotFound = 404
			}
			osc.updateCustomer << {
				template = "/customers/{customerId}"
				method = "put"
			}
			format = "json"
		}
		interfaces: CustomerInformationHolder
	}

	inputPort Input {
		location: "local"
		interfaces: MyTestInterface
	}

	main {
		[ testGetCustomer()() {
			getCustomer@CustomerManagement({ids= "zbej74yalh"})(response)
			equals@assertions( {
				actual = response.customerId
				expected = "zbej74yalh"
			})()
		} ]

		[ testGetCustomerNotFound()() {
			scope ( test ){
				install( CustomerNotFound => nullProcess)
				getCustomer@CustomerManagement({ids= "smt"})(response)
				if ( is_defined(response) ){
					throw(TestFailed, "expect CustomerNotFound")
				}
			}
		} ]

		[ testUpdateCustomer()() {
			updateCustomer@CustomerManagement({
				customerId = "rgpp0wkpec"
				requestDto << {
					firstName = "Dane"
					lastName = "Joe"
					birthday = "1/1/2022"
					streetAddress = "Some street"
					postalCode = "postalccc"
					city = "Some City"
					email = "a@a.com"
					phoneNumber = "01230304030"
				}
			})(actual)
			equals@assertions( {
				actual = actual
				expected = {
					birthday = "1/1/2022"
					firstName = "Dane"
					lastName = "Joe"
					phoneNumber = "01230304030"
					streetAddress = "Some street"
					city = "Some City"
					postalCode = "postalccc"
					customerId = "rgpp0wkpec"
					email = "a@a.com"
				}
			})()
		} ]

	}
}