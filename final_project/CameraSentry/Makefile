include theos/makefiles/common.mk

TWEAK_NAME = CameraSentry
CameraSentry_FILES = Tweak.xm
CameraSentry_FRAMEWORKS = UIKit
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
