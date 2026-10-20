import Cocoa

class ViewController: NSViewController {
    let setDocumentDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
    let getAGPMFilePath = "/System/Library/Extensions/AppleGraphicsPowerManagement.kext/Contents/Info.plist"
    let bundleID = "com.apple.driver.AGPMInjector"
    let bundleName = "AGPMInjector"
    let bundleSig = "????"
    // Create Decoder object
    let plistDecoder = PropertyListDecoder()
    // Write the AGPMInjector.kext/Contents directory to the users Desktop and copying AGPMInjector.plist into that directory as Info.plist
    let setAGPMInjectorDirectory = "AGPMInjector.kext/Contents"
    let setInfoPlistName = "Info.plist"
    let AgdcEnabled = 1
    let controlID = 17
    let maxPState = 15
    let miniPState = 0
    let setID = -1
    var didLoadMachines = false
    var AMDDictionary = [
        "RX 5600XT": "Vendor1002Device731f",
        "RX 5500XT": "Vendor1002Device7340",
        "Radeon VII": "Vendor1002Device66af",
        "R9 270": "Vendor1002Device6811",
        "R9 270X": "Vendor1002Device6810",
        "R9 280": "Vendor1002Device679a",
        "R9 280X": "Vendor1002Device6798",
        "R9 295 X2": "Vendor1002Device67b9",
        "R9 380": "Vendor1002Device6939",
        "R9 380X": "Vendor1002Device6938",
        "R9 290": "Vendor1002Device67b1",
        "R9 390": "Vendor1002Device67b1",
        "R9 290X": "Vendor1002Device67b0",
        "R9 390X": "Vendor1002Device67b0",
        "R9 Fury": "Vendor1002Device7300",
        "RX 460": "Vendor1002Device67ef",
        "RX 550": "Vendor1002Device699f",
        "RX 560": "Vendor1002Device67ff",
        "RX 470": "Vendor1002Device67df",
        "RX 480": "Vendor1002Device67df",
        "RX 570": "Vendor1002Device67df",
        "RX 580": "Vendor1002Device67df",
        "RX 590": "Vendor1002Device67df",
        "Vega 56": "Vendor1002Device687f",
        "Vega 64": "Vendor1002Device687f",
        "Vega Frontier": "Vendor1002Device6863",
        "Pro Duo": "Vendor1002Device67c4",
        "W 7100": "Vendor1002Device692b",
        "W 9100": "Vendor1002Device67a0",
        "RX 5700XT": "Vendor1002Device731f",
        "RX 6500XT": "Vendor1002Device743f",
        "RX 6600": "Vendor1002Device73ff",
        "RX 6600XT": "Vendor1002Device73ff",
        "RX 6700XT": "Vendor1002Device73df",
        "RX 6800": "Vendor1002Device73bf",
        "RX 6800XT": "Vendor1002Device73bf",
        "RX 6900XT": "Vendor1002Device73bf"
    ]
    
    var NvidiaDictionary = [
        "GT 710": "Vendor10deDevice128b",
        "GT 730": "Vendor10deDevice1287",
        "GTX 650": "Vendor10deDevice8428",
        "GTX 650 Ti": "Vendor10deDevice11c6",
        "GTX 650 TI Boost": "Vendor10deDevice11c2",
        "GTX 760": "Vendor10deDevice1187",
        "GTX 760 Ti": "Vendor10deDevice1189",
        "GTX 770": "Vendor10deDevice1184",
        "GTX 780": "Vendor10deDevice1004",
        "GTX 780 Ti": "Vendor10deDevice100a",
        "GTX 950": "Vendor10deDevice1402",
        "GTX 960": "Vendor10deDevice1401",
        "GTX 970": "Vendor10deDevice13c2",
        "GTX 980": "Vendor10deDevice13c0",
        "GTX 980 Ti": "Vendor10deDevice17c8",
        "GTX 1050": "Vendor10deDevice1c81",
        "GTX 1050 Ti": "Vendor10deDevice1c82",
        "GTX 1060": "Vendor10deDevice1c02",
        "GTX 1070": "Vendor10deDevice1b81",
        "GTX 1070 Ti": "Vendor10deDevice1b82",
        "GTX 1080": "Vendor10deDevice1b80",
        "GTX 1080 Ti": "Vendor10deDevice1b06",
        "GTX Titan": "Vendor10deDevice1005",
        "Titan V": "Vendor10deDevice1d81",
        "Titan X": "Vendor10deDevice1b00",
        "Titan XP": "Vendor10deDevice1b02",
        "GTX Titan Black": "Vendor10deDevice100c"
    ]
    
    @IBOutlet weak var machineSelected: NSPopUpButton!
    @IBOutlet weak var AMDMenu: NSPopUpButton!
    @IBOutlet weak var NvidiaMenu: NSPopUpButton!
    @IBOutlet weak var AMDCheck: NSButton!
    @IBOutlet weak var NvidiaCheck: NSButton!
    @IBOutlet weak var amdimage: NSImageView!
    @IBOutlet weak var smbiosImage: NSImageView!
    @IBOutlet weak var nvidiaImage: NSImageView!
    
    
    
    // Board-IDs used by AppleGraphicsPowerManagement.kext mapped to the model identifiers shown to the user
    let boardIDToModel = [
        "Mac-27AD2F918AE68F61": "MacPro7,1",
        "Mac-27ADBB7B4CEE8E61": "iMac14,2",
        "Mac-00BE6ED71E35EB86": "iMac13,1",
        "Mac-031B6874CF7F642A": "iMac14,1",
        "Mac-42FD25EABCABB274": "iMac15,1",
        "Mac-4B682C642B45593E": "iMac18,1",
        "Mac-77EB7D7DAF985301": "iMac14,3",
        "Mac-77F17D7DA9285301": "iMac18,2",
        "Mac-7BA5B2D9E42DDD94": "iMacPro1,1",
        "Mac-7DF2A3B5E5D671ED": "iMac13,3",
        "Mac-81E3E92DD6088272": "iMac14,4",
        "Mac-A369DDC4E67F1C45": "iMac16,1",
        "Mac-B809C3757DA9BB8D": "iMac17,1",
        "Mac-BE088AF8C5EB4FA2": "iMac18,3",
        "Mac-F60DEB81FF30ACF6": "MacPro6,1",
        "Mac-FA842E06C61E91C5": "iMac15,2",
        "Mac-FC02E91DDD3FA6A4": "iMac13,2",
        "Mac-FFE5EF870D7BA81A": "iMac16,2",
        "Mac-63001698E7A34814": "iMac19,2",
        "Mac-AA95B1DDAB278B95": "iMac19,1",
        "Mac-AF89B6D9451A490B": "iMac20,2",
        "Mac-CFF7D910A743CAAF": "iMac20,1"
    ]

    // Only desktop type machines that can take a "desktop" GPU make sense here
    func isDesktopModel(_ name: String) -> Bool {
        guard name != "iMac9,1" else { return false }
        return name.range(of: "^(iMac|iMacPro|MacPro)[0-9]+,[0-9]+$", options: .regularExpression) != nil
    }

    func readAGPMPlist() throws -> PlistGet {
        let data = try Data(contentsOf: URL(fileURLWithPath: getAGPMFilePath))
        return try plistDecoder.decode(PlistGet.self, from: data)
    }

    func showFatalAlert(_ message: String, _ info: String) {
        let alert = NSAlert()
        alert.alertStyle = .critical
        alert.messageText = message
        alert.informativeText = info
        alert.runModal()
        NSApp.terminate(nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AMDMenu.isHidden = true
        NvidiaMenu.isHidden = true
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        guard !didLoadMachines else { return }
        didLoadMachines = true
        // Decode the AppleGraphicsPowerManagement.kext Info.plist and list the machines it supports
        let plistData: PlistGet
        do {
            plistData = try readAGPMPlist()
        } catch {
            showFatalAlert("Unable to read AppleGraphicsPowerManagement.kext",
                           "\(getAGPMFilePath) could not be read or parsed. This app only works on Intel Macs that ship this kext.\n\n\(error.localizedDescription)")
            return
        }
        var machines = Set<String>()
        for key in plistData.IOKitPersonalities.AGPM.Machines.keys {
            let name = boardIDToModel[key] ?? key
            if isDesktopModel(name) {
                machines.insert(name)
            }
        }
        guard !machines.isEmpty else {
            showFatalAlert("No supported machines found", "AppleGraphicsPowerManagement.kext does not list any iMac or Mac Pro models.")
            return
        }
        AMDMenu.removeAllItems()
        AMDMenu.addItems(withTitles: AMDDictionary.keys.sorted())
        AMDMenu.selectItem(at: 0)
        NvidiaMenu.removeAllItems()
        NvidiaMenu.addItems(withTitles: NvidiaDictionary.keys.sorted())
        NvidiaMenu.selectItem(at: 0)
        machineSelected.removeAllItems()
        machineSelected.addItems(withTitles: machines.sorted())
        machineSelected.selectItem(at: 0)
        imageSelection(machineSelected as Any)
    }

    func saveAlert () {
        let fileManager = FileManager.default
        let home = fileManager.homeDirectoryForCurrentUser
        let kextPath = "Downloads/AGPMInjector.kext"
        let kextUrl = home.appendingPathComponent(kextPath)
        let alert = NSAlert()
        alert.messageText = "Injector Kext Generation Complete!"
        alert.informativeText = "AGPMInjector.kext has been generated and saved to \(kextUrl.path)"
        alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
    }
    
    func showError(_ message: String, _ info: String) {
        let alert = NSAlert()
        alert.alertStyle = .critical
        alert.messageText = message
        alert.informativeText = info
        if let window = self.view.window {
            alert.beginSheetModal(for: window, completionHandler: nil)
        } else {
            alert.runModal()
        }
    }

    func existAlert (encodable: @escaping () -> Void) {
        let fileManager = FileManager.default
        let home = fileManager.homeDirectoryForCurrentUser
        let kextPath = "Downloads/AGPMInjector.kext"
        let kextUrl = home.appendingPathComponent(kextPath)
        let alert = NSAlert()
        alert.alertStyle = .critical
        alert.addButton(withTitle: "Delete")
        alert.addButton(withTitle: "Cancel")
        alert.messageText = "File Already Exist!"
        alert.informativeText = "AGPMInjector.kext already exist at \(kextUrl.path). Click Delete to replace it with a newly generated one."
        alert.beginSheetModal(for: self.view.window!, completionHandler: { (returnCode) -> Void in
            switch returnCode {
            case NSApplication.ModalResponse.alertFirstButtonReturn:
                do {
                    try fileManager.removeItem(at: kextUrl)
                    encodable()
                } catch {
                    self.showError("Unable to delete AGPMInjector.kext", error.localizedDescription)
                }
            default:
                return
            }
        })
    }
    
    func savePlist<EncodableType: Encodable>(encodable: EncodableType) {
        let plistEncoder = PropertyListEncoder()
        plistEncoder.outputFormat = .xml
        let filePath =  setDocumentDirectory.appendingPathComponent("\(setAGPMInjectorDirectory)")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath.path) {
            existAlert(encodable: { self.savePlist(encodable: encodable) })
        } else {
            do {
                try FileManager.default.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                let InfoPlistfilePath =  filePath.appendingPathComponent("\(setInfoPlistName)")
                let data = try plistEncoder.encode(encodable)
                try data.write(to: InfoPlistfilePath)
                saveAlert()
            }
            catch {
                showError("Unable to generate AGPMInjector.kext", error.localizedDescription)
            }
        }
    }
    
    
    
    @IBAction func AMDChecked(_ sender: NSButton) {
        AMDMenu.isHidden = (sender.state == .off)
        NvidiaCheck.isHidden = (sender.state == .on)
        nvidiaImage.isHidden = (sender.state == .on)
    }
    
    @IBAction func NvidiaChecked(_ sender: NSButton) {
        NvidiaMenu.isHidden = (sender.state == .off)
        AMDCheck.isHidden = (sender.state == .on)
        amdimage.isHidden = (sender.state == .on)
    }
    @IBAction func imageSelection(_ sender: Any) {
        let userSelected = machineSelected.titleOfSelectedItem
        switch userSelected {
        case "iMacPro1,1":
            smbiosImage.image = NSImage(named: "imacpro.png")
        case "MacPro4,1", "MacPro5,1":
            smbiosImage.image = NSImage(named: "macpro.png")
        case "iMac19,1", "iMac11,3", "iMac18,1", "iMac17,1", "iMac16,1", "iMac15,1", "iMac14,1", "iMac13,1", "iMac12,1", "iMac11,1", "iMac10,1", "iMac19,2", "iMac18,2",
             "iMac18,3", "iMac16,2", "iMac15,2", "iMac14,2", "iMac14,3", "iMac14,4", "iMac13,2", "iMac13,3", "iMac12,2", "iMac11,2", "iMac20,1", "iMac20,2":
            smbiosImage.image = NSImage(named: "imac.png")
        case "MacPro6,1":
            smbiosImage.image = NSImage(named: "macpro61.png")
        case "MacPro7,1":
            smbiosImage.image = NSImage(named: "macpro71.png")
        default:
            smbiosImage.image = NSImage(named: "")
        }
    }
    
    @IBAction func generateButton(_ sender: Any) {
        let plistData: PlistGet
        do {
            plistData = try readAGPMPlist()
        } catch {
            showError("Unable to read AppleGraphicsPowerManagement.kext", error.localizedDescription)
            return
        }
        guard let machine = machineSelected.titleOfSelectedItem else { return }
        let gpu: String?
        if AMDCheck.state == .on {
            gpu = AMDMenu.titleOfSelectedItem.flatMap { AMDDictionary[$0] }
        } else if NvidiaCheck.state == .on {
            gpu = NvidiaMenu.titleOfSelectedItem.flatMap { NvidiaDictionary[$0] }
        } else {
            showError("No GPU selected", "Check the box for the dGPU manufacturer you have installed.")
            return
        }
        guard let gpuID = gpu else { return }
        let agpm = plistData.IOKitPersonalities.AGPM
        let heuristic = setHeuristic(setID: setID)
        let gpuSettings = setGpu(gpu: gpuID, agdcEnabled: AgdcEnabled, setHeuristic: heuristic, controlID: controlID, maxPowerState: maxPState, minPowerState: miniPState)
        let machines = setMachines(machine: setMachine(machinetype: machine, setGPUs: gpuSettings))
        let personalities = setIOKitPersonalities(setAGPM: setAGPM(cfBundleIdentifier: agpm.cfBundleIdentifier, ioClass: agpm.ioClass, ioNameMatch: agpm.ioNameMatch, ioProviderClass: agpm.ioProviderClass, setMachines: machines))
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let plistToEncode = setPlist(buildMachineOSBuild: plistData.buildMachineOSBuild, cfBundleDevelopmentRegion: plistData.cfBundleDevelopmentRegion, cfBundleGetInfoString: plistData.cfBundleGetInfoString, cfBundleIdentifier: bundleID, cfBundleInfoDictionaryVersion: plistData.cfBundleInfoDictionaryVersion, cfBundleName: bundleName, cfBundlePackageType: plistData.cfBundlePackageType, cfBundleShortVersionString: version, cfBundleSignature: bundleSig, cfBundleVersion: plistData.cfBundleVersion, nsHumanReadableCopyright: plistData.nsHumanReadableCopyright, setIOKitPersonalities: personalities, osBundleRequired: plistData.osBundleRequired)
        savePlist(encodable: plistToEncode)
    }
}
