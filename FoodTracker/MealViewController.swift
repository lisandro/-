//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Lisandro Falconi on 2/2/17.
//  Copyright © 2017 Lisandro Falconi. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController {
  //MARK: Properties
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var ratingControl: RatingControl!
  @IBOutlet weak var saveMealButton: UIBarButtonItem!
  /*
   This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
   or constructed as part of adding a new meal.
   */
  var meal: Meal?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    nameTextField.delegate = self
    
    
    if let meal = meal {
      navigationItem.title = meal.name
      nameTextField.text = meal.name
      photoImageView.image = meal.photo
      ratingControl.rating = meal.rating
    }
    
    // Enable the Save button only if the text field has a valid Meal name.
    updateSaveButtonState()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  //MARK: Navigation
  
  @IBAction func cancel(_ sender: UIBarButtonItem) {
    let isPresentingInAddMealMode = presentingViewController is UINavigationController
    if isPresentingInAddMealMode {
      dismiss(animated: true, completion: nil)
    } else if let owningNavigationController = navigationController{
      owningNavigationController.popViewController(animated: true)
    } else {
      fatalError("The MealViewController is not inside a navigation controller.")
    }
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    guard let button = sender as? UIBarButtonItem, button === saveMealButton else {
      os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .default)
      return
    }
    
    let name = nameTextField.text ?? ""
    let photo = photoImageView.image
    let rating = ratingControl.rating
    
    meal = Meal(name: name, photo: photo, rating: rating)
  }
  
  //MARK: Actions
  
  @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
    nameTextField.resignFirstResponder()
    let imagePickerController = UIImagePickerController()
    imagePickerController.sourceType = .photoLibrary
    imagePickerController.delegate = self
    present(imagePickerController, animated: true, completion: nil)
  }
  
  func updateSaveButtonState() {
    // Disable the Save button if the text field is empty.
    let text = nameTextField.text ?? ""
    saveMealButton.isEnabled = !text.isEmpty
  }
}

//MARK: - UITextFieldDelegate
extension MealViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    self.updateSaveButtonState()
    navigationItem.title = textField.text
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    saveMealButton.isEnabled = false
  }
}

//MARK: - UIImagePickerControllerDelegate
extension MealViewController: UIImagePickerControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    // The info dictionary may contain multiple representations of the image. You want to use the original.
    guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
      fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
    }
    // Set photoImageView to display the selected image.
    photoImageView.image = selectedImage
    // Dismiss the picker.
    dismiss(animated: true, completion: nil)
  }
}

//MARK: - UINavigationControllerDelegate
extension MealViewController: UINavigationControllerDelegate {
  
}
