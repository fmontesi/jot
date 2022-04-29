from Service import Service, ServiceInterface // should it be auto imported? via filename reference
from Testing import TestInterface // contains before()(), beforeAll()(), after()(), afterAll()(),  

service ServiceTest {

 inputPort in {
  location: "local"
  interfaces: TestInterface
 }

 outputPort out {
  location: "local"
  interfaces: serviceInterface, TestInterface
 }


// implementation of hooks
 courier in {
    beforeAll()(){
        //  preparation before begins
        // (1)
    }
    before()(){
        //  preparation before begins each testCases
        // (2)
    }
    after()(){
        //  teardown after each testCases
        // (3)
    }
    afterAll()(){
        //  teardown after all testCases run
        // (4)
    }
 }

 // this line is required by jot to specify a Service to test
 embed Service as Target

 init {
     // testCases should be strictly type? 
     testCases << {
         .t1.name = "testcase1"
         .t1.op = "op1" // or op2
         .t1.request = {...} // request data
         .t1.expected = {...} // expectation
         .t1.expectedThrow = ErrorType  // expect to throws an error, optional?
         .t1.errorMsg = "print if error"
        //  ... t2, t3...
     }
 }

// these lines are auto generated by jot

//  main { 
//     beforeAll@out()() 
//     for( testCase in testCases ) {
//         scope(test){
//             install( this =>
//             //  check testCase.expectedThrow and throw if error 
//             )

//             before@out()()

//             testCase.[...].op@Target(testCase.[...].request)(res)

//             assert res against testCase.[...].expected
            
//             if fail
//                 println@Console( testCase.[...].errorMsg )()

//             after@out()()
//         }
//     }

//     afterAll@out()()
//  }
}