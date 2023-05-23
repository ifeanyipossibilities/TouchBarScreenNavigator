//
//  TouchScreenController.swift
//  TouchBarScreenNavigator
//
//  Created by ifeanyi on 5/23/23.
//

import Cocoa

class TouchScreenController: NSWindowController {

    var ScreenLocationX = 0;
    var ScreenLocationY = 0;
    var mouseLocation: NSPoint { NSEvent.mouseLocation }

    @IBOutlet weak var UpButtonIcon: NSButtonCell!
    @IBOutlet weak var ScrollViewImage: NSScrollView!
    @IBOutlet weak var DownButtonicon: NSButtonCell!
    @IBOutlet weak var LeftbuttonIcon: NSButtonCell!
    @IBOutlet weak var RightButtonIcon: NSButton!
    @IBOutlet weak var CurrentScreenView: NSImageCell!
    
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        
//        Mouse location or mouse Pointer is hidden in the screen capture how do i locate the pointer? now just printing the cordinate doing nothing with them maybe append the cordination to the image
        NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
                print("mouseLocation:", String(format: "%.1f, %.1f", self.mouseLocation.x, self.mouseLocation.y))
            self.updateScreenImage()

                return $0
            }
            NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
                print(String(format: "%.0f, %.0f", self.mouseLocation.x, self.mouseLocation.y))
                self.updateScreenImage()
                
            }
        
        self.CurrentScreenView.image =  self.ScreenImage()
        
        guard var frame = self.ScrollViewImage.documentView?.frame else { return }

       
//              frame.size.width += 10
//              frame.size.height += 10

    self.ScrollViewImage.animator().magnify(toFit: frame)
             
        
//        cause memory
////        dispach thread to update screen image but this seems not to be updating
//        DispatchQueue(label: "updateScreenImageDispach").async {
//            self.updateScreenImageDispach()
//               }
        
        var timer = Timer.scheduledTimer(timeInterval: 0.002, target: self, selector: #selector(self.updateScreenImage), userInfo: nil, repeats: true)
      
        

        self.UpButtonIcon.image = NSImage(named: NSImage.touchBarGoUpTemplateName)!
        self.DownButtonicon.image = NSImage(named:  NSImage.touchBarGoDownTemplateName)!
        self.RightButtonIcon.image = NSImage(named:  NSImage.touchBarGoForwardTemplateName)!
        self.LeftbuttonIcon.image = NSImage(named:  NSImage.touchBarGoBackTemplateName)!
    }
    
    
    //  update the current screen image
    @objc func updateScreenImage(){
            self.CurrentScreenView.image = self.ScreenImage()

    }
    
    
    
    
    //  constantly update the current screen image every 8 milliseconds
    func updateScreenImageDispach(){
        while true {
            self.CurrentScreenView.image =  self.ScreenImage()
            usleep(8000)
        }
    }
    
//    Go Left when button is tapped
    @IBAction func GoLeft(_ sender: Any) {
        let image =  self.ScreenImage()
            self.ScreenLocationX -= 10
           
            self.ScrollViewImage.magnify(toFit: NSRect(x: CGFloat(self.ScreenLocationX), y: CGFloat(self.ScreenLocationY), width: image.size.width, height: image.size.height))
        self.CurrentScreenView.image = image

        
    }
//    Go right when button tapped
    @IBAction func GoRight(_ sender: Any) {
        let image =  self.ScreenImage()
            self.ScreenLocationX += 10
            self.ScrollViewImage.magnify(toFit: NSRect(x: CGFloat(self.ScreenLocationX), y: CGFloat(self.ScreenLocationY), width: image.size.width, height: image.size.height))
        self.CurrentScreenView.image = image

        
    }
    
    
//    Function to capture the current screen
    func ScreenImage() -> NSImage{
        let displayID = CGMainDisplayID()
        let imageRef = CGDisplayCreateImage(displayID)
        let image =  NSImage(cgImage: imageRef!, size: (NSScreen.main?.frame.size)!)
        return image
    }
    
//    Go Up when button tapped
    @IBAction func GoUp(_ sender: Any) {
        let image =  self.ScreenImage()
            self.ScreenLocationY += 10
            self.ScrollViewImage.magnify(toFit: NSRect(x: CGFloat(self.ScreenLocationX), y: CGFloat(self.ScreenLocationY), width: image.size.width, height: image.size.height))
        self.CurrentScreenView.image = image
        
 
    }
    
//    Go Down when button tapped
    
    @IBAction func GoDown(_ sender: Any) {
        let image =  self.ScreenImage()
            self.ScreenLocationY -= 10
            self.ScrollViewImage.magnify(toFit: NSRect(x: CGFloat(self.ScreenLocationX), y: CGFloat(self.ScreenLocationY), width: image.size.width, height: image.size.height))
        self.CurrentScreenView.image = image
    
        
    }
    
    
  

    
    
    
    
}
