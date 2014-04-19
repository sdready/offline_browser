//
//  SettingsScreenController.h
//  OfflineBrowser
//
//  Created on 12-04-01.
//

#import <UIKit/UIKit.h>

@interface SettingsScreenController : UIViewController
{
    BOOL offlineMode;
}
@property (weak, nonatomic) IBOutlet UISwitch *offlineModeSwitch;
- (IBAction)offlineModeSwitchAction:(id)sender;

@end
