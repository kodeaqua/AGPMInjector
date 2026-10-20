import Foundation

/// A coding key built from an arbitrary string, used for machine and GPU identifiers
/// so that new models never have to be added to a hard-coded enum.
struct DynamicKey: CodingKey {
    let stringValue: String
    let intValue: Int? = nil

    init(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        return nil
    }
}

struct setPlist: Encodable {
    let buildMachineOSBuild, cfBundleDevelopmentRegion, cfBundleGetInfoString, cfBundleIdentifier: String?
    let cfBundleInfoDictionaryVersion, cfBundleName, cfBundlePackageType, cfBundleShortVersionString: String?
    let cfBundleSignature, cfBundleVersion, nsHumanReadableCopyright: String?
    let setIOKitPersonalities: setIOKitPersonalities
    let osBundleRequired: String?
    enum CodingKeys: String, CodingKey {
        case buildMachineOSBuild = "BuildMachineOSBuild"
        case cfBundleDevelopmentRegion = "CFBundleDevelopmentRegion"
        case cfBundleGetInfoString = "CFBundleGetInfoString"
        case cfBundleIdentifier = "CFBundleIdentifier"
        case cfBundleInfoDictionaryVersion = "CFBundleInfoDictionaryVersion"
        case cfBundleName = "CFBundleName"
        case cfBundlePackageType = "CFBundlePackageType"
        case cfBundleShortVersionString = "CFBundleShortVersionString"
        case cfBundleSignature = "CFBundleSignature"
        case cfBundleVersion = "CFBundleVersion"
        case nsHumanReadableCopyright = "NSHumanReadableCopyright"
        case setIOKitPersonalities = "IOKitPersonalities"
        case osBundleRequired = "OSBundleRequired"
    }
}

struct setIOKitPersonalities: Encodable {
    let setAGPM: setAGPM

    enum CodingKeys: String, CodingKey {
        case setAGPM = "AGPM"
    }
}

struct setAGPM: Encodable {
    let cfBundleIdentifier, ioClass, ioNameMatch, ioProviderClass: String
    let setMachines: setMachines
    enum CodingKeys: String, CodingKey {
        case cfBundleIdentifier = "CFBundleIdentifier"
        case ioClass = "IOClass"
        case ioNameMatch = "IONameMatch"
        case ioProviderClass = "IOProviderClass"
        case setMachines = "Machines"
    }
}

struct setMachines: Encodable {
    let machine: setMachine
    func encode(to encoder: Encoder) throws {
        var machinecontainer = encoder.container(keyedBy: DynamicKey.self)
        try machinecontainer.encode(machine, forKey: DynamicKey(stringValue: machine.machinetype))
    }
}

struct setMachine: Encodable {
    let machinetype: String
    let setGPUs: setGpu

    func encode(to encoder: Encoder) throws {
        var gpucontainer = encoder.container(keyedBy: DynamicKey.self)
        try gpucontainer.encode(setGPUs, forKey: DynamicKey(stringValue: setGPUs.gpu))
    }
}

struct setGpu: Encodable {
    let gpu: String
    let agdcEnabled: Int
    let setHeuristic: setHeuristic
    let controlID: Int
    let maxPowerState: Int
    let minPowerState: Int

    enum CodingKeys: String, CodingKey {
        case agdcEnabled = "AGDCEnabled"
        case setHeuristic = "Heuristic"
        case controlID = "control-id"
        case maxPowerState = "max-power-state"
        case minPowerState = "min-power-state"
    }
}

struct setHeuristic: Encodable {
    let setID: Int

    enum CodingKeys: String, CodingKey {
        case setID = "ID"
    }
}
