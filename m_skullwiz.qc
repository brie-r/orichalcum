/*
==============================================================================

SKULL WIZARDS

==============================================================================
*/

$cd id1/models/skullwiz
$origin 0 0 24
$base base        
$skin skin

$frame skdeth1 skdeth2 skdeth3 skdeth4 skdeth5 skdeth6 skdeth7 skdeth8
$frame skdeth9 skdeth10 skdeth11 skdeth12 skdeth13 skdeth14 skdeth15

$frame skgate1 skgate2 skgate3 skgate4 skgate5 skgate6 skgate7 skgate8
$frame skgate9 skgate10 skgate11 skgate12 skgate13 skgate14 skgate15
$frame skgate16 skgate17 skgate18 skgate19 skgate20 skgate21 skgate22
$frame skgate23 skgate24 skgate25 skgate26 skgate27 skgate28 skgate29
$frame skgate30

$frame skpain1 skpain2 skpain3 skpain4 skpain5 skpain6 skpain7 skpain8
$frame skpain9 skpain10 skpain11 skpain12

$frame skredi1 skredi2 skredi3 skredi4 skredi5 skredi6 skredi7 skredi8
$frame skredi9 skredi10 skredi11 skredi12

$frame skspel1 skspel2 skspel3 skspel4 skspel5 skspel6 skspel7 skspel8
$frame skspel9 skspel10 skspel11 skspel12 skspel13 skspel14 skspel15

$frame sktele1 sktele2 sktele3 sktele4 sktele5 sktele6 sktele7 sktele8
$frame sktele9 sktele10 sktele11 sktele12 sktele13 sktele14 sktele15

$frame sktran1 sktran2 sktran3 sktran4 sktran5 sktran6 sktran7

$frame skwait1 skwait2 skwait3 skwait4 skwait5 skwait6 skwait7 skwait8
$frame skwait9 skwait10 skwait11 skwait12 skwait13 skwait14 skwait15
$frame skwait16 skwait17 skwait18 skwait19

$frame skwalk1 skwalk2 skwalk3 skwalk4 skwalk5 skwalk6 skwalk7 skwalk8
$frame skwalk9 skwalk10 skwalk11 skwalk12 skwalk13 skwalk14 skwalk15
$frame skwalk16 skwalk17 skwalk18 skwalk19 skwalk20 skwalk21 skwalk22
$frame skwalk23 skwalk24

// Extra frames to emulate teleporting effects since we can't rely on scale.
$frame skwarp1 skwarp2 skwarp3 skwarp4 skwarp5 skwarp6 skwarp7 skwarp8
$frame skwarp9

//=============================================================================

// Teleportation for other than run anims
void(float chance) skullwiz_teleport_nonrun =
{
    local entity    theDest;
    local vector    org, delta;

	// more likely if the enemy is dangerously close
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) < 300)
		chance = chance + 0.1;

	// more likely for Archmages
	if (self.classname == "monster_skull_lord")
		chance = chance + 0.1;

    if (random() > chance)
        return;

	if (self.enemy)
		theDest = self.enemy;
	else
		theDest = self;
	org = self.origin;
	if (EntryPoint_Spawn (self, theDest, self.origin, EntryPoint_Mage))
	{
		spawn_tfog (org);
		spawn_tfog (self.origin);
	}
}

// Teleportation for run anims; checked twice per sequence
// .lip used to prevent two times teleporting during the same anim sequence
void() skullwiz_teleport_run =
{
    local entity    theDest;
    local vector    org, delta;
	local float		chance;

	if (self.lip == 1) return;

	// ONLY for when the enemy is dangerously close
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 300)
		return;

	if (self.classname == "monster_skull_lord")
		chance = 0.3;
	else
		chance = 0.2;

    if (random() > chance)
        return;

	if (self.enemy)
		theDest = self.enemy;
	else
		theDest = self;
	org = self.origin;
	if (EntryPoint_Spawn (self, theDest, self.origin, EntryPoint_Mage))
	{
		spawn_tfog (org);
		spawn_tfog (self.origin);
		self.lip = 1;
	}
}

// The wizard may teleport to his enemy if he can't see them or is very far; useful as an
// insurance should other teleportations get the wizard stuck away from the player
void() skullwiz_tele_to_player =
{
    local vector    org;

	if (self.lip == 1) return;

	org = self.origin;

	if (self.touch_time + 5 < time)
	{
		if (self.enemy && (!visible(self.enemy) || range(self.enemy) >= RANGE_FAR))
		{
			if (EntryPoint_Spawn (self, self.enemy, self.enemy.origin, EntryPoint_Mage))
			{
				spawn_tfog (org);
				spawn_tfog (self.origin);
				self.lip = 1;
				self.touch_time = time;
			}
		}
	}
}


/*
========
Skull Missile
========
*/
void() SkullWizMisExplode =
{
	if (skill == 3)
		T_RadiusDamage (self, self.trueowner, 60, world, DMGTYPE_EXPLOSION);
	else
		T_RadiusDamage (self, self.trueowner, 40, world, DMGTYPE_EXPLOSION);

	self.origin = self.origin - 8*normalize(self.velocity);
	T_ExplosiveTouch();
}

void() SkullWizMisTouch =
{
	if (other == self.owner) return;		// don't explode on owner
	if (CheckProjectilePassthru()) return;

	if (other.health)
	{
		if (skill == 3)
			T_Damage (other, self, self.trueowner, 10, DMGTYPE_EXPLOSION | DMGTYPE_ZKILL );
		else
			T_Damage (other, self, self.trueowner, 5, DMGTYPE_EXPLOSION | DMGTYPE_ZKILL );
	}

	SkullWizMisExplode();
}

void() SkullAdeptMisThink =
{
	if (self.lifetime_finished < time)
	{
		SkullWizMisExplode();
		return;
	}

	if (self.wait <= time)
    {
        sound (self, CHAN_BODY, "skullwiz/scream.wav", 1, ATTN_IDLE);
        self.wait = time + ((random() + 1) / 2);
    }

	self.think = SkullAdeptMisThink;
	self.nextthink = time + 0.1;

	self.owner = self.trueowner;
}

void() SkullAdeptMissile =
{
	vector org, vec;
	entity missile;

	org = self.origin + v_forward * 15 + v_right * -4 + v_up * 17;
	vec = normalize(enemy_vispos() - org + enemy_aim_vertical());

	makevectors(self.angles);
	if (angledif(self.ideal_yaw, self.angles_y) > 80)	// no ass skulls
	{
		vec_x = v_forward_x;
		vec_y = v_forward_y;
		vec = normalize(vec);
	}

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, CHAN_WEAPON, "skullwiz/firemisl.wav", 1, ATTN_NORM);

	if (skill == 3)
		missile = launch_projectile(org, vec * 750, "skullmissile");
	else
		missile = launch_projectile(org, vec * 650, "skullmissile");

	SUB_ChangeModel (missile, "progs/skulshot.mdl");
	missile.nextthink = time + 0.1;
	missile.think = SkullAdeptMisThink;
	missile.touch = SkullWizMisTouch;
	missile.lifetime_finished = time + 30;	 // blow up after a while
	missile.wait = time + ((random() + 1) / 2);
	missile.effects = EF_DIMLIGHT;
}


void() SkullLordMisHome =
{
	float dist, rate, dot;
	
	if (self.lifetime_finished < time)
	{
		SkullWizMisExplode();
		return;
	}
	if (!alive(self.enemy))
	{
		self.think = SkullWizMisExplode;
		self.nextthink = self.lifetime_finished;
		//remove(self);
		return;
	}
	if (self.wait <= time)
    {
        sound (self, CHAN_BODY, "skullwiz/scream2.wav", 1, ATTN_IDLE);
        self.wait = time + ((random() + 1) / 2);
    }
	
	self.think = SkullLordMisHome;
	self.nextthink = time + SHAL_BALL_THINK_RATE;
	rate = SHAL_BALL_TURN_RATE;
	dot = normalize(self.velocity) * normalize(self.enemy.origin - self.origin);
	
	self.owner = self.trueowner;
	
	// go faster at long distance to close the gap, so snipey skull lords have a better presence
	dist = vlen(self.enemy.origin - self.origin);
	dist = saturate( (dist-200) / 600 );
	
	// Skull Archmages' missiles have poor homing, though they move faster on Nightmare
	if (skill < 3)
	{
		if (dot > 0)
		{
			rate *= max(1, 1.5 * (1 - dot));
		}
		self.velocity = 650 * WrathTurnToward(self.enemy.origin, rate * 0.5);
	}
	else
	{
		if (dot > 0)
		{
			rate *= max(1, 1.5 * (1 - dot));
		}
		self.velocity = 750 * WrathTurnToward(self.enemy.origin, rate * 0.5);
	}
		
	self.velocity *= 1 + dist;
	self.velocity += Vector(crandom(),crandom(),crandom()) * 16;
	self.oldvelocity = self.velocity;	
}

void() SkullLordMissile =
{
	entity 	missile;
	vector	dir, org;

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, CHAN_WEAPON, "skullwiz/firemisl.wav", 1, ATTN_NORM);
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

	org = self.origin + v_forward * 15 + v_right * -4 + v_up * 17;
	
	if (skill == 3)
		missile = launch_projectile(org, dir * 750, "skullmissile");
	else
		missile = launch_projectile(org, dir * 650, "skullmissile");

	SUB_ChangeModel (missile, "progs/skulshot.mdl");
	missile.nextthink = time + 0.1;
	missile.think = SkullLordMisHome;
	missile.enemy = self.enemy;
	missile.touch = SkullWizMisTouch;
	missile.lifetime_finished = time + 30;	 // blow up after a while
	missile.wait = time + ((random() + 1) / 2);
	missile.effects = EF_DIMLIGHT;
}


/*
========
Magical Sharp Bones
========
*/
void() SkullWizMagicBone =
{
	entity missile;
    vector org, vec;

	ai_face();
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);

	org = self.origin + v_forward * 15 + v_right * -4 + v_up * 17;
    vec = normalize(enemy_vispos() - org + enemy_aim_vertical());
	makevectors (self.angles);

	if (angledif(self.ideal_yaw, self.angles_y) > 80)	// no ass magic bones
	{
		vec_x = v_forward_x;
		vec_y = v_forward_y;
		vec = normalize(vec);
	}

	if (skill == 3)
	{
		missile = launch_nail(org, vec * 1000);
		missile.dmg = 18;
	}
	else
	{
		missile = launch_nail(org, vec * 950);
		missile.dmg = 11;
	}
}


/*
========
Melee Repel Attack
========
*/
void() SkullWizMelee =
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

	sound (self, CHAN_WEAPON, "skullwiz/push.wav", 1, ATTN_NORM);

	if (self.classname == "monster_skull_lord" && skill == 3)
		damg = 52 + 4 * random();
	else if (self.classname == "monster_skull_lord")
		damg = 32 + 4 * random();
	else if (skill == 3)
		damg = 46 + 4 * random();
	else
		damg = 28 + 4 * random();

	T_Damage (self.enemy, self, self, damg);

    self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONGROUND);
    self.enemy.velocity = (self.enemy.origin - self.origin) * 10;
    self.enemy.velocity_z = 100;
}

//=============================================================================

void() skullwiz_stand1  =[ $skwait1,  skullwiz_stand2  ] {ai_stand();}
void() skullwiz_stand2  =[ $skwait2,  skullwiz_stand3  ] {ai_stand();}
void() skullwiz_stand3  =[ $skwait3,  skullwiz_stand4  ] {ai_stand();}
void() skullwiz_stand4  =[ $skwait4,  skullwiz_stand5  ] {ai_stand();}
void() skullwiz_stand5  =[ $skwait5,  skullwiz_stand6  ] {ai_stand();}
void() skullwiz_stand6  =[ $skwait6,  skullwiz_stand7  ] {ai_stand();}
void() skullwiz_stand7  =[ $skwait7,  skullwiz_stand8  ] {ai_stand();}
void() skullwiz_stand8  =[ $skwait8,  skullwiz_stand9  ] {ai_stand();}
void() skullwiz_stand9  =[ $skwait9,  skullwiz_stand10 ] {ai_stand();}
void() skullwiz_stand10 =[ $skwait10, skullwiz_stand11 ] {ai_stand();}
void() skullwiz_stand11 =[ $skwait11, skullwiz_stand12 ] {ai_stand();}
void() skullwiz_stand12 =[ $skwait12, skullwiz_stand13 ] {ai_stand();}
void() skullwiz_stand13 =[ $skwait13, skullwiz_stand14 ] {ai_stand();}
void() skullwiz_stand14 =[ $skwait14, skullwiz_stand15 ] {ai_stand();}
void() skullwiz_stand15 =[ $skwait15, skullwiz_stand16 ] {ai_stand();}
void() skullwiz_stand16 =[ $skwait16, skullwiz_stand17 ] {ai_stand();}
void() skullwiz_stand17 =[ $skwait17, skullwiz_stand18 ] {ai_stand();}
void() skullwiz_stand18 =[ $skwait18, skullwiz_stand19 ] {ai_stand();}
void() skullwiz_stand19 =[ $skwait19, skullwiz_stand1  ] {ai_stand();}


void() skullwiz_idle_sfx =
{
    if (self.classname == "monster_skull_adept")
        sound (self, CHAN_VOICE, "skullwiz/growl.wav", 1, ATTN_IDLE);
    else
        sound (self, CHAN_VOICE, "skullwiz/growl2.wav", 1, ATTN_IDLE);
}

void() skullwiz_walk1  =[ $skwalk1,  skullwiz_walk2  ] {
    if (random() < 0.1)
        skullwiz_idle_sfx ();
    ai_walk(2);
}
void() skullwiz_walk2  =[ $skwalk2,  skullwiz_walk3  ] {ai_walk(1);}
void() skullwiz_walk3  =[ $skwalk3,  skullwiz_walk4  ] {ai_walk(1);}
void() skullwiz_walk4  =[ $skwalk4,  skullwiz_walk5  ] {ai_walk(1);}
void() skullwiz_walk5  =[ $skwalk5,  skullwiz_walk6  ] {ai_walk(1);}
void() skullwiz_walk6  =[ $skwalk6,  skullwiz_walk7  ] {ai_walk(1);}
void() skullwiz_walk7  =[ $skwalk7,  skullwiz_walk8  ] {ai_walk(1);}
void() skullwiz_walk8  =[ $skwalk8,  skullwiz_walk9  ] {ai_walk(1);}
void() skullwiz_walk9  =[ $skwalk9,  skullwiz_walk10 ] {ai_walk(1);}
void() skullwiz_walk10 =[ $skwalk10, skullwiz_walk11 ] {ai_walk(1);}
void() skullwiz_walk11 =[ $skwalk11, skullwiz_walk12 ] {ai_walk(1);}
void() skullwiz_walk12 =[ $skwalk12, skullwiz_walk13 ] {ai_walk(1);}
void() skullwiz_walk13 =[ $skwalk13, skullwiz_walk14 ] {ai_walk(1);}
void() skullwiz_walk14 =[ $skwalk14, skullwiz_walk15 ] {ai_walk(1);}
void() skullwiz_walk15 =[ $skwalk15, skullwiz_walk16 ] {ai_walk(1);}
void() skullwiz_walk16 =[ $skwalk16, skullwiz_walk17 ] {ai_walk(1);}
void() skullwiz_walk17 =[ $skwalk17, skullwiz_walk18 ] {ai_walk(1);}
void() skullwiz_walk18 =[ $skwalk18, skullwiz_walk19 ] {ai_walk(1);}
void() skullwiz_walk19 =[ $skwalk19, skullwiz_walk20 ] {ai_walk(1);}
void() skullwiz_walk20 =[ $skwalk20, skullwiz_walk21 ] {ai_walk(1);}
void() skullwiz_walk21 =[ $skwalk21, skullwiz_walk22 ] {ai_walk(1);}
void() skullwiz_walk22 =[ $skwalk22, skullwiz_walk23 ] {ai_walk(1);}
void() skullwiz_walk23 =[ $skwalk23, skullwiz_walk24 ] {ai_walk(1);}
void() skullwiz_walk24 =[ $skwalk24, skullwiz_walk1  ] {ai_walk(1);}


void() skullwiz_run1  =[ $skwalk1,  skullwiz_run2  ] {
    if (random() < 0.2)
        skullwiz_idle_sfx ();
    ai_run(12); self.lip = 0;
}
void() skullwiz_run2  =[ $skwalk3,  skullwiz_run3  ] {ai_run(12);}
void() skullwiz_run3  =[ $skwalk5,  skullwiz_run4  ] {ai_run(12);}
void() skullwiz_run4  =[ $skwalk7,  skullwiz_run5  ] {ai_run(12);}
void() skullwiz_run5  =[ $skwalk9,  skullwiz_run6  ] {ai_run(12);}
void() skullwiz_run6  =[ $skwalk11, skullwiz_run7  ] {ai_run(12); skullwiz_teleport_run();}
void() skullwiz_run7  =[ $skwalk13, skullwiz_run8  ] {ai_run(12); skullwiz_tele_to_player();}
void() skullwiz_run8  =[ $skwalk15, skullwiz_run9  ] {ai_run(12);}
void() skullwiz_run9  =[ $skwalk17, skullwiz_run10 ] {ai_run(12);}
void() skullwiz_run10 =[ $skwalk19, skullwiz_run11 ] {ai_run(12);}
void() skullwiz_run11 =[ $skwalk21, skullwiz_run12 ] {ai_run(12);}
void() skullwiz_run12 =[ $skwalk23, skullwiz_run1  ] {ai_run(12); skullwiz_teleport_run();}


void() skullwiz_missile1  =[ $skredi2,  skullwiz_missile2 ] {ai_face();}
void() skullwiz_missile2  =[ $skredi6,  skullwiz_missile3 ] {ai_face();}
void() skullwiz_missile3  =[ $skredi10, skullwiz_missile4 ] {ai_face();}
void() skullwiz_missile4  =[ $skspel4,  skullwiz_missile5 ] {ai_face();}
void() skullwiz_missile5  =[ $skspel8,  skullwiz_missile6 ] {ai_face();}
void() skullwiz_missile6  =[ $skspel12, skullwiz_missile7 ] {ai_face();
	if (self.classname == "monster_skull_lord")
		SkullLordMissile();
	else
		SkullAdeptMissile();
}
void() skullwiz_missile7  =[ $skspel14, skullwiz_missile8 ] {ai_face();}
void() skullwiz_missile8  =[ $sktran3,  skullwiz_missile9 ] {ai_face();}
void() skullwiz_missile9  =[ $sktran7,  skullwiz_run1     ] {ai_face(); skullwiz_teleport_nonrun(0.3);}

void() skullwiz_bones1  =[ $skredi2,  skullwiz_bones2 ] {ai_face();}
void() skullwiz_bones2  =[ $skredi6,  skullwiz_bones3 ] {ai_face();}
void() skullwiz_bones3  =[ $skredi10, skullwiz_bones4 ] {ai_face();}
void() skullwiz_bones4  =[ $skspel4,  skullwiz_bones5 ] {ai_face();}
void() skullwiz_bones5  =[ $skspel8,  skullwiz_bones6 ] {ai_face();}
void() skullwiz_bones6  =[ $skspel12, skullwiz_bones7 ] {ai_face(); SkullWizMagicBone();}
void() skullwiz_bones7  =[ $skspel12, skullwiz_bones8 ] {ai_face(); SkullWizMagicBone();}
void() skullwiz_bones8  =[ $skspel12, skullwiz_bones9 ] {ai_face(); SkullWizMagicBone(); if (self.classname == "monster_skull_lord") self.think = skullwiz_bones8x; }
void() skullwiz_bones8x =[ $skspel12, skullwiz_bones9 ] {ai_face(); SkullWizMagicBone();}
void() skullwiz_bones9  =[ $skspel14, skullwiz_bones10 ] {ai_face();}
void() skullwiz_bones10  =[ $sktran3,  skullwiz_bones11 ] {ai_face();}
void() skullwiz_bones11  =[ $sktran7,  skullwiz_run1    ] {ai_face(); skullwiz_teleport_nonrun(0.3);}

void() skullwiz_missile =
{
	if (random() >= 0.5)
		skullwiz_missile1();
	else
		skullwiz_bones1();
}


void() skullwiz_melee1  =[ $skspel2,  skullwiz_melee2  ] {ai_charge(3);}
void() skullwiz_melee2  =[ $skspel4,  skullwiz_melee3  ] {ai_charge(3);}
void() skullwiz_melee3  =[ $skspel6,  skullwiz_melee4  ] {ai_charge(3);}
void() skullwiz_melee4  =[ $skspel8,  skullwiz_melee5  ] {ai_charge(3);}
void() skullwiz_melee5  =[ $skspel10, skullwiz_melee6  ] {ai_charge(3);
	SkullWizMelee();
	if (self.classname == "monster_skull_lord")
	{
		if (random() < 0.26)
			self.think = skullwiz_missile4;
		else if (random() < 0.26)
			self.think = skullwiz_bones4;
	}
}
void() skullwiz_melee6  =[ $skspel12, skullwiz_melee7  ] {ai_charge(3);}
void() skullwiz_melee7  =[ $skspel14, skullwiz_run1    ] {ai_charge(3); skullwiz_teleport_nonrun(0.5);}


void() skullwiz_pain1  =[ $skpain1,  skullwiz_pain2  ] {}
void() skullwiz_pain2  =[ $skpain3,  skullwiz_pain3  ] {}
void() skullwiz_pain3  =[ $skpain5,  skullwiz_pain4  ] {skullwiz_teleport_nonrun(0.7);}
void() skullwiz_pain4  =[ $skpain7,  skullwiz_pain5  ] {}
void() skullwiz_pain5  =[ $skpain9,  skullwiz_pain6  ] {}
void() skullwiz_pain6  =[ $skpain11, skullwiz_run1   ] {}

void(entity attacker, float damage) skull_adept_pain =
{
	if (self.pain_finished > time) return;

	// higher chance to flinch when below 50% health, and lower on Nightmare
	if (self.health >= self.max_health / 2 && skill == 3)
	{
		if (random()*390 > damage)
			return;
	}
	else if (self.health >= self.max_health / 2)
	{
		if (random()*340 > damage)
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

	skullwiz_pain1();
	PainFinished(1);
	sound (self, CHAN_VOICE, "skullwiz/pain.wav", 1, ATTN_NORM);
}

void(entity attacker, float damage) skull_lord_pain =
{
	if (self.pain_finished > time) return;

	// higher chance to flinch when below 50% health, and lower on Nightmare
	if (self.health >= self.max_health / 2 && skill == 3)
	{
		if (random()*400 > damage)
			return;
	}
	else if (self.health >= self.max_health / 2)
	{
		if (random()*350 > damage)
			return;
	}
	else if (skill == 3)
	{
		if (random()*180 > damage)
			return;
	}
	else
	{
		if (random()*150 > damage)
			return;
	}

	skullwiz_pain1();
	PainFinished(2);
	sound (self, CHAN_VOICE, "skullwiz/pain2.wav", 1, ATTN_NORM);
}


void() skullwiz_die1  =[ $skdeth1,  skullwiz_die2  ] {
	if (self.classname == "monster_skull_adept")
        sound (self, CHAN_VOICE, "skullwiz/death.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "skullwiz/death2.wav", 1, ATTN_NORM);
}
void() skullwiz_die2  =[ $skdeth3,  skullwiz_die3  ] {}
void() skullwiz_die3  =[ $skdeth5,  skullwiz_die4  ] {self.solid = SOLID_NOT;}
void() skullwiz_die4  =[ $skdeth7,  skullwiz_die5  ] {ai_back(1);}
void() skullwiz_die5  =[ $skdeth9,  skullwiz_die6  ] {ai_back(8);}
void() skullwiz_die6  =[ $skdeth11, skullwiz_die7  ] {ai_back(7);}
void() skullwiz_die7  =[ $skdeth13, skullwiz_die8  ] {}
void() skullwiz_die8  =[ $skdeth15, SUB_Null    ] {
	if (damage_attacker.classname != "func_void") ThrowHead ("progs/skulhead.mdl", self.health);}


// ========

void() monster_skull_adept_spawn =
{
	self.classname = "monster_skull_adept";
	self.type = "skullwiz";
	self.noselfbomb = 1;
		
	self.solid = SOLID_SLIDEBOX;
	//self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/skuladpt.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	if (!self.health)
	self.health = 550;

	self.th_stand = skullwiz_stand1;
	self.th_walk = skullwiz_walk1;
	self.th_run = skullwiz_run1;
	self.th_melee = skullwiz_melee1;
	self.th_missile = skullwiz_missile;
	self.th_pain = skull_adept_pain;
	self.th_die = skullwiz_die1;
	self.th_checkattack = MageCheckAttack;

	if (self.deathtype == string_null)
		self.deathtype = "succumbed to a Skull Adept's magic";

	walkmonster_start ();
}

void() monster_skull_adept_spawner = {mon_spawner_use(monster_skull_adept_spawn);}

/*QUAKED monster_skull_adept (1 0 0) (-16 -16 -24) (16 16 40) AMBUSH ? ? ? TRIGGERED NOTFOG NOTELEFRAG INSTAWAKE
Skull Adept, 550 health points.

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
"movedir" set to a velocity to make the monster jump on awakening
"no_infight" if set to 1 (or higher), this individual won't infight ever (doesn't provoke and isn't provoked)
*/
/*FGD
@PointClass base(Monster) size(-16 -16 -24, 16 16 40) model({ "path": ":progs/skuladpt.mdl" }) = monster_skull_adept : "Skull Adept

Default health = 550"
[
health(integer) : "Custom health amount"
]
*/
void() monster_skull_adept =
{
	if (!SUB_ShouldSpawn()) return;
	if (nomonster()) return;
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/skuladpt.mdl");
	precache_model ("progs/skulshot.mdl");
	precache_model ("progs/skulhead.mdl");
	
	precache_sound ("skullwiz/scream.wav");
	precache_sound ("skullwiz/growl.wav");
	precache_sound ("skullwiz/pain.wav");
	precache_sound ("skullwiz/death.wav");
	precache_sound ("skullwiz/gatespk.wav");
	precache_sound ("skullwiz/push.wav");
	precache_sound ("skullwiz/firemisl.wav");
	
	if (!self.health)
	self.health = 550;
	setsize (self, '-16 -16 -24', '16 16 40');
	if ( monster_spawnsetup( monster_skull_adept_spawner ) ) return;
	
	addmonster(1);
	monster_skull_adept_spawn();
}


// ========

void() monster_skull_lord_spawn =
{
	self.classname = "monster_skull_lord";
	self.type = "skullwiz";
	self.noselfbomb = 1;
		
	self.solid = SOLID_SLIDEBOX;
	//self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/skularch.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	if (!self.health)
	self.health = 1300;

	self.th_stand = skullwiz_stand1;
	self.th_walk = skullwiz_walk1;
	self.th_run = skullwiz_run1;
	self.th_melee = skullwiz_melee1;
	self.th_missile = skullwiz_missile;
	self.th_pain = skull_lord_pain;
	self.th_die = skullwiz_die1;
	self.th_checkattack = MageCheckAttack;

	if (self.deathtype == string_null)
		self.deathtype = "was eliminated by a Skull Archmage";

	walkmonster_start ();
}

void() monster_skull_lord_spawner = {mon_spawner_use(monster_skull_lord_spawn);}

/*QUAKED monster_skull_lord (1 0 0) (-16 -16 -24) (16 16 40) AMBUSH ? ? ? TRIGGERED NOTFOG NOTELEFRAG INSTAWAKE
Skull Archmage, 1300 health points.

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
"movedir" set to a velocity to make the monster jump on awakening
"no_infight" if set to 1 (or higher), this individual won't infight ever (doesn't provoke and isn't provoked)
*/
/*FGD
@PointClass base(Monster) size(-16 -16 -24, 16 16 40) model({ "path": ":progs/skularch.mdl" }) = monster_skull_lord : "Skull Archmage

Default health = 1300"
[
health(integer) : "Custom health amount"
]
*/
void() monster_skull_lord =
{
	if (!SUB_ShouldSpawn()) return;
	if (nomonster()) return;
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/skularch.mdl");
	precache_model ("progs/skulshot.mdl");
	precache_model ("progs/skulhead.mdl");
	
	precache_sound ("skullwiz/scream2.wav");
	precache_sound ("skullwiz/growl2.wav");
	precache_sound ("skullwiz/pain2.wav");
	precache_sound ("skullwiz/death2.wav");
	precache_sound ("skullwiz/gatespk.wav");
	precache_sound ("skullwiz/push.wav");
	precache_sound ("skullwiz/firemisl.wav");
	
	if (!self.health)
	self.health = 1300;
	setsize (self, '-16 -16 -24', '16 16 40');
	if ( monster_spawnsetup( monster_skull_lord_spawner ) ) return;
	
	addmonster(1);
	monster_skull_lord_spawn();
}
