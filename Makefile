IMAGE = fgrehm/alpine-go:1.5.1

default:
	docker build -t $(IMAGE) .

hack:
	docker run -ti --rm -v `pwd`:/code $(IMAGE) bash
