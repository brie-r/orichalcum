// m_zalarax.qc

$skin s_wrtrst
$frame s_wrtfrm

// walk
$frame s_wtwk01 s_wtwk02 s_wtwk03 s_wtwk04 s_wtwk05
$frame s_wtwk06 s_wtwk07 s_wtwk08 s_wtwk09 s_wtwk10
$frame s_wtwk11 s_wtwk12 s_wtwk13 s_wtwk14 s_wtwk15

// hand to hand attacks
$frame s_wtaa01 s_wtaa02 s_wtaa03 s_wtaa04 s_wtaa05
$frame s_wtaa06 s_wtaa07 s_wtaa08 s_wtaa09 s_wtaa10

$frame s_wtab01 s_wtab02 s_wtab03 s_wtab04 s_wtab05
$frame s_wtab06 s_wtab07 s_wtab08 s_wtab09 s_wtab10
$frame s_wtab11 s_wtab12 s_wtab13 s_wtab14

$frame s_wtac01 s_wtac02 s_wtac03 s_wtac04 s_wtac05
$frame s_wtac06 s_wtac07 s_wtac08 s_wtac09 s_wtac10
$frame s_wtac11 s_wtac12 s_wtac13 s_wtac14

// ranged attack
$frame s_wtba01 s_wtba02 s_wtba03 s_wtba04 s_wtba05
$frame s_wtba06 s_wtba07 s_wtba08 s_wtba09 s_wtba10 s_wtba11 s_wtba12

// pain
$frame s_wtpa01 s_wtpa02 s_wtpa03 s_wtpa04 s_wtpa05
$frame s_wtpa06 s_wtpa07s_wtpa08 s_wtpa09 s_wtpa10
$frame s_wtpa11 s_wtpa12 s_wtpa13 s_wtpa14

$frame s_wtpb01 s_wtpb02 s_wtpb03 s_wtpb04 s_wtpb05
$frame s_wtpb06 s_wtpb07s_wtpb08 s_wtpb09 s_wtpb10
$frame s_wtpb11 

// death
$frame s_wtdt01 s_wtdt02 s_wtdt03 s_wtdt04 s_wtdt05
$frame s_wtdt06 s_wtdt07 s_wtdt08 s_wtdt09 s_wtdt10 
$frame s_wtdt11 s_wtdt12 s_wtdt13 s_wtdt14 s_wtdt15
$frame s_wtdt16 s_wtdt17

// =======================================================

void() jd_special_playtele =
{
	local	float v;
	local	string snd;
	v = random() * 5;
	if (v < 1)
		snd = "misc/r_tele1.wav";
	else if (v < 2)
		snd = "misc/r_tele2.wav";
	else if (v < 3)
		snd = "misc/r_tele3.wav";
	else if (v < 4)
		snd = "misc/r_tele4.wav";
	else
		snd = "misc/r_tele5.wav";

	sound (self, CHAN_VOICE, snd, 1, ATTN_NORM);
	remove(self);
}

void(vector org) spawn_tfog =
{
	entity s;

	s = spawn ();
	setorigin(s, org);
	s.think = jd_special_playtele;
	s.nextthink = time + 0.2;

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
}

void(float chance) zalarax_teleport =
{
    local entity    theDest;
    local vector    org;

	if (self.health < self.max_health / 2)
		chance = chance + 0.2;

    if (random() > chance)
        return;

	// dynamic teleportation from Drake
	if (self.enemy)
		theDest = self.enemy;
	else
		theDest = self;
	org = self.origin;
	if (EntryPoint_Spawn (self, theDest, theDest.origin, EntryPoint_Random))
	{
		spawn_tfog (org);
		spawn_tfog (self.origin);
	}
}


/*
================
ZalaraxMissile
================
*/

void() ZalaraxMissileExplode =
{
	if (skill == 3)
		T_RadiusDamage (self, self.trueowner, 60, world, DMGTYPE_EXPLOSION);
	else
		T_RadiusDamage (self, self.trueowner, 40, world, DMGTYPE_EXPLOSION);

	T_ExplosiveTouch();
}

void() ZalaraxMissileTouch =
{
	if (CheckProjectilePassthru()) return;
	if (other == self.owner)
		return;		// don't explode on owner

	if (other.type == "zombie")
		T_Damage (other, self, self.trueowner, other.health + 25);
	
	ZalaraxMissileExplode();
}

void() ZalaraxHome =
{
	float dist, rate, dot;
	
	if (self.lifetime_finished < time)
	{
		ZalaraxMissileExplode();
		return;
	}
	if (!alive(self.enemy))
	{
		self.think = ZalaraxMissileExplode;
		self.nextthink = self.lifetime_finished;
		//remove(self);
		return;
	}
	
	self.think = ZalaraxHome;
	self.nextthink = time + SHAL_BALL_THINK_RATE;
	rate = SHAL_BALL_TURN_RATE;
	dot = normalize(self.velocity) * normalize(self.enemy.origin - self.origin);
	
	// reset our owner regularly, or else a zalball that passes through a notrace-invisible
	// player will become owned by the player and remain nonsolid to them after the ring ends
	self.owner = self.trueowner;
	// if the projectile is inside a notrace entity at this time, it'll touch again this frame
	// and reset anyway, so this state will pingpong until it passes out the other side
	
	// go faster at long distance to close the gap, so snipey zalaraxi have a better presence
	dist = vlen(self.enemy.origin - self.origin);
	dist = saturate( (dist-200) / 600 );
	
	// Zalaraxi's missiles have poor homing, though they move faster on Nightmare
	if (skill < 3)
	{
		if (dot > 0)
		{
			rate *= max(1, 1.5 * (1 - dot));
		}
		self.velocity = 600 * WrathTurnToward(self.enemy.origin, rate * 0.33);
	}
	else
	{
		if (dot > 0)
		{
			rate *= max(1, 1.5 * (1 - dot));
		}
		self.velocity = 700 * WrathTurnToward(self.enemy.origin, rate * 0.33);
	}
		
	self.velocity *= 1 + dist;
	self.velocity += Vector(crandom(),crandom(),crandom()) * 16;
	self.oldvelocity = self.velocity;	
}


void() ZalaraxMissile =
{
	entity 	missile;
	vector	dir, zorg;

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

	zorg = self.origin + v_forward*20 + v_up*16;
	
	if (skill == 3)
		missile = launch_projectile(zorg, dir * 700, "wrathball");
	else
		missile = launch_projectile(zorg, dir * 600, "wrathball");

	SUB_ChangeModel (missile, "progs/zal_ball.mdl");

	missile.avelocity = '300 300 300';
	missile.nextthink = time + 0.1;
	missile.think = ZalaraxHome;
	missile.enemy = self.enemy;
	missile.touch = ZalaraxMissileTouch;
	missile.lifetime_finished = time + 30;	 // blow up after a while
}

// =======================================================

void()  overlord_stand1 =[	$s_wtwk01,	overlord_stand1 ] { ai_stand();}

void()	overlord_walk01 =[	$s_wtwk01,	overlord_walk02 ] { ai_walk(8); }
void()	overlord_walk02 =[	$s_wtwk02,	overlord_walk03 ] { ai_walk(8); }
void()	overlord_walk03 =[	$s_wtwk03,	overlord_walk04 ] { ai_walk(8); }
void()	overlord_walk04 =[	$s_wtwk04,	overlord_walk05 ] { ai_walk(8); }
void()	overlord_walk05 =[	$s_wtwk05,	overlord_walk06 ] { ai_walk(8); }
void()	overlord_walk06 =[	$s_wtwk06,	overlord_walk07 ] { ai_walk(8); }
void()	overlord_walk07 =[	$s_wtwk07,	overlord_walk08 ] { ai_walk(8); }
void()	overlord_walk08 =[	$s_wtwk08,	overlord_walk09 ] { ai_walk(8); }
void()	overlord_walk09 =[	$s_wtwk09,	overlord_walk10 ] { ai_walk(8); }
void()	overlord_walk10 =[	$s_wtwk10,	overlord_walk11 ] { ai_walk(8); }
void()	overlord_walk11 =[	$s_wtwk11,	overlord_walk12 ] { ai_walk(8); }
void()	overlord_walk12 =[	$s_wtwk12,	overlord_walk13 ] { ai_walk(8); }
void()	overlord_walk13 =[	$s_wtwk13,	overlord_walk14 ] { ai_walk(8); }
void()	overlord_walk14 =[	$s_wtwk14,	overlord_walk15 ] { ai_walk(8); }
void()	overlord_walk15 =[	$s_wtwk15,	overlord_walk01 ] { ai_walk(8); }

void()	overlord_run01 =[ $s_wtwk01,	overlord_run02 ] { ai_run(12); }
void()	overlord_run02 =[ $s_wtwk02,	overlord_run03 ] { ai_run(12); }
void()	overlord_run03 =[ $s_wtwk03,	overlord_run04 ] { ai_run(12); }
void()	overlord_run04 =[ $s_wtwk04,	overlord_run05 ] { ai_run(12); }
void()	overlord_run05 =[ $s_wtwk05,	overlord_run06 ] { ai_run(12); }
void()	overlord_run06 =[ $s_wtwk06,	overlord_run07 ] { ai_run(12); }
void()	overlord_run07 =[ $s_wtwk07,	overlord_run08 ] { ai_run(12); }
void()	overlord_run08 =[ $s_wtwk08,	overlord_run09 ] { ai_run(12); }
void()	overlord_run09 =[ $s_wtwk09,	overlord_run10 ] { ai_run(12); }
void()	overlord_run10 =[ $s_wtwk10,	overlord_run11 ] { ai_run(12); }
void()	overlord_run11 =[ $s_wtwk11,	overlord_run12 ] { ai_run(12); }
void()	overlord_run12 =[ $s_wtwk12,	overlord_run13 ] { ai_run(12); }
void()	overlord_run13 =[ $s_wtwk13,	overlord_run14 ] { ai_run(12); }
void()	overlord_run14 =[ $s_wtwk14,	overlord_run15 ] { ai_run(12); }
void()	overlord_run15 =[ $s_wtwk15,	overlord_run01 ] { ai_run(12); }

// =================================================
// overlord hand-to-hand attack
// =================================================
void() zalarax_smash =
{
	local vector	delta;
	local float		smashDmg;
	
	if (!self.enemy)
		return;
	if (!CanDamage (self.enemy, self.origin))
		return;

	ai_charge(10);

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;

	if (skill == 3)
		smashDmg = 28 + random () * 12;
	else
		smashDmg = 20 + random () * 10;
	
	sound (self, CHAN_WEAPON, "s_wrath/smash.wav", 1, ATTN_NORM);
    T_Damage (self.enemy, self, self, smashDmg);
	delta = normalize (self.enemy.origin - self.origin + self.enemy.view_ofs);
	SpawnBlood ( self.enemy.origin - delta * 30, delta * -100, smashDmg);
}

void()	overlord_at_a01 =[	$s_wtaa01, overlord_at_a02 ] { ai_charge(12);}
void()	overlord_at_a02 =[	$s_wtaa02, overlord_at_a03 ] { ai_charge(12);}
void()	overlord_at_a03 =[	$s_wtaa03, overlord_at_a04 ] { ai_charge(12);}
void()	overlord_at_a04 =[	$s_wtaa04, overlord_at_a05 ] { ai_charge(12);}
void()	overlord_at_a05 =[	$s_wtaa05, overlord_at_a06 ] { ai_charge(12);}
void()	overlord_at_a06 =[	$s_wtaa06, overlord_at_a07 ] { ai_charge(12);}
void()  overlord_at_a07 =[  $s_wtaa07, overlord_at_a08 ] {zalarax_smash();}
void()	overlord_at_a08 =[	$s_wtaa08, overlord_at_a09 ] { ai_charge(12);}
void()	overlord_at_a09 =[	$s_wtaa09, overlord_at_a10 ] { ai_charge(12);}
void()	overlord_at_a10 =[	$s_wtaa10, overlord_run01 ] { ai_charge(12);}

void()	overlord_at_b01 =[	$s_wtab01,	overlord_at_b02 ] { ai_charge(12);}
void()	overlord_at_b02 =[	$s_wtab02,	overlord_at_b03 ] { ai_charge(12);}
void()	overlord_at_b03 =[	$s_wtab03,	overlord_at_b04 ] { ai_charge(12);}
void()	overlord_at_b04 =[	$s_wtab04,	overlord_at_b05 ] { ai_charge(12);}
void()	overlord_at_b05 =[	$s_wtab05,	overlord_at_b06 ] { ai_charge(12);}
void()  overlord_at_b06 =[  $s_wtab06,  overlord_at_b07 ] { ai_charge(12);}
void()	overlord_at_b07 =[	$s_wtab07,	overlord_at_b08 ] { ai_charge(12);}
void()  overlord_at_b08 =[  $s_wtab08,  overlord_at_b09 ] {zalarax_smash();}
void()	overlord_at_b09 =[	$s_wtab09,	overlord_at_b10 ] { ai_charge(12);}
void()	overlord_at_b10 =[	$s_wtab10,	overlord_at_b11 ] { ai_charge(12);}
void()	overlord_at_b11 =[	$s_wtab11,	overlord_at_b12 ] { ai_charge(12);}
void()	overlord_at_b12 =[	$s_wtab12,	overlord_at_b13 ] { ai_charge(12);}
void()	overlord_at_b13 =[	$s_wtab13,	overlord_at_b14 ] { ai_charge(12);}
void()	overlord_at_b14 =[	$s_wtab14,	overlord_run01 ] { ai_charge(12);}

void()	overlord_at_c01 =[	$s_wtac01,	overlord_at_c02 ] { ai_charge(12);}
void()	overlord_at_c02 =[	$s_wtac02,	overlord_at_c03 ] { ai_charge(12);}
void()	overlord_at_c03 =[	$s_wtac03,	overlord_at_c04 ] { ai_charge(12);}
void()	overlord_at_c04 =[	$s_wtac04,	overlord_at_c05 ] { ai_charge(12);}
void()	overlord_at_c05 =[	$s_wtac05,	overlord_at_c06 ] { ai_charge(12);}
void()  overlord_at_c06 =[  $s_wtac06,  overlord_at_c07 ] {zalarax_smash();}
void()	overlord_at_c07 =[	$s_wtac07,	overlord_at_c08 ] { ai_charge(12);}
void()	overlord_at_c08 =[	$s_wtac08,	overlord_at_c09 ] { ai_charge(12);}
void()	overlord_at_c09 =[	$s_wtac09,	overlord_at_c10 ] { ai_charge(12);}
void()	overlord_at_c10 =[	$s_wtac10,	overlord_at_c11 ] { ai_charge(12);}
void()  overlord_at_c11 =[  $s_wtac11,  overlord_at_c12 ] {zalarax_smash();}
void()	overlord_at_c12 =[	$s_wtac12,	overlord_at_c13 ] { ai_charge(12);}
void()	overlord_at_c13 =[	$s_wtac13,	overlord_at_c14 ] { ai_charge(12);}
void()	overlord_at_c14 =[	$s_wtac14,	overlord_run01 ] { ai_charge(12);}

void() zalarax_melee =
{
	local float r;

	r = random();

	if (r < 0.33)
	{
		overlord_at_a01 ();
	}
	else if (r < 0.66)
	{
		overlord_at_b01 ();
	}
	else
	{
		overlord_at_c01 ();
	}
}

// ==================================================
// missile attacks
// ==================================================
void() overlord_msl_a01 =[ $s_wtba01, overlord_msl_a02 ] { ai_charge(12);}
void() overlord_msl_a02 =[ $s_wtba02, overlord_msl_a03 ] { ai_charge(12);}
void() overlord_msl_a03 =[ $s_wtba03, overlord_msl_a04 ] { ai_charge(12);}
void() overlord_msl_a04 =[ $s_wtba04, overlord_msl_a05 ] { ai_charge(12);}
void() overlord_msl_a05 =[ $s_wtba05, overlord_msl_a06 ] { ai_charge(12);}
void() overlord_msl_a06 =[ $s_wtba06, overlord_msl_a07 ] {ZalaraxMissile();}
void() overlord_msl_a07 =[ $s_wtba07, overlord_msl_a08 ] { ai_charge(12);}
void() overlord_msl_a08 =[ $s_wtba08, overlord_msl_a09 ] { ai_charge(12);}
void() overlord_msl_a09 =[ $s_wtba09, overlord_msl_a10 ] { ai_charge(12);}
void() overlord_msl_a10 =[ $s_wtba10, overlord_msl_a11 ] { ai_charge(12);}
void() overlord_msl_a11 =[ $s_wtba11, overlord_msl_a12 ] { ai_charge(12);}
void() overlord_msl_a12 =[ $s_wtba12, overlord_run01 ] {zalarax_teleport(0.5);}

void() zalarax_missile = 
{
	local float r;
	r = random();

	overlord_msl_a01();
}

// ==================================================
// pain
// ==================================================
void()	overlord_pn_a01	=[	$s_wtpa01,	overlord_pn_a02	] {ai_nop();}
void()	overlord_pn_a02	=[	$s_wtpa02,	overlord_pn_a03	] {ai_nop();}
void()  overlord_pn_a03 =[  $s_wtpa03,  overlord_pn_a04 ] {ai_nop(); zalarax_teleport(0.7);}
void()	overlord_pn_a04	=[	$s_wtpa04,	overlord_pn_a05	] {ai_nop();}
void()	overlord_pn_a05	=[	$s_wtpa05,	overlord_pn_a06	] {ai_nop();}
void()	overlord_pn_a06	=[	$s_wtpa06,	overlord_pn_a07	] {ai_nop();}
void()	overlord_pn_a07	=[	$s_wtpa07,	overlord_run01  ] {ai_nop();}

void()	overlord_pn_b01	=[	$s_wtpb01,	overlord_pn_b02	] {ai_nop();}
void()	overlord_pn_b02	=[	$s_wtpb02,	overlord_pn_b03	] {ai_nop();}
void()  overlord_pn_b03 =[  $s_wtpb03,  overlord_pn_b04 ] {ai_nop(); zalarax_teleport(0.7);}
void()	overlord_pn_b04	=[	$s_wtpb04,	overlord_pn_b05	] {ai_nop();}
void()	overlord_pn_b05	=[	$s_wtpb05,	overlord_pn_b06	] {ai_nop();}
void()	overlord_pn_b06	=[	$s_wtpb06,	overlord_pn_b07	] {ai_nop();}
void()	overlord_pn_b07	=[	$s_wtpb07,	overlord_run01  ] {ai_nop();}


void(entity attacker, float damage) zalarax_pain = 
{
	if (self.health <= 0) return;
	if (self.pain_finished > time) return;

	local float r;

	r = random();

	if (skill == 3)
		r = r * 1.1;
	
	if (r > 0.2)
		return;
			
	if (r < 0.15)
		overlord_pn_a01 ();
	else 
		overlord_pn_b01 ();

	PainFinished(2);
	sound (self, CHAN_VOICE, "wrath/wpain.wav", 1, ATTN_NORM);
}

// note - death frame 9 is intentionally done twice.
void()	overlord_die01 =[ $s_wtdt01, overlord_die02 ] {self.nextthink = time +0.05;}
void()	overlord_die02 =[ $s_wtdt02, overlord_die03 ] 
	{ self.flags = self.flags | FL_FLY; self.nextthink = time +0.05;}
void()	overlord_die03 =[ $s_wtdt03, overlord_die04 ] {self.nextthink = time +0.05;}
void()	overlord_die04 =[ $s_wtdt04, overlord_die05 ] {self.nextthink = time +0.05;}
void()	overlord_die05 =[ $s_wtdt05, overlord_die06 ] {self.nextthink = time +0.05;}
void()	overlord_die06 =[ $s_wtdt06, overlord_die07 ] {self.nextthink = time +0.05;}
void()	overlord_die07 =[ $s_wtdt07, overlord_die08 ] {self.nextthink = time +0.05;}
void()	overlord_die08 =[ $s_wtdt08, overlord_die09 ] {self.nextthink = time +0.05;}
void()	overlord_die09 =[ $s_wtdt09, overlord_die10 ] {self.nextthink = time +0.05;}
void()	overlord_die10 =[ $s_wtdt09, overlord_die11 ] {self.nextthink = time +0.05;}
void()	overlord_die11 =[ $s_wtdt10, overlord_die12 ] {self.nextthink = time +0.05;}
void()	overlord_die12 =[ $s_wtdt11, overlord_die13 ] {self.nextthink = time +0.05;}
void()	overlord_die13 =[ $s_wtdt12, overlord_die14 ] {self.nextthink = time +0.05;}
void()	overlord_die14 =[ $s_wtdt13, overlord_die15 ] {self.nextthink = time +0.05;}
void()	overlord_die15 =[ $s_wtdt14, overlord_die16 ] {self.nextthink = time +0.05;}
void()	overlord_die16 =[ $s_wtdt15, overlord_die17 ] {self.nextthink = time +0.05;}
void()	overlord_die17 =[ $s_wtdt16, overlord_die17 ]
{
	ThrowGib ("progs/s_wrtgb2.mdl", GibVelocityForHealth(self.health));
	ThrowGib ("progs/s_wrtgb3.mdl", GibVelocityForHealth(self.health));
	ThrowGib ("progs/wrthgib1.mdl", GibVelocityForHealth(self.health));
	ThrowGib ("progs/wrthgib2.mdl", GibVelocityForHealth(self.health));
	ThrowGib ("progs/wrthgib3.mdl", GibVelocityForHealth(self.health));
	T_RadiusDamage (self, self, 80, world, DMGTYPE_EXPLOSION);

	BecomeExplosion();
}

//========
void() monster_zalarax_spawn =
{
	self.classname = "monster_zalarax";
	self.type = "wrathkin";
	self.noselfbomb = 1;
		
	self.solid = SOLID_SLIDEBOX;
	//self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/zalarax.mdl");

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	if (!self.health)
	self.health = 1200;
	self.pain_finished = 0;
	self.alpha = 0.5;

	self.th_stand = overlord_stand1;
	self.th_walk = overlord_walk01;
	self.th_run = overlord_run01;
	self.th_missile = zalarax_missile;
	self.th_melee = zalarax_melee;
	self.th_pain = zalarax_pain;
	self.th_die = overlord_die02;
	self.th_checkattack = CheckAttack;

	if (self.deathtype == string_null)
		self.deathtype = "was erased by a Zalarax";

	self.height = zeroconvertdefault(self.height, 35);
	self.jump_flag = self.height;	// remember original value for short term nav tweaking
	flymonster_start();
}

void() monster_zalarax_spawner = {mon_spawner_use(monster_zalarax_spawn);}

/*QUAKED monster_zalarax (1 0 0) (-16 -16 -24) (16 16 40) AMBUSH ? ? ? TRIGGERED NOTFOG NOTELEFRAG INSTAWAKE
Zalarax, 1200 health points.

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
@PointClass base(Monster) size(-16 -16 -24, 16 16 40) model({ "path": ":progs/zalarax.mdl" }) = monster_zalarax : "Zalarax

Default health = 1200"
[
health(integer) : "Custom health amount"
]
*/
void() monster_zalarax =
{
	if (!SUB_ShouldSpawn()) return;
	if (nomonster()) return;
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/zalarax.mdl");
	precache_model ("progs/zal_ball.mdl");
	precache_model ("progs/wrthgib1.mdl");
	precache_model ("progs/wrthgib2.mdl");
	precache_model ("progs/wrthgib3.mdl");
	precache_model ("progs/s_wrtgb2.mdl");
	precache_model ("progs/s_wrtgb3.mdl");

	precache_sound ("wrath/wsee.wav");
	precache_sound ("wrath/watt.wav");
	precache_sound ("wrath/wpain.wav");
	precache_sound ("wrath/wdthc.wav");
	precache_sound ("s_wrath/smash.wav");

	if (!self.health)
	self.health = 1200;
	//setsize (self, '-16 -16 -24', '16 16 40');
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	if ( monster_spawnsetup( monster_zalarax_spawner ) ) return;
	
	addmonster(1);
	monster_zalarax_spawn();
}
