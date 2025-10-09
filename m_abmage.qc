// Aberrant Mage

$cd /progs/ab_mage
$origin 0 0 24
$base base
$skin skin

$frame float1 float2 float3 float4 float5 float6 float7

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11 attack12 attack13 attack14 attack15

$frame attackb1 attackb2 attackb3 attackb4 attackb5 attackb6 attackb7

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9
$frame death10 death11 death12 death13 death14 death15 death16 death17

$frame decap1 decap2 decap3 decap4 decap5 decap6 decap7 decap8 decap9
$frame decap10 decap11 decap12 decap13 decap14 decap15 decap16 decap17


//==========================================================================

float() EntryPoint_Mage = {return EntryPoint_Randomize_Ex (400, 200, '360 360 0');}

void(float chance) abmage_teleport =
{
    local entity    theDest;
    local vector    org, delta;

	// more likely if the enemy is dangerously close
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) < 300)
		chance = chance + 0.1;

    if (random() > chance)
        return;

	// dynamic teleportation from Drake
	if (self.enemy)
		theDest = self.enemy;
	else
		theDest = self;
	org = self.origin;
	if (EntryPoint_Spawn (self, theDest, theDest.origin, EntryPoint_Mage))
	{
		spawn_tfog (org);
		spawn_tfog (self.origin);
	}
}


float() MageCheckAttack =
{
	local float		chance;

	if (!CheckClearAttack()) return FALSE;

	if (time < self.attack_finished) return FALSE;

	// always melee immediately when close enough
	if (enemy_range == RANGE_MELEE  && z_overlap(self.enemy))
	{
		self.attack_state = AS_MELEE;
		ai_attack_finished (1 + random());
		return TRUE;
	}
	
	if (enemy_range >= RANGE_FAR) return FALSE;
	
	if (enemy_range == RANGE_MELEE)
		chance = 0.9;
	if (enemy_range == RANGE_NEAR)
		chance = 0.5;
	else if (enemy_range == RANGE_MID)
		chance = 0.1;
	else if (enemy_range >= RANGE_FAR)
		chance = 0;

	if (self.goalentity.classname == "path_angry" && !(self.flags & (FL_FLY|FL_SWIM))) chance = chance * 0.2;

	if (random() < chance)
	{
		self.attack_state = AS_MISSILE;
		ai_attack_finished (1 + random());
		return TRUE;
	}

	return FALSE;
}


vector(float left) AbMageHand =
{
    makevectors (self.angles);
    if (left)   // TRUE = use left hand, FALSE = use right hand.
        return (self.origin + v_forward*16 - v_right*10 + v_up*30);
    return (self.origin - v_forward*16 + v_right*12 + v_up*45);
}


/*
================
Trio of Magic Missiles
================
*/
void() AbMageHome =
{
	float dist, rate, dot;
	
	if (self.lifetime_finished < time)
	{
		remove(self);
		return;
	}
	if (!alive(self.enemy))
	{
		remove(self);
		return;
	}
	
	self.think = AbMageHome;
	self.nextthink = time + SHAL_BALL_THINK_RATE;
	rate = SHAL_BALL_TURN_RATE;
	dot = normalize(self.velocity) * normalize(self.enemy.origin - self.origin);
	
	self.owner = self.trueowner;
	
	// go faster at long distance to close the gap, so snipey mages have a better presence
	dist = vlen(self.enemy.origin - self.origin);
	dist = saturate( (dist-200) / 600 );
	
	// Aberrant Mages' missiles have poor homing, though they move faster on Nightmare
	if (skill < 3)
	{
		if (dot > 0)
		{
			rate *= max(1, 1.5 * (1 - dot));
		}
		self.velocity = 600 * WrathTurnToward(self.enemy.origin, rate * 0.5);
	}
	else
	{
		if (dot > 0)
		{
			rate *= max(1, 1.5 * (1 - dot));
		}
		self.velocity = 700 * WrathTurnToward(self.enemy.origin, rate * 0.5);
	}
		
	self.velocity *= 1 + dist;
	self.velocity += Vector(crandom(),crandom(),crandom()) * 16;
	self.oldvelocity = self.velocity;	
}


void(float ofs, vector org) AbMageMissile =
{
	entity 	missile;
	vector	dir;

	makevectors(self.angles);
	
	dir = enemy_vispos() - self.origin + enemy_aim_vertical();
	dir = normalize(dir);
	
	// if player has strafed around behind, don't lob the missile out of our ass
	if (angledif(self.ideal_yaw, self.angles_y) > 80)
	{
		dir_x = v_forward_x;
		dir_y = v_forward_y;
		dir = normalize(dir);
	}

	org = org + v_right*ofs;
	
	if (skill == 3)
	{
		missile = launch_projectile(org, dir * 700, "knightspike");
		missile.dmg = 16 + 4 * random();
	}
	else
	{
		missile = launch_projectile(org, dir * 600, "knightspike");
		missile.dmg = 10 + 2 * random();
	}
	
	SUB_ChangeModel (missile, "progs/dd_spike.mdl");
	missile.nextthink = time + 0.1;
	missile.think = AbMageHome;
	missile.enemy = self.enemy;
	missile.touch = spike_touch;
	missile.lifetime_finished = time + 30;	 // end existence after a while
}


void() ThreeMissiles =
{
    local   vector  p1;

    p1 = AbMageHand (TRUE);
    self.effects = self.effects | EF_MUZZLEFLASH;
// Three shots, one per finger.  Left, center, and right.
    AbMageMissile(-3,p1); AbMageMissile(0.5,p1); AbMageMissile(3,p1);

	sound (self, CHAN_WEAPON, "hknight/attack1.wav", 1, ATTN_NORM);
}


/*
================
Explosive Lavaball
================
*/
void() abmage_lavaball_touch =
{
	if (other == self.owner) return;		// don't explode on owner
	if (CheckProjectilePassthru()) return;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	if (other.type == "zombie")
		T_Damage (other, self, self.trueowner, other.health + 25);

	if (skill == 3)
		T_RadiusDamage (self, self.trueowner, 60, world, DMGTYPE_EXPLOSION);
	else
		T_RadiusDamage (self, self.trueowner, 40, world, DMGTYPE_EXPLOSION);

	self.origin = self.origin - 8*normalize(self.velocity);
	T_ExplosiveTouch();
}


void() AbMageLavaball =
{
	vector org, vec;
	entity missile2;

	org = self.origin + v_forward*16 + v_right*12 + v_up*45;
	vec = normalize(enemy_vispos() - org + enemy_aim_vertical());

	makevectors(self.angles);
	if (angledif(self.ideal_yaw, self.angles_y) > 80)	// no ass lavaballs
	{
		vec_x = v_forward_x;
		vec_y = v_forward_y;
		vec = normalize(vec);
	}

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, CHAN_WEAPON, "boss1/throw.wav", 1, ATTN_NORM);

	if (skill == 3)
		missile2 = launch_lavamissile (org, vec * 800);
	else
		missile2 = launch_lavamissile (org, vec * 700);
	missile2.touch = abmage_lavaball_touch;
}


/*
================
Melee Electric Zap
================
*/
void() AbMageMelee =
{
	local vector	delta;
	local float		damg;

	if (!self.enemy)
		return;
	if (!CanDamage (self.enemy, self.origin))
		return;
	if (self.deadflag) return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 120)
		return;

	sound (self, CHAN_WEAPON, "ab_mage/eatt1.wav", 1, ATTN_NORM);

	fx_beam(self.origin, self.enemy.origin, self);

	if (skill == 3)
		damg = 45 + 4 * random();
	else
		damg = 25 + 4 * random();

	T_Damage (self.enemy, self, self, damg, DMGTYPE_LIGHTNING);
}


//==========================================================================

void() abmage_idlesound =
{
	local   float   mr;

	mr = random();
	if (mr > 0.9) 
		sound (self, CHAN_VOICE, "ab_mage/tidle1.wav", 1, ATTN_IDLE);
	else if (mr < 0.1)
		sound (self, CHAN_VOICE, "ab_mage/tidle2.wav", 1, ATTN_IDLE);
}


void() abmage_stand1  =[ $float1,  abmage_stand2  ] {ai_stand();
    if (!(self.spawnflags & 1))     // Chant ominously if not in ambush mode.
        abmage_idlesound();
}
void() abmage_stand2  =[ $float2,  abmage_stand3  ] {ai_stand();}
void() abmage_stand3  =[ $float3,  abmage_stand4  ] {ai_stand();}
void() abmage_stand4  =[ $float4,  abmage_stand5  ] {ai_stand();}
void() abmage_stand5  =[ $float5,  abmage_stand6  ] {ai_stand();}
void() abmage_stand6  =[ $float6,  abmage_stand7  ] {ai_stand();}
void() abmage_stand7  =[ $float7,  abmage_stand1  ] {ai_stand();}


void() abmage_walk1  =[ $float1,  abmage_walk2  ] {ai_walk(8); abmage_idlesound();}
void() abmage_walk2  =[ $float2,  abmage_walk3  ] {ai_walk(8);}
void() abmage_walk3  =[ $float3,  abmage_walk4  ] {ai_walk(8);}
void() abmage_walk4  =[ $float4,  abmage_walk5  ] {ai_walk(8);}
void() abmage_walk5  =[ $float5,  abmage_walk6  ] {ai_walk(8);}
void() abmage_walk6  =[ $float6,  abmage_walk7  ] {ai_walk(8);}
void() abmage_walk7  =[ $float7,  abmage_walk1  ] {ai_walk(8);}


void() abmage_side1  =[ $float1,  abmage_side2  ] {ai_run(8); abmage_idlesound();}
void() abmage_side2  =[ $float2,  abmage_side3  ] {ai_run(8);}
void() abmage_side3  =[ $float3,  abmage_side4  ] {ai_run(8);}
void() abmage_side4  =[ $float4,  abmage_side5  ] {ai_run(8);}
void() abmage_side5  =[ $float5,  abmage_side6  ] {ai_run(8);}
void() abmage_side6  =[ $float6,  abmage_side7  ] {ai_run(8);}
void() abmage_side7  =[ $float7,  abmage_side1  ] {ai_run(8);}

void() abmage_run1  =[ $float1,  abmage_run2  ] {ai_run(16); abmage_idlesound();}
void() abmage_run2  =[ $float2,  abmage_run3  ] {ai_run(16);}
void() abmage_run3  =[ $float3,  abmage_run4  ] {ai_run(16);}
void() abmage_run4  =[ $float4,  abmage_run5  ] {ai_run(16);}
void() abmage_run5  =[ $float5,  abmage_run6  ] {ai_run(16);}
void() abmage_run6  =[ $float6,  abmage_run7  ] {ai_run(16);}
void() abmage_run7  =[ $float7,  abmage_run1  ] {ai_run(16);}


void() AbMageAttackFinished =
{
	enemy_range = range(self.enemy);
	enemy_vis = visible(self.enemy);
	
	if (enemy_range >= RANGE_MID || !enemy_vis)
	{
		self.attack_state = AS_STRAIGHT;
		self.think = abmage_run1;
	}
	else
	{
		self.attack_state = AS_SLIDING;
		self.think = abmage_side1;
	}
}

void() abmage_melee1  =[ $attackb1,  abmage_melee2  ] {ai_face();}
void() abmage_melee2  =[ $attackb2,  abmage_melee3  ] {ai_face();}
void() abmage_melee3  =[ $attackb3,  abmage_melee4  ] {ai_face(); self.effects = EF_BRIGHTLIGHT;}
void() abmage_melee4  =[ $attackb4,  abmage_melee5  ] {ai_face();}
void() abmage_melee5  =[ $attackb5,  abmage_melee6  ] {ai_face(); AbMageMelee();}
void() abmage_melee6  =[ $attackb6,  abmage_melee7  ] {ai_face(); self.effects = 0;}
void() abmage_melee7  =[ $attackb2,  abmage_melee8  ] {ai_face();}
void() abmage_melee8  =[ $attackb1,  abmage_run1   ] {ai_face(); abmage_teleport(0.5); AbMageAttackFinished();}

void() abmage_range1  =[ $attackb1,  abmage_range2  ] {ai_face();}
void() abmage_range2  =[ $attackb2,  abmage_range3  ] {ai_face();}
void() abmage_range3  =[ $attackb3,  abmage_range4  ] {ai_face(); sound (self, CHAN_VOICE, "ab_mage/frblatck.wav", 1, ATTN_NORM);}
void() abmage_range4  =[ $attackb4,  abmage_range5  ] {ai_face();}
void() abmage_range5  =[ $attackb5,  abmage_range6  ] {ai_face();
	if (random() >= 0.5)
		ThreeMissiles();
	else
		AbMageLavaball();
}
void() abmage_range6  =[ $attackb6,  abmage_range7  ] {ai_face();}
void() abmage_range7  =[ $attackb2,  abmage_range8  ] {ai_face();}
void() abmage_range8  =[ $attackb1,  abmage_run1   ] {ai_face(); abmage_teleport(0.3); AbMageAttackFinished();}


void() abmage_pain1  =[ $pain1,  abmage_pain2  ] {ai_nop(); self.effects = 0;}
void() abmage_pain2  =[ $pain2,  abmage_pain3  ] {ai_nop();}
void() abmage_pain3  =[ $pain3,  abmage_pain4  ] {ai_nop(); abmage_teleport(0.7);}
void() abmage_pain4  =[ $pain4,  abmage_pain5  ] {ai_nop();}
void() abmage_pain5  =[ $pain5,  abmage_pain6  ] {ai_nop();}
void() abmage_pain6  =[ $pain6,  abmage_run1   ] {ai_nop();}

void(entity attacker, float damage) abmage_pain =
{
	if (self.pain_finished > time) return;

	// higher chance to flinch when below 50% health, and lower on Nightmare
	if (self.health >= self.max_health / 2 && skill == 3)
	{
		if (random()*350 > damage)
			return;
	}
	else if (self.health >= self.max_health / 2)
	{
		if (random()*300 > damage)
			return;
	}
	else if (skill == 3)
	{
		if (random()*120 > damage)
			return;
	}
	else
	{
		if (random()*100 > damage)
			return;
	}

	abmage_pain1();
	PainFinished(1);
	sound (self, CHAN_VOICE, "ab_mage/tpain.wav", 1, ATTN_NORM);
}


void() abmage_death1  =[ $death1,  abmage_death2  ] {
	self.velocity_x = -200 + 400*random();
	self.velocity_y = -200 + 400*random();
	self.velocity_z = 200 + 100*random();
	self.flags = not(self.flags, FL_ONGROUND);
	if (random() < 0.5)
        sound (self, CHAN_VOICE, "ab_mage/tdeath1.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "ab_mage/tdeath2.wav", 1, ATTN_NORM);
}
void() abmage_death2  =[ $death2,  abmage_death3  ] {}
void() abmage_death3  =[ $death3,  abmage_death4  ] {self.solid = SOLID_NOT; self.flags = not(self.flags, FL_ONGROUND);}
void() abmage_death4  =[ $death4,  abmage_death5  ] {}
void() abmage_death5  =[ $death5,  abmage_death6  ] {}
void() abmage_death6  =[ $death6,  abmage_death7  ] {}
void() abmage_death7  =[ $death7,  abmage_death8  ] {}
void() abmage_death8  =[ $death8,  abmage_death9  ] {}
void() abmage_death9  =[ $death9,  abmage_death10 ] {}
void() abmage_death10 =[ $death10, abmage_death11 ] {}
void() abmage_death11 =[ $death11, abmage_death12 ] {}
void() abmage_death12 =[ $death12, abmage_death13 ] {}
void() abmage_death13 =[ $death13, abmage_death14 ] {}
void() abmage_death14 =[ $death14, abmage_death15 ] {}
void() abmage_death15 =[ $death15, abmage_death16 ] {}
void() abmage_death16 =[ $death16, abmage_death17 ] {}
void() abmage_death17 =[ $death17, SUB_Null   ] {}

void() abmage_die =
{
	self.effects = 0;

	if (self.health < -40)
	{
		Gib ("progs/h_a_mage.mdl", self.health);
		return;
	}
	abmage_death1();
}


// ========

void() monster_aberrant_mage_spawn =
{
	self.classname = "monster_aberrant_mage";
	self.noselfbomb = 1;
		
	self.solid = SOLID_SLIDEBOX;
	//self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/ab_mage.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	if (!self.health)
	self.health = 500;

	self.th_stand = abmage_stand1;
	self.th_walk = abmage_walk1;
	self.th_run = abmage_run1;
	self.th_missile = abmage_range1;
	self.th_melee = abmage_melee1;
	self.th_pain = abmage_pain;
	self.th_die = abmage_die;
	self.th_checkattack = MageCheckAttack;

	if (self.deathtype == string_null)
		self.deathtype = "was destroyed by an Aberrant Mage";

	self.height = zeroconvertdefault(self.height, 35);
	self.jump_flag = self.height;	// remember original value for short term nav tweaking
	flymonster_start();
}

void() monster_aberrant_mage_spawner = {mon_spawner_use(monster_aberrant_mage_spawn);}

/*QUAKED monster_aberrant_mage (1 0 0) (-16 -16 -24) (16 16 40) AMBUSH ? ? ? TRIGGERED NOTFOG NOTELEFRAG INSTAWAKE
Aberrant Mage, 500 health points.

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
@PointClass base(Monster) size(-16 -16 -24, 16 16 40) model({ "path": ":progs/ab_mage.mdl" }) = monster_aberrant_mage : "Aberrant Mage

Default health = 500"
[
health(integer) : "Custom health amount"
]
*/
void() monster_aberrant_mage =
{
	if (!SUB_ShouldSpawn()) return;
	if (nomonster()) return;
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/ab_mage.mdl");
	precache_model ("progs/h_a_mage.mdl");
	precache_model ("progs/dd_spike.mdl");
	precache_model ("progs/lavaball.mdl");

	precache_sound ("ab_mage/eatt1.wav");
	precache_sound ("ab_mage/frblatck.wav");
	precache_sound ("ab_mage/tdeath1.wav");
	precache_sound ("ab_mage/tdeath2.wav");
	precache_sound ("ab_mage/tidle1.wav");
	precache_sound ("ab_mage/tidle2.wav");
	precache_sound ("ab_mage/tpain.wav");
	precache_sound ("ab_mage/tsight1.wav");
	precache_sound ("ab_mage/tsight2.wav");
	precache_sound ("hknight/attack1.wav");
    precache_sound ("hknight/hit.wav");    // used by C code, so don't sound2
	precache_sound ("boss1/throw.wav");

	if (!self.health)
	self.health = 500;
	setsize (self, '-16 -16 -24', '16 16 40');
	if ( monster_spawnsetup( monster_aberrant_mage_spawner ) ) return;
	
	addmonster(1);
	monster_aberrant_mage_spawn();
}
