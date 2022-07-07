from .jotutils import JotUtils
from console import Console
from string-utils import StringUtils

service main {
	embed JotUtils as jotUtils
	embed Console as Console
	embed StringUtils as StringUtils
	main {
		findTestOperations@jotUtils( "/home/nau/sdu/jot/lakesidemutual-jolie/customer-core/test/CustomerInformationHolderTests.ol" )( result ) // this should check that @Test-annotated ops are RequestResponse
		valueToPrettyString@StringUtils(result)(p)
		println@Console(p)()
	}
}