//
//  ViewController.swift
//  macAnalysis
//
//  Created by Mahmoud Hassan on 1/29/21.
//  Copyright © 2021 Mahmoud Hassan. All rights reserved.
//

import Cocoa

class ViewController: NSViewController,NSTableViewDataSource,NSTableViewDelegate {
    
    @IBOutlet weak var table: NSTableView!
    var dataObjects = [filesData]()
    var myDuplicates = [Duplicates]()
    let dialog = NSOpenPanel();
    var names = [String]()
    var urls = [URL]()
    var i : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        // Do any additional setup after loading the view.
        //  activeApps()
     //   let information = shell("")
      //  print("information \(information)")
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
            
        }
    }
    
    @IBAction func directoryPicker(_ sender: NSButton) {
        
        names.removeAll()
        urls.removeAll()
        dataObjects.removeAll()
        
        
        dialog.title                   = "Choose single directory | Our Code World";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseFiles = false;
        dialog.canChooseDirectories = true;
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url
            
            if (result != nil) {
                
                SearchForFiles(path: result!)
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    ///
    
    var pngArray = [String]()
    
    
    //MARK: Search for Files
    var myIndex = 0
    func SearchForFiles(path : URL) {
        
        let enumerator  = FileManager.default.enumerator(at: path, includingPropertiesForKeys: .none)
        
    
        
        for element in enumerator! {
            
            let fullname: String = (element as AnyObject).lastPathComponent!
            let url : URL = element as! URL
            
            if(fullname.hasSuffix(".png") || fullname.hasSuffix(".jpg") || fullname.hasSuffix(".wav") ||
                fullname.hasSuffix(".pdf") || fullname.hasSuffix(".doc") || fullname.hasSuffix(".docx") ||
                fullname.hasSuffix(".zip") || fullname.hasSuffix(".mp3") || fullname.hasSuffix(".mp4")  )
            {
                urls.append(url)
                names.append(fullname)
                
            }
            
            
            
            
        }
        if(names.count > 0 && urls.count > 0)
        {
            
            sizeForLocalFilePath()
            
        }
        
        else
        {
            print("No Duplication!")
        }
        
        
    }
    
    
    //MARK: Size for each file
    func sizeForLocalFilePath()
    {
        do {
            
            for index in 0...urls.count-1 {
                
                let resources = try urls[index].resourceValues(forKeys:[.fileSizeKey])
                let fileSize = Float(resources.fileSize!)
                let val = fileSize / 1048576.0
                
                let object = filesData()
                object.size = val
                object.name = names[index]
                object.url = urls[index]
                object.duplicated = false
                object.isChecked = false

                if(object.name.hasSuffix(".png"))
                {
                    object.fileType = "png"
                }
                else if(object.name.hasSuffix(".jpg"))
                {
                    object.fileType = "jpg"
                }
                else   if(object.name.hasSuffix(".wav"))
                {
                    object.fileType = "wav"
                }
                else if(object.name.hasSuffix(".pdf"))
                {
                    object.fileType = "pdf"
                }
                else  if(object.name.hasSuffix(".doc"))
                {
                    object.fileType = "doc"
                }
                else  if(object.name.hasSuffix(".docx"))
                {
                    object.fileType = "docx"
                }
                else if(object.name.hasSuffix(".zip"))
                {
                    object.fileType = "zip"
                }
                else if(object.name.hasSuffix(".mp3"))
                {
                    object.fileType = "mp3"
                }
                else if(object.name.hasSuffix(".mp4"))
                {
                    object.fileType = "mp4"
                }

                dataObjects.append(object)
                
            }
            
            self.isDuplicated()
            
        }
        catch {
            print("Error: \(error)")
        }
        
    }
    
    
    //MARK:  Check Duplication
    
    func isDuplicated()
    {
        for i in 0...dataObjects.count-1
        {
            
            let ptrav = dataObjects[i]
            
            for i2 in 0...dataObjects.count-1
            {
                
                let ptrav2 = dataObjects[i2]
                
                if(i != i2)
                {
                     let str1 = (ptrav.url.deletingPathExtension().lastPathComponent)
                     let str2 = (ptrav2.url.deletingPathExtension().lastPathComponent)
                    
                    // file URL without its name
                    let pathword1:  String = (ptrav.url.deletingLastPathComponent().absoluteString)
                    let pathword2:  String = (ptrav2.url.deletingLastPathComponent().absoluteString)
                    
                    
                    if(ptrav.size == ptrav2.size &&   str1.contains(str2)  && pathword1 == pathword2 && ptrav.isChecked == false)
                    {
                        
                        print("i = \(ptrav.name)  && i2 = \(ptrav2.name)")
                        ptrav.isChecked = true
                        ptrav2.isChecked = true
                        
                        
                        let didDuplicat = Duplicates(name: ptrav.name, url: ptrav.url, size: ptrav.size, type: ptrav.fileType, match: 100)
                        
                         let didDuplicat2 = Duplicates(name: ptrav2.name, url: ptrav2.url, size: ptrav2.size, type: ptrav2.fileType, match: 100)
                        
                        myDuplicates.append(didDuplicat)
                        myDuplicates.append(didDuplicat2)

                        
                    }
                }
            }
            
            
        }
        print("////////////////////////")
        table.reloadData()
        
    }
    
    
   
    //MARK: Software & Hardware
    
    func shell(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
    
    
    
    //MARK: Table
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return myDuplicates.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        myDuplicates[row]
    }
    
    
    
}





