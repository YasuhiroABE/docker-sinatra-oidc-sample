
OAGEN_CLI = openapi-generator-cli
OASV_CLI = $(HOME)/.local/bin/openapi-spec-validator

.PHONY: manual gen-docs gen-code validate clean diff-files

manual:
	firefox "https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.3.md"

gen-docs:
	$(OAGEN_CLI) generate -g html -o docs -i openapi.yaml

gen-code:
	$(OAGEN_CLI) generate -g ruby-sinatra -o code -i openapi.yaml
	cp _docker/default_api.rb code/api/
	cp _docker/Makefile code/
	cp _docker/Dockerfile code/
	cp _docker/run.sh code/
	cp _docker/Gemfile code/
	cp _docker/config.ru code/
	cp _docker/myconfig.rb code/lib/
	cp _docker/myoidcprovider.rb code/lib/
	mkdir -p code/lib/views
	cp _docker/header.erubis code/lib/views/
	cp _docker/main.erubis code/lib/views/
	cp _docker/protected.erubis code/lib/views/
	cp _docker/login.erubis code/lib/views/
	cp _docker/footer.erubis code/lib/views/

## Please install the command as following: $ pip3 install openapi-spec-validator --user
validate:
	$(OASV_CLI) openapi.yaml

clean:
	find . -type f -name '*~' -exec rm {} \; -print

diff-files:
	diff -u _docker/default_api.rb code.impl/api/default_api.rb
	diff -u _docker/Makefile code.impl/Makefile
	diff -u _docker/Dockerfile code.impl/Dockerfile
	diff -u _docker/run.sh code.impl/run.sh
	diff -u _docker/Gemfile code.impl/Gemfile
	diff -u _docker/config.ru code.impl/config.ru
	diff -u _docker/myconfig.rb code.impl/lib/myconfig.rb
	diff -u _docker/myoidcprovider.rb code.impl/lib/myoidcprovider.rb
	diff -u _docker/header.erubis code.impl/lib/views/header.erubis
	diff -u _docker/main.erubis code.impl/lib/views/main.erubis
	diff -u _docker/protected.erubis code.impl/lib/views/protected.erubis
	diff -u _docker/login.erubis code.impl/lib/views/login.erubis
	diff -u _docker/footer.erubis code.impl/lib/views/footer.erubis
