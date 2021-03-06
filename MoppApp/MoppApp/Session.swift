//
//  Session.swift
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

class Session
{
    static let shared = Session()

    func createMobileSignature(withContainer containerPath: String, idCode: String, language: String, phoneNumber: String) {
        MoppLibContainerActions.sharedInstance().openContainer(
            withPath: containerPath,
            success: { (_ initialContainer: MoppLibContainer!) -> Void in
                MoppLibService.sharedInstance().mobileCreateSignature(
                    withContainer: containerPath,
                    idCode: idCode,
                    language: language,
                    phoneNumber: phoneNumber,
                    withCompletion: { (_ response: MoppLibMobileCreateSignatureResponse!) -> Void in
                        NotificationCenter.default.post(
                            name: .createSignatureNotificationName,
                            object: nil,
                            userInfo: [kCreateSignatureResponseKey: response])
                        
                    },
                    andStatus: { (_ container: MoppLibContainer?, _ error: Error?, _ status: String?) -> Void in
                        if let status = status {
                            if status == "OUTSTANDING_TRANSACTION" {
                                NotificationCenter.default.post(name: .signatureMobileIDPendingRequestNotificationName, object: nil)
                            }
                        }
                        
                        if let error = error {
                            NotificationCenter.default.post(
                                name: .errorNotificationName,
                                object: nil,
                                userInfo: [kErrorKey: error])
                        }
                        else
                        if let container = container {
                            NotificationCenter.default.post(
                                name: .signatureAddedToContainerNotificationName,
                                object: nil,
                                userInfo: [kNewContainerKey: container, kOldContainerKey: initialContainer])
                        }
                    }
                    
            )},
            failure: { (_ error: Error?) -> Void in
                NotificationCenter.default.post(name: .errorNotificationName, object: nil, userInfo: [kErrorKey: error!])
                return
            })
    }
}
