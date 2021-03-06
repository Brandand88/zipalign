#
# Copyright (C) 2008-2014 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
LOCAL_PATH := $(my-dir)
include $(CLEAR_VARS)

# This is what we want to do:
#  liblog_cflags := $(shell \
#   sed -n \
#       's/^\([0-9]*\)[ \t]*liblog[ \t].*/-DLIBLOG_LOG_TAG=\1/p' \
#       $(LOCAL_PATH)/event.logtags)
# so make sure we do not regret hard-coding it as follows:
liblog_cflags := -DLIBLOG_LOG_TAG=1005

liblog_sources := logd_write.c log_event_list.c log_event_write.c
liblog_host_sources := $(liblog_sources) fake_log_device.c event.logtags
liblog_target_sources := $(liblog_sources) event_tag_map.c
liblog_target_sources += log_time.cpp log_is_loggable.c logprint.c log_read.c

# Static library for target
# ========================================================
include $(CLEAR_VARS)
LOCAL_MODULE := liblog
LOCAL_SRC_FILES := $(liblog_target_sources)
LOCAL_CFLAGS := $(liblog_cflags)

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/../include

# AddressSanitizer runtime library depends on liblog.
LOCAL_SANITIZE := never
include $(BUILD_STATIC_LIBRARY)

include $(call first-makefiles-under,$(LOCAL_PATH))
