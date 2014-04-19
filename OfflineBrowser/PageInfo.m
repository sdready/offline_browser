/*********************************************************************************************
*   OFFLINE BROWSER:    PageInfo                                                             *
*                                                                                            *
* Authors:     Greg Murray and Shaun Ready                                                   *
* Last Edit:   March 31, 2012                                                                *
*                                                                                            *
* Description: This is the view for the screen that is displayed when editing page info.     *
*              Currently, the only editable information is the text that is displayed in the *
*              tables in SavedScreenController and FavouritesScreenController.               *
**********************************************************************************************/
 
#import "PageInfo.h"

@implementation PageInfo
@synthesize idTextField;
@synthesize pageType;
@synthesize pageIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (IBAction)saveChangesAction:(id)sender 
{
    //Determine whether the page is in the WebPages singleton or the FavouritePages singleton
    if([pageType isEqualToString:@"Saved"])
        [[[[WebPages defaultPages] allPages] objectAtIndex:pageIndex] setDisplayText:[idTextField text]];
    else
        [[[[FavouritePages defaultPages] allPages] objectAtIndex:pageIndex] setDisplayText:[idTextField text]];
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Determine the page type (Saved or Favourites) and set the title accordingly
    if([pageType isEqualToString:@"Saved"])
    {
        page = [[[WebPages defaultPages] allPages] objectAtIndex:pageIndex];
        [self setTitle:[page displayText]];
    }
    else
    {
        page = [[[FavouritePages defaultPages] allPages] objectAtIndex:pageIndex];
        [self setTitle:[page displayText]];
    }
    
    [idTextField setDelegate:self];
    [idTextField setText:[page displayText]]; //Initialize the text field to contain the current display text
}

- (void)viewDidUnload
{
    [self setIdTextField:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
