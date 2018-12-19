#!/usr/bin/make -f

PROJECT = piwitch
VERSION = 0.1.0
INVENTORY = hosts

.PHONY: all version dist install update remove

all:	init
	@if test ! -f inventory/$(INVENTORY).ini ; then echo "copy inventory/example.ini to inventory/$(INVENTORY).ini and modify as needed" ; fi
	@echo run make install, make update, make remove, or make dist

version:
	@echo $(VERSION)

init:
	@echo "PROJECT_VERSION = '${VERSION}'" >webkit/project.rb
	@echo "PROJECT_NAME = '${PROJECT}'" >>webkit/project.rb
	@echo "PROJECT_INVENTORY = '${INVENTORY}'" >>webkit/project.rb

dist:
	@rm -f $(PROJECT)-*.tar.gz
	@git archive -o $(PROJECT)-$(VERSION).tar.gz --format tar.gz --prefix=$(PROJECT)-$(VERSION)/ v$(VERSION) 2>/dev/null || git archive -o $(PROJECT)-$(VERSION).tar.gz --format tar.gz --prefix=$(PROJECT)-$(VERSION)/ HEAD

install:	init
	ansible-playbook -i inventory/$(INVENTORY).ini install.yml

update:		init
	ansible-playbook -i inventory/$(INVENTORY).ini install.yml

remove:
	ansible-playbook -i inventory/$(INVENTORY).ini remove.yml

