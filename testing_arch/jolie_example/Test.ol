from targetInterface import TargetInterface
from providerInterface import ProviderInterface, GetInput_isEvenInterface, CheckOutput_isEvenInterface
from console import Console
from Provider import Provider
from Target import Target

service Test {

 outputPort Target {
  location: "socket://localhost:9000"
  protocol: sodep
  interfaces: TargetInterface
 }

 outputPort Provider {
  interfaces: ProviderInterface, GetInput_isEvenInterface, CheckOutput_isEvenInterface
 }

 embed Console as Console
 embed Provider in Provider
 embed Target in Target

 main {
  getInput_isEven@Provider()( t1_req )
  isEven@Target( t1_req )( t1_res )
  checkOutput_isEven@Provider( t1_res )( t1_check )
  if( is_defined( t1_check.errorMsg ) ){
   throw( FailedTest_isEven, t1_check.errorMsg )
  }
  println@Console( "All tests passed" )()
 }
}