//
//  ViewController.swift
//  TravelApp_1
//
//  Created by Sinan MacBook on 8.12.2019.
//  Copyright © 2019 Sinan MacBook. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage


class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var myDb: Firestore!
    
    var storageReff : StorageReference {
        return Storage.storage().reference().child("images")
    }
    
    var globalImage = [UIImage]()
    var collectionArr = [LocationModel]()
        

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        donwloadLocationImages()
        //Collection View DataSource and Delegate to ViewController
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //CollectionView Spacing
        spacingCollectionViewCell()
       
        //Database Firestore
        //Load info from firestore
        myDb = Firestore.firestore()
        loadInfoFromFirestore()
        
    }
    
    func donwloadLocationImages()  {
        let downloadImageRef = storageReff.child("adalar.jpeg")

        let dowloadTask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
            if let e = error {
                print(e)
            }else {
                if let data = data {
                    let image = UIImage(data: data)
                    //print(image)
                    self.globalImage.append(image!)
                    
                }
            }
            
        }
        dowloadTask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "No more progress")
            print("Sinan")
        }

        dowloadTask.resume()
    }
    
    func loadInfoFromFirestore() {
        collectionArr = []
        myDb.collection("city").getDocuments { (querySnapshot, error) in
            if let e = error {
                print("There was issue")
            } else {
                if let snapshotDocument = querySnapshot?.documents {
                    for doc in snapshotDocument {
                        let _data = doc.data()
                        for data in _data.keys {
                            let newMessageKey = LocationModel(location: data)
                            self.collectionArr.append(newMessageKey)
                            print(self.collectionArr.count)
                            
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                            
                        }
                    }
                }
            }
        }
        collectionView.reloadData()
    }

    //Number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionArr.count
    }
    
    //Cell adrresing to InfoCell
    //Image show name
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "infoCell", for: indexPath) as! InfoCollectionViewCell
        
        
        cell.infoImage.image = globalImage[0]
        cell.locationLabel.text = String(collectionArr[indexPath.row].location)
        return cell
    }
    
    //CollectionView layout customize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 10
        //let height = UIScreen.main.bounds.width/3 + UIScreen.main.bounds.height / 10
        let height =  UIScreen.main.bounds.height / 5
        return CGSize(width: width, height:  height)
        
    }
    
    //Spacing between collection cells
    func spacingCollectionViewCell() {
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView.collectionViewLayout = layout
        
    }
    
}


