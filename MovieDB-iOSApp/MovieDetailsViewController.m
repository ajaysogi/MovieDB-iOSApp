 //
//  MovieDetailsViewController.m
//  MovieDB-iOSApp
//
//  Created by Ajay Sogi on 19/02/2015.
//  Copyright (c) 2015 Ajay Sogi. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "MovieDetailsService.h"
#import "MoviePictureDownloadService.h"

@interface MovieDetailsViewController ()

@end

@implementation MovieDetailsViewController

// Create Acessor methods to the UI features
@synthesize imgFilm;
@synthesize txtFilmText;
@synthesize txtFilmYear;
@synthesize txtOverview;
@synthesize txtProdCompanies;

// Accessor methods for Dictionary that stores all the retrived movie data 
@synthesize movie;

//==================================================================================================================
// This method is called before the navigation controller is animated in to the view. The view controlls contents are updated.
-(void)viewWillAppear:(BOOL)animated{
    
    if([self movie] != nil){
        
        // Set The Nav Pane as the name of the movie
        [self setTitle:[[self movie] valueForKey:@"title"]];
        
        [txtFilmText setText:[[self movie] valueForKey:@"title"]];
        [txtFilmYear setText:[[[self movie] valueForKey:@"release_date"] description]];
        
        // Clear text fields
        [txtOverview setText:@""];
        [txtProdCompanies setText:@""];
        
        // Add content already saved
        [txtOverview setText:[[self movie] valueForKey:@"overview"]];
        [txtProdCompanies setText:[[self movie] valueForKey:@"prodComp"]];
         
        // Service Queue
        serviceQueue = [[NSOperationQueue alloc] init];
        [serviceQueue setMaxConcurrentOperationCount:1];
        
        MovieDetailsService *service = [[MovieDetailsService alloc] init];
        [service setMovieID:[[[self movie] valueForKey:@"id"] description]];
        [service setDelegate:self];
        [serviceQueue addOperation:service];
        
        // If the Movie Data is incomplete
        if(![[[self movie] allKeys] containsObject:@"overview"] &&
           ![[[self movie] allKeys] containsObject:@"prodComp"]){
            
            MovieDetailsService *service = [[MovieDetailsService alloc] init];
            [service setMovieID:[[[self movie] valueForKey:@"id"] description]];
            [service setDelegate:self];
            [serviceQueue addOperation:service];
        }
        
        // Check if the image is downloaded
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir, [[self movie] valueForKey:@"id"]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if([fileManager fileExistsAtPath:pngFilePath]){
            UIImage *pic = [UIImage imageWithData:[NSData dataWithContentsOfFile:pngFilePath]];
            [imgFilm setImage:pic];
        } else{
            MovieDetailsService *service = [[MovieDetailsService alloc] init];
            [service setMovieID:[[[self movie] valueForKey:@"id"] description]];
            [service setDelegate:self];
            [serviceQueue addOperation:service];
        }

        
    }
}
//==================================================================================================================
//
-(void)serviceFinished:(id)service withError:(BOOL)error{
    
    if (!error) {
        
        if ([service class] == [MovieDetailsService class]) {
        NSDictionary *m = [service details];
        
        [[self movie] setValue:[m valueForKey:@"title"] forKey:@"title"];
        [[self movie] setValue:[m valueForKey:@"release_date"] forKey:@"release_date"];
        
        [[self movie] setValue:[m valueForKey:@"overview"] forKey:@"overview"];
    
        
        // Create Production Companies Text
        NSString *prodComp = @"";
        
        for (NSDictionary *productionCompanies in [m valueForKey:@"production_companies"]){
            
            
            NSString *Id = [productionCompanies valueForKey:@"id"];
            
            NSString *Name = [NSString stringWithFormat:@"%@, (%@)", [productionCompanies valueForKey:@"name"], Id];
            
            prodComp = [NSString stringWithFormat:@"%@%@\n", prodComp, Name];
            
        }
        [[self movie]setValue:prodComp forKey:@"prodComp"];
        // ---------------------------------------------------------------------------------------
        // Download and Cache profile pictures
        MoviePictureDownloadService *service = [[MoviePictureDownloadService alloc] init];
        [service setDelegate:self];
        [service setMovieId:[[self movie] valueForKey:@"id"]];
        
        // Create the base URL string to prepare for request to webservice
        NSString *imgRequestPrefix = @"http://image.tmdb.org/t/p/w500";
        NSString *theRequest = [NSString stringWithFormat:@"%@%@", imgRequestPrefix, [m valueForKey:@"poster_path"]];
        
        // Process request
        [service setMoviePictureUrl:theRequest];
        
        // ---------------------------------------------------------------------------------------
        
        [serviceQueue addOperation:service];
        
        // Refresh the UI on the MAIN THREAD
        [self performSelectorOnMainThread:@selector(refreshView) withObject:nil waitUntilDone:YES];
        
        } else {
        [self performSelectorOnMainThread:@selector(refreshView) withObject:nil waitUntilDone:YES];
        }
    }
}
//==================================================================================================================
//
-(void)refreshView{
    
    if([self movie] != nil){
        [txtFilmText setText:[[self movie] valueForKey:@"title"]];
        [txtFilmYear setText:[[[self movie] valueForKey:@"release_date"] description]];
        
        // Add content already saved
        [txtOverview setText:[[[self movie] valueForKey:@"overview"] description]];
        [txtProdCompanies setText:[[self movie] valueForKey:@"prodComp"]];
        
        // Check if image has been downloaded. If true, set the image as display
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir, [[self movie] valueForKey:@"id"]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if([fileManager fileExistsAtPath:pngFilePath]){
            UIImage *pic = [UIImage imageWithData:[NSData dataWithContentsOfFile:pngFilePath]];
            [imgFilm setImage:pic];
        }
        
    }
}
//==================================================================================================================

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // custom initilisation
        [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshMovieDetails)]];
    }
    return self;
}
// This method starts the MovieDetailsService opperation off and once this service has been completed the movie object is updated and the image is redownloaded
- (void)refreshMovieDetails{
    MovieDetailsService *service = [[MovieDetailsService alloc] init];
    [service setMovieID:[[[self movie] valueForKey:@"id"] description]];
    [service setDelegate:self];
    [serviceQueue addOperation:service];
    
    //DEBUG CODE:---------------------
    NSLog(@"Refresh Button Clicked\n");
    //--------------------------------
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
