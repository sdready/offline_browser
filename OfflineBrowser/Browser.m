/*********************************************************************************************
*   OFFLINE BROWSER:    Browser                                                              *
*                                                                                            *
* Authors:     Greg Murray and Shaun Ready                                                   *
* Last Edit:   April 02, 2012                                                                *
*                                                                                            *
* Description: This is the view for the app's offline web browser. When there is no Internet *
*              connection or the "offline mode" setting is on, the UIWebView loads the       * 
*              stored HTML code. If there is an Internet connection and the "offline mode"   *  
*              setting is off, a new request is made and the updated web page is displayed   *
*                                                                                            *
* Issues:      There is currently an issue that sometimes occurs when refreshing pages with  *
*              no Internet connection. An example of this error would be when loading the    *
*              UPEI home page. This error does not occur in the MainScreenController,        *
*              however, despite having identical code. This refresh option was a late        *
*              addition so this issue could not be fully troubleshot. The offline version    *
*              is loaded instead when this error occurs.                                     *
*     *** This error may have potentially been resolved. Further testing still required. *** *
*********************************************************************************************/

#import "Browser.h"
#import "WebPages.h"
#import "FavouritePages.h"
#import "Page.h"
#import "PageInfo.h"
#import "Settings.h"

@implementation Browser
@synthesize activityIndicator;
@synthesize browserType;
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Offline Browser"];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil webPage:(Page *)page
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        activePage = page;
        [self setTitle:@"Offline Browser"];
    }
    return self;
}

/* Action function for the Edit button. Opens a page that allows certain page information to be edited
 ********************************************************************************************************/
- (IBAction)editButtonAction:(id)sender 
{
    PageInfo *pageInfo = [[PageInfo alloc] initWithNibName:@"PageInfo" bundle:nil];
    [pageInfo setPageType:browserType];
    if([browserType isEqualToString:@"Saved"])
        [pageInfo setPageIndex:[[[WebPages defaultPages] allPages] indexOfObject:activePage]];
    else
        [pageInfo setPageIndex:[[[FavouritePages defaultPages] allPages] indexOfObject:activePage]];
    [self.navigationController pushViewController:pageInfo animated:YES];
}

/* Action function for the Refresh button. Attempts to connect to the Internet to refresh the page
 *******************************************************************************************************/
- (IBAction)refreshButtonAction:(id)sender 
{
    attemptLoad = YES;
    [activityIndicator startAnimating];
    
    responseData = [[NSMutableData alloc] init];
    url = [NSURL URLWithString:[activePage pageURL]];
    request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:50];
    
    NSURLConnection *unusedVar = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    unusedVar=unusedVar; //Variable doesn't need to be used; gets rid of annoying warning
}

/* Action function for the Add button. Adds the page to the FavouritePages singleton
 **************************************************************************************/
- (IBAction)addButtonAction:(id)sender 
{
    [[FavouritePages defaultPages] addPage:activePage];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offline Browser" message:@"Added to Favourites" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alert show]; //Alert that the page was added to Favourites
}

/* Action function for the Delete button. Displays an ActionSheet to confirm deletion
 **************************************************************************************/
- (IBAction)deleteButtonAction:(id)sender 
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Confirm Delete" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
    [sheet showInView:[self view]];
    
}

/* Delegate function for the ActionSheet
 ******************************************/
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) 
    {
        if ([browserType isEqualToString:@"Saved"]) //Delete from Saved Pages
        {
            [[[WebPages defaultPages] allPages] removeObject:activePage];
            [[self navigationController] popToRootViewControllerAnimated:YES];
        }
        else //Delete from Favourite Pages
        {
            [[[FavouritePages defaultPages] allPages] removeObject:activePage];
            [[self navigationController] popToRootViewControllerAnimated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    initialLoad = YES; //Variable that prevents the alert from being displayed when initially opening the browser
    
    if([[Settings settings] offlineMode]) //Load saved HTML if in offline mode
    {
        attemptLoad = NO;
        initialLoad = NO;
        [webView loadHTMLString:[activePage pageHTML] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    }
    else //Attempt to make a request to reload the page
    {
        attemptLoad = YES;
        [activityIndicator startAnimating];
        
        responseData = [[NSMutableData alloc] init];
        url = [NSURL URLWithString:[activePage pageURL]];
        request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:50];
    
        NSURLConnection *unusedVar = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        unusedVar=unusedVar; //Variable doesn't need to be used; gets rid of annoying warning
    }
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/* Append data as it is received
 ****************************************/
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    [responseData appendData:data];
}

/* Load the saved HTML data if an error occurs when loading the page
 ***************************************************************************/
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offline Browser" message:@"Unable to connect" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];

    if(!initialLoad)
        [alert show]; //Display alert message for unsuccessful loads after the first
    
    initialLoad = NO;
    attemptLoad = NO;
    [webView loadHTMLString:[activePage pageHTML] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    [activityIndicator stopAnimating];
}

/* Retrieve and save the HTML code with the base64 encoded images
 ********************************************************************/
- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    @try{
    NSString *baseURL; //Will hold the URL of the main website
    NSString *fullURL = [url description]; //URL of the current web page
    int i=7; //Adjusted to skip over "http://"
    
    //Move i until it reaches the end of the main URL
    while (i < ([fullURL length]-1) && [fullURL characterAtIndex:i] != '/') 
        i++;
    
    //Set the base URL for the website
    if([fullURL characterAtIndex:i] == '/')
        baseURL = [fullURL substringWithRange:NSMakeRange(0, i)];
    else
        baseURL = fullURL;
    
    [activePage setPageHTML:[[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]];
    
    i=0;
    //Search the HTML code for the <img> tag
    while(i < [[activePage pageHTML] length]) 
    {
        NSString *subString = NULL;
        
        if(i + 4 < [[activePage pageHTML] length])
            subString = [[activePage pageHTML] substringWithRange:NSMakeRange(i, 4)];
        
        if([subString isEqualToString:@"<img"]) //<img> tag found
        {
            int imgEnd = i + 3;
            
            i += 4; //Look for the "src" portion of the <img> tag
            while (![subString isEqualToString:@"src=\""] && ![subString isEqualToString:@"src='"]) 
            {
                i++;
                subString = [[activePage pageHTML] substringWithRange:NSMakeRange(i, 5)];
            }
            
            int srcStart = i;
            
            i += 5;
            if (![[[activePage pageHTML] substringWithRange:NSMakeRange(i, 5)] isEqualToString:@"data:"]) //Already embedded
            {
                int imgSourceIndex = i;
                int subLength = 0;
                
                while([[activePage pageHTML] characterAtIndex:i+subLength] != '"' && [[activePage pageHTML] characterAtIndex:i+subLength] != '\'')
                    subLength++;
                
                //Set subString to be the path of the image source
                subString = [[activePage pageHTML] substringWithRange:NSMakeRange(i, subLength)];
                i += subLength;
                
                //This code will create an image URL for most HTML image formats
                NSString *imageURLString = subString;
                if (![[subString substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"http"]) 
                    imageURLString = [baseURL stringByAppendingString:subString];
                
                NSURL *imageURL = [NSURL URLWithString:imageURLString];
                NSData *data = [[NSData alloc] initWithContentsOfURL:imageURL];
                
                
                //Create an image URL and get the data from it. The following block of code handles an HTML format for images that some sites, like Wikipedia, use.
                if(data == NULL)
                {
                    imageURLString = @"http://";
                    imageURLString = [imageURLString stringByAppendingString:[subString substringWithRange:NSMakeRange(2, [subString length]-2)]];
                    imageURL = [NSURL URLWithString:imageURLString];
                    data = [[NSData alloc] initWithContentsOfURL:imageURL];
                }
                
                //Encode the image with base64 for embedding in the HTML string
                NSString *encodedImage = [self base64StringFromData:data length:[data length]];
                
                int j = [subString length] - 1;
                while (j >= 0 && [subString characterAtIndex:j] != '.') 
                    j--;
                
                NSString *imageType = [subString substringWithRange:NSMakeRange(j+1, 3)];
                    
                if(srcStart-imgEnd > 2)
                {
                    //Accounts for a less common way of storing images
                        
                    NSString *base64ImageString = @"src=\"data:image/";
                    base64ImageString = [base64ImageString stringByAppendingString:imageType];
                    base64ImageString = [base64ImageString stringByAppendingString:@";base64,"];
                    base64ImageString = [base64ImageString stringByAppendingString:encodedImage];
                    base64ImageString = [base64ImageString stringByAppendingFormat:@"\""];
                        
                    int endIndex = imgSourceIndex + [subString length] - imgEnd+2;
                    [activePage setPageHTML:[[activePage pageHTML] stringByReplacingCharactersInRange:NSMakeRange(imgEnd+2, endIndex+1) withString:base64ImageString]];
                }
                else
                {
                    //The typical method for incorporating images into HTML
                        
                    NSString *base64ImageString = @"data:image/";
                    base64ImageString = [base64ImageString stringByAppendingString:imageType];
                    base64ImageString = [base64ImageString stringByAppendingString:@";base64,"];
                    base64ImageString = [base64ImageString stringByAppendingString:encodedImage];
                    base64ImageString = [base64ImageString stringByAppendingFormat:@"\""];
                        
                    [activePage setPageHTML:[[activePage pageHTML] stringByReplacingCharactersInRange:NSMakeRange(imgSourceIndex, [subString length]+1) withString:base64ImageString]];
                }
            }
        }
        else
            i++;
    }
    if (attemptLoad) 
        [webView loadRequest:request];
    else
        [webView loadHTMLString:[activePage pageHTML] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    }
    @catch (NSException *exception) 
    {
        [webView loadRequest:request];
    }
    initialLoad = NO;
    attemptLoad = NO;
    [activityIndicator stopAnimating];
}

//This function was taken from:
//http://stackoverflow.com/questions/392464/any-base64-library-on-iphone-sdk
- (NSString *) base64StringFromData: (NSData *)data length: (int)length 
{
    static char base64EncodingTable[64] = 
    {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
    };
    
    
    unsigned long ixText, textLength;
    long charsRemaining;
    unsigned char input[3], output[4];
    short i, charsOnLine = 0, charsCopy;
    const unsigned char *rawData;
    NSMutableString *result;
    
    textLength = [data length]; 
    if (textLength < 1)
        return @"";
    
    result = [NSMutableString stringWithCapacity: textLength];
    rawData = [data bytes];
    ixText = 0; 
    
    while (true) 
    {
        charsRemaining = textLength - ixText;
        if (charsRemaining <= 0) 
            break;   
        
        for (i = 0; i < 3; i++) 
        { 
            unsigned long ix = ixText + i;
            if (ix < textLength)
                input[i] = rawData[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        charsCopy = 4;
        
        switch (charsRemaining) 
        {
            case 1: 
                charsCopy = 2; 
                break;
            case 2: 
                charsCopy = 3; 
                break;
        }
        
        for (i = 0; i < charsCopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = charsCopy; i < 4; i++)
            [result appendString: @"="];
        
        ixText += 3;
        charsOnLine += 4;
        
        if ((length > 0) && (charsOnLine >= length))
            charsOnLine = 0;
    }     
    return result;
}

@end
