//
//  ViewController.swift
//  APOD
//
//  Created by Doren Proctor on 4/7/18.
//  Copyright © 2018 Doren Proctor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var copyrightLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    
    let popoverViewController = UIViewController()
    let datePicker: UIDatePicker = UIDatePicker()
    
    @IBAction func changeDate(_ sender: UIButton) {
        
        // Position date picket within a view
        datePicker.frame = CGRect(x: 10, y: self.view.frame.height-300, width: self.view.frame.width, height: 200)
        
        // Set some of UIDatePicker properties
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePickerMode.date
        
        // Add an event to call onDidChangeDate function when value is changed.
//        datePicker.addTarget(self, action: #selector(ViewController.datePickerValueChanged(_:)), for: .valueChanged)
        
        
        
        let selectButton = UIButton(frame: CGRect(x: 0, y: self.view.frame.height-100, width: self.view.frame.width, height: 50))
        let swiftColor = UIColor(red: 93/255, green: 173/255, blue: 226/255, alpha: 1)
        selectButton.backgroundColor = swiftColor
        selectButton.setTitle("Select Date", for: .normal)
        selectButton.addTarget(self, action: #selector(selectDate), for: .touchUpInside)
        
        let cancelButton = UIButton(frame: CGRect(x: 0, y: self.view.frame.height-50, width: self.view.frame.width, height: 50))
        cancelButton.backgroundColor = .gray
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelDate), for: .touchUpInside)
        
        let popoverView = UIView()
        popoverView.backgroundColor = UIColor.clear
        popoverView.addSubview(datePicker)
        popoverView.addSubview(selectButton)
        popoverView.addSubview(cancelButton)
        
        
        let popoverViewController = UIViewController()
        popoverViewController.view = popoverView
        popoverViewController.view.frame = CGRect(x: 0, y: 0, width: 320, height: 216)
        popoverViewController.modalPresentationStyle = .popover
        popoverViewController.preferredContentSize = CGSize(width: 320, height: 216)
        popoverViewController.popoverPresentationController?.sourceView = sender // source button
        popoverViewController.popoverPresentationController?.sourceRect = sender.bounds // source button bounds
        
        
        self.present(popoverViewController, animated: true, completion: nil)
        
        
    }
    @objc func selectDate(sender: UIButton!) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate: String = dateFormatter.string(from: datePicker.date)
        
        print("Selected value \(selectedDate)")
        self.dismiss(animated:true, completion: nil)
        let photoInfoController = PhotoInfoController()
        photoInfoController.fetchPhotoInfo(date: selectedDate) { (photoInfo) in
            if let photoInfo = photoInfo {
                self.updateUI(with: photoInfo)
            }
        }
    }
    @objc func cancelDate(sender: UIButton!) {
        self.dismiss(animated:true, completion: nil)
    }
//    @objc func datePickerValueChanged(_ sender: UIDatePicker){
//
//        // Create date formatter
//        let dateFormatter: DateFormatter = DateFormatter()
//
//        // Set date format
//        dateFormatter.dateFormat = "yyyy/MM/dd"
//
//        // Apply date format
//        let selectedDate: String = dateFormatter.string(from: sender.date)
//
//        print("Selected value \(selectedDate)")
//    }
    
    
    func updateUI(with photoInfo: PhotoInfo) {
        guard let url = photoInfo.url.withHTTPS() else { return }
        let task = URLSession.shared.dataTask(with: url,
          completionHandler: { (data, response, error) in
            if let data = data,
                let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.title = photoInfo.title
                    self.imageView.image = image
                    self.descriptionLabel.text = photoInfo.description
//                    print("title: ", photoInfo.title)
                    if let copyright = photoInfo.copyright {
                        self.copyrightLabel.text = "Copyright \(copyright)"
                    } else {
                        self.copyrightLabel.isHidden = true
                    }
                }
            }
        })
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Date())
        let photoInfoController = PhotoInfoController()
        photoInfoController.fetchPhotoInfo(date: "2012-07-13") { (photoInfo) in
            if let photoInfo = photoInfo {
                self.updateUI(with: photoInfo)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

