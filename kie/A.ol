interface AInterface {
    RequestResponse: twice(int)(int)
}

service A {

 inputPort in {
  location: "local"
  interfaces: AInterface
 }

 main { 
    twice(req)(res){
        res = req * 2
    }
 }
}