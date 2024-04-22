#################################################################################
# GLOBALS                                                                       #
#################################################################################

PROJECT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PYTHON_INTERPRETER = $(PROJECT_DIR)/env/bin/python
PACKAGE_VERSION_CLEAN = $(shell python -m setuptools_scm --strip-dev)

globals:
	@echo '=============================================='
	@echo '=    displaying all global variables         ='
	@echo '=============================================='
	@echo 'PROJECT_DIR: ' $(PROJECT_DIR)
	@echo 'PYTHON_INTERPRETER: ' $(PYTHON_INTERPRETER)
	@echo 'PACKAGE_VERSION_CLEAN: ' $(PACKAGE_VERSION_CLEAN)

commands:
	@echo '=============================================='
	@echo '=    displaying all functions available      ='
	@echo '=============================================='
	@echo 'test: run tox to fully test package'
	@echo 'publish: publish package to pypi_test server'
	@echo 'publish_prod: publish package to pypi server'
	@echo 'docker_package: docker build the Dockerfile to create the image'
	@echo 'docker_hub_push: push docker image to docker hub'
	@echo '		Make sure to be loged into docker with an access token'
	@echo 'helm: build docker package, upload to docker hub, delete local image...'
	@echo '		...delete current helm install and install new helm chart'

#################################################################################
# COMMANDS                                                                      #
#################################################################################

## Delete all compiled Python files
clean:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete

package:
	rm -rf dist/*
	$(PYTHON_INTERPRETER) -m build

check_credentials_exist:
	[ -f ~/.pypi ] && echo 'pypi credentials found' || echo '~/.pypi file not found!'

publish: package check_credentials_exist
	twine check dist/*
	twine upload --repository testpypi --config-file ~/.pypi dist/*
	@echo '==============================================='
	@echo 'THIS COMMAND ONLY DEPLOYS TO TEST_PYPI'
	@echo 'To deploy to PYPI use the command publish_prod'

publish_prod: check_credentials_exist test
	twine check dist/*
	twine upload --repository pypi --config-file ~/.pypi dist/*

test:
	tox

pip_requirements:
	python -m pip freeze > requirements.txt

git: pip_requirements
	git commit -a -m "debug"

docker_package:
	@echo '==========================================================================='
	@echo 'MAKE SURE TO RUN ONLY ON A CLEAN GIT BRANCH'
	@echo '==========================================================================='

	docker build . -t kuchedav/fastapi-kubernetes:$(PACKAGE_VERSION_CLEAN)

	@echo '==========================================================================='
	@echo '# Show docker images'
	docker images | grep fastapi-kubernetes
	@echo '==========================================================================='

docker_hub_push: pip_requirements docker_package
	docker push kuchedav/fastapi-kubernetes:$(PACKAGE_VERSION_CLEAN)

docker_clean:
	docker rmi kuchedav/fastapi-kubernetes:$(PACKAGE_VERSION_CLEAN)

helm: docker_hub_push docker_clean
	sed -i "" "/^\([[:space:]]*version: \).*/s//\1$(PACKAGE_VERSION_CLEAN)/" helm/Chart.yaml
	helm lint ./helm/
	-helm uninstall fastapi-kubernetes
	helm install fastapi-kubernetes ./helm
