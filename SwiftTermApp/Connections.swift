//
//  Connections.swift
//  testMasterDetail
//
//  Created by Miguel de Icaza on 4/28/20.
//  Copyright © 2020 Miguel de Icaza. All rights reserved.
//

import Foundation
import Combine
import UIKit
import SwiftTerm
 
///
/// Tracks the active SSH Sessions, which often contain one or more terminals.
///
/// Note: terminal views are typically created first, and tracked before a session is created, which only takes place later
///
class Connections: ObservableObject {
    public static var shared: Connections = Connections()
    
    @Published public var sessions: [Session] = [
    ]

    public var terminalsCount: Int {
        dispatchPrecondition(condition: .onQueue(DispatchQueue.main))

        var count = 0
        for session in sessions {
            count += session.terminals.count
        }
        return count
    }
    
    public func active () -> Bool {
        return sessions.count > 0
    }
    
    // Returns a newly allocated array with all active terminals
    public func getTerminals () -> [SshTerminalView] {
        dispatchPrecondition(condition: .onQueue(DispatchQueue.main))

        return sessions.flatMap { $0.terminals }
    }
    
    /// Tracks the terminal
    public static func track (session: Session)
    {
        DispatchQueue.main.async {
            if shared.sessions.contains(session) {
                return
            }
            shared.sessions.append(session)
            
            // This is used to track whether we should keep the display on, only when we have active sessions
            settings.updateKeepOn()
        }
    }
    
    public static func lookupActiveTerminal (host: Host) -> SshTerminalView?
    {
        dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
        if let session = lookupActiveSession(host: host) {
            return session.terminals.first
        }
        return nil
    }
    
    public static func unregister (session: Session) {
        DispatchQueue.main.async {
            if let idx = shared.sessions.firstIndex(of: session) {
                shared.sessions.remove(at: idx)
            }
            settings.updateKeepOn()
        }
    }

    public static func lookupActiveSession (host: Host) -> Session?
    {
        dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
        return shared.sessions.first { $0.host.id == host.id }
    }
}

