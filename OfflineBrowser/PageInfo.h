//
//  PageInfo.h
//  OfflineBrowser
//
//  Created on 12-03-31.
//

#import <UIKit/UIKit.h>
#import "WebPages.h"
#import "FavouritePages.h"
#import "Page.h"

@interface PageInfo : UIViewController <UITextFieldDelegate>
{
    Page *page;
    NSString *pageType;
    int pageIndex;
}
@property (strong, nonatomic) NSString *pageType;
@property int pageIndex;
- (IBAction)saveChangesAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *idTextField;

@end
