#!/bin/sh
chmod -R 755 uncompiled-packages



perl debs

rm -rf Packages Packages.bz2
dpkg-scanpackages -m 'deb' /dev/null >Packages
bzip2 -k -z Packages




#!/bin/sh
cd deb
ls -t | grep '.deb' | head -5 | perl -e 'use JSON; @in=grep(s/\n$//, <>); $count=0; foreach $fileNow (@in) { $size = -s $fileNow; $section= `dpkg -f $fileNow Section | tr -d "\n\r"`; $name= `dpkg -f $fileNow Name | tr -d "\n\r"`; $version= `dpkg -f $fileNow Version | tr -d "\n\r"`; $package= `dpkg -f $fileNow Package | tr -d "\n\r"`; $time= `date -r $fileNow +%s | tr -d "\n\r"`; @in[$count] = {section=>$section, package=>$package, version=>$version, size=>$size+0, time=>$time+0, name=>$name}; $count++; } print encode_json(\@in)."\n"; ' >../last.updates
exit 0
