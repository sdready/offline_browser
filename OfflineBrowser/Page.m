/*********************************************************************************************
*   OFFLINE BROWSER:    Page                                                                 *
*                                                                                            *
* Authors:     Greg Murray and Shaun Ready                                                   *
* Last Edit:   March 29, 2012                                                                *
*                                                                                            *
* Description: Page is an object representing a web page. It implements NSCoding and can     *
*              be archived.                                                                  *
**********************************************************************************************/

#import "Page.h"

@implementation Page
@synthesize pageHTML;
@synthesize pageURL;
@synthesize displayText; //The text that is displayed in the UITableViews

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:pageHTML forKey:@"pageHTML"];
    [encoder encodeObject:pageURL forKey:@"pageURL"];
    [encoder encodeObject:displayText forKey:@"displayText"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if(self)
    {
        [self setPageHTML:[decoder decodeObjectForKey:@"pageHTML"]];
        [self setPageURL:[decoder decodeObjectForKey:@"pageURL"]];
        [self setDisplayText:[decoder decodeObjectForKey:@"displayText"]];
    }
    
    return self;
}
@end
