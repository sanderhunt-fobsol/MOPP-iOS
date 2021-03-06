//
//  MobileIDChallengeViewController.swift
//  MoppApp
//
/*
 * Copyright 2017 Riigi Infosüsteemide Amet
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */
private var kRequestTimeout: Double = 60.0


class MobileIDChallengeViewController : UIViewController {
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var timeoutProgressView: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var helpLabel: UILabel!
    
    var challengeID = String()
    var sessCode = String()

    var currentProgress: Double = 0.0
    var sessionTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = MoppLib_LocalizedString("digidoc-service-status-request-sent")
        helpLabel.text = L(.mobileIdSignHelpTitle)
        codeLabel.isHidden = true
        timeoutProgressView.progress = 0

        NotificationCenter.default.addObserver(self, selector: #selector(receiveCreateSignatureStatus), name: .signatureAddedToContainerNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveErrorNotification), name: .errorNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveStatusPendingNotification), name: .signatureMobileIDPendingRequestNotificationName, object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receiveMobileCreateSignatureNotification),
            name: .createSignatureNotificationName,
            object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func receiveStatusPendingNotification(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.text = MoppLib_LocalizedString("digidoc-service-status-request-outstanding-transaction")
        }
    }

    @objc func receiveCreateSignatureStatus(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.text = MoppLib_LocalizedString("digidoc-service-status-request-signature")
        }
        sessionTimer?.invalidate()
        NotificationCenter.default.post(name: .signatureCreatedFinishedNotificationName, object: nil)
        dismiss(animated: false)
    }
    
    @objc func receiveMobileCreateSignatureNotification(_ notification: Notification) {

        guard let response = notification.userInfo?[kCreateSignatureResponseKey] as? MoppLibMobileCreateSignatureResponse else {
            return
        }
    
        challengeID = response.challengeId!
        sessCode = "\(Int(response.sessCode))"
    
        codeLabel.isHidden = false
        titleLabel.text = MoppLib_LocalizedString("digidoc-service-status-request-ok")
        codeLabel.text = L(LocKey.challengeCodeLabel, [challengeID])
        currentProgress = 0.0
        
        sessionTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSessionProgress), userInfo: nil, repeats: true)
    }
    
    @objc func receiveErrorNotification() {
        sessionTimer?.invalidate()
        MoppLibService.sharedInstance().cancelMobileSignatureStatusPolling()
        dismiss(animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        UIView.animate(withDuration: 0.35) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }

    func viewWillDisAppear(_ animated: Bool) {
        sessionTimer?.invalidate()
    }

    @objc func updateSessionProgress(_ timer: Timer) {
        if currentProgress < 1.0 {
            let step: Double = 1.0 / kRequestTimeout
            currentProgress = currentProgress + step
            timeoutProgressView.progress = Float(currentProgress)
        }
        else {
            timer.invalidate()
            MoppLibService.sharedInstance().cancelMobileSignatureStatusPolling()
            dismiss(animated: false, completion: nil)
            NotificationCenter.default.post(name: .errorNotificationName, object: nil, userInfo: [kErrorMessage: L(.mobileIdTimeoutMessage)])
        }
    }

}
