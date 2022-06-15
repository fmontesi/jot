type BeforeEachRequest {
	testName:string
}

type AfterEachRequest {
	testName:string
}

interface TestInterface {
RequestResponse:
	beforeAll(void)(void),
	afterAll(void)(void),
	beforeEach(BeforeEachRequest)(void),
	afterEach(AfterEachRequest)(void)
}