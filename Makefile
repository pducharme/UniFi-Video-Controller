NAME=pducharme/unifi-video-controller
VERSION=3.9.2

.PHONY: all build tag_latest release

help:
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

all: build

build:	## Builds unifi-video docker image.
	docker build --no-cache --build-arg UNIFI_VIDEO_VERSION=$(VERSION) -t $(NAME):$(VERSION) --rm=true .

tag_latest:	## Tags this version of unifi-video in docker.
	docker tag $(NAME):$(VERSION) $(NAME):latest

release: tag_latest	## Checks for built image, pushes to docker and echos git tag commands.
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"
