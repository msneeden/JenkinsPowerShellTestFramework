JenkinsPowerShellTestFramework
==============================

A lightweight PowerShell testing framework intended to be used with Jenkins.

Required Plugins:
-----------------
* Hudson PowerShell plugin

Usage:
------
Drop the 'framework.ps1' file into the workspace of the Jenkins job to be used for testing.  Select the post-build action 'Publish JUnit test result report' pointing to the generated '\testResults.xml' file.

In the Jenkins job, add a 'Windows PowerShell' build step, load the 'framework.ps1' file.  Call the 'setup' function to intialize the reporting bits.  For each test to be executed call the 'executeTest' function.  Close the build step by calling the 'tearDown' function to finalize the reporting bits and generate the report file.