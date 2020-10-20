//
//  ViewController.swift
//  PushPush
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet private weak var bundleIdTextField: NSTextField!
    @IBOutlet private weak var simulatorSelectionPopUpButton: NSPopUpButton!
    @IBOutlet private weak var chooseApnsFileButton: NSButton!
    @IBOutlet private weak var pushButton: NSButton!
    @IBOutlet private weak var updateDevicesListButton: NSButton!
    @IBOutlet weak var devicesUpdateProgressIndicator: NSProgressIndicator!
    
    private let xcRunHelper = XCRunHelper()
    private var bootedDevices = [Device]()
    private var selectedFilePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bundleIdTextField.delegate = self
        fetchDevices()
    }
    
    // MARK: - IBAAcations
    @IBAction func selectFileButtonTapped(_ sender: NSButton) {
        FileOpenPanelHelper.selectFile(withFormats: ["apns"], dialogTitle: StringConstants.chooseApnsFile) { (url) in
            selectedFilePath = url.path
            validateFields()
            DispatchQueue.main.async {
                self.chooseApnsFileButton.image = ImageConstants.check
            }
        }
    }
    
    @IBAction func updateButtonTapped(_ sender: NSButton) {
        updateDevicesListButton.isHidden = true
        devicesUpdateProgressIndicator.startAnimation(nil)
        
        fetchDevices {
            self.devicesUpdateProgressIndicator.stopAnimation(nil)
            self.updateDevicesListButton.isHidden = false
        }
    }
    
    @IBAction func pushButtonTapped(_ sender: NSButton) {
        let udid = bootedDevices[simulatorSelectionPopUpButton.indexOfSelectedItem].udid
        let bundleId = bundleIdTextField.stringValue
        let selectedPath = selectedFilePath!
        
        xcRunHelper.sendPushNotification(filePath: selectedPath, udid: String(udid), bundleId: bundleId) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    NSAlertGenerator.showInfoAlert(withMessage: StringConstants.alertPushErrorTitle,
                                                   additionalText: error.localizedDescription)
                }
            case .success(let string):
                DispatchQueue.main.async {
                    NSAlertGenerator.showInfoAlert(withMessage: StringConstants.alertPushTitle,
                                                   additionalText: string)
                }
            }
        }
    }
}

// MARK: Private functions
private extension ViewController {
    func validateFields() {
        guard let _ = selectedFilePath,
              let _ = simulatorSelectionPopUpButton.selectedItem,
              !bundleIdTextField.stringValue.isEmpty else {
            pushButton.isEnabled = false
            return
        }
        
        pushButton.isEnabled = true
    }
    
    func fetchDevices(_ completion: (() -> Void)? = nil) {
        // Clean previous devices
        simulatorSelectionPopUpButton.removeAllItems()
        
        xcRunHelper.avaliableSimulators { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.asyncAfter(deadline: .now() + 1 , execute: {
                    NSAlertGenerator.showInfoAlert(withMessage: StringConstants.alertDeviceFetchErrorTitle,
                                                   additionalText: error.localizedDescription)
                    completion?()
                })
            case .success(let devicesCollection):
                self?.bootedDevices = devicesCollection.bootedDevices
                guard let bootedDevices = self?.bootedDevices.compactMap({ $0.name + " (\($0.udid))" }) else {
                    NSAlertGenerator.showInfoAlert(withMessage: StringConstants.alertDeviceFetchErrorTitle,
                                                   additionalText: StringConstants.noDevicesError)
                    return
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1 , execute: {
                    self?.simulatorSelectionPopUpButton.addItems(withTitles: bootedDevices)
                    completion?()
                })
            }
        }
    }
}

// MARK: NSTextFieldDelegate
extension ViewController: NSTextFieldDelegate {
    func controlTextDidEndEditing(_ obj: Notification) {
        validateFields()
    }
    func controlTextDidChange(_ obj: Notification) {
        pushButton.isEnabled = false
    }
}
