#import "RayCastCallback.h"

#define collinear(x1, y1, x2, y2, x3, y3) fabsf((y1 - y2) * (x1 - x3) - (y1 - y3) * (x1 - x2))

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
        
        b2Vec2 entrySide = ps.entryPoint - ps.centroid;
        b2Vec2 exitSide  = ps.exitPoint - ps.centroid;
        
        if (entrySide.x * exitSide.x < 0 || entrySide.y * exitSide.y < 0) {
            ps.sliceExited = YES;
        } else {
            // If the cut didn't cross the centroid, you check if the entry and exit point lie on the same line
            b2Fixture* fixture = ps.body->GetFixtureList();
            b2PolygonShape* polygon = (b2PolygonShape*)fixture->GetShape();
            int count = polygon->GetVertexCount();
            
            BOOL onSameLine = NO;
            for (int i = 0; i < count; ++i) {
                b2Vec2 pointA = polygon->GetVertex(i);
                b2Vec2 pointB;
                
                if (i == count -1) {
                    pointB = polygon->GetVertex(0);
                } else {
                    pointB = polygon->GetVertex(i+1);
                }
                
                float collinear = collinear(pointA.x, pointA.y, ps.entryPoint.x, ps.entryPoint.y, pointB.x, pointB.y);
                if (collinear <= 0.00001f) {
                    float collinear = collinear(pointA.x, pointA.y, ps.exitPoint.x, ps.exitPoint.y, pointB.x, pointB.y);
                    if (collinear <= 0.00001f) {
                        onSameLine = YES;
                    }
                }
            }
            
            if (onSameLine) {
                ps.entryPoint       = ps.exitPoint;
                ps.sliceEntryTime   = CACurrentMediaTime();
                ps.sliceExited      = NO;
            }
            else {
                ps.sliceExited = YES;
            }
        }
        
        CCLOG(@"Slice Entered at world coordinates:(%f, %f), polygon coordinates:(%f, %f)",
              point.x * PTM_RATIO,
              point.y * PTM_RATIO,
              ps.exitPoint.x * PTM_RATIO,
              ps.exitPoint.y * PTM_RATIO);
    }
    
    return 1;
}