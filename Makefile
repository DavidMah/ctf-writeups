all: phdays-zip polictf-zip

phdays-zip:
	zip -r phdays-quals-dmah-writeups.zip phdays-quals

polictf-zip:
	zip -r polictf-dmah-writeups.zip polictf

clean:
	rm *.zip
	rm */*.html
