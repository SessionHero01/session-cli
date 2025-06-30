macos_rust_targets = aarch64-apple-darwin x86_64-apple-darwin
ios_rust_targets = aarch64-apple-ios x86_64-apple-ios
android_native_platforms = arm64-v8a x86_64 x86 armeabi-v7a
linux_platforms = x86_64

macos_lib = flutter/macos/libsession_ui.dylib
ios_lib = flutter/ios/libsession_ui.dylib
android_libs = $(patsubst %,flutter/android/app/src/main/jniLibs/%/libsession_ui.so,$(android_native_platforms)) \
	$(patsubst %,flutter/android/app/src/main/jniLibs/%/libc++_shared.so,$(android_native_platforms))
linux_libs = $(patsubst %,flutter/linux/%/libsession_ui.so,$(linux_platforms))

all:

macos: ${macos_lib}
	cd flutter && flutter build macos --release

android: ${android_libs}
	cd flutter && flutter build apk --release

linux: ${linux_libs}
	cd flutter && flutter build linux --release && \
		appimagetool build/linux/x64/release/bundle/ \
			build/linux/session-x86_64.AppImage

.PHONY: android macos ios linux

target/%/release/libsession_ui.dylib:
	cargo build --release --target $* -p session-ui -vv

target/%/release/libsession_ui.so:
	cargo build --release --target $* -p session-ui -vv


flutter/android/app/src/main/jniLibs/%/libsession_ui.so \
	flutter/android/app/src/main/jniLibs/%/libc++_shared.so:
	cargo ndk -o flutter/android/app/src/main/jniLibs/$* \
		-p 21 -t $* \
		build --release -p session-ui

flutter/linux/%/libsession_ui.so:
	cargo build --release --target $*-unknown-linux-gnu -p session-ui
	@mkdir -p flutter/linux/$*
	@cp target/$*-unknown-linux-gnu/release/libsession_ui.so $@
