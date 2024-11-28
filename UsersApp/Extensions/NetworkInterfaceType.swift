import Network


extension NWInterface.InterfaceType: @retroactive CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [ 
        .other,
        .wifi,
        .cellular,
        .loopback,
        .wiredEthernet
    ]
}
