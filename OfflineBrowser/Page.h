

#import <Foundation/Foundation.h>

@interface Page : NSObject <NSCoding>
{
    NSString *pageHTML;
    NSString *pageURL;
    NSString *displayText;
}
@property (strong, nonatomic) NSString *pageHTML;
@property (strong, nonatomic) NSString *pageURL;
@property (strong, nonatomic) NSString *displayText;

@end
