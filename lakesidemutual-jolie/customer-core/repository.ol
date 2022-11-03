from spring.jparepository import JpaRepository
from console import Console
from file import File
from string_utils import StringUtils
from database import ConnectionInfo, Database

type RepositoryParams {
    connectionInfo: ConnectionInfo
}

// implementation of customer core under jpa repository interface
service CustomerCoreRepository(p : RepositoryParams) {

    inputPort ip {
        location: "local"
        interfaces: JpaRepository
    }

    embed Console as Console
    embed File as File
    embed StringUtils as StringUtils
    embed Database as Database

    execution: concurrent

    init {
        println@Console("initializing CustomerCoreRepository")()
        connect@Database( p.connectionInfo )( void )
        checkConnection@Database()()
        println@Console("connection success")()
        
    }

    main{

        [findAll(req)(res){
	        queryRequest =
	            "SELECT * FROM customers;";
	        query@Database( queryRequest )( queryResponse );
            for ( customerRaw in queryResponse.row){
                res.result[#res.result] << {
                    birthday = customerRaw.birthday
                    firstName = customerRaw.firstName
                    lastName = customerRaw.lastName
                    password = customerRaw.password
                    phoneNumber = customerRaw.phoneNumber
                    streetAddress = customerRaw.streetAddress
                    city = customerRaw.city
                    postalCode = customerRaw.postalCode
                    customerId = customerRaw.customerId
                    email = customerRaw.email
                }
            }
        }]

        [findAllById(req)(res){
	        queryRequest =
	            "SELECT * FROM customers WHERE customerId = :customerId;";
            queryRequest.customerId= req
	        query@Database( queryRequest )( queryResponse );
            for ( customerRaw in queryResponse.row){
                res.result[#res.result] << {
                    birthday = customerRaw.birthday
                    firstName = customerRaw.firstName
                    lastName = customerRaw.lastName
                    password = customerRaw.password
                    phoneNumber = customerRaw.phoneNumber
                    streetAddress = customerRaw.streetAddress
                    city = customerRaw.city
                    postalCode = customerRaw.postalCode
                    customerId = customerRaw.customerId
                    email = customerRaw.email
                }
            }

            for ( customer in global.customers){
                if (req == customer.customerId){
                    res.result[#res.result]  << customer
                }
            }
        }]

        [saveAll(req)(res){
            nullProcess // TODO
        }]

        [flush(req)(res){
            nullProcess // TODO
        }]

        [saveAndFlush(req)(res){
            nullProcess // TODO
        }]

        [saveAllAndFlush(req)(res){
            nullProcess // TODO
        }]

        [deleteAllInBatch(req)(res){
            nullProcess // TODO
        }]

        [deleteAllByIdInBatch(req)(res){
            nullProcess // TODO
        }]

        [getById(req)(res){
            for ( customer in global.customers){
                if (req == customer.customerId){
                    res << customer
                }
            }
        }]

    }
}