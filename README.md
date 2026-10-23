# FleuxSU for ROM builders

Prebuilt **FleuxSU** manager APK packaged as an AOSP prebuilt app, so a ROM can ship the root
manager without touching its build system. This is the same layout as
[`packages_apps_MIUICamera_fleur`](https://github.com/StasGr12/packages_apps_MIUICamera_fleur):
clone into `packages/apps/`, add one `PRODUCT_PACKAGES` line, build.

FleuxSU is a KernelSU/BakaSU fork. This repository only carries the manager APK; the kernel
side lives in [`daliboss/FleuxSU`](https://gitlab.com/daliboss/FleuxSU) and the app source in
[`daliboss/fleux-app`](https://gitlab.com/daliboss/fleux-app).

| | |
|---|---|
| Package | `com.daliboss.fleux` |
| Version | 2.0 (versionCode 13) |
| Min SDK | 26 |
| ABI | arm64-v8a (`libksud.so` is bundled) |
| SHA-256 | see `FleuxSU.apk.sha256` |

## Usage

1. Clone into your tree:

   ```bash
   git clone https://github.com/daliboss/packages_apps_FleuxSU packages/apps/FleuxSU
   ```

2. Add it to the device or product makefile:

   ```make
   PRODUCT_PACKAGES += FleuxSU
   ```

3. Build. The app is installed to `/system/app/FleuxSU/FleuxSU.apk`.

   Set `privileged: true` in `Android.bp` if you prefer `/system/priv-app`; the app requests no
   privileged permissions, so no `privapp-permissions` allowlist is needed either way.

## Kernel requirement

**A stock KernelSU/SukiSU kernel will not accept this app as its manager.** KernelSU verifies the
manager APK by the signing certificate compiled into the kernel
(`EXPECTED_SIZE_FLEUX` / `EXPECTED_HASH_FLEUX` in
[`kernel/manager/manager_sign.h`](https://gitlab.com/daliboss/FleuxSU/-/blob/main/kernel/manager/manager_sign.h)).
Build the kernel from the FleuxSU fork, or add this APK's certificate to your own KernelSU-based
kernel the same way before shipping.

Two consequences:

- **Do not re-sign `FleuxSU.apk`.** `presigned: true` in `Android.bp` keeps the release
  signature. The kernel compares the DER signing certificate (size + SHA-256), so re-signing
  with the platform key makes the app invisible to the kernel even though the package name is
  unchanged.
- **Do not repack or re-compress the APK.** `preprocessed: true` keeps the published bytes.

The kernel also needs the usual KernelSU integration (`CONFIG_KSU` and the corresponding hooks).
On first launch the app extracts the bundled `ksud` daemon and installs it to `/data/adb/ksud`;
nothing extra needs to be preinstalled in the ROM.

## Updating the prebuilt

```bash
./scripts/update-apk.sh 2.0
```

The script downloads `Fleux-$version.apk` from the release page, checks that it is an APK,
replaces `FleuxSU.apk`, and writes a fresh `FleuxSU.apk.sha256`. Commit both files.

## Older trees (make only)

Soong ignores `Android.mk` when `Android.bp` exists in the same directory. On a tree without
Soong, copy [`legacy/Android.mk`](legacy/Android.mk) to the repository root as `Android.mk`,
remove/rename `Android.bp`, then add `PRODUCT_PACKAGES += FleuxSU` as usual.

## Source and licensing

- App: <https://gitlab.com/daliboss/fleux-app> (releases: <https://gitlab.com/daliboss/fleux-app/-/releases>)
- Kernel / daemon: <https://gitlab.com/daliboss/FleuxSU>
- The manager UI derives from [BakaSU](https://github.com/Baka-SU/BakaSU) and
  [KernelSU](https://github.com/tiann/KernelSU), both GPL-3.0. See those trees for the license
  text; the corresponding sources for this prebuilt are the repositories above.
