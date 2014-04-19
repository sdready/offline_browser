/*********************************************************************************************
*   OFFLINE BROWSER:    FavouritesScreenController                                           *
*                                                                                            *
* Authors:     Greg Murray and Shaun Ready                                                   *
* Last Edit:   March 31, 2012                                                                *
*                                                                                            *
* Description: This is the view for the app's screen that displays the list of favourite     *
*              pages. By default the URLs of the web pages are displayed, but custom display * 
*              text can be set by the user in the Browser. The user can swipe to delete      *
*              pages.                                                                        *
*********************************************************************************************/

#import "FavouritesScreenController.h"
#import "FavouritePages.h"
#import "Page.h"
#import "Browser.h"

@implementation FavouritesScreenController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self setTitle:@"Favourites"];
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
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self tableView] reloadData]; //Ensures data is reloaded when added from another view
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[FavouritePages defaultPages] allPages] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //Set the cell text to be the display text of the web page object. (URL by default)
    NSString *cellText = [[[[FavouritePages defaultPages] allPages] objectAtIndex:[indexPath row]] displayText];
    [[cell textLabel] setText:cellText];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the selected page and send it to the Browser to be displayed
    Page *page = [[[FavouritePages defaultPages] allPages] objectAtIndex:[indexPath row]];
    Browser *browser = [[Browser alloc] initWithNibName:@"Browser" bundle:nil webPage:page];
    [browser setHidesBottomBarWhenPushed:YES];
    [browser setBrowserType:@"Favourites"];
    [self.navigationController pushViewController:browser animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *ipaths = [NSArray arrayWithObject:indexPath];
    
    [[[FavouritePages defaultPages] allPages] removeObjectAtIndex:[indexPath row]];
    [[self tableView] deleteRowsAtIndexPaths:ipaths withRowAnimation:UITableViewRowAnimationFade];
}

@end
