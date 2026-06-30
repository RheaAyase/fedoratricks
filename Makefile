NAME := fedoratricks
SOURCES := Containerfile \
       fedoratricks.spec \
       fedoratricks.sh \
       $(wildcard commands/*.sh)

all: lint test build-rpm

.PHONY: lint
lint: builder-image
	podman run --rm -it \
		-v $(PWD):/src \
		-w /src \
		"$(NAME)-builder:latest" shellcheck "$(NAME).sh" commands/*

.PHONY: test
test:
	podman run --rm -it \
		-v $(PWD):/src \
		-w /src \
		-e PATH=$(PWD):$(PWD)/tests/mocks:/usr/bin \
		"$(NAME)-builder:latest" bats tests/*.bats

builder-image: build/$(NAME).builder

build/$(NAME).builder: $(SOURCES)
	podman --remote build \
		-t $(NAME)-builder:latest \
		--target=builder \
		.
	touch build/$(NAME).builder

build-rpm: build/rpms builder-image

build/rpms:
	podman run --rm -it \
		-v "$(PWD):/src" \
		-w /src \
		$(NAME)-builder:latest \
		cp -rp /rpms build/
