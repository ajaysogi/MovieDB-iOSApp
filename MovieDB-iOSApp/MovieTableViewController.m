//
//  MovieTableViewController.m
//  MovieDB-iOSApp
//
//  Created by Ajay Sogi on 18/02/2015.
//  Copyright (c) 2015 Ajay Sogi. All rights reserved.
//

#import "MovieTableViewController.h"
#import "MovieSearchService.h"

#import "MovieDetailsViewController.h"

@interface MovieTableViewController ()

@end

@implementation MovieTableViewController

//=================================================================================================================
//
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
//=================================================================================================================
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated {
    // Save movie list once returend to list view
    [super viewWillAppear:animated];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"movies.xml"];
    [movies writeToFile:yourArrayFileName atomically:YES];
    
}
//=================================================================================================================
#pragma mark - Table view data source
//=================================================================================================================
// This method detects wether the user is searching and ignores any warning messages and simply adds the film to the movie array and resets the user interface back to the film list that was created in the previous session
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (searching) {
        
        // Use for interaction with search list
        NSDictionary *movie = [searchResults objectAtIndex:[indexPath row]];
        
        // Check label for system messages
        if ([[movie valueForKey:@"id"] intValue] != -1) {
            
            // Add new film to the list
            [movies addObject:movie];
            
            // Clear Search text
            [searchBar setText:@""];
            
            // Remove the Cancel/Done button from the navigation bar
            [[self navigationItem] setRightBarButtonItem:nil];
            
            // Clear search results and reset state
            searching = NO;
            [searchResults removeAllObjects];
            
            // Force table to reload and redraw
            [[self tableView] reloadData];
            
            // Sort Movies
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
            [movies sortUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
            
            // Store Data
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"movies.xml"];
            [movies writeToFile:yourArrayFileName atomically:YES];
            
        }
    } else {
        
        // Use for interaction with films list
        //----------------------------------------------------------------------------------
        //
        NSDictionary *movie = [movies objectAtIndex:[indexPath row]];
        
        // Create a new MovieDeatilsViewController
        MovieDetailsViewController *mdvc = [[MovieDetailsViewController alloc] initWithNibName:@"MovieDetailsViewController" bundle:nil];
        
        // Set movie properties to the selected movie
        [mdvc setMovie:movie];
        
        // add the new view and make it slide in from the right.
        [[self navigationController] pushViewController:mdvc animated:YES];
        
    }
}
//=================================================================================================================
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}
//=================================================================================================================
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    
    /*
     The rows will be calculated based on the search state using a conditional operator
     
     TRUE:  return the number of rows to display all the searchResult array objects
     FALSE: return the number of rows to display all the movie array objects
     
     */
    
    return searching ? [searchResults count] : [movies count];
}
//=================================================================================================================
// This method handels the config and display of the cells within this tableView class
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    // Check to see if the cell is empty
    if(cell == nil){
        
        // If cell is empty then create a new cell that allows a subtitle(year) to be set
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // @params *movie:
    // Retrieves the title and year of the movie depending on search state, and stores within this dictionary
    NSDictionary *movie = searching ? [searchResults objectAtIndex:[indexPath row]] : [movies objectAtIndex:[indexPath row]];
    
    // Assign to row, the 'title' and 'year' from the dictionary *movie
    [[cell textLabel] setText:[movie valueForKey:@"title"]];
    [[cell detailTextLabel] setText:[[movie valueForKey:@"release_date"] description]];
    
    
    return cell;
}

#pragma mark - Styling
//=================================================================================================================
//
- (id)initWithStyle:(UITableViewStyle)style{
    
    self = [super initWithStyle:style];
    
    if(self){
        
        // Set title
        [self setTitle:@"My Movies"];
    
        // Create SearchBar for table header
        UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        [vw addSubview:searchBar];
        [[self tableView] setTableHeaderView:vw];

        // Set up search bar for use
        [searchBar setPlaceholder:@"Movie Title"];
        [searchBar setDelegate:self];
        searching = NO;
    
        // Create basic movie list for testing display
        movies = [NSMutableArray arrayWithCapacity:10];
        searchResults = [NSMutableArray arrayWithCapacity:10];
    
        // Set up service queue
        serviceQueue = [[NSOperationQueue alloc] init];
        
        // Set total number of simultaneous tasks as 1 (this is good practice for when the service request made triggers off multiple times, this allows it to be bought back to 1)
        [serviceQueue setMaxConcurrentOperationCount:1];
    
        // Restore saved Movie list
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"movies.xml"];
        movies = [[NSMutableArray alloc] initWithContentsOfFile: yourArrayFileName];
        if(movies == nil) {
            movies = [NSMutableArray arrayWithCapacity:10];
        }
        
        // Sort films
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
        [movies sortUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
        
        // Edit 1 - Create Edit Button
        [[self navigationItem] setBackBarButtonItem:[self editButtonItem]];
    }
    
    return self;
}

#pragma mark - Search bar
//=================================================================================================================
// Allow the application to respond to the search events. Informs the delegate when the user begins editing the search text.
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    // set state to be searching
    searching = YES;
    
    // Add Cancel/Done button to navigation bar and tell it to call a method "searchDone" on our object (self) when it is pressed
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(searchDone:)]];
    
    // Edit 2 - Remove Edit button when in search state
    [[self navigationItem] setLeftBarButtonItem:nil];
    
    // Ensure that every time a search request is made, the search result is cleared and ready to store new returned data.
    [searchResults removeAllObjects];
    
    // Force table to reload and redraw
    [[self tableView] reloadData];
    
}
//=================================================================================================================
/*
 This method is exe. when the 'DONE' button has been pressed. The method resets the UI back to its starting state by 
 removing the searching text and the done button as well as the focus from the search field. Then it redraws the table.
 */
- (void)searchDone:(id)sender{
    
    // Clear Search text
    [searchBar setText:@""];
    
    // Hide keyboard from the search bar
    [searchBar resignFirstResponder];
    
    // Remove the Cancel/Done button from the navigation bar
    [[self navigationItem] setRightBarButtonItem:nil];
    
    // Edit 3 - Add back the Edit Button
    [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    
    // Clear search results and reset state
    searching = NO;
    [searchResults removeAllObjects];
    
    // Force table to reload and redraw
    [[self tableView] reloadData];
    
}
//=================================================================================================================
//
- (void)searchBarSearchButtonClicked:(UISearchBar *)sbButtonClicked{
    
    //retrive search term from search bar
    NSString *searchTerm = [searchBar text];
    
    // DEBUG CODE -----------------------------
    // Log search term on terminal
    NSLog(@"Search Term : %@", searchTerm);
    //-----------------------------------------
    
    // Create and initialise a new search service
    MovieSearchService *service = [[MovieSearchService alloc] init];
    
    // Set the search term and delegate
    [service setSearchTerm:searchTerm];
    [service setDelegate:self];
    
    // Add to search queue to be executed
    [serviceQueue addOperation:service];
    
    // Clear searchResults array when the new service request has been started
    [searchResults removeAllObjects];
    
    // Notify the user that the app is currently searching (by adding a object to the array stating 'searching')
    [searchResults addObject:
     [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-1", @"Searching . . .", @"", nil]
                                 forKeys:[NSArray arrayWithObjects:@"id", @"title", @"release_date", nil]]];
    
    // Reload and Redraw table
    [[self tableView]reloadData];
    
    // Hide the keyboard form the search bar
    [searchBar resignFirstResponder];
    
}
//=================================================================================================================
/*
    This method is used to respond to the service request made -> (MovieSearchService)
 
*/
- (void)serviceFinished:(id)service withError:(BOOL)error{
    
    // Exe. the following code if an error has not been detected
    if(!error){
        
        // Remove all current items in the searchResults Array
        [searchResults removeAllObjects];
        
        // Loop through the results and extract the 'title' from the returned results from the service request
        for (NSDictionary *movie in [service results]){
            
            // Create a dictionary to store multiple values for a movie
            NSMutableDictionary *m_info = [[NSMutableDictionary alloc] initWithCapacity:3];
            
            // Store given variables
            [m_info setValue:[movie valueForKey:@"id"] forKey:@"id"];
            [m_info setValue:[movie valueForKey:@"title"] forKey:@"title"];
            [m_info setValue:[movie valueForKey:@"release_date"] forKey:@"release_date"];
            
            // Add movie info to main list
            [searchResults addObject:m_info];
            
        } // End for loop
        
        // If there are no results found
        if ([searchResults count] == 0) {
            [searchResults addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-1", @"No Results Found", @"", nil]
                                         forKeys:[NSArray arrayWithObjects:@"id", @"title", @"release_date", nil]]];
        }
        
        // Refresh and reload table
        [[self tableView] reloadData];
        
        
    } else {
        
        // Remove all objects
        [searchResults removeAllObjects];
        
        // Add new Objects
        
        
        [searchResults addObject: [NSDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:@"-1", @"There has been an Error", @"", nil] forKeys:[NSMutableArray arrayWithObjects:@"id", @"title", @"release_date", nil]]];
        
        // Refresh and reload table
        [[self tableView] reloadData];
    }
}
//=================================================================================================================
#pragma mark - Editing the row data
//=================================================================================================================
// Edit 4 -
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return !searching;
}


// Edit 5 - Responding to the delete request and deletig the bookmarked movie.

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // If row is deleted by user, remove it from the list
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Remove from array
        NSDictionary *movie = [movies objectAtIndex:[indexPath row]];
        
        // Delete Thumbnail if present
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir, [movie valueForKey:@"id"]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if([fileManager fileExistsAtPath:pngFilePath]){
            [fileManager removeItemAtPath:pngFilePath error:nil];
        }
        
        // Remove from list and save changes
        [movies removeObject:movie];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"movies.xml"];
        [movies writeToFile:yourArrayFileName atomically:YES];
        
        // Trigger remove animation on table
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
