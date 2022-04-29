from providerInterface import ProviderInterface
from checkOutput_isEven_Service import CheckOutput_isEven_Service
from getInput_isEven_Service import GetInput_isEven_Service


service Provider {

  embed GetInput_isEven_Service as GetInput_isEven_Service
  embed CheckOutput_isEven_Service as CheckOutput_isEven_Service

  inputPort in {
    location: "local"
    interfaces: ProviderInterface
    aggregates: GetInput_isEven_Service, CheckOutput_isEven_Service
  }

  main{
    close()
  }
  
}