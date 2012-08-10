JenkinsPowerShellTestFramework
==============================

A lightweight PowerShell testing framework intended to be used with Jenkins.

Required Plugins:
-----------------
* Hudson PowerShell plugin

Usage:
------
Drop the 'framework.ps1' file into the workspace of the Jenkins job to be used for testing.  Select the post-build action 'Publish JUnit test result report' pointing to the generated '\testResults.xml' file.
