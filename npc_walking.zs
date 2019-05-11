npc script walking
{
	/*Attributes
	[20] Small Walk Step Amount
	[21] Big Walk Step Amount
	[22] Minimum Time between Moves
	[23] Maximum Time Between Moves
	[24] Maximum Time Between Changing Dir
	[25] Maximum Time Between Chaning Dir
	
	
	*/
	int comboT(npc T)
	{
		return (Graphics->GetPixel(bitmaps.overscan_type,scroll.xPos+T->X + (T->TileWidth*0.5), scroll.yPos+T->Y+56+(T->TileHeight*0.5)) * 10000);
	}
	void run(bool constantwalk) //.d0, the cooldown time between moves
	{
		if ( constantwalk ) this->InitD[0] = 0;
		int steps[2] = { this->Attributes[20], this->Attributes[21] };
		int f; int q; int clk = ( Rand(this->Attributes[22], this->Attributes[23]) );
		this->Dir = Rand(4); bool newdir; int curstep; bool slowwalk; int cooldown = this->Haltrate;
		int dirclk = Rand(this->Attributes[24], this->Attributes[25]);
		while(this->isValid())
		{
			if ( !dirclk )
			{
				int olddir = this->Dir;
				//change direction
				do 
				{
					this->Dir = Rand(4);
				} until(this->Dir != olddir );
				newdir = false;
				
			}
			else 
			{
				--dirclk;
			}
			if ( cooldown )
			{
				--cooldown;
				Waitframe();
				continue;
			}
			else
			{
				cooldown = this->Haltrate;
				
				if ( clk )
				{
					slowwalk = comboT(this);
					curstep = ( (slowwalk) ? ( (f&1) ? steps[1] : 0 ) : ( ( (f&1) ? steps[0] : steps[1]) ) ); //if it is a slow walk tile, reduce the step by half.
					( (f&1) ? steps[0] : steps[1] ); //slow, fast
					switch(this->Dir)
					{
						case DIR_UP:
						{
							for ( q = 0; q < curstep; ++q )
							{
								if (!(Graphics->GetPixel(bitmaps.overscan_solid,scroll.xPos+this->X+(this->TileWidth*0.5), 
									scroll.yPos+this->Y + 56 - 1) ) )
								{
									this->Y -= ((!curstep) ? 0 : 1);
									
									
								}
								else //complete move in another direction
								{
									int olddir = this->Dir;
									
									do 
									{
										this->Dir = Rand(4);
									} until(this->Dir != olddir );
									
								}
							}

							
							break;
						}
						case DIR_DOWN:
						{
							for ( q = 0; q < curstep; ++q )
							{
								if (!(Graphics->GetPixel(bitmaps.overscan_solid,scroll.xPos+this->X+(this->TileWidth/2), 
									//16+scroll.yPos+this->Y+56 + 1)))
									16+scroll.yPos+this->Y + 1)))
								{
									this->Y += ((!curstep) ? 0 : 1);
									
									
								}
								else 
								{
									int olddir = this->Dir;
									
									do 
									{
										this->Dir = Rand(4);
									} until(this->Dir != olddir );
									
								}
							}
							
							break;
						}
						case DIR_LEFT:
						{
							for ( q = 0; q < curstep; ++q )
							{
								if(!(Graphics->GetPixel(bitmaps.overscan_solid,scroll.xPos+this->X-1, 
									scroll.yPos+this->Y+56+(this->TileHeight/2)) ) )


								{
									this->X -= ((!curstep) ? 0 : 1);
									
									
								}
								else 
								{
									int olddir = this->Dir;
									
									do 
									{
										this->Dir = Rand(4);
									} until(this->Dir != olddir );
									
								}
							}
							
							break;
						}
						case DIR_RIGHT:
						{
							for ( q = 0; q < curstep; ++q )
							{
								if(!(Graphics->GetPixel(bitmaps.overscan_solid,scroll.xPos+this->X+16+1, 
									scroll.yPos+this->Y+56+(this->TileHeight*0.5)) ) )


								{
									this->X += ((!curstep) ? 0 : 1);
									
									
								}
								else 
								{
									int olddir = this->Dir;
									
									do 
									{
										this->Dir = Rand(4);
									} until(this->Dir != olddir );
									
								}
							}
							
							break;
						}
						default: break;
					}//completed its move
					--clk;
				}
				else 
				{
					//Repeat(this->Haltrate) Waitframe();
					
					clk = ( Rand(this->Attributes[22], this->Attributes[23]) );
					
					
				}
			}
			Waitframe();
		}
	}
}