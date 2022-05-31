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
            .filename= "/workspaces/jot/lakesidemutual-jolie/customer-core/resources/mock_customers_small.csv"
        } )( csvRes )
        split@StringUtils( csvRes {
            .regex="\\R"
        } )( lines )
        // valueToPrettyString@StringUtils( lines )( prettyLine )

        // println@Console("read result " + prettyLine)()

        split@StringUtils( lines.result[ 0 ] {
            .regex=","
        } )( header )

        global.customers = undefined
        global.customers[0].id = 111
        for ( i = 1, i < #lines.result, i++ ) {
            println@Console( "line[" + i + "] = " + lines.result[i] )()

            split@StringUtils( lines.result[i] {
                .regex=","
            } )( cell )

            for ( j = 0, j < #header.result, j++ ) {
                global.customers[i].(header.result[j]) = cell.result[j]
            }

            valueToPrettyString@StringUtils( global.customers[i] )( prettyLine )
            println@Console("prettyLine " + prettyLine)()

        }

        println@Console("eee " + global.customers[0].id )()

        valueToPrettyString@StringUtils( global.customers )( prettyLine )
        println@Console("ee " + prettyLine)()

        // foreach( line : lines.result ){
        //     println@Console("read result " + line)()

        //     valueToPrettyString@StringUtils( line )( prettyLine )
        //     println@Console("prettyLine " + prettyLine)()
        // }

    }

    main{

        [findAll(req)(res){
            nullProcess // TODO    
        }]

        [findAllById(req)(res){
            nullProcess // TODO
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
            nullProcess // TODO
        }]

    }
}