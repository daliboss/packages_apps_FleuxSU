# Legacy (make) prebuilt for trees that do not use Soong yet.
#
# Soong ignores Android.mk in a directory that also has Android.bp. To use this:
#   1. copy this file to the repository root as Android.mk
#   2. rename or delete Android.bp
#   3. add "FleuxSU" to PRODUCT_PACKAGES

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := FleuxSU
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := FleuxSU.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_DEX_PREOPT := false
LOCAL_MULTILIB := 64
include $(BUILD_PREBUILT)
