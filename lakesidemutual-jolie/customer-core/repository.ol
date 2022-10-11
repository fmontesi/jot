from ..spring.jparepository import JpaRepository
from console import Console
from file import File
from string_utils import StringUtils

// implementation of customer core under jpa repository interface
service CustomerCoreRepository {

    inputPort ip {
        location: "local"
        interfaces: JpaRepository
    }

    embed Console as Console
    embed File as File
    embed StringUtils as StringUtils

    execution: concurrent

    init{
        println@Console("initializing CustomerCoreRepository")()
        readFile@File( {
            .filename= "./resources/mock_customers_small.csv"
        } )( csvRes )
        split@StringUtils( csvRes {
            .regex="\\R"
        } )( lines )

        split@StringUtils( lines.result[ 0 ] {
            .regex=","
        } )( header )

        global.customers = undefined
        for ( i = 1, i < #lines.result, i++ ) {
            split@StringUtils( lines.result[i] {
                .regex=","
            } )( cell )

            for ( j = 0, j < #header.result, j++ ) {
                global.customers[i-1].(header.result[j]) = cell.result[j]
            }
        }
    }

    main{

        [findAll(req)(res){
            for ( customer in global.customers){
                res.result[#res.result] << customer
            }
        }]

        [findAllById(req)(res){
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