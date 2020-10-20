//
//  NSAlertGenerator.swift
//  PushPush
//

import Cocoa

class NSAlertGenerator {
    static func showInfoAlert(withMessage message: String, additionalText: String) {
        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = additionalText
        alert.addButton(withTitle: StringConstants.ok)
        alert.runModal()
    }
}
