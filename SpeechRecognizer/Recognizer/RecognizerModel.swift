//
//  RecognizerModel.swift
//  SpeechRecognizer
//
//  Created by Andrei Momot on 11/15/17.
//    Copyright © 2017 Andrey Momot. All rights reserved.
//

import UIKit

protocol RecognizerModelDelegate: NSObjectProtocol {
    
}

protocol RecognizerModelProtocol: NSObjectProtocol {
    
    weak var delegate: RecognizerModelDelegate? { get set }
}

class RecognizerModel: NSObject, RecognizerModelProtocol {
    
    // MARK: - RecognizerModel methods

    weak public var delegate: RecognizerModelDelegate?
    
    /** Implement RecognizerModel methods here */
    
    
    // MARK: - Private methods
    
    /** Implement private methods here */
    
}
