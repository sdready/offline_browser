/*********************************************************************************************
*   OFFLINE BROWSER:    Page                                                                 *
*                                                                                            *
* Authors:     Greg Murray and Shaun Ready                                                   *
* Last Edit:   March 31, 2012                                                                *
*                                                                                            *
* Description: Settings is a singleton that contains configuration data. It implements       *
*              NSCoding and can be archived. Currently, only one setting is provided.        *
**********************************************************************************************/

#import "Settings.h"

static Settings *settings = nil;

@implementation Settings
@synthesize offlineMode;


+(Settings *)settings
{
    if(!settings)
        settings = [[super allocWithZone:NULL] init];
    
    return settings;
}

-(id)init
{
    if(settings)
        return settings;
    
    self = [super init];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeBool:offlineMode forKey:@"offlineMode"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if(self)
    {
        [self setOfflineMode:[decoder decodeBoolForKey:@"offlineMode"]];
    }
    
    return self;
}

/* Archive the settings
 ************************************/
-(void)saveSettings
{
    NSString *path = [self getArchivePath];
    [NSKeyedArchiver archiveRootObject:settings toFile:path];
}

/* Unarchive the saved settings
 ************************************/
-(void)loadSettings
{
    NSString *path = [self getArchivePath];
    [settings setOfflineMode: [[NSKeyedUnarchiver unarchiveObjectWithFile:path] offlineMode]];
}

/* Get the path to the location where the data will be saved and loaded from
 ************************************************************************************/
-(NSString *)getArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"savedSettings.data"];
    
    return path;
}

@end
