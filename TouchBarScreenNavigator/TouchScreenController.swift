//
//  TouchScreenController.swift
//  TouchBarScreenNavigator
//
//  Created by ifeanyi on 5/23/23.
//

import Cocoa
import Foundation

//TODO
//1 Remove initial Window
//2 Allow user to customize hot corner
// 3 stay on the touchbar screen like MTMR without depriving other TouchBar App the TouchBar Usability
class TouchScreenController: NSWindowController,  NSWindowDelegate {

    
//    set display height
    var ScreenHeight = 1080
    //    set display width
    var ScreenWidth = 1920
//    # set distance (hotcorner sensitivity)
    let radius = 20

// Screen Corners labels
//    # bottom-left, bottom-right, top-left, top-right,Center
    let ScreenCordinateLabel = [
        "bottom-left",
        "bottom-right",
        "top-left",
        "top-right",
        "Center"
        ]
    
    //   # list Screen Corners points
    //   # bottom-left, bottom-right, top-left, top-right,Center
    var ScreenCorner: [[Int]] = [[0, 0], [1920, 0], [0, 1080], [1920, 1080],  [1920/2, 1080/2]]
    //Screen Dimention
    var ScreenDimention = [1920, 1080]
    
//    Last Screen Coordinate variable
    var screenCordinateDiff = [Int()]
    var currentScreenCordinate = [Int()]
    var previousScreenCordinate  = [Int()]
        
//    Track key event
    var isCommandPressed = false
    var ScreenLocationX = 0;
    var ScreenLocationY = 0;
    var mouseLocation: NSPoint { NSEvent.mouseLocation }
//    var mouseLocation: CGPoint = .zero
    var ZoomScreenRatio = Double(0.1)
    
    
    @IBOutlet weak var TouchBarScreenNavigatorTouchBar: NSTouchBar!
    
    
    @IBOutlet weak var UpButtonIcon: NSButtonCell!
    @IBOutlet weak var ScrollViewImage: NSScrollView!
    @IBOutlet weak var DownButtonicon: NSButtonCell!
    @IBOutlet weak var LeftbuttonIcon: NSButtonCell!
    @IBOutlet weak var RightButtonIcon: NSButton!
    @IBOutlet weak var CurrentScreenView: NSImageCell!
    
    private var frontmostApplicationIdentifier: String? {
        return NSWorkspace.shared.frontmostApplication?.bundleIdentifier
    }
    
    

    var state: CursorPosition = CursorPosition(PosX: 0.0, PosY: 0.0, MouseLeftStatus: 0, Keys:[])
    
    override func windowDidLoad() {
        super.windowDidLoad()
//        test our Exponentiation operator
        self.test_power()
        self.setScreenDimention()
    
        
//        set buttom icons

        self.UpButtonIcon.image = NSImage(named: NSImage.touchBarGoUpTemplateName)!
        self.DownButtonicon.image = NSImage(named:  NSImage.touchBarGoDownTemplateName)!
        self.RightButtonIcon.image = NSImage(named:  NSImage.touchBarGoForwardTemplateName)!
        self.LeftbuttonIcon.image = NSImage(named:  NSImage.touchBarGoBackTemplateName)!

        
        // listen for zoom keys combo in the background
        NSEvent.addGlobalMonitorForEvents(matching: [.keyDown], handler: self.doKeyDown)
            // listen for zoom keys combo in the background
        NSEvent.addGlobalMonitorForEvents(matching: [.flagsChanged], handler: self.doModKeyDown)
            
            
            // listen for zoom keys combo in the foreground to allow playing around (Global doesn't provide)
        NSEvent.addLocalMonitorForEvents(matching: [.keyDown])
            { event in
                self.doKeyDown(evt: event)
                return event
            }
            
            // listen for zoom keys combo keys in the foreground to allow playing around (Global doesn't provide)
          NSEvent.addLocalMonitorForEvents(matching: [.flagsChanged])
            { event in
                self.doModKeyDown(evt: event)
                return event
            }
        
        
//        update screen based on mousemovement
        NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
//                self.mouseLocation = NSEvent.mouseLocation()
//                print(String(format: "l%.0f, %.0f", self.mouseLocation.x, self.mouseLocation.y))
                self.state.PosX = Double(self.mouseLocation.x)
                self.state.PosY = Double(self.mouseLocation.y)
//            follow mouse pointer centering the cursor as we track the movement
                self.mouseCursorUpdate()

                return $0
            }
        
        
            NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in

                self.state.PosX =  Double(self.mouseLocation.x)
                self.state.PosY =  Double(self.mouseLocation.y)
                //            follow mouse pointer centering the cursor as we track the movement
                self.mouseCursorUpdate()
            }

//update screen
        self.updateScreenImage()

        
    
        guard let frame = self.ScrollViewImage.documentView?.frame else { return }
        self.ScrollViewImage.animator().magnify(toFit: frame)
        
        
        
              
      //      update screen image using schedule
              Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.updateScreenImage), userInfo: nil, repeats: true)
            
        
        
    }
    
//    set screen dimention

    func setScreenDimention(){
        if let screen = NSScreen.main {
            let rect = screen.frame
            self.ScreenHeight = Int(rect.size.height)
            self.ScreenWidth = Int( rect.size.width)
        }
        
//        # list Screen Corners
//        # bottom-left, bottom-right, top-left, top-right,Center
        self.ScreenCorner = [[0, 0], [ScreenWidth, 0], [0, self.ScreenHeight], [self.ScreenWidth, self.ScreenHeight],  [self.ScreenWidth/2, self.ScreenHeight/2]]
//        Screen Dimention
        self.ScreenDimention = [ self.ScreenWidth,self.ScreenHeight]
    }
    
    //  update the current screen image
    @objc func updateScreenImage(){
//        print("frontmostApplicationIdentifier \(String(describing: frontmostApplicationIdentifier))")
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
        self.CurrentScreenView.image = image
        
        if   self.ScreenLocationX  != 0 {
            self.ScreenLocationX -= 10
        }
            self.ScrollViewImage.magnify(toFit: NSRect(x: CGFloat(self.ScreenLocationX), y: CGFloat(self.ScreenLocationY), width: image.size.width, height: image.size.height))
        self.ScrollViewImage.setMagnification(self.ZoomScreenRatio, centeredAt: NSPoint(x: self.ScreenLocationX, y: self.ScreenLocationY))
        

        
    }
//    Go right when button tapped
    @IBAction func GoRight(_ sender: Any) {
        let image =  self.ScreenImage()
        self.CurrentScreenView.image = image
        if self.ScreenLocationX<self.ScreenWidth{
            self.ScreenLocationX += 10
        }
            self.ScrollViewImage.magnify(toFit: NSRect(x: CGFloat(self.ScreenLocationX), y: CGFloat(self.ScreenLocationY), width: image.size.width, height: image.size.height))
        self.ScrollViewImage.setMagnification(self.ZoomScreenRatio, centeredAt: NSPoint(x: self.ScreenLocationX, y: self.ScreenLocationY))
       

        
    }
    
    
//    Go Up when button tapped
    @IBAction func GoUp(_ sender: Any) {
        let image =  self.ScreenImage()
        self.CurrentScreenView.image = image
        if self.ScreenLocationY<self.ScreenHeight{
            self.ScreenLocationY += 10
        }
    self.ScrollViewImage.magnify(toFit: NSRect(x: CGFloat(self.ScreenLocationX), y: CGFloat(self.ScreenLocationY), width: image.size.width, height: image.size.height))
        self.ScrollViewImage.setMagnification(self.ZoomScreenRatio, centeredAt: NSPoint(x: self.ScreenLocationX, y: self.ScreenLocationY))
       
        
 
    }
    
//    Go Down when button tapped
    
    @IBAction func GoDown(_ sender: Any) {
        
        minimizeSystemModal(self.TouchBarScreenNavigatorTouchBar)
        let image =  self.ScreenImage()
        self.CurrentScreenView.image = image
        if   self.ScreenLocationY  != 0{
            self.ScreenLocationY -= 10
        }
            self.ScrollViewImage.magnify(toFit: NSRect(x: CGFloat(self.ScreenLocationX), y: CGFloat(self.ScreenLocationY), width: image.size.width, height: image.size.height))
        self.ScrollViewImage.setMagnification(self.ZoomScreenRatio, centeredAt: NSPoint(x: self.ScreenLocationX, y: self.ScreenLocationY))
        
    
        
    }
    
    //    Function to capture the current screen
        func ScreenImage() -> NSImage{
            //        print(String(format: "%.0f, %.0f", self.mouseLocation.x, self.mouseLocation.y))
            let displayID = CGMainDisplayID()
            let imageRef = CGDisplayCreateImage(displayID)
            let image =  NSImage(cgImage: imageRef!, size: (NSScreen.main?.frame.size)!)
//
//            let mouseimagecursor = NSImage(systemSymbolName: "circle.fill", accessibilityDescription: "")!
            let mouseimagecursor =  NSImage(named: "cursor")!
//            print(String(format: "Mouse Location l%.0f, %.0f", self.mouseLocation.x, self.mouseLocation.y))
            //        mouse cordinate AXIS Y - Cursor Image height
            let newim = image.DrwawImageAtPoint(anotherImage: mouseimagecursor, atPoint: NSPoint(x: mouseLocation.x, y: mouseLocation.y-50), toSize:NSSize(width: 50, height: 50))
            return newim
        }
    
    
//    derive cordinate from mouse and use
    func mouseCursorUpdate(){
        
        self.setScreenDimention()
        
//                guard let frame = self.ScrollViewImage.documentView?.frame else { return }
//        self.ScrollViewImage.contentView.documentCursor = NSCursor.iBeam;
//            print(String(format: "Frame Location l%.0f, %.0f", frame.size.width, frame.size.height))
        let image =  self.ScreenImage()
        self.CurrentScreenView.image = image
        
        
        //    Last mouse known Position
        let pos =  [Int(self.state.PosX),Int( self.state.PosY)]
        
        let x = (CGFloat(self.state.PosX))
        let y = (CGFloat(self.state.PosY))

//        derive centered from  cordinate
        let x2 = self.state.PosX / 2
        let y2 = self.state.PosY / 2
      
//        hot corners tracking
        self.screenCordinateDiff = self.diffScreenDimention2d(corners: self.ScreenCorner, axis:self.ScreenDimention, pos: pos)
        self.previousScreenCordinate  = [self.screenCordinateDiff.firstIndex(where: { $0 < self.radius }) ?? -1]
//        Todo track screen cordinate possition for HotCorners Misc option

        if self.all([self.previousScreenCordinate != self.currentScreenCordinate,self.previousScreenCordinate]) {
            if self.previousScreenCordinate[0] != -1 {
                let CordinateLabel = self.ScreenCordinateLabel[self.previousScreenCordinate[0]]
                print(CordinateLabel)
//                self.runcmd("say \(CordinateLabel) ")
                //
                //                    DispatchQueue(label: "RunCornerCmd").async {
                //                        self.runcmd("say \(CordinateLabel) ")
                //                           }
            }
            
        }
//        print("Diff \(self.screenCordinateDiff)")
//        print("Prev \(self.previousScreenCordinate)")
//        print(" Current \(self.currentScreenCordinate)")

        self.currentScreenCordinate = self.previousScreenCordinate
//        print(String(format: "x %.0f, %.0f", x, y))
//        print(String(format: " x1,  x2  %.0f, %.0f",   x1,  x2 ))
//        print(String(format: " y1,  y2 %.0f, %.0f",  y1,  y2))
//        print(String(format: "Mouse Location l%.0f, %.0f", self.mouseLocation.x, self.mouseLocation.y))

        self.ScrollViewImage.magnify(toFit: NSRect(x: x2, y: y2, width: x, height: y))
        self.ScrollViewImage.setMagnification(self.ZoomScreenRatio, centeredAt: NSPoint(x: x2, y: y2))
  
        
        
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
   
        self.ScrollViewImage.magnify(toFit: NSRect(x: CGFloat(self.ScreenLocationX), y: CGFloat(self.ScreenLocationY), width: image.size.width, height: image.size.height))
        self.ScrollViewImage.setMagnification(self.ZoomScreenRatio, centeredAt: NSPoint(x: self.ScreenLocationX, y: self.ScreenLocationY))


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
    
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
          NSApp.hide(nil)
          return false
      }
    
    
    //Return True if all elements of the iterable are true (or if the iterable is empty). Equivalent to:
    func all(_ iterable: [Any]) -> Bool {
        for element in iterable {
            if (element as? Bool) == false {
                return false
            }
        }
        return true
    }

    // run command on system
    func runcmd(_ cmd: String ) -> Bool {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", cmd]
        task.launch()
        task.waitUntilExit()
        let status = task.terminationStatus
        return status == 0
    }
    
    
    
    
    
    // get the current difference from the mousepointer to each of the corner (radius)
    func diffScreenDimention2d(corners: [[Int]], axis: [Int], pos: [Int]) -> [Int] {
     let diff = corners.map { c in Int(sqrt(Double(axis.enumerated().map { (i, n) in (c[i] - pos[i]) ** 2 }.reduce(0, +)))) }
        
        return diff
    }
    
    
    
//    run power Exponent test
    func test_power(){
        // Test Exponent = 0
        assert(0**0 == 1)
        assert(1**0 == 1)
        assert(2**0 == 1)

        // Test Exponent = 1
        assert(-1**1 == -1)
        assert(0**1 == 0)
        assert(1**1 == 1)
        assert(2**1 == 2)

        // Test Exponent = -1
        assert(-1 ** -1 == -1)
        assert(0 ** -1 == 0)
        assert(1 ** -1 == 1)
        assert(2 ** -1 == 0)

        // Test Exponent = 2
        assert(-1 ** 2 == 1)
        assert(0 ** 2 == 0)
        assert(1 ** 2 == 1)
        assert(2 ** 2 == 4)
        assert(3 ** 2 == 9)

        // Test Base = 0
        assert(0**0 == 1)
        assert(0**1 == 0)
        assert(0**2 == 0)

        // Test Base = 1
        assert(1 ** -1 == 1)
        assert(1**0 == 1)
        assert(1**1 == 1)
        assert(1**2 == 1)

        // Test Base = -1
        assert(-1 ** -1 == -1)
        assert(-1**0 == 1)
        assert(-1**1 == -1)
        assert(-1**2 == 1)
        assert(-1**2 == 1)
        assert(-1**3 == -1)

        // Test Base = 2
        assert(2 ** -1 == 0)
        assert(2**0 == 1)
        assert(2**1 == 2)
        assert(2**2 == 4)
        assert(2**3 == 8)

        // Test Base = -2
        assert(-2 ** -1 == 0)
        assert(-2**0 == 1)
        assert(-2**1 == -2)
        assert(-2**2 == 4)
        assert(-2**3 == -8)

        // Test Base = 3
        assert(3 ** -1 == 0)
        assert(3**0 == 1)
        assert(3**1 == 3)
        assert(3**2 == 9)
        assert(3**3 == 27)

        // Test Towers of Powers
        assert(2**2**2 == 16)
        assert(3**2**2 == 81)
        assert(2**2**3 == 256)
        assert(2**3**2 == 512)
    }
}
