from targetInterface import TargetInterface

service Target {

 execution: single

 inputPort in {
  location: "local"
  interfaces: TargetInterface
 }

 main {
  isEven( req )( req % 2 == 0 )
 }

}