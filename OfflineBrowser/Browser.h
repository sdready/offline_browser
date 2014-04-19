//
//  Browser.h
//  OfflineBrowser
//
//  Created on 12-03-29.
//

#import <UIKit/UIKit.h>
#import "Page.h"

@interface Browser : UIViewController <UIActionSheetDelegate>
{
    Page *activePage;
    NSMutableData *responseData;
    NSURL *url;
    
    NSString *browserType;
    NSMutableURLRequest *request;
    
    BOOL initialLoad;
    BOOL attemptLoad;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSString *browserType;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil webPage:(Page *)page;
- (NSString *) base64StringFromData: (NSData *)data length: (int)length;

- (IBAction)editButtonAction:(id)sender;
- (IBAction)refreshButtonAction:(id)sender;
- (IBAction)addButtonAction:(id)sender;
- (IBAction)deleteButtonAction:(id)sender;
@end
