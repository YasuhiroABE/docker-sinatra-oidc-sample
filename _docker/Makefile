
NAME = sinatra-oidc-sample
DOCKER_IMAGE = sinatra-oidc-sample
DOCKER_IMAGE_VERSION = 1.0.0
IMAGE_NAME = $(DOCKER_IMAGE)
REGISTRY_SERVER = docker.io
REGISTRY_LIBRARY = yasuhiroabe

PROTOCOL = http
HOST = 0.0.0.0
PORT = 8080
URI_PATH = search

OIDC_PROVIDER_URI = https://example.com/dex
OIDC_CLIENT_ID = oidc-example-id
OIDC_SECRET = 99a52ff4aa8c336cf7c6b79098e86796
OIDC_REDIRECT_URI = http://localhost:$(PORT)/callback
REDIS_URI = redis://10.0.0.1:6379/0

.PHONY: run bundle-install docker-build docker-build-prod docker-tag docker-push docker-run docker-stop clean

run: bundle-install
	env OIDC_PROVIDER_URI=$(OIDC_PROVIDER_URI) \
		OIDC_CLIENT_ID=$(OIDC_CLIENT_ID) \
		OIDC_SECRET=$(OIDC_SECRET) \
		OIDC_REDIRECT_URI=$(OIDC_REDIRECT_URI) \
		REDIS_URI=$(REDIS_URI) \
		bundle exec rackup --host $(HOST) --port $(PORT)

bundle-install:
	bundle config set path lib
	bundle install

docker-build:
	rm -f Gemfile.lock
	rm -fr lib/ruby
	rm -fr .bundle
	sudo docker build . --tag $(IMAGE_NAME)

docker-build-prod:
	rm -f Gemfile.lock
	rm -fr lib/ruby
	rm -fr .bundle
	sudo docker build . --tag $(IMAGE_NAME):$(DOCKER_IMAGE_VERSION) --no-cache

docker-tag:
	sudo docker tag  $(IMAGE_NAME):$(DOCKER_IMAGE_VERSION) $(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

docker-push:
	sudo docker push $(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

docker-run:
	sudo docker run -it --rm  \
		--env LC_CTYPE=ja_JP.UTF-8 \
		--env OIDC_PROVIDER_URI=$(OIDC_PROVIDER_URI) \
		--env OIDC_CLIENT_ID=$(OIDC_CLIENT_ID) \
		--env OIDC_SECRET=$(OIDC_SECRET) \
		--env OIDC_REDIRECT_URI=$(OIDC_REDIRECT_URI) \
		--env REDIS_URI=$(REDIS_URI) \
		-p $(PORT):8080 \
		--name $(NAME) \
                $(IMAGE_NAME)

docker-redis-run:
	 sudo docker run -it --rm -d \
		-p 6379:6379 \
		--name redis redis:latest

docker-stop:
	sudo docker stop $(NAME)

clean:
	find . -type f -name '*~' -exec rm -f {} \; -print
