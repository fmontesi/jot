interface AInterface {
    RequestResponse: twice(int)(int)
}

service A {
 inputPort in {
  location: "local"
  interfaces: AInterface
 }
 execution : concurrent
 main { 
    twice(req)(res){
        res = req * 2
    }
 }
}