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
import SDWebImage


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
        MessagesHandler.Instance.observeMediaMessages();
        
        // Do any additional setup after loading the view.
    }
    
    //COLLECTION VIEW FUNCTIONS
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let bubbleFactory = JSQMessagesBubbleImageFactory();
        let message = messages[indexPath.item];
        
        if message.senderId == self.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.blue);
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.blue);
        }
        
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
        
        //messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text));
        //collectionView.reloadData();
        
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
            
            let data = UIImageJPEGRepresentation(pic, 0.01);
            MessagesHandler.Instance.sendMedia(image: data, video: nil, senderID: senderId, senderName: senderDisplayName);
            
            //Checks if it is a photo then displays it
        } else  if let vidURL  = info[UIImagePickerControllerMediaURL] as? URL {
            
            MessagesHandler.Instance.sendMedia(image: nil, video: vidURL, senderID: senderId, senderName: senderDisplayName);

            
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
    
//    func mediaReceived(senderID: String, senderName: String, url: String) {
//        if let mediaURL = URL(string: url) {
//            
//            do {
//                let data = try Data(contentsOf: mediaURL);
//                
//                if let _ = UIImage(data:data) {
//                    let _ = SDWebImageDownloader.shared().downloadImage(with: mediaURL, options: [], progress: nil, completed: { (image, data, error, finished) in
//                        
//                        DispatchQueue.main.async {
//                            let photo = JSQPhotoMediaItem(image: image)
//                            if senderID == self.senderId {
//                                photo?.appliesMediaViewMaskAsOutgoing = true;
//                            }else {
//                                photo?.appliesMediaViewMaskAsOutgoing = false;
//                            }
//                            self.messages.append(JSQMessage(senderId: senderID, displayName: senderName , media: photo));
//                            self.collectionView.reloadData();
//                            
//                            
//                        
//                        }
//                        
//                    })
//                }
//            } catch {
//                //Catches all potential errors
//            }
//            
//        }
//        
//    }
    func mediaReceived(senderID: String, senderName: String, url: String) {
        
        if let mediaURL = URL(string: url) {
            
            do {
                
                let data = try Data(contentsOf: mediaURL);
                
                if let _ = UIImage(data: data) {
                    
                    let _ = SDWebImageDownloader.shared().downloadImage(with: mediaURL, options: [], progress: nil, completed: { (image, data, error, finished) in
                        
                        DispatchQueue.main.async {
                            let photo = JSQPhotoMediaItem(image: image);
                            if senderID == self.senderId {
                                photo?.appliesMediaViewMaskAsOutgoing = true;
                            } else {
                                photo?.appliesMediaViewMaskAsOutgoing = false;
                            }
                            
                            self.messages.append(JSQMessage(senderId: senderID, displayName: senderName, media: photo));
                            self.collectionView.reloadData();
                            
                        }
                        
                    })
                    
                } else {
                    let video = JSQVideoMediaItem(fileURL: mediaURL, isReadyToPlay: true);
                    if senderID == self.senderId {
                        video?.appliesMediaViewMaskAsOutgoing = true;
                    } else {
                        video?.appliesMediaViewMaskAsOutgoing = false;
                    }
                    messages.append(JSQMessage(senderId: senderID, displayName: senderName, media: video));
                    self.collectionView.reloadData();
                    
                }
                
            } catch {
                // here we are gonna catch all potential errors that we get
            }
            
        }
        
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
