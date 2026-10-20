# AGPMInjector

macOS (AppKit, Swift 5) app that generates `AGPMInjector.kext` (an `Info.plist` only) for desktop GPUs. It reads `/System/Library/Extensions/AppleGraphicsPowerManagement.kext/Contents/Info.plist`, copies its metadata, and writes one `Machines.<model>.<VendorXXXXDeviceYYYY>` entry to `~/Downloads/AGPMInjector.kext/Contents/Info.plist`.

## Layout
- `AGPMInjector/ViewController.swift`: UI logic, machine/GPU dictionaries, generation.
- `AGPMInjector/getPlist.swift`: `Decodable` model of the system AGPM plist (all top-level keys optional; Apple drops keys between releases).
- `AGPMInjector/setPlist.swift`: `Encodable` output model. Machine and GPU keys are `DynamicKey` strings, so no enums to maintain.
- `Support Files/`: Sparkle 2.x framework and `generate_appcast`/`generate_keys`. Referenced relative to the project (`SOURCE_ROOT`), never absolute.
- `bitrise.yml`: CI/release pipeline (uses a signing step).

## Build and run
```
xcodebuild -project AGPMInjector.xcodeproj -scheme AGPMInjector -configuration Debug -derivedDataPath $TMPDIR/dd CODE_SIGNING_ALLOWED=NO build
```
- Intel only (`EXCLUDED_ARCHS = arm64`): the AGPM kext exists only on Intel Macs. Deployment target is macOS 12 (Sparkle 2.10 requires it).
- The app needs the system AGPM kext at runtime; on failure it shows an alert instead of crashing.

## Conventions and gotchas
- GPU IDs must be lowercase hex (`Vendor1002Device731f`); the key is case sensitive.
- The output key is `Machines` (plural). A kext with `Machine` is silently ignored by AGPM.
- The machine key must be the **board-ID** (e.g. `Mac-7BA5B2D9E42DDD94` for iMacPro1,1) on Tahoe's AGPM plist, not the model name; `generateButton` maps model to board-ID via `boardIDToModel`, falling back to the model name for older machines keyed by model (MacPro5,1 etc.). A wrong key is silently ignored and the GPU idles at high power (~70 W on Vega 56, memory clock stuck at 800 MHz).
- Verified working on Tahoe 26.7.1 (Vega 56, OpenCore, board-ID key): idle ~69 W -> ~45 W, memory clock 800 -> 500 MHz.
- Verify a loaded kext with `ioreg -l -w0 | grep '"Machine" = '`. AGPM replaces `Machines` with a single `Machine` entry for the matched board, keyed by model name (e.g. `iMacPro1,1`), so `grep Machines` finds nothing even when it works. Check idle power with `ioreg -rc IOAccelerator -w0 | grep -o '"Total Power(W)"=[0-9]*'`.
- Display names for Mac board-IDs live in `boardIDToModel`; only iMac/iMacPro/MacPro models are listed (`isDesktopModel`).
- Add a GPU by adding a line to `AMDDictionary` or `NvidiaDictionary`; no other change is needed.
- Releases are unsigned/ad-hoc: users must clear quarantine (`xattr -dr com.apple.quarantine`) or right-click Open.
- `SUFeedURL` in `Info.plist` still points to the upstream `Pavo-IM` appcast.
- Remotes: `origin` is upstream `Pavo-IM/AGPMInjector`; `kodeaqua` is the user's repo (push there).
