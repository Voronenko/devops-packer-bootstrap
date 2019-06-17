build:
	packer build project.json

push:
	docker push voronenko/someproject:latest
