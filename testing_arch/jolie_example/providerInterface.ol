type CheckResultType: void | void { errorMsg: string }
type UnimplementedTest: void

interface GetInput_isEvenInterface {
 requestResponse: 
  getInput_isEven( void )( int ) throws UnimplementedTest
}

interface CheckOutput_isEvenInterface {
  requestResponse: 
   checkOutput_isEven( bool )( CheckResultType ) throws UnimplementedTest
}

interface ProviderInterface {
  oneWay: close( void )
}