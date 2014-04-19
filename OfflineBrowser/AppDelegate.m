//
//  AppDelegate.m
//  OfflineBrowser
//
//  Created on 12-03-08.
//

#import "AppDelegate.h"
#import "MainScreenController.h"
#import "SavedScreenController.h"
#import "FavouritesScreenController.h"
#import "SettingsScreenController.h"
#import "WebPages.h"
#import "FavouritePages.h"
#import "Settings.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    sleep(3); //Delay to display splash screen
    
    //Create the view controllers for the app
    UITabBarController *tabController = [[UITabBarController alloc] init];
    
    UIViewController *mainScreen = [[MainScreenController alloc] init];
    
    UITableViewController *savedScreen = [[SavedScreenController alloc] init];
    UINavigationController *savedScreenNav = [[UINavigationController alloc] initWithRootViewController:savedScreen];
    [[savedScreenNav navigationBar] setBarStyle:UIBarStyleBlackOpaque];
    
    UITableViewController *favScreen = [[FavouritesScreenController alloc] init];
    UINavigationController *favScreenNav = [[UINavigationController alloc] initWithRootViewController:favScreen];
    [[favScreenNav navigationBar] setBarStyle:UIBarStyleBlackOpaque];
    
    UIViewController *settingsScreen = [[SettingsScreenController alloc] init];
    UINavigationController *settingsScreenNav = [[UINavigationController alloc] initWithRootViewController:settingsScreen];
    [[settingsScreenNav navigationBar] setBarStyle:UIBarStyleBlackOpaque];
    
    NSArray *screenControllers = [[NSArray alloc] initWithObjects:mainScreen, savedScreenNav, favScreenNav, settingsScreenNav, nil];
    [tabController setViewControllers:screenControllers];
    [[self window] setRootViewController:tabController];
    
    //Load archived web pages and settings
    [[WebPages defaultPages] loadPages];
    [[FavouritePages defaultPages] loadPages];
    [[Settings settings] loadSettings];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application{}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //Archive the saved web pages and settings
    [[WebPages defaultPages] savePages];
    [[FavouritePages defaultPages] savePages];
    [[Settings settings] saveSettings];
}

- (void)applicationWillEnterForeground:(UIApplication *)application{}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    sleep(1); //Slight delay to display the splash screen
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //Archive the saved web pages and settings
    [[WebPages defaultPages] savePages];
    [[FavouritePages defaultPages] savePages];
    [[Settings settings] saveSettings];
}

@end
