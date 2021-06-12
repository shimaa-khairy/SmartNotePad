//
//  MyNotesViewController.swift
//  SmartNotepad
//
//  Created by shimaa_khairy on 6/1/21.
//

import UIKit
import RealmSwift
import CoreLocation
class MyNotesViewController: UIViewController {

    @IBOutlet weak var notesTableView : UITableView!
    @IBOutlet weak var emptyStateView : UIView!
    
    let realm  = try! Realm()
    var notes : Results<NoteModel>?
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNotes()
    }
    @IBAction func addNewNote(_ sender: Any) {
        let vc = UIStoryboard(name: "NoteDetailsViewcontroller", bundle: nil).instantiateViewController(withIdentifier: "NoteDetailsViewcontroller") as! NoteDetailsViewcontroller
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    func loadNotes(){
        notes = realm.objects(NoteModel.self).sorted(byKeyPath: "noteTimeStamp", ascending: false)
        getUserLocation()
        if notes != nil{
            notesTableView.reloadData()
        }
    }
    
    func deleteNote(note : NoteModel){
        try! realm.write{
            realm.delete(note)
            notes = realm.objects(NoteModel.self)
            
        }
    }
    
    func getUserLocation(){
        
        if [.notDetermined, .restricted, .denied].contains(CLLocationManager.authorizationStatus()){
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
    }
    
    func getNearestLocation(location:CLLocation){
        if let notes = notes{
            var index : Int?
            var minDis : Double?
            for (i,note) in notes.enumerated(){
                if note.lat != 0{
                    var dis = location.distance(from: CLLocation(latitude: note.lat, longitude: note.long))
                    if minDis == nil || dis < minDis!{
                        minDis = dis
                        index = i
                    }
                }
        }
            if let index = index{
                try! realm.write{
                    let note = notes.filter("nearest == 1").first
                    note?.nearest = 0
                    notes[index].nearest = 1

                }
                self.notes! = self.notes!.sorted(byKeyPath: "nearest",ascending: false)
                notesTableView.reloadData()
                
        }
        }
    }
    
}
extension MyNotesViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyStateView.isHidden = notes?.count != 0 ? true : false
        return notes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell") as! NotesTableViewCell
        cell.configureCell(note: notes![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "NoteDetailsViewcontroller", bundle: nil).instantiateViewController(withIdentifier: "NoteDetailsViewcontroller") as! NoteDetailsViewcontroller
        vc.update = true
        vc.note = notes![indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNote(note: notes![indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
       
}
extension MyNotesViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            getNearestLocation(location:location)
        }
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
