#import "RayCastCallback.h"

RaycastCallback::RaycastCallback()
{
}

float RaycastCallback::ReportFixture(b2Fixture *fixture, const b2Vec2 &point, const b2Vec2 &normal, float fraction)
{
    PolygonSprite* ps = (PolygonSprite*)fixture->GetBody()->GetUserData();
    if (ps.sliceEntered == NO) {
        ps.sliceEntered = YES;
        
        // you need to get the point coordinates within the shape
        ps.entryPoint = ps.body->GetLocalPoint(point);
        
        ps.sliceEntryTime = CACurrentMediaTime() + 1;
        
        CCLOG(@"Slice Entered at world coordinates:(%f, %f), polygon coordinates:(%f, %f)",
              point.x * PTM_RATIO,
              point.y * PTM_RATIO,
              ps.entryPoint.x * PTM_RATIO,
              ps.entryPoint.y * PTM_RATIO);
    }
    else if (ps.sliceExited == NO) {
        ps.exitPoint = ps.body->GetLocalPoint(point);
        ps.sliceExited = YES;
        
        CCLOG(@"Slice Entered at world coordinates:(%f, %f), polygon coordinates:(%f, %f)",
              point.x * PTM_RATIO,
              point.y * PTM_RATIO,
              ps.exitPoint.x * PTM_RATIO,
              ps.exitPoint.y * PTM_RATIO);
    }
    
    return 1;
}