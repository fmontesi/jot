from providerInterface import CheckOutput_isEvenInterface

service CheckOutput_isEven_Service {

 inputPort in {
  location: "local"
  interfaces: CheckOutput_isEvenInterface
 }

 main {
  checkOutput_isEven( req )( res ){
   throw( UnimplementedTest )
   // if( req ){
   //  res << { .errorMsg = "Expecting false" }
   // }
  }
 }

}