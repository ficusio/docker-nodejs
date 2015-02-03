img = ficusio/nodejs

tag: build
	docker rmi $(img):prev 2>/dev/null ||:
	docker tag $(img):latest $(img):prev 2>/dev/null ||:
	docker tag -f $(img):new $(img):latest
	docker rmi $(img):new

build:
	docker build -t $(img):new .

push:
	docker push $(img):latest

.PHONY: tag build push
