//
//  RecognizerView.swift
//  SpeechRecognizer
//
//  Created by Andrei Momot on 11/15/17.
//    Copyright © 2017 Andrey Momot. All rights reserved.
//

import UIKit

protocol RecognizerViewDelegate: NSObjectProtocol {
    
    func startRecognition(view: RecognizerViewProtocol)
}

protocol RecognizerViewProtocol: NSObjectProtocol {
    
    weak var delegate: RecognizerViewDelegate? { get set }
    var recordButton: UIButton! { get }
    var recognizedTextView: UITextView! { get }
}

class RecognizerView: UIView, RecognizerViewProtocol{
    
    // MARK: - RecognizerView interface methods

    weak public var delegate: RecognizerViewDelegate?
    
    @IBOutlet var recognizedTextView: UITextView!
    @IBOutlet var recordButton: UIButton!
    // MARK: - Overrided methods

    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - IBActions
    
    @IBAction func onPressedRecordButton(_ sender: Any) {
        self.delegate?.startRecognition(view: self)
    }
}
