//
//  Chat2VC.swift
//  MedSync4.0
//
//  Created by - on 2017/04/17.
//  Copyright © 2017 Danth. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit


class Chat2VC: JSQMessagesViewController, MessageReceivedDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var messages = [JSQMessage]();
    
    let picker = UIImagePickerController();


    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self;
        MessagesHandler.Instance.delegate = self;
        
        self.senderId = AuthProvider.Instance.userID();
        self.senderDisplayName = AuthProvider.Instance.userName;
        
        MessagesHandler.Instance.observeMessages();
        
        // Do any additional setup after loading the view.
    }
    
    //COLLECTION VIEW FUNCTIONS
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let bubbleFactory = JSQMessagesBubbleImageFactory();
        //let message = messages[indexPath.item];
        return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.blue);
        
        //Blue background for text messages
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "user"), diameter: 30);
        
        //Displays the avatar image (profile picture) for the users
    }
    
   
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item];
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let msg = messages[indexPath.item];
        if msg.isMediaMessage {
            if let mediaItem = msg.media as? JSQVideoMediaItem {
                let player = AVPlayer(url: mediaItem.fileURL);
                let playerController = AVPlayerViewController();
                playerController.player = player;
                self.present(playerController, animated:true, completion:nil);
            
            }//Checks if it is a media message, if it is, tries converting it into a video
        }
        
        //Clicking a video item will play the video
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell;
        
        return cell;
    }
    
    //END COLLECTION VIEW FUNCTIONS
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        MessagesHandler.Instance.sendMessage(senderID: senderId, senderName: senderDisplayName, text: text);
        
        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text));
        collectionView.reloadData();
        
        //This will remove text from the text field
        finishSendingMessage();
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil);
        
        //Dismisses this view controller
    }
    
    
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let alert = UIAlertController(title: "Media Messages", message: "Please Select A Media", preferredStyle: .actionSheet);
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        let photos = UIAlertAction(title: "Photos", style: .default, handler: { (alert: UIAlertAction) in
            self.chooseMedia(type: kUTTypeImage);
        })
        let videos = UIAlertAction(title: "Videos", style: .default, handler: { (alert: UIAlertAction) in
            self.chooseMedia(type: kUTTypeMovie);

        })
        
        alert.addAction(photos);
        alert.addAction(videos);

        alert.addAction(cancel);
        present(alert, animated:true, completion:nil);
        
        //Creates the pop-up to choose photo vs video
    }
    
    //END SENDING BUTTON FUNCTIONS


    //PICKER VIEW FUNCTIONS
    
    private func chooseMedia(type: CFString) {
        picker.mediaTypes = [type as String];
        present(picker, animated:true, completion: nil);
    } //Presents mini screen with option of photo vs video
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pic = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let img = JSQPhotoMediaItem(image:pic);
            self.messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: img));
            
            //Checks if it is a photo then displays it
        } else  if let vidUrl  = info[UIImagePickerControllerMediaURL] as? URL {
            
            let video = JSQVideoMediaItem(fileURL: vidUrl, isReadyToPlay: true);
            messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: video));
            
            //Checks if it is a video then displays it
        }
        
        self.dismiss(animated: true, completion: nil);
        collectionView.reloadData();
        
    }
    
    //END PICKER VIEW FUNCTIONS
    
    //DELEGATINO FUNCTIONS
    
    func messageReceived(senderID: String, senderName: String,  text: String) {
        messages.append(JSQMessage(senderId: senderID, displayName: senderName, text: text));
        collectionView.reloadData();
    }
    
    
    //END DELEGATION FUNCTIONS
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
