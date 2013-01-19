//
//  PolygonSprite.m
//  CutCutCut
//
//  Created by demo on 19.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "PolygonSprite.h"


@implementation PolygonSprite

@synthesize body            = body_;
@synthesize original        = original_;
@synthesize centroid        = centroid_;
@synthesize entryPoint      = entryPoint_;
@synthesize exitPoint       = exitPoint_;
@synthesize sliceEntered    = sliceEntered_;
@synthesize sliceExited     = sliceExited_;
@synthesize sliceEntryTime  = sliceEntryTime_;

+(id) spriteWithFile:(NSString*)filename body:(b2Body *)body original:(BOOL)original
{
    return [[[self alloc] initWithFile:filename body:body original:original] autorelease];
}

+(id) spriteWithTexture:(CCTexture2D *)texture body:(b2Body *)body original:(BOOL)original
{
    return [[[self alloc] initWithTexture:texture body:body original:original] autorelease];
}

+(id) spriteWithWorld:(b2World*)world
{
    return [[[self alloc] initWithWorld:world] autorelease];
}

-(id) initWithFile:(NSString *)filename body:(b2Body *)body original:(BOOL)original
{
    CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:filename];
    return [self initWithTexture:texture body:body original:original];
}

-(id) initWithTexture:(CCTexture2D *)texture body:(b2Body *)body original:(BOOL)original
{
    b2Fixture* originalFixture = body->GetFixtureList();
    b2PolygonShape* shape = (b2PolygonShape*)originalFixture->GetShape();
    int vertexCount = shape->GetVertexCount();
    NSMutableArray* points = [NSMutableArray arrayWithCapacity:vertexCount];
    for (int i = 0; i < vertexCount; ++i) {
        CGPoint p = ccp(shape->GetVertex(i).x * PTM_RATIO, shape->GetVertex(i).y * PTM_RATIO);
        [points addObject:[NSValue valueWithCGPoint:p]];
    }
    
    if ((self = [super initWithPoints:points andTexture:texture]))
    {
        body_ = body;
        body->SetUserData(self);
        
        original_ = original;
        
        centroid_ = self.body->GetLocalCenter();
        
        self.anchorPoint = ccp(centroid_.x * PTM_RATIO / texture.contentSize.width,
                               centroid_.y * PTM_RATIO / texture.contentSize.height);
        
        sliceEntered_   = NO;
        sliceExited_    = NO;
        sliceEntryTime_ =0.0;
        entryPoint_.SetZero();
        exitPoint_.SetZero();
    }
    
    return self;
}

-(id) initWithWorld:(b2World*)world
{
    return nil;
}

-(void) setPosition:(CGPoint)position
{
    [super setPosition:position];
    body_->SetTransform(b2Vec2(position.x/PTM_RATIO, position.y/PTM_RATIO), body_->GetAngle());
}

-(b2Body*) createBodyForWorld:(b2World*)world
                     position:(b2Vec2)position
                     rotation:(float)rotation
                     vertices:(b2Vec2*)verticies
                  vertexCount:(int32)count
                      density:(float)density
                     friction:(float)friction
                  restitution:(float)restitution
{
    b2BodyDef bodyDef;
    bodyDef.type    = b2_dynamicBody;
    bodyDef.position= position;
    bodyDef.angle   = rotation;
    
    b2Body* body = world->CreateBody(&bodyDef);
    
    b2FixtureDef fixtureDef;
    fixtureDef.density = density;
    fixtureDef.friction= friction;
    fixtureDef.filter.categoryBits = 0;
    fixtureDef.filter.maskBits     = 0;
    
    b2PolygonShape shape;
    shape.Set(verticies, count);
    fixtureDef.shape = &shape;
    body->CreateFixture(&fixtureDef);
    
    return body;
}

-(void) activateCollisiions
{
    b2Fixture* fixture = body_->GetFixtureList();
    b2Filter filter = fixture->GetFilterData();
    filter.categoryBits = 0x0001;
    filter.maskBits = 0x0001;
    fixture->SetFilterData(filter);
}

-(void) deactivateCollisions
{
    b2Fixture* fixture = body_->GetFixtureList();
    b2Filter filter = fixture->GetFilterData();
    filter.categoryBits = 0;
    filter.maskBits = 0;
    fixture->SetFilterData(filter);
}

-(CGAffineTransform) nodeToParentTransform
{
    b2Vec2 pos = body_->GetPosition();
    
    float x = pos.x * PTM_RATIO;
    float y = pos.y * PTM_RATIO;
    
    if ([self ignoreAnchorPointForPosition]) {
        x += [self anchorPointInPoints].x;
        y += [self anchorPointInPoints].y;
    }
    
    float radians = body_->GetAngle();
    float c = cosf(radians);
    float s = sinf(radians);
    
    if (CGPointEqualToPoint(anchorPointInPoints_, CGPointZero) == NO) {
        x += c * -anchorPointInPoints_.x + -s * -anchorPointInPoints_.y;
        y += s * -anchorPointInPoints_.x +  c * -anchorPointInPoints_.y;
    }
    
    transform_ = CGAffineTransformMake(c, s, -s, c, x, y);
    
    return transform_;
}

@end

