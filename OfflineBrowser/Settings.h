//
//  Settings.h
//  OfflineBrowser
//
//  Created on 12-03-31.

#import <Foundation/Foundation.h>

@interface Settings : NSObject <NSCoding>
{
    BOOL offlineMode;
}
@property BOOL offlineMode;
+(Settings *)settings;
-(void)encodeWithCoder:(NSCoder *)encoder;
-(id)initWithCoder:(NSCoder *)decoder;
-(void)saveSettings;
-(void)loadSettings;
-(NSString *)getArchivePath;

@end
