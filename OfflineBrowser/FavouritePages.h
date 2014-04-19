//
//  FavouritePages.h
//  OfflineBrowser
//
//  Created on 12-03-31.
//

#import <Foundation/Foundation.h>
#import "Page.h"

@interface FavouritePages : NSObject
{
    NSMutableArray *allPages;
}
-(void)savePages;
-(void)loadPages;
-(NSString *)getArchivePath;
+(FavouritePages *)defaultPages;
-(NSMutableArray *)allPages;
-(Page *)addPage:(Page *)newPage;

@end
