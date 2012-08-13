# Global variables
$global:errorCount = 0
$global:testCount = 0
$global:failureCount = 0
$global:failFlag = $false

function setup {
	# Create the xml document for the report
	$global:xmlDoc = New-Object System.Xml.XmlDocument
	$xmlDec = $xmlDoc.CreateXmlDeclaration("1.0", "utf-8", $null)

	$rootNode = $global:xmlDoc.CreateElement("testsuites")
	$global:xmlDoc.InsertBefore($xmlDec, $xmlDoc.DocumentElement)
	$global:xmlDoc.AppendChild($rootNode)

	$global:testsuiteNode = $global:xmlDoc.CreateElement("testsuite")
	$global:testsuiteNode.Attributes.Append($global:xmlDoc.CreateAttribute("errors"))
	$global:testsuiteNode.Attributes.Append($global:xmlDoc.CreateAttribute("tests"))
	$global:testsuiteNode.Attributes.Append($global:xmlDoc.CreateAttribute("failures"))
	$global:testsuiteNode.Attributes.Append($global:xmlDoc.CreateAttribute("name"))
	$global:testsuiteNode.SetAttribute("name", "Tests")
	$global:testsuiteNode.Attributes.Append($global:xmlDoc.CreateAttribute("id"))
	$global:testsuiteNode.SetAttribute("id", 1)
	$global:xmlDoc.DocumentElement.PrependChild($testsuiteNode)
}

function tearDown {
	$global:testsuiteNode.SetAttribute("errors", $global:errorCount)
	$global:testsuiteNode.SetAttribute("tests", $global:testCount)
	$global:testsuiteNode.SetAttribute("failures", $global:failureCount)
	
	$xmlDoc.Save("$env:WORKSPACE\testResults.xml")
	
	# Fail the job if any of the tests failed
	if ($global:failFlag) {
	    exit 1
	}
}

function executeTest($description, $expected, $actual) {
	$global:testCount++
	
    # Create the test case node
	$testcaseNode = $global:xmlDoc.CreateElement("testcase")
	$testcaseNode.Attributes.Append($global:xmlDoc.CreateAttribute("name"))
	$testcaseNode.SetAttribute("name", $description)
	$testcaseNode.Attributes.Append($global:xmlDoc.CreateAttribute("classname"))
	$testcaseNode.SetAttribute("classname", "Tests")
	$testcaseNode.Attributes.Append($global:xmlDoc.CreateAttribute("time"))
	

	# 'Run' the test, time it
	$stopwatch = New-Object System.Diagnostics.Stopwatch
	$stopwatch.Start()
	
	if ($expected -ne $actual) {
		$global:failureCount++
		$global:errorCount++
		$failureNode = $global:xmlDoc.CreateElement("failure")
		$failureNode.Attributes.Append($global:xmlDoc.CreateAttribute("type"))
		$failureNode.SetAttribute("type", "failure")
		$failureNode.Attributes.Append($global:xmlDoc.CreateAttribute("message"))
		$failureNode.SetAttribute("message", "Expected '$description' to be '$expected' was '$actual'")
		$testcaseNode.PrependChild($failureNode)
	}
	
	# Stop the stopwatch
	$stopwatch.Stop()
	
	# Finalize the report bits for this test
	$testcaseNode.SetAttribute("time", $stopwatch.ElapsedMilliseconds)
	$global:testsuiteNode.PrependChild($testcaseNode)
}