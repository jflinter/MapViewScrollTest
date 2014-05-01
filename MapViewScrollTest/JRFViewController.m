//
//  JRFViewController.m
//  MapViewScrollTest
//
//  Created by Jack Flintermann on 11/20/13.
//  Copyright (c) 2013 Jack Flintermann. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <BDDROneFingerZoomGestureRecognizer/BDDROneFingerZoomGestureRecognizer.h>
#import "JRFViewController.h"

@interface JRFViewController ()<MKMapViewDelegate, UIGestureRecognizerDelegate>
@property(nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic) BDDROneFingerZoomGestureRecognizer *recognizer;
@property(nonatomic) MKCoordinateRegion lastRegion;
@end

@implementation JRFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.recognizer = [[BDDROneFingerZoomGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerZoomed:)];
    self.recognizer.scaleFactor = 5.0f;
    self.recognizer.delegate = self;
    [self resetScale];
    [self.mapView addGestureRecognizer:self.recognizer];
}

- (void) resetScale {
    self.recognizer.scale = 1.0f;
    self.lastRegion = self.mapView.region;
}

- (void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    UIGestureRecognizerState state = self.recognizer.state;
    if (state != UIGestureRecognizerStateBegan && state != UIGestureRecognizerStateChanged && state != UIGestureRecognizerStateEnded) {
        [self resetScale];
    }
}

- (void) oneFingerZoomed:(BDDROneFingerZoomGestureRecognizer *)recognizer {
    MKCoordinateSpan span = MKCoordinateSpanMake(self.lastRegion.span.latitudeDelta * recognizer.scale, self.lastRegion.span.longitudeDelta * recognizer.scale);
    self.mapView.region = MKCoordinateRegionMake(self.lastRegion.center, span);
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
