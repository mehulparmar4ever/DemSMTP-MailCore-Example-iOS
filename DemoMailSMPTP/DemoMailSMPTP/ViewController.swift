//
//  ViewController.swift
//  DemoMailSMPTP
//
//  Created by Mehul Parmar on 05/03/20.
//  Copyright © 2020 Mehul Parmar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //IBActions for button 'View Sheet'
    @IBAction func btnSendMailClicked(_ sender: UIButton) {
        print(#function)
        
        //Create Sesstion : Configure SMPTP Mail
        let smtpSession = MCOSMTPSession()
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.username = "email@gmail.com"
        smtpSession.password = "password" //pbbmdxojckmbnuhe
        smtpSession.port = 587 //25
        smtpSession.authType = MCOAuthType.saslPlain
        smtpSession.connectionType = MCOConnectionType.startTLS //TLS Or Clear
        smtpSession.isCheckCertificateEnabled = false
        
        //LOG : If you want to check log then uncomment below code
//        smtpSession.connectionLogger = {(connectionID, type, data) in
//            if data != nil {
//                if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
//                    NSLog("Connectionlogger: \(string)")
//                }
//            }
//        }

        //Create Builder : Set Data (Sender, Receiver, Subject, Body, Attachment, CC, BCC, etc..)
        let builder = MCOMessageBuilder()
        builder.header.to = [MCOAddress(displayName: "Swifty", mailbox: "mehulasjack@gmail.com")!]
        builder.header.from = MCOAddress(displayName: "Mehul Parmar", mailbox: "mehulasjack@gmail.com")
        builder.header.subject = "Sub: Test message"
        builder.htmlBody = "Hello Public, this is a test message! with attached Excel file"
        //builder.header.cc // You can add CC from here
        //builder.header.bcc // You can add BCC from here
        
        //Arrachment : Get file path , Convert it into data and attached it in mail attachment
        let urlFilePath = Bundle.main.url(forResource: "MonthlyExport", withExtension: "xlsx")
        let dataFile = try! Data(contentsOf: urlFilePath!)
        let fileNameWithExtension = urlFilePath!.lastPathComponent
        let extensionName = urlFilePath!.lastPathComponent.fileExtension()
        
        let attachment = MCOAttachment()
        attachment.mimeType =  MimeType(ext: extensionName)
        attachment.filename = fileNameWithExtension
        attachment.data = dataFile
        builder.addAttachment(attachment) //Attachment is optional
        
        //Send Mail : It will take upto 1 min max depends on Internet speed/Attachment
        let rfc822Data = builder.data()
        let sendOperation = smtpSession.sendOperation(with: rfc822Data)
        sendOperation?.start { (error) -> Void in
            if (error != nil) {
                NSLog("Error sending email: \(String(describing: error))")
            } else {
                NSLog("Successfully sent email!")
            }
        }
    }
}
