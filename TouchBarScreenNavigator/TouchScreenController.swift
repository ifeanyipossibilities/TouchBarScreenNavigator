//
//  TouchScreenController.swift
//  TouchBarScreenNavigator
//
//  Created by ifeanyi on 5/23/23.
//

import Cocoa


//TODO
//1 Remove initial Window
//2 add mouse cursor to screen image
//
// Mouse location or mouse Pointer is hidden in the screen capture how do i locate the pointer? now just printing the cordinate doing nothing with them maybe append the cordination to the image
class TouchScreenController: NSWindowController {

   
    
    var isCommandPressed = false
    var ScreenLocationX = 0;
    var ScreenLocationY = 0;
    var mouseLocation: NSPoint { NSEvent.mouseLocation }
    var ZoomScreenRatio = Double(0.25)
    
    @IBOutlet weak var UpButtonIcon: NSButtonCell!
    @IBOutlet weak var ScrollViewImage: NSScrollView!
    @IBOutlet weak var DownButtonicon: NSButtonCell!
    @IBOutlet weak var LeftbuttonIcon: NSButtonCell!
    @IBOutlet weak var RightButtonIcon: NSButton!
    @IBOutlet weak var CurrentScreenView: NSImageCell!
    
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
//        set buttom icons

        self.UpButtonIcon.image = NSImage(named: NSImage.touchBarGoUpTemplateName)!
        self.DownButtonicon.image = NSImage(named:  NSImage.touchBarGoDownTemplateName)!
        self.RightButtonIcon.image = NSImage(named:  NSImage.touchBarGoForwardTemplateName)!
        self.LeftbuttonIcon.image = NSImage(named:  NSImage.touchBarGoBackTemplateName)!

        // listen for main keys in the background
        NSEvent.addGlobalMonitorForEvents(matching: [.keyDown], handler: self.doKeyDown)
            // listen for modifier keys in the background
        NSEvent.addGlobalMonitorForEvents(matching: [.flagsChanged], handler: self.doModKeyDown)
            
            
            // listen for main keys in the foreground to allow playing around (Global doesn't provide)
        NSEvent.addLocalMonitorForEvents(matching: [.keyDown])
            { event in
                self.doKeyDown(evt: event)
                return event
            }
            
            // listen for modifier keys in the foreground to allow playing around (Global doesn't provide)
          NSEvent.addLocalMonitorForEvents(matching: [.flagsChanged])
            { event in
                self.doModKeyDown(evt: event)
                return event
            }
        
        


//
        self.CurrentScreenView.image =  self.ScreenImage()
        
    
        guard let frame = self.ScrollViewImage.documentView?.frame else { return }

       
//              frame.size.width += 10
//              frame.size.height += 10

    self.ScrollViewImage.animator().magnify(toFit: frame)
        
        
        
                   
              
      //        costs memory
      ////        dispach thread to update screen image but this seems not to be updating
      //        DispatchQueue(label: "updateScreenImageDispach").async {
      //            self.updateScreenImageDispach()
      //               }
              
      //      update screen image using schedule
              Timer.scheduledTimer(timeInterval: 0.50, target: self, selector: #selector(self.updateScreenImage), userInfo: nil, repeats: true)
            
        
        
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
        self.ScrollViewImage.magnification = self.ZoomScreenRatio
        

        
    }
//    Go right when button tapped
    @IBAction func GoRight(_ sender: Any) {
        let image =  self.ScreenImage()
            self.ScreenLocationX += 10
            self.ScrollViewImage.magnify(toFit: NSRect(x: CGFloat(self.ScreenLocationX), y: CGFloat(self.ScreenLocationY), width: image.size.width, height: image.size.height))
        self.CurrentScreenView.image = image
        self.ScrollViewImage.magnification = self.ZoomScreenRatio
       

        
    }
    
    
//    Go Up when button tapped
    @IBAction func GoUp(_ sender: Any) {
        let image =  self.ScreenImage()
            self.ScreenLocationY += 10
            self.ScrollViewImage.magnify(toFit: NSRect(x: CGFloat(self.ScreenLocationX), y: CGFloat(self.ScreenLocationY), width: image.size.width, height: image.size.height))
        self.CurrentScreenView.image = image
        self.ScrollViewImage.magnification = self.ZoomScreenRatio
        
 
    }
    
//    Go Down when button tapped
    
    @IBAction func GoDown(_ sender: Any) {
        let image =  self.ScreenImage()
            self.ScreenLocationY -= 10
            self.ScrollViewImage.magnify(toFit: NSRect(x: CGFloat(self.ScreenLocationX), y: CGFloat(self.ScreenLocationY), width: image.size.width, height: image.size.height))
        self.CurrentScreenView.image = image
        
    
        
    }
    
    //    Function to capture the current screen
        func ScreenImage() -> NSImage{
            //        print(String(format: "%.0f, %.0f", self.mouseLocation.x, self.mouseLocation.y))
            let displayID = CGMainDisplayID()
            let imageRef = CGDisplayCreateImage(displayID)
            let image =  NSImage(cgImage: imageRef!, size: (NSScreen.main?.frame.size)!)
            return image
        }
    
    
    
    func zoomScreen(key: UInt16){
        let image =  self.ScreenImage()
        self.CurrentScreenView.image = image
        let zoomPlus = (key == 24)
        let zoomMinus = (key == 27)
        if zoomPlus{
            self.ZoomScreenRatio += Double(0.15)
        }else if zoomMinus{
            self.ZoomScreenRatio -= Double(0.15)
        }else{
            self.ZoomScreenRatio = 0.25
        }
//        self.ScrollViewImage.setMagnification(CGFloat(self.ZoomScreenRatio),centeredAt: NSPoint(x: CGFloat(self.ScreenLocationX), y: CGFloat(self.ScreenLocationY)))
   
        guard let frame = self.ScrollViewImage.documentView?.frame else { return }
        self.ScrollViewImage.magnify(toFit: NSRect(x: CGFloat(self.ScreenLocationX), y: CGFloat(self.ScreenLocationY), width: frame.size.width, height: frame.size.height))
        
       self.ScrollViewImage.magnification = self.ZoomScreenRatio

       
//              frame.size.width += 10
//              frame.size.height += 10

//    self.ScrollViewImage.magnify(toFit: NSRect(x: CGFloat(self.ScreenLocationX), y: CGFloat(self.ScreenLocationY), width: image.size.width, height: image.size.height))
    }

    func doKeyDown(evt: NSEvent) {
//        print ("key \(evt.keyCode)")
        let key = evt.keyCode
        let zoomPlus = (key == 24)
        let zoomMinus = (key == 27)
        let zoomReset = (key == 29)
        
        if self.isCommandPressed && (zoomPlus || zoomMinus || zoomReset) {
            self.zoomScreen(key: key)
        }
    }
    
    func doModKeyDown(evt: NSEvent) {
        let key = evt.keyCode
        let isCommandPressed = (key == 55)
        self.isCommandPressed = isCommandPressed
        
    }
    
    

    
    
}
