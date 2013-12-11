include theos/makefiles/common.mk

TWEAK_NAME = CameraSentry
CameraSentry_FILES = Tweak.xm
CameraSentry_FRAMEWORKS = UIKit Foundation CoreFoundation
ContactPrivacy_PRIVATE_FRAMEWORKS = AppSupport
CameraSentry_LDFLAGS = -lsubstrate

include $(THEOS_MAKE_PATH)/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
