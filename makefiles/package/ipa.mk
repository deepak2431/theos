ifeq ($(_THEOS_PACKAGE_FORMAT_LOADED),)
_THEOS_PACKAGE_FORMAT_LOADED := 1

TARGET_CODESIGN = :

TARGET_METEORITE = meteorite
TARGET_METEORITE_FLAGS = --certificate certificate.p12 --key key.p12 --profile profile.mobileprovision

COMPRESSION := 1
ifeq ($(_THEOS_FINAL_PACKAGE),$(_THEOS_TRUE))
COMPRESSION := 9
endif

_THEOS_IPA_PAYLOAD_DIR_NAME = Payload
_THEOS_IPA_PAYLOAD_DIR_PATH = $(THEOS_STAGING_DIR)
_THEOS_IPA_PAYLOAD_DIR = $(_THEOS_IPA_PAYLOAD_DIR_PATH)/$(_THEOS_IPA_PAYLOAD_DIR_NAME)

_THEOS_IPA_PACKAGE_FILENAME = $(THEOS_PACKAGE_DIR)/$(APPLICATION_NAME)_$(_THEOS_INTERNAL_PACKAGE_VERSION)_$(THEOS_PACKAGE_ARCH).ipa

$(_THEOS_IPA_PAYLOAD_DIR)::
	$(ECHO_NOTHING)mkdir -p $(_THEOS_IPA_PAYLOAD_DIR)$(ECHO_END)

internal-package:: $(_THEOS_IPA_PAYLOAD_DIR)
	$(ECHO_NOTHING)$(TARGET_METEORITE) $(TARGET_METEORITE_FLAGS) $(THEOS_STAGING_DIR)/Applications/*.app --output $(_THEOS_IPA_PAYLOAD_DIR)/$(APPLICATION_NAME).app$(ECHO_END)
	$(ECHO_NOTHING)cd "$(_THEOS_IPA_PAYLOAD_DIR_PATH)" && zip -yqr$(COMPRESSION) "$(THEOS_PROJECT_DIR)/$(_THEOS_IPA_PACKAGE_FILENAME)" "$(_THEOS_IPA_PAYLOAD_DIR_NAME)"$(ECHO_END)

after-package:: __THEOS_LAST_PACKAGE_FILENAME = $(_THEOS_IPA_PACKAGE_FILENAME)

deploy::
	@echo $(_THEOS_PACKAGE_LAST_FILENAME)
endif
