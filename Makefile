REPO ?= dfherr/carchain
TAG  ?= $(GITTAG)
GITTAG ?= v0.1.1.p6

all: build commit push

clean:
	docker rmi $(shell docker images -q $(REPO))

build: Dockerfile
	git submodule update --remote --init;
	cd src && git fetch --tags && git checkout -f tags/$(GITTAG) && cd ..;
	docker build --rm -t $(REPO):$(TAG) .
	docker tag $(REPO):$(TAG) $(REPO):latest

commit:
	git add Makefile src/
	git commit -m "Version $(TAG)"

push:
	docker push $(REPO):$(TAG)
	docker push $(REPO):latest
	git push
