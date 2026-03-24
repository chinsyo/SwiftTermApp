//
//  ConnectionMessage.swift
//  SwiftTermApp
//
//  Created by Miguel de Icaza on 2/15/22.
//  Copyright © 2022 Miguel de Icaza. All rights reserved.
//

import Foundation

protocol ConnectionMessage {
    init(host: Host, message: String, ok: @escaping ()->())
}
