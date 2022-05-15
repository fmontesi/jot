interface TestInterface {
    RequestResponse: beforeAll(void)(void),
    before(void)(void),
    afterAll(void)(void),
    after(void)(void)
}

service Test {
    inputPort testInput{
        location: "local"
        interfaces: TestInterface
    }

    execution: concurrent

    main{
        [beforeAll(req)(res){
            nullProcess
        }]
        [before(req)(res){
            nullProcess
            
        }]
        [afterAll(req)(res){
            nullProcess
            
        }]
        [after(req)(res){
            nullProcess
            
        }]
    }
}