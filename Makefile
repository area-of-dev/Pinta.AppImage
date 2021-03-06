# Copyright 2020 Alex Woroschilow (alex.woroschilow@gmail.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
PWD:=$(shell pwd)

OUTPUT="Pinta.AppImage"

all: clean
	mkdir --parents $(PWD)/build/mono
	mkdir --parents $(PWD)/build/pinta

	wget --output-document=$(PWD)/build/mono/build.rpm https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/m/mono-core-6.8.0-2.el7.x86_64.rpm
	cd $(PWD)/build/mono && rpm2cpio build.rpm | cpio -idmv && cd ..

	wget --output-document=$(PWD)/build/mono/build.rpm https://rpmfind.net/linux/epel/7/x86_64/Packages/g/gtk-sharp2-2.12.26-4.el7.x86_64.rpm
	cd $(PWD)/build/mono && rpm2cpio build.rpm | cpio -idmv && cd ..

	wget --output-document=$(PWD)/build/mono/build.rpm http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/gtk2-2.24.32-5.el8.x86_64.rpm
	cd $(PWD)/build/mono && rpm2cpio build.rpm | cpio -idmv && cd ..

	wget --output-document=$(PWD)/build/mono/build.rpm http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/gtk3-3.22.30-6.el8.x86_64.rpm
	cd $(PWD)/build/mono && rpm2cpio build.rpm | cpio -idmv && cd ..

	wget --output-document=$(PWD)/build/mono/build.rpm https://ftp.lysator.liu.se/pub/opensuse/distribution/leap/15.2/repo/oss/x86_64/libatk-1_0-0-2.34.1-lp152.1.7.x86_64.rpm
	cd $(PWD)/build/mono && rpm2cpio build.rpm | cpio -idmv && cd ..

	wget --output-document=$(PWD)/build/mono/build.rpm https://ftp.lysator.liu.se/pub/opensuse/distribution/leap/15.2/repo/oss/x86_64/libatk-bridge-2_0-0-2.34.1-lp152.1.5.x86_64.rpm
	cd $(PWD)/build/mono && rpm2cpio build.rpm | cpio -idmv && cd ..

	wget --output-document=$(PWD)/build/mono/build.rpm https://ftp.lysator.liu.se/pub/opensuse/distribution/leap/15.2/repo/oss/x86_64/libatspi0-2.34.0-lp152.2.4.x86_64.rpm
	cd $(PWD)/build/mono && rpm2cpio build.rpm | cpio -idmv && cd ..

	wget --output-document=$(PWD)/build/mono/build.rpm http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/librsvg2-2.42.7-4.el8.x86_64.rpm
	cd $(PWD)/build/mono && rpm2cpio build.rpm | cpio -idmv && cd ..


	git clone https://github.com/PintaProject/Pinta.git $(PWD)/build/pinta
	mkdir --parents $(PWD)/build/pinta/build

	cd $(PWD)/build/pinta && ./autogen.sh --prefix=`pwd`/build && cd ..
	# cd $(PWD)/Pinta && sed -i 's/@YELP_HELP_RULES@//g' Makefile && cd ..
	# cd $(PWD)/Pinta && sed -i 's/@YELP_HELP_RULES@//g' Makefile.am && cd ..
	# cd $(PWD)/Pinta && sed -i 's/@YELP_HELP_RULES@//g' Makefile.in && cd ..
	# cd $(PWD)/Pinta && sed -i 's/@YELP_HELP_RULES@//g' help/Makefile && cd ..
	# cd $(PWD)/Pinta && sed -i 's/@YELP_HELP_RULES@//g' help/Makefile.am && cd ..
	# cd $(PWD)/Pinta && sed -i 's/@YELP_HELP_RULES@//g' help/Makefile.in && cd ..

	cd $(PWD)/build/pinta && make -i -B && make install && cd ..


	cp -r $(PWD)/build/mono/etc 			$(PWD)/AppDir
	cp -r $(PWD)/build/mono/usr/* 			$(PWD)/AppDir
	cp -r $(PWD)/build/pinta/build/* 		$(PWD)/AppDir

	chmod +x $(PWD)/AppDir/AppRun

	export ARCH=x86_64; bin/appimagetool.AppImage $(PWD)/AppDir $(PWD)/Pinta.AppImage
	chmod +x $(PWD)/Pinta.AppImage

clean: $(shell rm -rf $(PWD)/build)
	rm -rf $(PWD)/AppDir/bin
	rm -rf $(PWD)/AppDir/lib
	rm -rf $(PWD)/AppDir/lib64
	rm -rf $(PWD)/AppDir/share
	rm -rf $(PWD)/AppDir/etc
	rm -f $(PWD)/*.rpm
