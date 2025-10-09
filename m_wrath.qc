// m_wrath.qc

const float WRATH_BALL_VEL			= 400;


$skin wrthskin

$frame wrthfrme

$frame wrthwk01 wrthwk02 wrthwk03 wrthwk04 wrthwk05 wrthwk06
$frame wrthwk07 wrthwk08 wrthwk09 wrthwk10 wrthwk11 wrthwk12

$frame wrthaa01 wrthaa02 wrthaa03 wrthaa04 wrthaa05 wrthaa06 wrthaa07
$frame wrthaa08 wrthaa09 wrthaa10 wrthaa11 wrthaa12 wrthaa13 wrthaa14

$frame wrthab01 wrthab02 wrthab03 wrthab04 wrthab05 wrthab06 wrthab07
$frame wrthab08 wrthab09 wrthab10 wrthab11 wrthab12 wrthab13

$frame wrthac01 wrthac02 wrthac03 wrthac04 wrthac05
$frame wrthac06 wrthac07 wrthac08 wrthac09 wrthac10 
$frame wrthac11 wrthac12 wrthac13 wrthac14 wrthac15

$frame wrthpa01 wrthpa02 wrthpa03 wrthpa04 wrthpa05 wrthpa06

$frame wrthpb01 wrthpb02 wrthpb03 wrthpb04 wrthpb05 wrthpb06
$frame wrthpb07 wrthpb08 wrthpb09 wrthpb10 wrthpb11

$frame wrthdt01 wrthdt02 wrthdt03 wrthdt04 wrthdt05
$frame wrthdt06 wrthdt07 wrthdt08 wrthdt09 wrthdt10
$frame wrthdt11 wrthdt12 wrthdt13 wrthdt14 wrthdt15

void()	wrath_stand1 =[	$wrthwk01,	wrath_stand1 ] { ai_stand();}

void()	wrath_walk01 =[	$wrthwk01,	wrath_walk02 ] { ai_walk(8); }
void()	wrath_walk02 =[	$wrthwk02,	wrath_walk03 ] { ai_walk(8); }
void()	wrath_walk03 =[	$wrthwk03,	wrath_walk04 ] { ai_walk(8); }
void()	wrath_walk04 =[	$wrthwk04,	wrath_walk05 ] { ai_walk(8); }
void()	wrath_walk05 =[	$wrthwk05,	wrath_walk06 ] { ai_walk(8); }
void()	wrath_walk06 =[	$wrthwk06,	wrath_walk07 ] { ai_walk(8); }
void()	wrath_walk07 =[	$wrthwk07,	wrath_walk08 ] { ai_walk(8); }
void()	wrath_walk08 =[	$wrthwk08,	wrath_walk09 ] { ai_walk(8); }
void()	wrath_walk09 =[	$wrthwk09,	wrath_walk10 ] { ai_walk(8); }
void()	wrath_walk10 =[	$wrthwk10,	wrath_walk11 ] { ai_walk(8); }
void()	wrath_walk11 =[	$wrthwk11,	wrath_walk12 ] { ai_walk(8); }
void()	wrath_walk12 =[	$wrthwk12,	wrath_walk01 ] { ai_walk(8); }

void()	wrath_run01	=[	$wrthwk01,	wrath_run02 ] { ai_run(12); }
void()	wrath_run02	=[	$wrthwk02,	wrath_run03 ] { ai_run(12); }
void()	wrath_run03	=[	$wrthwk03,	wrath_run04 ] { ai_run(12); }
void()	wrath_run04	=[	$wrthwk04,	wrath_run05 ] { ai_run(12); }
void()	wrath_run05	=[	$wrthwk05,	wrath_run06 ] { ai_run(12); }
void()	wrath_run06	=[	$wrthwk06,	wrath_run07 ] { ai_run(12); }
void()	wrath_run07	=[	$wrthwk07,	wrath_run08 ] { ai_run(12); }
void()	wrath_run08	=[	$wrthwk08,	wrath_run09 ] { ai_run(12); }
void()	wrath_run09	=[	$wrthwk09,	wrath_run10 ] { ai_run(12); }
void()	wrath_run10 =[	$wrthwk10,	wrath_run11 ] { ai_run(12); }
void()	wrath_run11 =[	$wrthwk11,	wrath_run12 ] { ai_run(12); }
void()	wrath_run12 =[	$wrthwk12,	wrath_run01 ] { ai_run(12); }

void()	wrath_at_a01 =[	$wrthaa01,	wrath_at_a02 ] {ai_charge(12);}
void()	wrath_at_a02 =[	$wrthaa02,	wrath_at_a03 ] {ai_charge(12);}
void()	wrath_at_a03 =[	$wrthaa03,	wrath_at_a04 ] {ai_charge(12);}
void()	wrath_at_a04 =[	$wrthaa04,	wrath_at_a05 ] {ai_charge(12);}
void()	wrath_at_a05 =[	$wrthaa05,	wrath_at_a06 ] {ai_charge(12);}
void()	wrath_at_a06 =[	$wrthaa06,	wrath_at_a07 ] {ai_charge(12);}
void()	wrath_at_a07 =[	$wrthaa07,	wrath_at_a08 ] {ai_charge(12);}
void()	wrath_at_a08 =[	$wrthaa08,	wrath_at_a09 ] {ai_charge(12);}
void()	wrath_at_a09 =[	$wrthaa09,	wrath_at_a10 ] {ai_charge(12);
	if (skill == 3)
		self.dest = enemy_vispos();
}
void()	wrath_at_a10 =[	$wrthaa10,	wrath_at_a11 ] {ai_charge(12);
	if (skill == 3 && visible(self.enemy))
		self.dest = enemy_vispos();
}
void()	wrath_at_a11 =[	$wrthaa11,	wrath_at_a12 ] {WrathMissile(1);}
void()	wrath_at_a12 =[	$wrthaa12,	wrath_at_a13 ] {ai_charge(12);}
void()	wrath_at_a13 =[	$wrthaa13,	wrath_at_a14 ] {ai_charge(12);}
void()	wrath_at_a14 =[	$wrthaa14,	wrath_run01 ] {ai_charge(12);}

void()	wrath_at_b01 =[	$wrthab01,	wrath_at_b02 ] {ai_charge(12);}
void()	wrath_at_b02 =[	$wrthab02,	wrath_at_b03 ] {ai_charge(12);}
void()	wrath_at_b03 =[	$wrthab03,	wrath_at_b04 ] {ai_charge(12);}
void()	wrath_at_b04 =[	$wrthab04,	wrath_at_b05 ] {ai_charge(12);
	if (skill == 3)
		self.dest = enemy_vispos();
}
void()	wrath_at_b05 =[	$wrthab05,	wrath_at_b06 ] {ai_charge(12);
	if (skill == 3 && visible(self.enemy)) 
		self.dest = enemy_vispos();
}
void()	wrath_at_b06 =[	$wrthab06,	wrath_at_b07 ] {WrathMissile(2);}
void()	wrath_at_b07 =[	$wrthab07,	wrath_at_b08 ] {ai_charge(12);}
void()	wrath_at_b08 =[	$wrthab08,	wrath_at_b09 ] {ai_charge(12);}
void()	wrath_at_b09 =[	$wrthab09,	wrath_at_b10 ] {ai_charge(12);}
void()	wrath_at_b10 =[	$wrthab10,	wrath_at_b11 ] {ai_charge(12);}
void()	wrath_at_b11 =[	$wrthab11,	wrath_at_b12 ] {ai_charge(12);}
void()	wrath_at_b12 =[	$wrthab12,	wrath_at_b13 ] {ai_charge(12);}
void()	wrath_at_b13 =[	$wrthab13,	wrath_run01 ] {ai_charge(12);}

void()	wrath_at_c01 =[	$wrthac01,	wrath_at_c02 ] {ai_charge(12);}
void()	wrath_at_c02 =[	$wrthac02,	wrath_at_c03 ] {ai_charge(12);}
void()	wrath_at_c03 =[	$wrthac03,	wrath_at_c04 ] {ai_charge(12);}
void()	wrath_at_c04 =[	$wrthac04,	wrath_at_c05 ] {ai_charge(12);}
void()	wrath_at_c05 =[	$wrthac05,	wrath_at_c06 ] {ai_charge(12);
	if (skill == 3)
		self.dest = enemy_vispos();
}
void()	wrath_at_c06 =[	$wrthac06,	wrath_at_c07 ] {ai_charge(12);
	if (skill == 3 && visible(self.enemy)) 
		self.dest = enemy_vispos();
}
void()	wrath_at_c07 =[	$wrthac07,	wrath_at_c08 ] {WrathMissile(3);}
void()	wrath_at_c08 =[	$wrthac08,	wrath_at_c09 ] {ai_charge(12);}
void()	wrath_at_c09 =[	$wrthac09,	wrath_at_c10 ] {ai_charge(12);}
void()	wrath_at_c10 =[	$wrthac10,	wrath_at_c11 ] {ai_charge(12);}
void()	wrath_at_c11 =[	$wrthac11,	wrath_at_c12 ] {ai_charge(12);}
void()	wrath_at_c12 =[	$wrthac12,	wrath_at_c13 ] {ai_charge(12);}
void()	wrath_at_c13 =[	$wrthac13,	wrath_at_c14 ] {ai_charge(12);}
void()	wrath_at_c14 =[	$wrthac14,	wrath_at_c15 ] {ai_charge(12);}
void()	wrath_at_c15 =[	$wrthac15,	wrath_run01 ] {ai_charge(12);}

void() wrath_attack = 
{
	local float r;

	r = random();

	if (r < 0.25)
	{
		wrath_at_a01 ();
	}
	else if (r < 0.65)
	{
		wrath_at_b01 ();
	}
	else
	{
		wrath_at_c01 ();
	}
	sound (self, CHAN_VOICE, "wrath/watt.wav", 1, ATTN_NORM);
}

void()	wrath_pn_a01	=[	$wrthpa01,	wrath_pn_a02	] {ai_nop();}
void()	wrath_pn_a02	=[	$wrthpa02,	wrath_pn_a03	] {ai_nop();}
void()	wrath_pn_a03	=[	$wrthpa03,	wrath_pn_a04	] {ai_nop();}
void()	wrath_pn_a04	=[	$wrthpa04,	wrath_pn_a05	] {ai_nop();}
void()	wrath_pn_a05	=[	$wrthpa05,	wrath_pn_a06	] {ai_nop();}
void()	wrath_pn_a06	=[	$wrthpa06,	wrath_run01		] {ai_nop();}

void()	wrath_pn_b01	=[	$wrthpb01,	wrath_pn_b02	] {ai_nop();}
void()	wrath_pn_b02	=[	$wrthpb02,	wrath_pn_b03	] {ai_nop();}
void()	wrath_pn_b03	=[	$wrthpb03,	wrath_pn_b04	] {ai_nop();}
void()	wrath_pn_b04	=[	$wrthpb04,	wrath_pn_b05	] {ai_nop();}
void()	wrath_pn_b05	=[	$wrthpb05,	wrath_pn_b06	] {ai_nop();}
void()	wrath_pn_b06	=[	$wrthpb06,	wrath_pn_b07	] {ai_nop();}
void()	wrath_pn_b07	=[	$wrthpb07,	wrath_pn_b08	] {ai_nop();}
void()	wrath_pn_b08	=[	$wrthpb08,	wrath_pn_b09	] {ai_nop();}
void()	wrath_pn_b09	=[	$wrthpb09,	wrath_pn_b10	] {ai_nop();}
void()	wrath_pn_b10	=[	$wrthpb10,	wrath_pn_b11	] {ai_nop();}
void()	wrath_pn_b11	=[	$wrthpb11,	wrath_run01		] {ai_nop();}


void(entity attacker, float damage) wrath_pain = 
{
	if (self.health <= 0) return;
	if (self.pain_finished > time) return;

	float r;

	r = random();
	
	if (r > 0.1)
	{
		PainFinished(0.5);
		return;
	}
			
	if (r < 0.07)
		wrath_pn_a01 ();
	else 
		wrath_pn_b01 ();

	PainFinished(3);
	sound (self, CHAN_VOICE, "wrath/wpain.wav", 1, ATTN_NORM);
}

void()	wrath_die02 =[ $wrthdt02, wrath_die03 ] 
	{ sound (self, CHAN_VOICE, "wrath/wdthc.wav", 1, ATTN_NORM); }
void()	wrath_die03 =[ $wrthdt03, wrath_die04 ] {}
void()	wrath_die04 =[ $wrthdt04, wrath_die05 ] {}
void()	wrath_die05 =[ $wrthdt05, wrath_die07 ] {}
void()	wrath_die07 =[ $wrthdt07, wrath_die09 ] {}
void()	wrath_die09 =[ $wrthdt09, wrath_die11 ] {}
void()	wrath_die11 =[ $wrthdt11, wrath_die13 ] {}
void()	wrath_die13 =[ $wrthdt13, wrath_die15 ] {}
void()	wrath_die15 =[ $wrthdt15, wrath_die15 ] 
{
	ThrowGib ("progs/wrthgib1.mdl", GibVelocityForHealth(self.health));
	ThrowGib ("progs/wrthgib2.mdl", GibVelocityForHealth(self.health));
	ThrowGib ("progs/wrthgib3.mdl", GibVelocityForHealth(self.health));
	T_RadiusDamage (self, self, 80, world, DMGTYPE_EXPLOSION);

	self.origin = self.origin + '0 0 24';

	BecomeExplosion();
}

/*
================
WrathMissile
================
*/

void() WrathMissileExplode =
{
	T_RadiusDamage (self, self.trueowner, 20, world, DMGTYPE_EXPLOSION);
	//sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

	T_ExplosiveTouch();
}

void() WrathMissileTouch =
{
	if (CheckProjectilePassthru()) return;
	if (other == self.owner)
		return;		// don't explode on owner

	if (other.type == "zombie")
		T_Damage (other, self, self.trueowner, other.health + 25);
	
	WrathMissileExplode();
}

vector(vector targ, float turnrate) WrathTurnToward =
{
	vector	vel, aimdir, temp, temp2, out;

	temp = targ + '0 0 10';
	aimdir = temp - self.origin;
	aimdir = normalize(aimdir);
	vel = normalize(self.velocity);
	
	temp = CrossProduct(vel, aimdir);
	
	// try to flatten the rotation to the horizontal plane unless the difference is extreme
	if (fabs(temp_z) > 0.92)
	{
		temp_z *= 4;
		temp = normalize(temp);
	}
	out = rotateVectorAround(vel, temp, turnrate * SHAL_BALL_THINK_RATE);
	
	// don't turn past the desired direction
	temp2 = CrossProduct(out, aimdir);
	if ((temp * temp2) < 0)
		return aimdir;
	return out;
}

void() WrathHome =
{
	float dist, rate, dot;
	
	if (self.lifetime_finished < time)
	{
		WrathMissileExplode();
		return;
	}		
	if (!alive(self.enemy))
	{
		self.think = WrathMissileExplode;
		self.nextthink = self.lifetime_finished;
		//remove(self);
		return;
	}
	
	self.think = WrathHome;
	self.nextthink = time + SHAL_BALL_THINK_RATE;
	rate = SHAL_BALL_TURN_RATE;
	dot = normalize(self.velocity) * normalize(self.enemy.origin - self.origin);
	
	// reset our owner regularly, or else a wrathball that passes through a notrace-invisible
	// player will become owned by the player and remain nonsolid to them after the ring ends
	self.owner = self.trueowner;
	// if the projectile is inside a notrace entity at this time, it'll touch again this frame
	// and reset anyway, so this state will pingpong until it passes out the other side
	
	// go faster at long distance to close the gap, so snipey wraths have a better presence
	dist = vlen(self.enemy.origin - self.origin);
	dist = saturate( (dist-200) / 600 );
	
	if (skill < 3)
	{
		// 'poor' homing (half turn rate):
		if ( self.owner.health <= 0		// if our papa dies
			|| self.owner.customflags & CFL_PLUNGE	// or falls in a hole
			
			//|| !visible(self.enemy)		// if we lost LOS
			// took ^^ this one out, because it made voreballs even more effective at going
			// around corners, which meant that courageous players had a nice new dodge move
			// but those who tried to fight the vore the old cautious way were punished			
			|| has_invis(self.enemy)			// if target is invis
			|| pointcontents(self.origin) < CONTENT_SOLID ) // if wrathball is underwater
		{
			// wrathballs headed straight at the player when he's hidden should maintain course, to
			// make the dodge possible without it immediately turning to hit him
			if (dot > 0)
			{
				rate *= max(1, 1.5 * (1 - dot));
			}
			self.velocity = WRATH_BALL_VEL * WrathTurnToward(self.enemy.origin, rate * 0.33);
		}
		else // good homing (full turn rate):
		{
			// wrathballs headed straight away from the player don't normally seem to be able to pick a direction to 
			// turn and wobble more or less straight away - amp turn rate in these cases to force a 'decision'
			if (dot < 0)
			{
				rate *= min(1.4, 1.4 + fabs(dot));
			}
			self.velocity = WRATH_BALL_VEL * WrathTurnToward(self.enemy.origin, rate);
		}
		
		self.velocity *= 1 + dist;
		self.velocity += Vector(crandom(),crandom(),crandom()) * 16;
	}
	else
	{
		// nightmare: vanilla-evil homing with corner following to force engagement rather than encourage it
		enemy_vis = visible(self.enemy);
		if (enemy_vis)	// go straight to follow player around corners
		{
			// remember last seen position for corner hax
			self.dest = self.enemy.origin;
		}
		
		// poor homing
		if ( self.owner.health <= 0	 || self.owner.customflags & CFL_PLUNGE
			|| pointcontents(self.origin) < CONTENT_SOLID )
		{
			if (dot > 0)
			{
				rate *= max(1, 1.5 * (1 - dot));
			}
			self.velocity = WRATH_BALL_VEL * WrathTurnToward(self.dest, rate * 0.5);
		}
		else // evile homing
		{
			self.velocity = WRATH_BALL_VEL * normalize(self.dest + '0 0 10' - self.origin);
		}
		
		self.velocity *= 1 + dist;
		self.velocity += Vector(crandom(),crandom(),crandom()) * 16;
	}

	self.oldvelocity = self.velocity;	
}


void(float AttackNumber) WrathMissile =
{
	entity 	missile;
	vector	dir, worg;

	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors(self.angles);
	
	dir = (enemy_vispos() + '0 0 10') - self.origin + enemy_aim_vertical();
	dir = normalize(dir);
	
	// if player has strafed around behind, don't lob the missile out of our ass
	if (angledif(self.ideal_yaw, self.angles_y) > 80)
	{
		dir_x = v_forward_x;
		dir_y = v_forward_y;
		dir = normalize(dir);
	}

	if ( AttackNumber == 1)
	{
		worg = self.origin + v_forward*20 + v_up*12;
	}
	else if ( AttackNumber == 2)
	{
		worg = self.origin + v_forward*18 + v_up*10;
	}
	else if ( AttackNumber == 3)
	{
		worg = self.origin + v_forward*12 + v_up*12 + v_right*20;
	}
	
	missile = launch_projectile(worg, dir * WRATH_BALL_VEL, "wrathball");

	SUB_ChangeModel (missile, "progs/w_ball.mdl");

	missile.avelocity = '300 300 300';
	missile.nextthink = time + 0.1;
	missile.think = WrathHome;
	missile.enemy = self.enemy;
	missile.touch = WrathMissileTouch;
	missile.lifetime_finished = time + 30;	 // blow up after a while
	if (skill == 3) missile.dest = self.dest;
}



//========
void() monster_wrath_spawn =
{
	self.classname = "monster_wrath";
	self.type = "wrathkin";
	self.noselfbomb = 1;
		
	self.solid = SOLID_SLIDEBOX;
	//self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/wrath.mdl");

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	if (!self.health)
	self.health = 400;
	self.yaw_speed = 35;

	self.th_stand = wrath_stand1;
	self.th_walk = wrath_walk01;
	self.th_run = wrath_run01;
	self.th_missile = wrath_attack;
	self.th_pain = wrath_pain;
	self.th_die = wrath_die02;
	self.th_checkattack = CheckAttack;

	if (self.deathtype == string_null)
		self.deathtype = "was disintegrated by a Wrath";

	self.height = zeroconvertdefault(self.height, 35);
	self.jump_flag = self.height;	// remember original value for short term nav tweaking
	flymonster_start();
}

void() monster_wrath_spawner = {mon_spawner_use(monster_wrath_spawn);}

/*QUAKED monster_wrath (1 0 0) (-16 -16 -24) (16 16 40) AMBUSH ? ? ? TRIGGERED NOTFOG NOTELEFRAG INSTAWAKE
Wrath, 400 health points.

Flags:
"ambush" only wake up on seeing the player, not another monster getting angry

"Triggered"	will not spawn until triggered - triggering again will wake him up. Set 'count' to make this a multi-use spawner.
"NoTfog" 	supress teleport glitter when spawned with 'triggered'
"NoTelefrag" will silently fail to spawn if doing so would telefrag an existing monster. will try again automatically 2x/second until it succeeds.
"Instawake" spawn angry at activator

Keys:
"health" adjusted health amount
"target" entity to trigger when killed
"targetname" entity name
"no_infight" if set to 1 (or higher), this individual won't infight ever (doesn't provoke and isn't provoked)
*/
/*FGD
@PointClass base(Monster) size(-16 -16 -24, 16 16 40) model({ "path": ":progs/wrath.mdl" }) = monster_wrath : "Wrath

Default health = 400"
[
health(integer) : "Custom health amount"
]
*/
void() monster_wrath =
{
	if (!SUB_ShouldSpawn()) return;
	if (nomonster()) return;
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/wrath.mdl");
	precache_model ("progs/w_ball.mdl");
	precache_model ("progs/wrthgib1.mdl");
	precache_model ("progs/wrthgib2.mdl");
	precache_model ("progs/wrthgib3.mdl");

	precache_sound ("wrath/wsee.wav");
	precache_sound ("wrath/watt.wav");
	precache_sound ("wrath/wpain.wav");
	precache_sound ("wrath/wdthc.wav");

	if (!self.health)
	self.health = 400;
	//setsize (self, '-16 -16 -24', '16 16 40');
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	if ( monster_spawnsetup( monster_wrath_spawner ) ) return;
	
	addmonster(1);
	monster_wrath_spawn();
}
