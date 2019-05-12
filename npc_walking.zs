/* SUGGESTED VALUES

Random rate: 120
Halt Rate: 64
Step Speed: 1

Args <d3>: 40



*/

npc script walking
{
	int comboT(npc T)
	{
		return (Graphics->GetPixel(bitmaps.overscan_type,scroll.xPos+T->X + (T->TileWidth*0.5), scroll.yPos+T->Y+56+(T->TileHeight*0.5)) * 10000);
	}
	void run(bool constantwalk, bool ignoreSlowWalk, int haltFrames) //.d0, the cooldown time between moves
	{
		const int HALT_FRAMES = 32;
		haltFrames = ( haltFrames > 0 ) ? haltFrames : HALT_FRAMES;
		int f;
		this->Dir = Rand(4); 
		int dirclk = this->Rate;
		
		int curx, cury, stuckclk; //used to check if we are stuck.
		curx = this->X; cury = this->Y; 
		
		int randomclk = this->Rate;
		int haltclk = this->Haltrate;
		int curstep = this->Step;
		
		while(this->isValid())
		{
			++f;
			//logic
			if (comboT(this) == CT_SLOWWALK && !ignoreSlowWalk)
			{
				curstep = ( (f&1) ) ? curstep : 0;
			}
			else curstep = this->Step;
			//move
			//halt for a bit if not constantwalk
			//check if it is time to change direction
			//if it is, then we do a coinflip. heads, change, tails, do not change, reset the clk (random)
			
			if ( randomclk > 0 ) 
			{
				--randomclk;
			}
			else
			{
				//change direction.
				this->Dir = Rand(4);
				randomclk = this->Rate;
			}
			if ( haltclk > 0 ) 
			{
				--haltclk;
				//LogPrint("NPC Can Walk? %s \n", (npcs::canWalk(this, curstep, this->Dir)) ? "true" : "false!");
				if (npcs::canWalk(this, curstep, this->Dir))
				{
					switch(this->Dir)
					{
						case DIR_UP: this->Y -= curstep; break;
						case DIR_DOWN: this->Y += curstep; break;
						case DIR_LEFT: this->X -= curstep; break;
						case DIR_RIGHT: this->X += curstep; break;
					}
				}
				else //change dir
				{
					//LogPrint("npc %d could not move \n", <int>this);
					int validDirs[3];
					switch(this->Dir)
					{
						case DIR_UP:
						{
							validDirs[0] = DIR_DOWN;
							validDirs[1] = DIR_LEFT;
							validDirs[2] = DIR_RIGHT;
							break;
						}
						case DIR_LEFT:
						{
							validDirs[0] = DIR_DOWN;
							validDirs[1] = DIR_UP;
							validDirs[2] = DIR_RIGHT;
							break;
						}
						case DIR_DOWN:
						{
							validDirs[0] = DIR_LEFT;
							validDirs[1] = DIR_UP;
							validDirs[2] = DIR_RIGHT;
							break;
						}
						case DIR_RIGHT:
						{
							validDirs[0] = DIR_LEFT;
							validDirs[1] = DIR_UP;
							validDirs[2] = DIR_DOWN;
							break;
						}
						default: break;
					}
					//change direction
					this->Dir = validDirs[Rand(3)];
				}
				
			}
			else
			{
				int halfwaypoint = haltFrames*0.5;
				for ( int q = 0; q < haltFrames; ++q ) 
				{
					if ( q == halfwaypoint ) this->Attack();
					Waitframe();
				}
				haltclk = this->Haltrate;
			}
			Waitframe();
		}
	}
}