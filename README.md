# Open-GApps

My custom gapps-config.txt created following [Open GApps Advanced Features and Options](https://github.com/opengapps/opengapps/wiki/Advanced-Features-and-Options).

# GApps repackaging
Bash script for Unix/Linux/Mac/Cygwin to replace standard APKs included in opengapps with your custom versions.

**Sample uses**

- include older version of googlecamera that works for your phone (ie hammerhead needs googlecamera 3.2 to support HDR+)
- replace youtube.apk with a ad-free patched version from [arter97](https://forum.xda-developers.com/android/apps-games/app-patched-ad-free-youtube-apks-t3449312)

**Requirements**
- bash, unzip, zip, lzip, find
- [Open GApps .zip archive](http://opengapps.org/) for your version and achitecture
- extracted directory structure for repackaging, similar to rep_youtube. Note per-DPI directories used by Open GApps, you would typically need a package for your device's DPI

**Example**
````
$ bash gapps_repackage.sh
INFO: Extracting open_gapps-arm-7.1-super-20170310.zip

INFO: Doing open_gapps-arm-7.1-super-20170310/GApps/cameragoogle-arm.tar.lz
INFO: No .apk in rep_cameragoogle, using existing .lz from rep_cameragoogle
'rep_cameragoogle/cameragoogle-arm.tar.lz' -> 'open_gapps-arm-7.1-super-20170310/GApps/cameragoogle-arm.tar.lz'

INFO: Doing open_gapps-arm-7.1-super-20170310/GApps/cameragoogle-common.tar.lz
INFO: No .apk in rep_cameragoogle-common, using existing .lz from rep_cameragoogle-common
'rep_cameragoogle-common/cameragoogle-common.tar.lz' -> 'open_gapps-arm-7.1-super-20170310/GApps/cameragoogle-common.tar.lz'

INFO: Doing open_gapps-arm-7.1-super-20170310/GApps/youtube-arm.tar.lz
'rep_youtube/youtube_12.16.55-121655333_minAPI21(armeabi-v7a)(320dpi)-adaway.apk' -> 'rep_youtube/youtube-arm/320/app/YouTube/YouTube.apk'
'rep_youtube/youtube_12.16.55-121655334_minAPI21(armeabi-v7a)(480dpi)-adaway.apk' -> 'rep_youtube/youtube-arm/480/app/YouTube/YouTube.apk'
INFO: create LZ with updated apk: rep_youtube/youtube-arm.tar.lz
youtube-arm/
youtube-arm/320/
youtube-arm/320/app/
youtube-arm/320/app/YouTube/
youtube-arm/320/app/YouTube/YouTube.apk
youtube-arm/480/
youtube-arm/480/app/
youtube-arm/480/app/YouTube/
youtube-arm/480/app/YouTube/YouTube.apk
'rep_youtube/youtube-arm.tar.lz' -> 'open_gapps-arm-7.1-super-20170310/GApps/youtube-arm.tar.lz'

INFO: Creating updated opengapps zip...Done
827M my_open_gapps-arm-7.1-super-20170310.zip

````
