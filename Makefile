BUILD_DIR=build
ARCHIVE=$(BUILD_DIR)/Cardmoa.xcarchive
IPA=$(BUILD_DIR)/Cardmoa.ipa
DSYM=$(ARCHIVE)/dSYMs/Cardmoa.app.dSYM
DSYM_ZIP=$(BUILD_DIR)/dsym.zip

alpha: clean archive export dsym testflight
	@echo "Done."

clean:
	rm -rf build

archive:
	xctool archive\
		-archivePath $(ARCHIVE)\
		-project Cardmoa.xcodeproj\
		-scheme Cardmoa\
		-sdk iphoneos

export:
	xcodebuild\
		-sdk iphoneos\
		-archivePath "$(ARCHIVE)"\
		-exportArchive\
		-exportPath "$(IPA)"\
		-exportFormat ipa\
		-exportProvisioningProfile "CardmoaDistribution"

dsym:
	/usr/bin/zip --recurse-paths "$(DSYM_ZIP)" "$(DSYM)"

testflight:
	curl http://testflightapp.com/api/builds.json\
		-F file=@"$(IPA)"\
		-F dsym=@"$(DSYM_ZIP)"\
		-F api_token='1d696d8ad3c411c67d69d93bece36464_MjMwNTQ0MjAxMS0xMS0yOCAwMTowNjozMC41MTE0MTU'\
		-F team_token='6fc7fdad101c65b2d88487f83bcb9850_NDQ1OTkxMjAxNC0xMC0xMiAxMjozMjo0NS4xNzcyNDc'\
		-F notes='Cardmoa'\
		-F notify=True\
		-F distribution_lists='Cardmoa'
