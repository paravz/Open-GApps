#!/bin/bash

# Extract for re-packaging, ie youtube from opengapps:
# mkdir rep_youtube; cd rep_youtube
# cp ../youtube-arm.tar.lz .
# lzip.exe -d *.lz
# tar xfv *.tar

if (unzip -h && zip -h && lzip -h && find --help) &>/dev/null ; then
	# all needed tools are installed
	:
else
	echo "ERR: Missing required tools, aborting"
	echo "Install: unzip, zip, lzip, find"
	exit 1
fi
	

OZIP=$(ls -1tr open_gapps*.zip 2>/dev/null|tail -1)
if [ -z "$OZIP" ]; then
	echo "ERR: open_gapps*.zip not found in current directory, aborting."
	exit 1
fi
# cut trailing .zip
ODIR=${OZIP/.zip}
OARCH=$(echo $OZIP|cut -f2 -d-)

if [ \! -d "$ODIR" ]; then
	echo "INFO: Extracting $OZIP"
	unzip -q "$OZIP" -d "$ODIR"
else
	echo "INFO: Using already extracted: $ODIR"
fi
echo

# main loop against 
for repdir in rep_*; do
	# target package .lz in opengapps dir
	OLZ=""
	# extracted package dir to be added to opengapps (originally extracted .lz)
	REPPKGDIR=""
	NEWAPK=""
	# cut rep_ at the beginning to extract package name
	PKGNAME=${repdir#rep_}
	
	# OLZ might contain arch (arm, arm64) or might not (cameragoogle-common)
	OLZ=$(find "$ODIR" -name ${PKGNAME}.tar.lz)
	if [ -z "$OLZ" ]; then
		OLZ=$(find "$ODIR" -name ${PKGNAME}-$OARCH.tar.lz)
	fi
	
	REPPKGDIR=$(find "$repdir" -mindepth 1 -maxdepth 1 -type d -name ${PKGNAME}\*)
	if [ -z "$OLZ" -o -z "$REPPKGDIR" ];then
		echo "ERR: skipping $repdir, something is missing"
		echo "ERR: target LZ: $OLZ, Target DIR: $REPPKGDIR"
		continue
	fi
	echo -e "INFO: Doing $OLZ"
	
	# copy .APK matching target dpi (by directory name) into extracted package dir structure
	for DPIDIR in $REPPKGDIR/*; do
		SAPK=""
		# strip path in beginning  to leave only DPI (320, 480, nodpi, etc)
		DPI=${DPIDIR##*/}
		TAPK=$(find "$DPIDIR" -name \*.apk)
		SAPK=$(ls -1tr $repdir/*$DPI* 2>/dev/null| tail -1)
		# copy latest .apk from rep_pkgname directory if present 
		if [ \! -z "$SAPK" -a \! -z "$TAPK" ]; then
			cp -vf $SAPK $TAPK
			NEWAPK="yes"
		else
			echo "INFO: No .apk in $repdir, using existing .lz from $repdir"
		fi
	done
	
	# extract package name with arch
	LZNAME=${OLZ##*/}
	LZNAME=${LZNAME/.tar.lz/}
	
	# create new .lz if a new .apk was added by this script
	# or 
	# use existing .lz from rep_pkgname otherwise, ie force 
	# cameragoogle-arm.tar.lz compatible with hammerhead instead
	# of the latest shipped in opengapps)
	if [ "$NEWAPK" = "yes" ]; then
		cd "$repdir"
		echo "INFO: create LZ with updated apk: $repdir/$LZNAME.tar.lz"
		tar cfv $LZNAME.tar $LZNAME
		lzip -f $LZNAME.tar
		cd - >/dev/null
	fi
	
	if [ -f "$repdir/$LZNAME.tar.lz" ]; then
		cp -fv "$repdir/$LZNAME.tar.lz" "$OLZ"
	fi
	echo 
done

echo -n "INFO: Creating updated opengapps zip..."
cd "$ODIR"
if zip -q -r "../my_$OZIP" * ; then
	echo "Done"
fi

cd - >/dev/null
ls -lah "my_$OZIP"
