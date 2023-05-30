# TouchBarScreenNavigator

After my Mac Book Pro's 19 TouchBar 16-inch screen went blank without any visible damage, I decided to experiment by using the  TouchBar as a substitute screen. With some efforts, I managed to add desired features for navigating to apps. Still in progresss However,it works just add it to login item.

****


## How to use
1. Install TouchSwitcher
2. Enable Guest Auto login from system setting
3. Add TouchSwitcher to Login Item app
4. Download TouchBarScreenNavigator
5. Add TouchBarScreenNavigator to Login Item app
6. System Setting Lock Screen Accessibility Enable VoiceOver
7. To Zoom Command++ Command+- Command+0 to reset zoom

## Todo
1. Remove blank window
2. Allow user to customize cmd to run on HotCorner
3. Use [MTMR](https://github.com/Toxblh/MTMR/releases) concept to stay on TouchBar as we Navigate the Screen without depriving other TouchBar App the TouchBar Usability.
4. Experiment with pam module ```#include <security/pam_appl.h>``` to Capture the screen on Loginwindow  using ```<AppKit/AppKit.h>``` or work towards ```IOKit```  TouchBarScreenNavigator kernel extension which ever make it possible am going to try. 
5. Currently once you locate a point on the screen to to click due to the main window overlay you have to reclick.

## Way Foward
I have realized to achieve my objective i have to programatically create all the Touchbar and other componets without the storyboard.



## Contribution
I am venturing into Mac OS App development for the first time out of necessity. My Mac Book 19 is currently displaying a blank screen, and I need assistance with creating a TouchBar App. Specifically, I want to eliminate the blank window and make it a TouchBar only app. Please help.
