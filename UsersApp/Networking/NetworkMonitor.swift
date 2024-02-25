import UIKit
import Foundation
import Network


final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private (set) var isConnected = false
    private (set) var isExpensive = false
    private (set) var currentConnectionType: NWInterface.InterfaceType?
    private let networkQueue = DispatchQueue(label: "NetworkConnectivityMonitor")
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status != .unsatisfied
                self?.isExpensive = path.isExpensive
                self?.currentConnectionType = NWInterface.InterfaceType.allCases.filter{path.usesInterfaceType($0)}.first
                NotificationCenter.default.post(name: .connectivityStatus, object: nil)
            }
        }
        monitor.start(queue: networkQueue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
