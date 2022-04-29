from providerInterface import GetInput_isEvenInterface

service GetInput_isEven_Service {

 inputPort in {
  location: "local"
  interfaces: GetInput_isEvenInterface
 }

 main {
  getInput_isEven()( out ){
   throw( UnimplementedTest )
   // out = 5
  }
 }

}