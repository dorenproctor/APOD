//
//  ViewController.swift
//  APOD
//
//  Created by Doren Proctor on 4/7/18.
//  Copyright © 2018 Doren Proctor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleButton: UIButton!
    @IBOutlet var dateButton: UIButton!
    
    let popoverViewController = UIViewController()
    let datePicker: UIDatePicker = UIDatePicker()
    var info: PhotoInfo?
    
    @IBAction func showDetails(_ sender: UIButton) {
        
        let descriptionLabel = UILabel(frame: CGRect(x: 20, y: 0, width: self.view.frame.width-40, height: self.view.frame.height-50))
        if let copyright = info?.copyright {
            descriptionLabel.text = info!.description + "\n\nCopyright: " + copyright
        } else {
            descriptionLabel.text = info?.description
        }
        descriptionLabel.numberOfLines = 30
        let swiftColor = UIColor(red:1.00, green:0.98, blue:0.92, alpha:1.0)
        descriptionLabel.backgroundColor = swiftColor
        let doneButton = UIButton(frame: CGRect(x: 0, y: self.view.frame.height-50, width: self.view.frame.width, height: 50))
        doneButton.backgroundColor = .gray
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(closePopover), for: .touchUpInside)
        
        let popoverView = UIView()
        popoverView.backgroundColor = swiftColor
        
        popoverView.addSubview(descriptionLabel)
        popoverView.addSubview(doneButton)
        
        let popoverViewController = UIViewController()
        popoverViewController.view = popoverView
        popoverViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        popoverViewController.modalPresentationStyle = .popover
        popoverViewController.preferredContentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        popoverViewController.popoverPresentationController?.sourceView = sender // source button
        popoverViewController.popoverPresentationController?.sourceRect = sender.bounds // source button bounds
        
        self.present(popoverViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func changeDate(_ sender: UIButton) {
        datePicker.frame = CGRect(x: 0, y: self.view.frame.height-300, width: self.view.frame.width, height: 200)
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePickerMode.date
        
        let selectButton = UIButton(frame: CGRect(x: 0, y: self.view.frame.height-100, width: self.view.frame.width, height: 50))
        let swiftColor = UIColor(red: 93/255, green: 173/255, blue: 226/255, alpha: 1)
        selectButton.backgroundColor = swiftColor
        selectButton.setTitle("Select Date", for: .normal)
        selectButton.addTarget(self, action: #selector(selectDate), for: .touchUpInside)
        
        let cancelButton = UIButton(frame: CGRect(x: 0, y: self.view.frame.height-50, width: self.view.frame.width, height: 50))
        cancelButton.backgroundColor = .gray
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(closePopover), for: .touchUpInside)
        
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
        dateButton.setTitle(selectedDate, for: .normal)
        let photoInfoController = PhotoInfoController()
        photoInfoController.fetchPhotoInfo(date: selectedDate) { (photoInfo) in
            if let photoInfo = photoInfo {
                self.updateUI(with: photoInfo)
            }
        }
        self.dismiss(animated:true, completion: nil)
    }
    
    @objc func closePopover(sender: UIButton!) {
        self.dismiss(animated:true, completion: nil)
    }
    
    
    func updateUI(with photoInfo: PhotoInfo) {
        self.info = photoInfo
        guard let url = photoInfo.url.withHTTPS() else { return }
        let task = URLSession.shared.dataTask(with: url,
          completionHandler: { (data, response, error) in
            if let data = data,
                let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.titleButton.setTitle(photoInfo.title, for: .normal)
                    self.imageView.image = image
                }
            }
        })
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate: String = dateFormatter.string(from: Date())
        dateButton.setTitle(selectedDate, for: .normal)
        let photoInfoController = PhotoInfoController()
        photoInfoController.fetchPhotoInfo(date: selectedDate) { (photoInfo) in
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

