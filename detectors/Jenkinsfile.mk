ifndef JENKINS_URL
$(error No JENKINS_URL defined)
endif

##@ Jenkins

.PHONY: jenkins_%

# Check the Jenkins declarative pipeline syntax against the CI server
jenkins-lint: JENKINS_CRUMB = $(shell curl --silent --show-error "$(JENKINS_URL)/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")
jenkins-lint: Jenkinsfile ## Check Jenkinsfile pipeline syntax
	curl --silent --show-error -X POST -H $(JENKINS_CRUMB) -F "jenkinsfile=<$<" $(JENKINS_URL)/pipeline-model-converter/validate
