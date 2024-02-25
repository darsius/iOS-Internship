import Network


extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [ 
        .other,
        .wifi,
        .cellular,
        .loopback,
        .wiredEthernet
    ]
}
