#import <UIKit/UIKit.h>
#ifdef DEBUG
	#define DRLog(fmt, ...) NSLog((@"[Detour] %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
	#define DRLog(fmt, ...) 
#endif

struct SBGestureContextRef {};
struct XXStruct_XgRpiA {};

@interface SBGestureRecognizer : NSObject
@property(assign, nonatomic) unsigned types;

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

%hook SBOffscreenSwipeGestureRecognizer

// Offender: <SBOffscreenSwipeGestureRecognizer: 0x12d335200; state = Cancelled; type = <Show Notifications>; shouldReceiveTouches = YES>
- (BOOL)firstTouchQualifies:(const XXStruct_XgRpiA *)qualifies {
	if (self.types & 1 << 3) { // Thanks for the tip, @a1anyip!
		DRLog(@"[Detour] Caught %@ trying to allow Notification Center access, diverting...", self);
		return NO;
	}

	return %orig();
}

%end
