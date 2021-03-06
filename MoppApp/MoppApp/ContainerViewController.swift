//
//  ContainerViewController.swift
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
protocol ContainerViewControllerDelegate: class {
    func getDataFileCount() -> Int
    func getContainerPath() -> String
    func openContainer(afterSignatureCreated: Bool)
    func getContainerFilename() -> String
    func getDataFileRelativePath(index: Int) -> String
    func getDataFileDisplayName(index: Int) -> String?
    func isContainerEmpty() -> Bool
    func removeDataFile(index: Int)
}

protocol SigningContainerViewControllerDelegate: class {
    func startSigning()
    func getSignaturesCount() -> Int
    func getSignature(index: Int) -> Any
    func removeSignature(index: Int)
    func isContainerSignable() -> Bool
}

protocol CryptoContainerViewControllerDelegate: class {
    func addAddressees()
    func getAddressee(index: Int) -> Any
    func getAddresseeCount() -> Int
    func removeSelectedAddressee(index: Int)
    func startEncrypting()
    func startDecrypting()
}

class ContainerViewController : MoppViewController, ContainerActions, PreviewActions {
    
    var containerViewDelegate: ContainerViewControllerDelegate!
    var cryptoContainerViewDelegate: CryptoContainerViewControllerDelegate!
    var signingContainerViewDelegate: SigningContainerViewControllerDelegate! 
    var containerModel: Any!
    
    var containerPath: String!
    var isForPreview: Bool = false
    var isCreated: Bool = false
    var forcePDFContentPreview: Bool = false
    var startSigningWhenOpened = false
    var isDecrypted = false
    let landingViewController = LandingViewController.shared!
    var isAsicContainer = LandingViewController.shared.containerType == .asic
    @IBOutlet weak var tableView: UITableView!

    enum Section {
        case notifications
        case signatures
        case missingSignatures
        case timestamp
        case dataFiles
        case importDataFiles
        case addressees
        case importAddressees
        case missingAddressees
        case header
        case search
    }

    enum ContainerState {
        case loading        // Before container is opened or created
        case created
        case opened
        case preview
    }
    
    var isSectionRowEditable: [Section: Bool] = [
        .notifications   : false,
        .signatures     : true,
        .timestamp      : false,
        .dataFiles      : true,
        .addressees     : true,
        .missingAddressees : false,
        .header         : false,
        .search         : false
        ]

    var sectionHeaderTitle: [Section: String] = [
        .dataFiles      : L(LocKey.containerHeaderFilesTitle),
        .timestamp      : L(LocKey.containerHeaderTimestampTitle),
        .missingAddressees  : L(LocKey.containerHeaderCreateAddresseesTitle),
        .addressees  : L(LocKey.containerHeaderCreateAddresseesTitle),
        .signatures     : L(LocKey.containerHeaderSignaturesTitle)
        ]

    internal static let sectionsDefault  : [Section] = [.notifications, .header, .dataFiles, .signatures]
    private static let sectionsNoSignatures : [Section] = [.notifications, .header, .dataFiles, .importDataFiles]
    internal static let sectionsNoAddresses : [Section] =  [.notifications, .header, .dataFiles, .importDataFiles, .missingAddressees, .importAddressees]
    internal static let sectionsWithAddresses : [Section] = [.notifications, .header, .dataFiles, .importDataFiles, .addressees, .importAddressees]
    internal static let sectionsEncrypted : [Section] = [.notifications, .header, .dataFiles, .addressees]
    var sections: [Section] = ContainerViewController.sectionsDefault
    var notifications: [(isSuccess: Bool, text: String)] = []
    var state: ContainerState!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInsetAdjustmentBehavior = .never
        updateState(.loading)
        
        NotificationCenter.default.addObserver(self, selector: #selector(signatureCreatedFinished), name: .signatureCreatedFinishedNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main) { [weak self]_ in
            self?.refreshLoadingAnimation()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func signatureCreatedFinished() {
        DispatchQueue.main.async {
        [weak self] in
            self?.isCreated = false
            self?.isForPreview = false
            self?.updateState(.loading)
            self?.containerViewDelegate.openContainer(afterSignatureCreated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        landingViewController.tabButtonsDelegate = self
        
        reloadData()
        updateState(state)
    
        tableView.estimatedRowHeight = ContainerSignatureCell.height
        tableView.rowHeight = UITableViewAutomaticDimension
        
        showLoading(show: state == .loading)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        containerViewDelegate.openContainer(afterSignatureCreated:false)
    }
    
    func updateState(_ newState: ContainerState) {
        showLoading(show: newState == .loading)
        switch newState {
            case .loading:
                if isForPreview {
                    LandingViewController.shared.presentButtons([])
                }
                setupNavigationItemForPushedViewController(title: L(.containerValidating))

            case .created:
                if isAsicContainer {
                    setupNavigationItemForPushedViewController(title: L(.containerSignTitle))
                    LandingViewController.shared.presentButtons(isForPreview ? [] : [.signButton])
                }else{
                    setupNavigationItemForPushedViewController(title: L(.containerEncryptionTitle))
                    LandingViewController.shared.presentButtons(isForPreview ? [] : [.encryptButton])
                }  

            case .opened:
                var tabButtons: [LandingViewController.TabButtonId] = []
                if !isForPreview && isAsicContainer {
                    tabButtons = [.shareButton, .signButton]
                    setupNavigationItemForPushedViewController(title: L(.containerValidateTitle))
                } else if !isForPreview {
                    if isDecrypted {
                         tabButtons = []
                    } else {
                        tabButtons = [.decryptButton, .shareButton]
                    }
                    setupNavigationItemForPushedViewController(title: L(.containerDecryptionTitle))
                } else {
                    setupNavigationItemForPushedViewController(title: L(.containerValidateTitle))
                    tabButtons = [.shareButton]
                }
                LandingViewController.shared.presentButtons(tabButtons)
            
            case .preview:
                let containerUrl = URL(fileURLWithPath: containerPath!)
                let (filename, ext) = containerUrl.lastPathComponent.filenameComponents()
                LandingViewController.shared.presentButtons([])
                setupNavigationItemForPushedViewController(title: filename + "." + ext)
        }
        state = newState
    }
    
    override func showLoading(show: Bool, forFrame: CGRect? = nil) {
        super.showLoading(show: show, forFrame: tableView.frame)
        tableView.isHidden = show
    }
    
    class func instantiate() -> ContainerViewController {
        return UIStoryboard.container.instantiateInitialViewController(of: ContainerViewController.self)
    }
    
    func reloadContainer() {
        updateState(.loading)
        containerViewDelegate.openContainer(afterSignatureCreated:false)
        reloadData()
    }
    
}

extension ContainerViewController : LandingViewControllerTabButtonsDelegate {
    func landingViewControllerTabButtonTapped(tabButtonId: LandingViewController.TabButtonId, sender: UIView) {
        if tabButtonId == .signButton {
            signingContainerViewDelegate.startSigning()
        }
        else if tabButtonId == .shareButton {
            LandingViewController.shared.shareFile(using: URL(fileURLWithPath: containerPath), sender: sender, completion: { bool in })
        }
        else if tabButtonId == .encryptButton {
            cryptoContainerViewDelegate.startEncrypting()
        }
        else if tabButtonId == .decryptButton {
            cryptoContainerViewDelegate.startDecrypting()
        }
    }
}

extension ContainerViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if containerViewDelegate.isContainerEmpty() {
            return 0
        }
        switch sections[section] {
        case .notifications:
            return notifications.count
        case .signatures:
            if !isAsicContainer {
                return 0
            }
            return signingContainerViewDelegate.getSignaturesCount()
        case .dataFiles:
            return containerViewDelegate.getDataFileCount()
        case .addressees:
            return cryptoContainerViewDelegate.getAddresseeCount()
        case .missingSignatures, .header, .search, .timestamp, .importDataFiles, .importAddressees, .missingAddressees:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch sections[indexPath.section] {
        case .notifications:
            let cell = tableView.dequeueReusableCell(withType: ContainerNotificationCell.self, for: indexPath)!
                cell.populate(isSuccess: notifications[indexPath.row].isSuccess, text: notifications[indexPath.row].text)
            return cell
        case .signatures:
            let cell = tableView.dequeueReusableCell(withType: ContainerSignatureCell.self, for: indexPath)!
                cell.delegate = self
            let signature =  signingContainerViewDelegate.getSignature(index: indexPath.row) as! MoppLibSignature
            cell.populate(
                with: signature,
                kind: .signature,
                showBottomBorder: row < signingContainerViewDelegate.getSignaturesCount() - 1,
                showRemoveButton: !isForPreview && signingContainerViewDelegate.isContainerSignable(),
                signatureIndex: row)
            return cell
        case .missingSignatures:
            let cell = tableView.dequeueReusableCell(withType: ContainerNoSignaturesCell.self, for: indexPath)!
            return cell
        case .timestamp:
            let cell = tableView.dequeueReusableCell(withType: ContainerSignatureCell.self, for: indexPath)!
                //cell.populate(name: mockTimestamp[row], kind: .timestamp, colorTheme: .neutral, showBottomBorder: row < mockTimestamp.count - 1)
            return cell
        case .dataFiles:
            let cell = tableView.dequeueReusableCell(withType: ContainerFileCell.self, for: indexPath)!
                cell.delegate = self
            
            var isRemoveButtonShown = false
            if isAsicContainer {
                isRemoveButtonShown = containerViewDelegate.getDataFileCount() > 1   &&
                    !isForPreview   &&
                    (signingContainerViewDelegate.getSignaturesCount() == 0)    &&
                    signingContainerViewDelegate.isContainerSignable()
            } else {
                isRemoveButtonShown = containerViewDelegate.getDataFileCount() > 1   &&
                    !isForPreview   &&
                    (!(!isAsicContainer && state == .opened))
            }
                cell.populate(
                    name: containerViewDelegate.getDataFileDisplayName(index: row) ?? String(),
                    showBottomBorder: row < containerViewDelegate.getDataFileCount() - 1,
                    showRemoveButton: isRemoveButtonShown,
                    dataFileIndex: row)
            return cell
        case .importDataFiles:
            let cell = tableView.dequeueReusableCell(withType: ContainerImportFilesCell.self, for: indexPath)!
                cell.delegate = self
            return cell
        case .header:
            let cell = tableView.dequeueReusableCell(withType: ContainerHeaderCell.self, for: indexPath)!
                cell.populate(name: containerViewDelegate.getContainerFilename())
            return cell
        case .search:
            let cell = tableView.dequeueReusableCell(withType: ContainerSearchCell.self, for: indexPath)!
            return cell
        case .addressees:
            let cell = tableView.dequeueReusableCell(withType: ContainerAddresseeCell.self, for: indexPath)!
            cell.delegate = self
            let isStatePreviewOrOpened = state == .opened || state == .preview
            let isRemoveButtonHidden = !isAsicContainer && isStatePreviewOrOpened
            cell.populate(addressee: cryptoContainerViewDelegate.getAddressee(index: indexPath.row) as! Addressee,
                          index: row,
                          showRemoveButton: !isRemoveButtonHidden)
            return cell
        case .importAddressees:
            let cell = tableView.dequeueReusableCell(withType: ContainerImportAddresseesCell.self, for: indexPath)!
            cell.delegate = self
            return cell
        case .missingAddressees:
            let cell = tableView.dequeueReusableCell(withType: ContainerNoAddresseesCell.self, for: indexPath)!
            return cell
        }
    }
}

extension ContainerViewController : ContainerFileDelegate {
    func removeDataFile(dataFileIndex: Int) {
        containerViewDelegate.removeDataFile(index: dataFileIndex)
    }
}

extension ContainerViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .notifications:
            break
        case .signatures:
            break
        case .missingSignatures:
            break
        case .timestamp:
            break;
        case .dataFiles:
            let isStatePreviewOrOpened = state == .opened || state == .preview
            let isEncryptedDataFiles =
                !isAsicContainer &&
                isStatePreviewOrOpened &&
                isDecrypted == false
            if  !isEncryptedDataFiles {
                if isDecrypted {
                    guard let dataFile = containerViewDelegate.getDataFileDisplayName(index: indexPath.row) else { return }
                    openFilePreview(dataFileFilename: dataFile, containerFilePath: containerViewDelegate.getContainerPath(), isShareButtonNeeded: true)
                } else {
                    let dataFile = containerViewDelegate.getDataFileRelativePath(index: indexPath.row)
                    openFilePreview(dataFileFilename: dataFile, containerFilePath: containerViewDelegate.getContainerPath(), isShareButtonNeeded: false)
                }
                
            }
            break
        case .header:
            break
        case .search:
            break
        case .importDataFiles:
            break
        case .addressees:
            break
        case .importAddressees:
            break
        case .missingAddressees:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection _section: Int) -> UIView? {
        let section = sections[_section]
        var title: String!
        switch section {
            case .dataFiles:
                let createFileTitle = L(LocKey.containerHeaderCreateFilesTitle)
                title = isCreated ? createFileTitle : L(LocKey.containerHeaderFilesTitle)
            default:
                title = sectionHeaderTitle[section]
        }
        
        if let header = MoppApp.instance.nibs[.containerElements]?.instantiate(withOwner: self, type: ContainerTableViewHeaderView.self) {
            var signaturesCount = 0
            var isContainerSignable = false
            if isAsicContainer {
                signaturesCount = signingContainerViewDelegate.getSignaturesCount()
                isContainerSignable = signingContainerViewDelegate.isContainerSignable()
            }
            
            header.delegate = self
            header.populate(
                withTitle: title,
                showAddButton:
                    section == .dataFiles   &&
                    !isCreated              &&
                    signaturesCount == 0    &&
                    !isForPreview           &&
                    isContainerSignable)
            return header
        }

        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection _section: Int) -> CGFloat {
        let section = sections[_section]
        if sectionHeaderTitle[section] != nil {
            return ContainerTableViewHeaderView.height
        }
        return 0
    }
    
    func reloadData() {
        if containerViewDelegate.isContainerEmpty() {
            return
        }
        var isSignaturesEmpty: Bool {
            if !isAsicContainer { return true }
            return signingContainerViewDelegate.getSignaturesCount() == 0
        }
        if isForPreview {
            updateState(.preview)
        }
        else if isSignaturesEmpty && isCreated {
            updateState(.created)
        }
        else {
            updateState(.opened)
        }
        if isAsicContainer {
            if isSignaturesEmpty {
                    sections = (isForPreview || !isCreated) ? ContainerViewController.sectionsDefault : ContainerViewController.sectionsNoSignatures
                if let signaturesIndex = sections.index(where: { $0 == .signatures }) {
                    if !sections.contains(.missingSignatures) {
                        sections.insert(.missingSignatures, at: signaturesIndex + 1)
                    }
                }
            }
            else {
                sections = ContainerViewController.sectionsDefault
            }
        
        }
        
        tableView.reloadData()
        
        // Animate away success message if there is any
        if let notificationIndex = notifications.index(where: { $0.0 == true }), sections.contains(.notifications) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                if (self?.notifications.isEmpty)! { return }
                self?.notifications.remove(at: notificationIndex)
                if let notificationsSection = self?.sections.index(where: { $0 == .notifications }) {
                    self?.tableView.reloadSections([notificationsSection], with: .automatic)
                }
            }
        }
    }
}

extension ContainerViewController : ContainerSignatureDelegate {
    func containerSignatureRemove(signatureIndex: Int) {
        signingContainerViewDelegate.removeSignature(index: signatureIndex)
    }
}

extension ContainerViewController : ContainerTableViewHeaderDelegate {
    func didTapContainerHeaderButton() {
        NotificationCenter.default.post(
            name: .startImportingFilesWithDocumentPickerNotificationName,
            object: nil,
            userInfo: [kKeyFileImportIntent: MoppApp.FileImportIntent.addToContainer, kKeyContainerType: LandingViewController.shared.containerType])
    }
}

extension ContainerViewController : ContainerImportAddresseeCellDelegate {
    func containerImportCellAddAddressee() {
        cryptoContainerViewDelegate.addAddressees()
    }
}

extension ContainerViewController : ContainerAddresseeCellDelegate {
    func removeAddressee(index: Int) {
        cryptoContainerViewDelegate.removeSelectedAddressee(index: index)
    }
    
}

extension ContainerViewController : ContainerImportCellDelegate {
    func containerImportCellAddFiles() {
        NotificationCenter.default.post(
            name: .startImportingFilesWithDocumentPickerNotificationName,
            object: nil,
            userInfo: [kKeyFileImportIntent: MoppApp.FileImportIntent.addToContainer, kKeyContainerType: LandingViewController.shared.containerType])
    }
}
