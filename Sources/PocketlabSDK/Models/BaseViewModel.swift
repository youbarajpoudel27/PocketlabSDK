//
//  File.swift
//  
//
//  Created by Youbaraj POUDEL on 26/11/2023.
//

import Foundation
import Combine

public class BaseViewModel {
    
    public var bag = Set<AnyCancellable>()

   public init() {
//       print("")
    }
    
    deinit {
//        debugPrint("De-initialized --> \(String(describing: self))")
    }

}
