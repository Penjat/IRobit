//
//  IntentHandler.swift
//  FaceDirection
//
//  Created by Spencer Symington on 2022-07-18.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    func handle(intent: FaceDirectionIntent, completion: @escaping (FaceDirectionIntentResponse) -> Void) {
        
        print("recieved intent")
    }
}
