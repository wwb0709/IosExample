IosExample
==========
Iosexample
IosProject
sddsf

sdfsf



TTTQuadrantControl *quadrantControl = [[[TTTQuadrantControl alloc] initWithFrame:CGRectMake(10, 20, 300, 90)] autorelease];
quadrantControl.delegate = self;
[quadrantControl setNumber:[NSNumber numberWithInt:127]
                   caption:@"following"
                    action:@selector(didSelectFollowingQuadrant)
               forLocation:TopLeftLocation];

[quadrantControl setNumber:[NSNumber numberWithInt:1728]
                   caption:@"tweets"
                    action:@selector(didSelectTweetsQuadrant)
               forLocation:TopRightLocation];

[quadrantControl setNumber:[NSNumber numberWithInt:352]
                   caption:@"followers"
                    action:@selector(didSelectFollowersQuadrant)
               forLocation:BottomLeftLocation];

[quadrantControl setNumber:[NSNumber numberWithInt:61]
                   caption:@"favorites"
                    action:@selector(didSelectFavoritesQuadrant)
               forLocation:BottomRightLocation];