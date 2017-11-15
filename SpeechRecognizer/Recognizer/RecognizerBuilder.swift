//
//  RecognizerBuilder.swift
//  SpeechRecognizer
//
//  Created by Andrei Momot on 11/15/17.
//    Copyright © 2017 Andrey Momot. All rights reserved.
//

import UIKit

class RecognizerBuilder: NSObject {

    class func viewController() -> RecognizerViewController {

        let view: RecognizerViewProtocol = RecognizerView.create() as  RecognizerViewProtocol
        let model: RecognizerModelProtocol = RecognizerModel()
        let router = RecognizerRouter()
        
        let viewController = RecognizerViewController(withView: view, model: model, router: router)
        return viewController
    }
}
