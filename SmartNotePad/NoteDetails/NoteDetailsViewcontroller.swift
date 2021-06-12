//
//  NoteDetailsViewcontroller.swift
//  SmartNotepad
//
//  Created by shimaa_khairy on 6/2/21.
//

import UIKit
import RealmSwift
import CoreLocation
import PhotosUI
class NoteDetailsViewcontroller: UIViewController {

    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteBody: UITextView!
    @IBOutlet weak var noteImageButton: UIButton!
    @IBOutlet weak var addLocationButton: UIButton!
    
    let realm = try! Realm()
    var photoURL : String?
    var update = false
    var note : NoteModel?
    var latitude ,longitude : Double?
    let imagePicker = UIImagePickerController()
    lazy var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if update{
            viewNote()
        }
    }
    @IBAction func addLocation(_ sender: UIButton) {
        locationManager.delegate = self
        checkLocationPermission()
    }
    @IBAction func addPhoto(_ sender: UIButton) {
        imagePicker.delegate = self
        checkPhotosPermission()
        
    }
    @IBAction func save(_ sender: UIButton) {
        if noteTitle.text?.trimmingCharacters(in: .whitespaces) != "" {
        saveRealmNote()
        }
    }
    func showImagePicker(){
        DispatchQueue.main.async {
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    func requsetUserLocation(){
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    func checkLocationPermission(){
        switch CLLocationManager.authorizationStatus() {
        case .restricted, .denied:
            let alertController = UIAlertController(
                    title: "Background Location Access Disabled",
                    message: "In order to be notified, please open this app's settings and set location access to 'Always'.",
                    preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)

            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = NSURL(string:UIApplication.openSettingsURLString) {
                    UIApplication.shared.openURL(url as URL)
                    }
                }
                alertController.addAction(openAction)

            self.present(alertController, animated: true, completion: nil)
        case .authorizedAlways,.authorizedWhenInUse:
            print("authorized")
            requsetUserLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            print("notDetermined")
        default:
            print("")
        }
        
    }
    func checkPhotosPermission(){
        PHPhotoLibrary.requestAuthorization({
               (newStatus) in
                 if newStatus ==  PHAuthorizationStatus.authorized {
                    self.showImagePicker()
            }
        })
        switch PHPhotoLibrary.authorizationStatus() {
        case .restricted, .denied:
            let alertController = UIAlertController(
                    title: "Photo Access Disabled",
                    message: "please open this app's settings and set allow access to 'All Photos'.",
                    preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)

            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = NSURL(string:UIApplication.openSettingsURLString) {
                    UIApplication.shared.openURL(url as URL)
                    }
                }
                alertController.addAction(openAction)

            self.present(alertController, animated: true, completion: nil)
        case .authorized:
            showImagePicker()
        default:
            print("")
        
        }
        
        
    }
    func viewNote(){
        noteTitle.text = note?.title ?? ""
        noteBody.text = note?.body ?? ""
        noteBody.placeholder = note?.body != nil ? "" : "Note Body Here"
        if note?.imageString != nil{
            let image = convertBase64StringToImage(imageBase64String: (note?.imageString!)!)
            noteImageButton.setBackgroundImage(image, for: .normal)
        }
        if note?.location != nil{
            addLocationButton.setTitle(note!.location, for: .normal)
        }
    }
    
    func saveRealmNote(){
        if note == nil {
            note = NoteModel()
        }
        try! realm.write{
            note!.title = noteTitle.text
            note!.body = noteBody.text
            note!.noteTimeStamp = getCurrentTime()
            if noteImageButton.currentBackgroundImage != nil{
            note!.imageString = convertImageToBase64String(img: noteImageButton.currentBackgroundImage!)
            }
            if addLocationButton.title(for: .normal) != "Add Location"{
                note!.location = addLocationButton.title(for: .normal)
            }
            if latitude != nil && longitude != nil{
                note?.lat = latitude!
                note?.long = longitude!
            }
            realm.add(note!)
            print("added")
                }
        self.navigationController?.popViewController(animated: true)
    }
    
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image!
    }
    func getCurrentTime() -> String{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = format.string(from: date)
        return timestamp
    }
}

extension NoteDetailsViewcontroller: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            noteImageButton.setTitle("", for: .normal)
            noteImageButton.setBackgroundImage(pickedImage, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension NoteDetailsViewcontroller : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            longitude = location.coordinate.longitude
            latitude = location.coordinate.latitude
            
            locationManager.stopUpdatingLocation()
            getAddressFromLatLon(lat: latitude!, long: longitude!)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
extension NoteDetailsViewcontroller{

    func getAddressFromLatLon(lat:Double,long:Double){
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = long

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)

            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                        var addressString : String = ""
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
//                        if pm.locality != nil {
//                            addressString = addressString + pm.locality! + ", "
//                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country!
                        }
                        self.addLocationButton.setTitle(addressString, for: .normal)
                        self.addLocationButton.isUserInteractionEnabled = false
                        print(addressString)
                  }
            })

        }
}
