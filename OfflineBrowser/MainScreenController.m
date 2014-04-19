/********************************************************************************************
*   OFFLINE BROWSER:    MainScreenController                                                *
*                                                                                           *
* Authors:     Greg Murray and Shaun Ready                                                  *
* Last Edit:   April 02, 2012                                                               *
*                                                                                           *
* Description: This is the view for the app's main screen. This view contains a UIWebView   *
*              that displays websites specified by the user. The currently displayed web    *
*              page can be saved. This page is saved by retrieving the HTML code from the   *
*              current page and putting it in a String. The String is then parsed to search *
*              for image tags. The images are then downloaded and encoded using base64 and  *
*              embedded in the String containing the HTML code.                             *
*                                                                                           *
* Issues:      There currently aren't any known issues with this screen, but due to the     *
*              nature of the Internet, it's likely there are some pages that would cause    *
*              issues.                                                                      *
********************************************************************************************/


#import "MainScreenController.h"
#import "AppDelegate.h"
#import "WebPages.h"

@implementation MainScreenController
@synthesize activityIndicator;
@synthesize urlTextField;
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Main"];
        adding = false; //Adding variable allows for distinction between View and Add
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setUrlTextField:nil];
    [self setWebView:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//Make a request using the URL in the text field.
/********************************************************/
- (IBAction)viewButtonAction:(id)sender 
{
    [activityIndicator startAnimating];
    [urlTextField resignFirstResponder];
    
    responseData = [[NSMutableData alloc] init];
    url = [NSURL URLWithString:[urlTextField text]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:50];
    
    NSURLConnection *unusedVar = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    unusedVar=unusedVar; //Variable doesn't need to be used; gets rid of annoying warning
}

//Make a request using the URL in the text field
/********************************************************/
- (IBAction)addActionButton:(id)sender 
{
    [activityIndicator startAnimating];
    [urlTextField resignFirstResponder];
    adding = true;
    
    responseData = [[NSMutableData alloc] init];
    url = [NSURL URLWithString:[urlTextField text]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:50];
    
    NSURLConnection *unusedVar = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    unusedVar=unusedVar; //Variable doesn't need to be used; gets rid of annoying warning
}

//Append data as it is received
/********************************************************/
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    [responseData appendData:data];
}

/* Display an error alert if the requested page was unable to load
*********************************************************************/
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    [activityIndicator stopAnimating];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offline Browser" message:@"Unable to load page" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alert show];
}

/* Retrieve and save the HTML code with the base64 encoded images
 ********************************************************************/
- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    //Although the page data is already loaded into responseData, using NSMutableURLRequest allows
    //the web page to be displayed and formatted properly with images and other resources. The 
    //NSURLConnection is still used as it provides more control.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:100];
    [webView loadRequest:request];
    
    if (adding == true) //This if- block is skipped if the page is simply being viewed.
    {
        pageHTML = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
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
        

        i=0;
        //Search the HTML code for the <img> tag
        while(i < [pageHTML length]) 
        {
            NSString *subString = NULL;

            if(i + 4 < [pageHTML length])
                subString = [pageHTML substringWithRange:NSMakeRange(i, 4)];
            
            if([subString isEqualToString:@"<img"]) //<img> tag found
            {
                int imgEnd = i + 3;
                
                i += 4; //Look for the "src" portion of the <img> tag
                while (![subString isEqualToString:@"src=\""] && ![subString isEqualToString:@"src='"]) 
                {
                    i++;
                    subString = [pageHTML substringWithRange:NSMakeRange(i, 5)];
                }
                
                int srcStart = i;
                
                i += 5;
                if (![[pageHTML substringWithRange:NSMakeRange(i, 5)] isEqualToString:@"data:"]) //Already embedded
                {
                    int imgSourceIndex = i;
                    int subLength = 0;
                
                    while([pageHTML characterAtIndex:i+subLength] != '"' && [pageHTML characterAtIndex:i+subLength] != '\'')
                        subLength++;
                
                    //Set subString to be the path of the image source
                    subString = [pageHTML substringWithRange:NSMakeRange(i, subLength)];
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
                    while (j >= 0 && [subString characterAtIndex:j] != '.') //Find image extension
                        j--;
                
                    NSString *imageType = [subString substringWithRange:NSMakeRange(j+1, 3)];

                    if(srcStart-imgEnd > 2)
                    {
                        //Accounts for an alternate way of storing images
                        //i.e. <img class="........... src=".....

                        NSString *base64ImageString = @"src=\"data:image/";
                        base64ImageString = [base64ImageString stringByAppendingString:imageType];
                        base64ImageString = [base64ImageString stringByAppendingString:@";base64,"];
                        base64ImageString = [base64ImageString stringByAppendingString:encodedImage];
                        base64ImageString = [base64ImageString stringByAppendingFormat:@"\""];
                    
                        int endIndex = imgSourceIndex + [subString length] - imgEnd+2;
                        pageHTML = [pageHTML stringByReplacingCharactersInRange:NSMakeRange(imgEnd+2, endIndex+1) withString:base64ImageString];
                    }
                    else
                    {
                        //The typical method for incorporating images into HTML
                        //i.e. <img src=".........
                        //Could probably be done with the method shown above also. Didn't test

                        NSString *base64ImageString = @"data:image/";
                        base64ImageString = [base64ImageString stringByAppendingString:imageType];
                        base64ImageString = [base64ImageString stringByAppendingString:@";base64,"];
                        base64ImageString = [base64ImageString stringByAppendingString:encodedImage];
                        base64ImageString = [base64ImageString stringByAppendingFormat:@"\""];
                    
                        pageHTML = [pageHTML stringByReplacingCharactersInRange:NSMakeRange(imgSourceIndex, [subString length]+1) withString:base64ImageString];
                    }
                }
            }
            else
                i++;
        }
        }
        @catch (NSException *exception) 
        {
            pageHTML = pageHTML; //Uneccessary, but conveys the desired action
        }
        
        //Add the page to a singleton to be displayed in a UITableView
        [[WebPages defaultPages] addPageURL:[url description] html:pageHTML];
        [[[[WebPages defaultPages] allPages] objectAtIndex:[[[WebPages defaultPages] allPages] count]-1] setDisplayText:[url description]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offline Browser" message:@"Page Saved" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show]; //Alert that the page was saved
    }
    adding = false;
}

/* Set the URL text field to contain the URL of the currently displayed page. (called when link is clicked)
 ******************************************************************************/
- (void)webViewDidFinishLoad:(UIWebView*)wView
{
    NSURL* newURL = [[wView request] mainDocumentURL];
    urlTextField.text = [newURL absoluteString];
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
