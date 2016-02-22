IMAGE = fgrehm/alpine-go:1.6

default:
	docker build -t $(IMAGE) .

hack:
	docker run -ti --rm -v `pwd`:/code $(IMAGE) bash
