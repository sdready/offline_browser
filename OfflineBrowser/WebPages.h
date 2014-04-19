//
//  WebPages.h
//  OfflineBrowser
//
//  Created on 12-03-08.
//

#import <Foundation/Foundation.h>
#import "Page.h"

@interface WebPages : NSObject
{
    NSMutableArray *allPages;
}
-(void)savePages;
-(void)loadPages;
-(NSString*)getArchivePath;
+(WebPages *)defaultPages;
-(NSMutableArray *)allPages;
-(Page *)addPageURL:(NSString *)pageURL html:(NSString *)pageHTML;

@end
