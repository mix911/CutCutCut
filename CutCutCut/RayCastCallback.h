//
//  RayCastCallback.h
//  CutCutCut
//
//  Created by demo on 19.01.13.
//
//

#ifndef CutCutCut_RayCastCallback_h
#define CutCutCut_RayCastCallback_h

#import "Box2D.h"
#import "PolygonSprite.h"

class RaycastCallback : public b2RayCastCallback
{
public:
    RaycastCallback();
    virtual float ReportFixture(b2Fixture* fixture, const b2Vec2& point, const b2Vec2& normal, float fraction);
};

#endif
