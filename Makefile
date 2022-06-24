#!/usr/bin/make

all: package

package:
	rm -f dist/*
	python3 setup.py sdist bdist_wheel

install: package
	pip3 install --no-deps --force dist/*.whl

release: package
	twine upload dist/*

clean:
	-rm -rf dist build examples/ArduinoLearningKitStarter
	-rm -rf PcbDraw.egg-info

deb:
	# Make sure we don't include the downloaded example
	make clean
	@-[ ! -f versioneer.py.ok ] && mv versioneer.py versioneer.py.ok
	@-[ ! -f pcbdraw/_version.py.ok ] && mv pcbdraw/_version.py pcbdraw/_version.py.ok
	cp debian/versioneer.py .
	DEB_BUILD_OPTIONS=nocheck fakeroot dpkg-buildpackage -uc -b
	mv versioneer.py.ok versioneer.py
	mv pcbdraw/_version.py.ok pcbdraw/_version.py

deb_sig:
	# Make sure we don't include the downloaded example
	make clean
	@-[ ! -f versioneer.py.ok ] && mv versioneer.py versioneer.py.ok
	@-[ ! -f pcbdraw/_version.py.ok ] && mv pcbdraw/_version.py pcbdraw/_version.py.ok
	cp debian/versioneer.py .
	DEB_BUILD_OPTIONS=nocheck fakeroot dpkg-buildpackage -b
	mv versioneer.py.ok versioneer.py
	mv pcbdraw/_version.py.ok pcbdraw/_version.py

deb_clean:
	fakeroot debian/rules clean

.PHONY: package release deb deb_clean
