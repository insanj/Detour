#import <UIKit/UIKit.h>

/*
@interface SBNotificationCenterViewController : XXUnknownSuperclass <SBBulletinViewControllerDelegate, SBSizeObservingViewDelegate, SBNotificationCenterWidgetHost, SBBulletinActionHandler>
- (void)presentGrabberView;
- (CGRect)revealRectForBulletin:(id)bulletin;
- (void)_setContainerFrame:(CGRect)frame;
*/

struct SBGestureContextRef {};
struct XXStruct_XgRpiA {};

@interface SBGestureRecognizer : NSObject
- (BOOL)shouldReceiveTouches;
- (void)touchesBegan:(SBGestureContextRef)began;
- (void)touchesCancelled:(SBGestureContextRef)cancelled;
- (void)touchesEnded:(SBGestureContextRef)ended;
- (void)touchesMoved:(SBGestureContextRef)moved;
@end

@interface SBFluidSlideGestureRecognizer : SBGestureRecognizer 
- (void)updateActiveTouches:(SBGestureContextRef)touches;
- (void)updateForBeganOrMovedTouches:(SBGestureContextRef)beganOrMovedTouches;
- (void)updateForEndedOrCancelledTouches:(SBGestureContextRef)endedOrCancelledTouches;
@end

@interface SBPanGestureRecognizer : SBFluidSlideGestureRecognizer 
- (id)initForVerticalPanning;
- (float)computeIncrementalGestureMotion:(SBGestureContextRef)motion;
- (void)updateForBeganOrMovedTouches:(SBGestureContextRef)beganOrMovedTouches;
@end


@interface SBOffscreenSwipeGestureRecognizer : SBPanGestureRecognizer
- (BOOL)firstTouchQualifies:(const XXStruct_XgRpiA *)qualifies;
- (BOOL)secondTouchQualifies:(const XXStruct_XgRpiA *)qualifies;
@end

// Offender: <SBOffscreenSwipeGestureRecognizer: 0x12d335200; state = Cancelled; type = <Show Notifications>; shouldReceiveTouches = YES>

%hook SBOffscreenSwipeGestureRecognizer

/*
- (void)touchesBegan:(SBGestureContextRef)began {
	SBOffscreenSwipeGestureRecognizer *recognizer = self;
	if ([recognizer.description rangeOfString:@"Show Notifications"].location != NSNotFound) {
		NSLog(@"[Detour] Caught %@ trying to allow Notification Center access, diverting...", recognizer);
		return;
	}

	else {
		NSLog(@"[Detour] %@ is not a threat, allowing passage...", recognizer);
	}
}*/

- (BOOL)firstTouchQualifies:(const XXStruct_XgRpiA *)qualifies {
	if ([self.description rangeOfString:@"Show Notifications"].location != NSNotFound) {
		NSLog(@"[Detour] Caught %@ trying to allow Notification Center access, diverting...", self);
		return NO;
	}

	return %orig();
}

%end
