devops-packer-template
======================

##Makefile

Each transient image is proposed to be wrapped into separate build stage.

Thus you would find series of actions like

```makefile

build:
	packer build project.json

push:
	docker push voronenko/someproject:latest

  ```

## Image Layers definitions

The configuration file used to define what image we want built and how is called a template in Packer terminology. The format of a template is simple JSON. JSON struck the best balance between human-editable and machine-editable, allowing both hand-made templates as well as machine generated templates to easily be made.

Follow packer documentation  https://www.packer.io/intro/why.html  for additional option

In bootstrap template it got mocked with project.json

```json
{
    "builders": [
        {
            "type": "docker",
            "image": "docker.io/softasap/ubuntu:16.04.python27.latest",
            "commit": true,
            "changes": [
#                "WORKDIR /project",
#                "ENTRYPOINT [\"/opt/bin/entry_point.sh\"]"
            ]
        }
    ],
    "provisioners": [
        {
            "type": "ansible",
#            "user": "seluser",
            "playbook_file": "layer_project/provision.yml"
        }
    ],
    "post-processors": [
        [
            {
                "type": "docker-tag",
                "repository": "docker.io/voronenko/someproject",
                "tag": "latest"
            }
        ]
    ]
}

```


## Image provisioner

I usually use ansible,  as you can see in `provisioners`

In bootstrap template it got mocked with `layer_project/provision.yml`

```yaml
---

- name: Provision App Logic
  hosts: all

  vars:
    somecustomvar: 99

  tasks:
    - name: debug
      debug: msg="======================================================================================"

- name: Container cleanup
  hosts: all
  gather_facts: no
  tasks:
    - name: Remove autoremovables and do apt-get clean
      raw: apt-get autoremove -y && apt-get clean
      become: yes

    - name: Remove apt lists
      raw: rm -rf /var/lib/apt/lists/*
      become: yes
```
