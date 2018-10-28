#!/usr/bin/make -f

PROJECT = piwitch
VERSION = 0.0.2
INVENTORY = inventory/hosts.ini

.PHONY: all version dist install update remove

all:
	@if test ! -f $(INVENTORY) ; then echo "copy inventory/example.ini to $(INVENTORY) and modify as needed" ; fi
	@echo run make install, make update, make remove, or make dist

version:
	@echo $(VERSION)

dist:
	@rm -f $(PROJECT)-*.tar.gz
	@git archive -o $(PROJECT)-$(VERSION).tar.gz --format tar.gz --prefix=$(PROJECT)-$(VERSION)/ v$(VERSION) 2>/dev/null || git archive -o $(PROJECT)-$(VERSION).tar.gz --format tar.gz --prefix=$(PROJECT)-$(VERSION)/ HEAD

install:
	ansible-playbook -i $(INVENTORY) install.yml

update:
	ansible-playbook -i $(INVENTORY) install.yml

remove:
	ansible-playbook -i $(INVENTORY) remove.yml

