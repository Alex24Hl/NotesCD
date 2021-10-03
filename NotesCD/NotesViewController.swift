//
//  NoteViewController.swift
//  NotesCD
//
//  Created by Александр Холод on 03.10.2021.
//

import UIKit
import CoreData

struct structNote {
    let structTitle: String
    let structContent: String
}

protocol UpdateNotesViewControllerDelegate {
    func updateNotes()
}

class NotesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var notes: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults()
        if !defaults.bool(forKey: "initialStartup") {
            defaults.set(true, forKey: "initialStartup")
            saveNote(title: "Welcome message", content: "Hello))")
        }
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadedNotes()
        print("viewWillAppear")
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        setupCell()
    }
    
    func setupCell() {
        let nib = UINib(nibName: "NoteCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: NoteCell.cellId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SEGUE_NOTE_DETAIL" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            tableView.deselectRow(at: indexPath, animated: true)
            
            if let viewController = segue.destination as? NoteDetailViewController {
                if let note = sender as? Note {
                    viewController.note = note
                }
            }
        } else if segue.identifier == "SEGUE_NOTE_ADD" {
            guard let navigationVC = segue.destination as? UINavigationController else { return }
            guard let addNoteVC = navigationVC.topViewController as? AddNoteViewController else { return }
            addNoteVC.delegate = self
        }
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func loadedNotes() {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        
        do {
            notes = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func saveNote(title: String, content: String) {
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Note", in: context) else { return }
        
        let note = Note(entity: entity, insertInto: context)
        note.title = title
        note.content = content
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    private func deleteNote(note: Note) {
        let context = getContext()
        context.delete(note)
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}

// MARK: - UITableViewDataSource

extension NotesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.cellId, for: indexPath) as! NoteCell
        let note = notes[indexPath.row]
        
        cell.titleLabel.text = note.title
        cell.contentLabel.text = note.content
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NoteCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        performSegue(withIdentifier: "SEGUE_NOTE_DETAIL", sender: note)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = notes.remove(at: indexPath.row)
            deleteNote(note: note)
            tableView.reloadData()
        }
    }
}

//MARK: - UpdateNotesViewControllerDelegate

extension NotesViewController: UpdateNotesViewControllerDelegate {
    func updateNotes() {
        loadedNotes()
        tableView.reloadData()
    }
}
  
