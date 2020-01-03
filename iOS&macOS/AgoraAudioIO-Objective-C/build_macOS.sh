rm -rf *.app
rm -f *.zip
rm -rf dSYMs
rm -rf *.dSYM
rm -f *dSYMs.zip
rm -rf *.xcarchive

BUILD_DATE=`date +%Y-%m-%d-%H.%M.%S`
APP_PROJECT=AgoraAudioIO
APP_TARGET=AgoraAudioIO-macOS
ArchivePath=${APP_TARGET}-${BUILD_DATE}.xcarchive

xcodebuild clean -project "${APP_PROJECT}.xcodeproj" -scheme "${APP_TARGET}" -configuration Release
xcodebuild CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO -project "${APP_PROJECT}.xcodeproj" -scheme "${APP_TARGET}" -archivePath ${ArchivePath} archive
xcodebuild CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO -exportArchive -exportOptionsPlist exportPlist_macOS.plist -archivePath ${ArchivePath} -exportPath .