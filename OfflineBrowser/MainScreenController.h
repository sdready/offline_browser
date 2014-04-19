//
//  MainScreenController.h
//  OfflineBrowser
//
//  Created on 12-03-08.
//

#import <UIKit/UIKit.h>

@interface MainScreenController : UIViewController <UITextFieldDelegate>
{
    NSURL *url;
    NSString *pageHTML;
    NSMutableData *responseData;
    BOOL adding;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)viewButtonAction:(id)sender;
- (IBAction)addActionButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (NSString *) base64StringFromData: (NSData *)data length: (int)length;

@end
