/*********************************************************************************************
*   OFFLINE BROWSER:    SettingsScreenController                                             *
*                                                                                            *
* Authors:     Greg Murray and Shaun Ready                                                   *
* Last Edit:   April 01, 2012                                                                *
*                                                                                            *
* Description: This is the view for the app's settings screen. The settings are saved and    *
*              archived using a singleton. Currently, the only setting provided allows for   * 
*              the user to specify they want saved pages to always be displayed in "offline  *
*              mode".                                                                        *
*                                                                                            *
* Issues:      There is currently only one settings option. We couldn't think of anything    *
*              else to add. We attempted to create a setting that allowed the favourite      *
*              pages to be added on startup, but there were issues encountered when making   *
*              sequential requests for multiple pages.                                       *
*********************************************************************************************/

#import "SettingsScreenController.h"
#import "Settings.h"

@implementation SettingsScreenController
@synthesize offlineModeSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Settings"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [offlineModeSwitch setOn:[[Settings settings] offlineMode]];
}

- (void)viewDidUnload
{
    [self setOfflineModeSwitch:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)offlineModeSwitchAction:(id)sender 
{
    [[Settings settings] setOfflineMode:[offlineModeSwitch isOn]];
}
@end
