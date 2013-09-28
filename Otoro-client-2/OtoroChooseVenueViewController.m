//
//  OtoroChooseVenueViewController.m
//  Otoro-client-2
//
//  Created by Jono on 9/7/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "OtoroChooseVenueViewController.h"

@interface OtoroChooseVenueViewController ()

@property (weak, nonatomic) IBOutlet UITableView *placesTableView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) NSURLConnection *foursquareConnection;
@property (strong, nonatomic) NSMutableData *foursquareResponseData;
@property (strong, nonatomic) NSArray *placesArray;
@property (strong, nonatomic) CLLocation *location;

@end

@implementation OtoroChooseVenueViewController
- (instancetype)initWithDelegate:(id<OtoroChooseVenueViewControllerDelegate>)delegate location:(CLLocation *)location
{
    self = [super init];
    if (self) {
		_delegate = delegate;
        _location = location;
		
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:105.0/255.0 green:190.0/255.0 blue:232.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	[self getNearbyPlaces];
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"appear");

}

-(void)viewDidDisappear:(BOOL)animated {
    NSLog(@"disappear");

}

#pragma mark - Private

- (void)chooseStringAsVenue:(NSString *)name
{
	OVenue *venue = [[OVenue alloc] init];
	venue.name = name;
	venue.coordinate = self.location.coordinate;
	[self.delegate otoroChooseVenueViewController:self didChooseVenue:venue];
}


- (void)chooseVenueFromPlaceInfo:(NSDictionary *)placeInfo {
	OVenue *venue = [[OVenue alloc] init];
	
	venue.venueID = placeInfo[@"id"];
	
	venue.name = [placeInfo objectForKey:@"name"];
	
	if ([[placeInfo objectForKey:@"location"] objectForKey:@"lat"]) {
		venue.coordinate = CLLocationCoordinate2DMake([[[placeInfo objectForKey:@"location"] objectForKey:@"lat"] floatValue], [[[placeInfo objectForKey:@"location"] objectForKey:@"lng"] floatValue]);
	} else {
		venue.coordinate = self.location.coordinate;
	}
	
	if ([[placeInfo objectForKey:@"location"] objectForKey:@"city"]) {
		venue.cityName = [[placeInfo objectForKey:@"location"] objectForKey:@"city"];
	}
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	[self.delegate otoroChooseVenueViewController:self didChooseVenue:venue];
}

- (void)getNearbyPlaces {
	if (self.location) {
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"https://api.foursquare.com/v2/venues/search?ll=%f,%f&radius=%d&client_id=%@&client_secret=%@&v=%@&limit=50", self.location.coordinate.latitude, self.location.coordinate.longitude, 500, @"KS5CABGDWPZGFOZMT2CP2TYWNOTK2XX42ZUVFWUROXB0EVHB", @"QRH0W4C1RERZDVEQ1F2DCJMMC0ENEEXXK3DLDL1LS3CXTGTM", @"20120601"]];
		NSURLRequest *request = [NSURLRequest requestWithURL:url
												 cachePolicy:NSURLRequestUseProtocolCachePolicy
											 timeoutInterval:30.0];
		
		self.foursquareConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		self.foursquareResponseData = [NSMutableData data];
		
		self.placesArray = [NSArray array];
		self.placesTableView.hidden = YES;
		self.statusLabel.text = @"Loading...";
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.foursquareResponseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSError *error;
	NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:self.foursquareResponseData options:0 error:&error];
	
	if ([[[dataDict objectForKey:@"meta"] objectForKey:@"code"] integerValue] != 200) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh oh" message:@"Something went wrong trying to get a list of places. Try again later or let us know at feedback@glassmap.com." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
		[alert show];
	} else {
		self.placesArray = [NSArray arrayWithArray:[[dataDict objectForKey:@"response"] objectForKey:@"venues"]];
	}
	
	self.foursquareResponseData = nil;
	self.foursquareConnection = nil;
				
	self.statusLabel.text = @"";
	self.placesTableView.hidden = NO;
	[self.placesTableView reloadData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh oh" message:@"Something went wrong trying to get a list of nearby places. Try again later or let us know at feedback@glassmap.com." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
	[alert show];

	self.foursquareResponseData = nil;
	self.foursquareConnection = nil;
	
	self.statusLabel.text = @"Something went wrong, try again later.";
	self.placesTableView.hidden = YES;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < self.placesArray.count) {
		NSDictionary *placeInfo = [self.placesArray objectAtIndex:indexPath.row];
		
		[self chooseVenueFromPlaceInfo:placeInfo];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
	return NO;
}

- (NSString *)stringOfDistance:(CLLocationDistance)distance {
	if (distance < 10) {
		return @"5 meters";
	}
	if (distance < 100) {
		int rounded = 10 * (int)(distance / 10);
		return [NSString stringWithFormat:@"%i meters", rounded];
	}
	if (distance < 1600) {
		int rounded = 100 * (int)(distance / 100);
		return [NSString stringWithFormat:@"%i meters", rounded];
	}
	if (distance < 2 * 1609) {
		return @"1 mile";
	}
	else {
		int rounded = (int)(distance / 1609);
		return [NSString stringWithFormat:@"%i miles", rounded];
	}
}


- (void)fillCell:(UITableViewCell *)cell withPlaceInfo:(NSDictionary *)placeInfo {
	cell.textLabel.text = [placeInfo objectForKey:@"name"];
	
	NSNumber *distance = [[placeInfo objectForKey:@"location"] objectForKey:@"distance"];
	NSString *distanceString = nil;
	if (distance) {
		distanceString = [self stringOfDistance:[distance floatValue]];
	}
	
	NSString *prefixString = nil;
	if ([[placeInfo objectForKey:@"categories"] count] > 0 ) {
		prefixString = [[[placeInfo objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"name"];
	} else if ([[placeInfo objectForKey:@"location"] objectForKey:@"address"]) {
		prefixString = [[placeInfo objectForKey:@"location"] objectForKey:@"address"];
	}
	
	if (prefixString && distanceString) {
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", prefixString, distanceString];
	} else if (prefixString) {
		cell.detailTextLabel.text = prefixString;
	} else if (distanceString) {
		cell.detailTextLabel.text = distanceString;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0){
		if (indexPath.row < self.placesArray.count) {
			// look for name, location['distance'], location['lat'], location['lng'], location['categories'][0]['name'] or location['address'] (only name is guaranteed)
			
			NSString *cellIdentifier = @"ChooseVenueCellIdentifier";
			
			UITableViewCell	*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
			}
			NSDictionary *placeInfo = [self.placesArray objectAtIndex:indexPath.row];
			[self fillCell:cell withPlaceInfo:placeInfo];
			
			return cell;
		} else if (indexPath.row == self.placesArray.count) {
			NSString *cellIdentifier = @"ChooseVenueFoursquareCreditCellIdentifier";
			UITableViewCell	*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				
				cell.backgroundColor = [UIColor clearColor];
				
				UIImageView *foursquare = [[UIImageView alloc] initWithFrame:CGRectMake((cell.frame.size.width - 230)/2, (cell.frame.size.height - 30)/2, 230, 30)];
				foursquare.image = [UIImage imageNamed:@"poweredByFoursquare.png"];
				foursquare.userInteractionEnabled = YES;
				[cell addSubview:foursquare];
			}
			return cell;
		}
	}
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		return self.placesArray.count + 1;
}


@end

