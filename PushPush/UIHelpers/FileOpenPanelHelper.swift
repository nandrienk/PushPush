//
//  FileOpenPanelHelper.swift
//  PushPush
//

import Cocoa

class FileOpenPanelHelper {
    static func selectFile(withFormats formats: [String],
                           dialogTitle: String,
                           completion: (URL) -> Void) {
        let dialog = NSOpenPanel()
        dialog.title = dialogTitle
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.allowsMultipleSelection = false;
        dialog.canChooseDirectories = false;
        dialog.allowedFileTypes = formats;
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            completion(dialog.url!)
        }
    }
}
