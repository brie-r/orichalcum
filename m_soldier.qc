/*
==============================================================================

SOLDIER / PLAYER

==============================================================================
*/

$cd id1/models/soldier3
$origin 0 -6 24
$base base		
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10

$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11

$frame load1 load2 load3 load4 load5 load6 load7 load8 load9 load10 load11

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 painc9 painc10
$frame painc11 painc12 painc13

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6 shoot7 shoot8 shoot9

$frame prowl_1 prowl_2 prowl_3 prowl_4 prowl_5 prowl_6 prowl_7 prowl_8
$frame prowl_9 prowl_10 prowl_11 prowl_12 prowl_13 prowl_14 prowl_15 prowl_16
$frame prowl_17 prowl_18 prowl_19 prowl_20 prowl_21 prowl_22 prowl_23 prowl_24

// J_D: nailgunner and rocketeer stuff here
vector() soldierguy_muzzle_org =
{
	vector vec, right;
	vec = normalize(enemy_vispos() - self.origin);
	right = CrossProduct(vec, '0 0 1');

	return (self.origin + vec * 30 + right * 5 + '0 0 12');
}

float() soldierguy_clear_attack =
{
	vector spot1, spot2;

	if (has_invis(self.enemy)) return TRUE;	// blast away

	spot1 = soldierguy_muzzle_org();
	spot2 = enemy_vispos() + self.enemy.view_ofs;

	traceline2(spot1, spot2, self, TRACE_WATER);

	if (trace_inopen && trace_inwater) return FALSE;	// sight line crossed contents
	if (trace_ent != self.enemy) return FALSE;			// don't have a clear shot
	return TRUE;
}

float() nailgunner_check_attack =
{
	local float chance;

	if (time < self.attack_finished) return FALSE;
	if (enemy_range >= RANGE_FAR) return FALSE;
	if (!soldierguy_clear_attack()) return FALSE;

	if (enemy_range == RANGE_MELEE)
		chance = 0.9;
	else if (enemy_range == RANGE_NEAR)
		chance = 0.4;
	else if (enemy_range == RANGE_MID)
		chance = 0.1;
	else
		chance = 0;

	if (self.goalentity.classname == "path_angry") chance = chance * 0.2;

	if (random() < chance)
	{
		self.attack_state = AS_MISSILE;

		if (self.goalentity.classname == "path_angry")
			ai_attack_finished (2 + random() + random());
		else
			ai_attack_finished (1 + random() + random());

		return TRUE;
	}

	return FALSE;
}

float() rocketeer_check_attack =
{
	local float chance;

	if (time < self.attack_finished) return FALSE;
	if (enemy_range >= RANGE_FAR) return FALSE;
	if (!soldierguy_clear_attack()) return FALSE;

	if (enemy_range >= RANGE_FAR)
			return FALSE;

	chance = 0.9;
	if (self.goalentity.classname == "path_angry") chance = chance * 0.2;

	if (random() < chance)
	{
		self.attack_state = AS_MISSILE;

		if (self.goalentity.classname == "path_angry")
			ai_attack_finished (3 + random() + random());
		else
			ai_attack_finished (1 + random() + random());

		return TRUE;
	}

	return FALSE;
}

/*
==============================================================================
SOLDIER CODE
==============================================================================
*/

void()	army_stand1	=[	$stand1,	army_stand2	] {ai_stand();}
void()	army_stand2	=[	$stand2,	army_stand3	] {ai_stand();}
void()	army_stand3	=[	$stand3,	army_stand4	] {ai_stand();}
void()	army_stand4	=[	$stand4,	army_stand5	] {ai_stand();}
void()	army_stand5	=[	$stand5,	army_stand6	] {ai_stand();}
void()	army_stand6	=[	$stand6,	army_stand7	] {ai_stand();}
void()	army_stand7	=[	$stand7,	army_stand8	] {ai_stand();}
void()	army_stand8	=[	$stand8,	army_stand1	] {ai_stand();}

void()	army_walk1	=[	$prowl_1,	army_walk2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
ai_walk(1);}
void()	army_walk2	=[	$prowl_2,	army_walk3	] {ai_walk(1);}
void()	army_walk3	=[	$prowl_3,	army_walk4	] {ai_walk(1);}
void()	army_walk4	=[	$prowl_4,	army_walk5	] {ai_walk(1);}
void()	army_walk5	=[	$prowl_5,	army_walk6	] {ai_walk(2);}
void()	army_walk6	=[	$prowl_6,	army_walk7	] {ai_walk(3);}
void()	army_walk7	=[	$prowl_7,	army_walk8	] {ai_walk(4);}
void()	army_walk8	=[	$prowl_8,	army_walk9	] {ai_walk(4);}
void()	army_walk9	=[	$prowl_9,	army_walk10	] {ai_walk(2);}
void()	army_walk10	=[	$prowl_10,	army_walk11	] {ai_walk(2);}
void()	army_walk11	=[	$prowl_11,	army_walk12	] {ai_walk(2);}
void()	army_walk12	=[	$prowl_12,	army_walk13	] {ai_walk(1);}
void()	army_walk13	=[	$prowl_13,	army_walk14	] {ai_walk(0);}
void()	army_walk14	=[	$prowl_14,	army_walk15	] {ai_walk(1);}
void()	army_walk15	=[	$prowl_15,	army_walk16	] {ai_walk(1);}
void()	army_walk16	=[	$prowl_16,	army_walk17	] {ai_walk(1);}
void()	army_walk17	=[	$prowl_17,	army_walk18	] {ai_walk(3);}
void()	army_walk18	=[	$prowl_18,	army_walk19	] {ai_walk(3);}
void()	army_walk19	=[	$prowl_19,	army_walk20	] {ai_walk(3);}
void()	army_walk20	=[	$prowl_20,	army_walk21	] {ai_walk(3);}
void()	army_walk21	=[	$prowl_21,	army_walk22	] {ai_walk(2);}
void()	army_walk22	=[	$prowl_22,	army_walk23	] {ai_walk(1);}
void()	army_walk23	=[	$prowl_23,	army_walk24	] {ai_walk(1);}
void()	army_walk24	=[	$prowl_24,	army_walk1	] {ai_walk(1);}

void()	army_run1	=[	$run1,		army_run2	] {
if (random() < 0.2 && time > self.show_hostile)
	sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
ai_run(11);}
void()	army_run2	=[	$run2,		army_run3	] {ai_run(15);}
void()	army_run3	=[	$run3,		army_run4	] {ai_run(10);}
void()	army_run4	=[	$run4,		army_run5	] {ai_run(10);}
void()	army_run5	=[	$run5,		army_run6	] {ai_run(8);}
void()	army_run6	=[	$run6,		army_run7	] {ai_run(15);}
void()	army_run7	=[	$run7,		army_run8	] {ai_run(10);}
void()	army_run8	=[	$run8,		army_run1	] {ai_run(8);}

void()	army_atk1	=[	$shoot1,	army_atk2	] {nmfast();ai_face();}
void()	army_atk2	=[	$shoot2,	army_atk3	] {nmfast();ai_face();}
void()	army_atk3	=[	$shoot3,	army_atk4	] {nmfast();ai_face(); army_aim(); }
void()	army_atk4	=[	$shoot4,	army_atk5	] {nmfast();ai_face();}
void()	army_atk5	=[	$shoot5,	army_atk6	] {nmfast();ai_face(); army_fire(); }
void()	army_atk6	=[	$shoot6,	army_atk7	] {ai_face();}
void()	army_atk7	=[	$shoot7,	army_atk8	] {ai_face(); ai_check_refire (army_atk3);}
void()	army_atk8	=[	$shoot8,	army_atk9	] {ai_face(); ai_attack_finished (0.3 + random() + random());}
void()	army_atk9	=[	$shoot9,	army_run1	] {ai_face();}

void()	nailer_atk1	=[	$shoot1,	nailer_atk2	] {nmfast();ai_face();}
void()	nailer_atk2	=[	$shoot2,	nailer_atk3	] {nmfast();ai_face();}
void()	nailer_atk3	=[	$shoot3,	nailer_atk4	] {nmfast();ai_face();}
void()	nailer_atk4	=[	$shoot4,	nailer_atk5	] {nmfast();ai_face();}
void()	nailer_atk5	=[	$shoot5,	nailer_atk6	] {nmfast();ai_face();nailer_fire();}
void()	nailer_atk6	=[	$shoot5,	nailer_atk7	] {nmfast();ai_face();nailer_fire();}
void()	nailer_atk7	=[	$shoot5,	nailer_atk8	] {nmfast();ai_face();nailer_fire();}
void()	nailer_atk8	=[	$shoot5,	nailer_atk9	] {nmfast();ai_face();nailer_fire();}
void()	nailer_atk9	=[	$shoot6,	nailer_atk10] {ai_face();}
void()	nailer_atk10=[	$shoot7,	nailer_atk11] {ai_face(); ai_check_refire (nailer_atk3);}
void()	nailer_atk11=[	$shoot8,	nailer_atk12] {ai_face(); ai_attack_finished (0.9 + random());}
void()	nailer_atk12=[	$shoot9,	army_run1	] {ai_face();}

void()	rock_atk1	=[	$shoot1,	rock_atk2	] {nmfast();ai_face();}
void()	rock_atk2	=[	$shoot2,	rock_atk3	] {nmfast();ai_face();}
void()	rock_atk3	=[	$shoot3,	rock_atk4	] {nmfast();ai_face();}
void()	rock_atk4	=[	$shoot4,	rock_atk5	] {nmfast();ai_face();}
void()	rock_atk5	=[	$shoot5,	rock_atk6	] {nmfast();ai_face(); rocketeer_fire(); }
void()	rock_atk6	=[	$shoot6,	rock_atk7	] {ai_face();}
void()	rock_atk7	=[	$shoot7,	rock_atk8	] {ai_face();}
void()	rock_atk8	=[	$shoot8,	rock_atk9	] {ai_face(); ai_attack_finished (0.9 + random());}
void()	rock_atk9	=[	$shoot9,	army_run1	] {ai_face();}


void()	army_pain1	=[	$pain1,		army_pain2	] {}
void()	army_pain2	=[	$pain2,		army_pain3	] {}
void()	army_pain3	=[	$pain3,		army_pain4	] {}
void()	army_pain4	=[	$pain4,		army_pain5	] {}
void()	army_pain5	=[	$pain5,		army_pain6	] {}
void()	army_pain6	=[	$pain6,		army_run1	] {ai_pain(1);}

void()	army_painb1	=[	$painb1,	army_painb2	] {}
void()	army_painb2	=[	$painb2,	army_painb3	] {ai_painforward(13);}
void()	army_painb3	=[	$painb3,	army_painb4	] {ai_painforward(9);}
void()	army_painb4	=[	$painb4,	army_painb5	] {}
void()	army_painb5	=[	$painb5,	army_painb6	] {}
void()	army_painb6	=[	$painb6,	army_painb7	] {}
void()	army_painb7	=[	$painb7,	army_painb8	] {}
void()	army_painb8	=[	$painb8,	army_painb9	] {}
void()	army_painb9	=[	$painb9,	army_painb10] {}
void()	army_painb10=[	$painb10,	army_painb11] {}
void()	army_painb11=[	$painb11,	army_painb12] {}
void()	army_painb12=[	$painb12,	army_painb13] {ai_pain(2);}
void()	army_painb13=[	$painb13,	army_painb14] {}
void()	army_painb14=[	$painb14,	army_run1	] {}

void()	army_painc1	=[	$painc1,	army_painc2	] {}
void()	army_painc2	=[	$painc2,	army_painc3	] {ai_pain(1);}
void()	army_painc3	=[	$painc3,	army_painc4	] {}
void()	army_painc4	=[	$painc4,	army_painc5	] {}
void()	army_painc5	=[	$painc5,	army_painc6	] {ai_painforward(1);}
void()	army_painc6	=[	$painc6,	army_painc7	] {ai_painforward(1);}
void()	army_painc7	=[	$painc7,	army_painc8	] {}
void()	army_painc8	=[	$painc8,	army_painc9	] {ai_pain(1);}
void()	army_painc9	=[	$painc9,	army_painc10] {ai_painforward(4);}
void()	army_painc10=[	$painc10,	army_painc11] {ai_painforward(3);}
void()	army_painc11=[	$painc11,	army_painc12] {ai_painforward(6);}
void()	army_painc12=[	$painc12,	army_painc13] {ai_painforward(8);}
void()	army_painc13=[	$painc13,	army_run1] {}

void(entity attacker, float damage)	army_pain =
{
	local float r;
	
	if (self.pain_finished > time)
		return;

	r = random();

	if (r < 0.2)
	{
		PainFinished(0.6);
		army_pain1 ();
		sound (self, CHAN_VOICE, "soldier/pain1.wav", 1, ATTN_NORM);
	}
	else if (r < 0.6)
	{
		PainFinished(1.1);
		army_painb1 ();
		sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
	}
	else
	{
		PainFinished(1.1);
		army_painc1 ();
		sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
	}
}

/*
vanilla grunts pretend to lag their shots by applying negative leading based
on player velocity. SV_PushMove only sets origins per hostframe and doesn't 
modify velocities, so a player standing on a train or a lift will have zero 
velocity and get drilled constantly. (see: SMEJ w1m1)

grunts now choose an aim vector 0.3 seconds before firing, rather than trying 
to work 0.2 seconds backwards at firing time
*/
void() army_aim =
{
	// store it relative to self in case we're riding the same mover as our target
	self.dest = enemy_vispos() + enemy_aim_vertical() - self.origin;
}

void() army_fire =
{
	local	vector	dir;
	
	ai_face();
	self.effects = self.effects | EF_MUZZLEFLASH;	
	sound (self, CHAN_WEAPON, "soldier/sattck1.wav", 1, ATTN_NORM);	

// fire somewhat behind the player, so a dodging player is harder to hit
//	dir = enemy_vispos() - self.enemy.velocity*0.2;
//	dir = normalize (dir - self.origin);
	dir = normalize (self.dest);

	// lunaran: moved multidamage here
	ClearMultiDamage ();
	FireBullets (4, dir, '0.1 0.1 0');
	ApplyMultiDamage ();
}

// J_D: the nailgunner's attack
void() nailer_fire =
{
    vector org, vec;

	ai_face();
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);

	org = soldierguy_muzzle_org();
    vec = normalize(enemy_vispos() - org + enemy_aim_vertical());
	makevectors (self.angles);

	if (angledif(self.ideal_yaw, self.angles_y) > 80)	// no ass nails
	{
		vec_x = v_forward_x;
		vec_y = v_forward_y;
		vec = normalize(vec);
	}

	launch_nail(org, vec * 1000);
}

// J_D: the rocketeer's attack
void() rocketeer_missile_touch =
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
		T_RadiusDamage (self, self.trueowner, 100, world, DMGTYPE_EXPLOSION);
	else
		T_RadiusDamage (self, self.trueowner, 50, world, DMGTYPE_EXPLOSION);

	self.origin = self.origin - 8*normalize(self.velocity);
	T_ExplosiveTouch();
}

void() rocketeer_fire =
{
	vector org, vec;
	entity missile;

	ai_face();
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	org = soldierguy_muzzle_org();
    vec = normalize(enemy_vispos() - org + enemy_aim_vertical());
	makevectors (self.angles);

	if (angledif(self.ideal_yaw, self.angles_y) > 80)	// no ass rockets
	{
		vec_x = v_forward_x;
		vec_y = v_forward_y;
		vec = normalize(vec);
	}

	if (skill == 3)
		missile = launch_rocket (org, vec * 900);
	else
		missile = launch_rocket (org, vec * 800);
	missile.touch = rocketeer_missile_touch;
}


/*
===========
SoldierCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() SoldierCheckAttack =
{
	local float		chance;

	if (time < self.attack_finished)
		return FALSE;
		
	if (enemy_range >= RANGE_FAR)
		return FALSE;
		
	if (!CheckClearAttack()) return FALSE;

	// missile attack
	
	if (enemy_range == RANGE_MELEE)
		chance = 0.9;
	else if (enemy_range == RANGE_NEAR)
		chance = 0.4;
	else if (enemy_range == RANGE_MID)
		chance = 0.05;
	else
		chance = 0;

	if (self.goalentity.classname == "path_angry") chance = chance * 0.2;

	if (random () < chance)
	{
		self.attack_state = AS_MISSILE;

		if (self.goalentity.classname == "path_angry")
			ai_attack_finished (3 + random() + random());
		else
			ai_attack_finished (1 + random() + random());

		return TRUE;
	}

	return FALSE;
}
//=============================================================================


// J_D: dropammo function for grunts and nailgunners; rocketeers don't drop ammo
void() human_lesser_dropammo =
{
	if (self.classname == "monster_nailgunner")
	{
		self.ammo_nails = 5;
		DropBackpack();
	}
	else if (self.classname == "monster_army")
	{
		self.ammo_shells = 5;
		DropBackpack();
	}
}


void()	army_die1	=[	$death1,	army_die2	] {}
void()	army_die2	=[	$death2,	army_die3	] {}
void()	army_die3	=[	$death3,	army_die4	]
{self.solid = SOLID_NOT;human_lesser_dropammo();}
void()	army_die4	=[	$death4,	army_die5	] {}
void()	army_die5	=[	$death5,	army_die6	] {}
void()	army_die6	=[	$death6,	army_die7	] {}
void()	army_die7	=[	$death7,	army_die8	] {}
void()	army_die8	=[	$death8,	army_die9	] {}
void()	army_die9	=[	$death9,	army_die10	] {}
void()	army_die10	=[	$death10,	SUB_Null	] {}

void()	army_cdie1	=[	$deathc1,	army_cdie2	] {}
void()	army_cdie2	=[	$deathc2,	army_cdie3	] {ai_back(5);}
void()	army_cdie3	=[	$deathc3,	army_cdie4	]
{self.solid = SOLID_NOT;human_lesser_dropammo();ai_back(4);}
void()	army_cdie4	=[	$deathc4,	army_cdie5	] {ai_back(13);}
void()	army_cdie5	=[	$deathc5,	army_cdie6	] {ai_back(3);}
void()	army_cdie6	=[	$deathc6,	army_cdie7	] {ai_back(4);}
void()	army_cdie7	=[	$deathc7,	army_cdie8	] {}
void()	army_cdie8	=[	$deathc8,	army_cdie9	] {}
void()	army_cdie9	=[	$deathc9,	army_cdie10	] {}
void()	army_cdie10	=[	$deathc10,	army_cdie11	] {}
void()	army_cdie11	=[	$deathc11,	SUB_Null	] {}


void() army_die =
{
// check for gib
	if (self.health < -35)
	{
		Gib("progs/h_guard.mdl", self.health);
		human_lesser_dropammo();
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "soldier/death1.wav", 1, ATTN_NORM);
	if (random() < 0.5)
		army_die1 ();
	else
		army_cdie1 ();
}

void() monster_army_spawn =
{
	self.classname = "monster_army";
	
	self.solid = SOLID_SLIDEBOX;
	//self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/soldier.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	if (!self.health)
	self.health = 35;

	self.th_stand = army_stand1;
	self.th_walk = army_walk1;
	self.th_run = army_run1;
	self.th_missile = army_atk1;
	self.th_pain = army_pain;
	self.th_die = army_die;
	self.th_checkattack = SoldierCheckAttack;

	if (self.deathtype == string_null)
		self.deathtype = "was shot by a Grunt";

	walkmonster_start ();
}

void() monster_army_spawner = {mon_spawner_use(monster_army_spawn);}

/*QUAKED monster_army (1 0 0) (-16 -16 -24) (16 16 40) AMBUSH ? ? ? TRIGGERED NOTFOG NOTELEFRAG INSTAWAKE
Grunt, 35 health points.

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
@PointClass base(Monster) size(-16 -16 -24, 16 16 40) model({ "path": ":progs/soldier.mdl" }) = monster_army : "Grunt

Default health = 35"
[
health(integer) : "Custom health amount"
]
*/
void() monster_army =
{	
	if (!SUB_ShouldSpawn()) return;
	if (nomonster()) return;
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/soldier.mdl");
	precache_model ("progs/h_guard.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	precache_sound ("soldier/death1.wav");
	precache_sound ("soldier/idle.wav");
	precache_sound ("soldier/pain1.wav");
	precache_sound ("soldier/pain2.wav");
	precache_sound ("soldier/sattck1.wav");
	precache_sound ("soldier/sight1.wav");

	precache_sound ("player/udeath.wav");		// gib death
	if (!self.health)
	self.health = 35;

	setsize (self, '-16 -16 -24', '16 16 40');
	if ( monster_spawnsetup( monster_army_spawner ) ) return;
	
	addmonster(1);
	monster_army_spawn();
}


// J_D: The Nailgunner

void() monster_nailgunner_spawn =
{
	self.classname = "monster_nailgunner";
	self.type = "soldier";
	
	self.solid = SOLID_SLIDEBOX;
	//self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/nailer.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	if (!self.health)
	self.health = 60;

	self.th_stand = army_stand1;
	self.th_walk = army_walk1;
	self.th_run = army_run1;
	self.th_missile = nailer_atk1;
	self.th_pain = army_pain;
	self.th_die = army_die;
	self.th_checkattack = nailgunner_check_attack;

	if (self.deathtype == string_null)
		self.deathtype = "was pierced by a Nailgunner";

	walkmonster_start ();
}

void() monster_nailgunner_spawner = {mon_spawner_use(monster_nailgunner_spawn);}

/*QUAKED monster_nailgunner (1 0 0) (-16 -16 -24) (16 16 40) AMBUSH ? ? ? TRIGGERED NOTFOG NOTELEFRAG INSTAWAKE
Nailgunner, 60 health points.

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
@PointClass base(Monster) size(-16 -16 -24, 16 16 40) model({ "path": ":progs/nailer.mdl" }) = monster_nailgunner : "Nailgunner

Default health = 60"
[
health(integer) : "Custom health amount"
]
*/
void() monster_nailgunner =
{	
	if (!SUB_ShouldSpawn()) return;
	if (nomonster()) return;
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/nailer.mdl");
	precache_model ("progs/h_guard.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	precache_sound ("soldier/death1.wav");
	precache_sound ("soldier/idle.wav");
	precache_sound ("soldier/pain1.wav");
	precache_sound ("soldier/pain2.wav");
	precache_sound ("soldier/sight1.wav");

	precache_sound ("player/udeath.wav");		// gib death
	if (!self.health)
	self.health = 60;

	setsize (self, '-16 -16 -24', '16 16 40');
	if ( monster_spawnsetup( monster_nailgunner_spawner ) ) return;
	
	addmonster(1);
	monster_nailgunner_spawn();
}


// J_D: The Rocketeer

void() monster_rocketeer_spawn =
{
	self.classname = "monster_rocketeer";
	self.type = "soldier";
	self.noselfbomb = 1;
	
	self.solid = SOLID_SLIDEBOX;
	//self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/rocketer.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	if (!self.health)
	self.health = 70;

	self.th_stand = army_stand1;
	self.th_walk = army_walk1;
	self.th_run = army_run1;
	self.th_missile = rock_atk1;
	self.th_pain = army_pain;
	self.th_die = army_die;
	self.th_checkattack = rocketeer_check_attack;

	if (self.deathtype == string_null)
		self.deathtype = "was blasted by a Rocketeer";

	walkmonster_start ();
}

void() monster_rocketeer_spawner = {mon_spawner_use(monster_rocketeer_spawn);}

/*QUAKED monster_rocketeer (1 0 0) (-16 -16 -24) (16 16 40) AMBUSH ? ? ? TRIGGERED NOTFOG NOTELEFRAG INSTAWAKE
Rocketeer, 70 health points.

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
@PointClass base(Monster) size(-16 -16 -24, 16 16 40) model({ "path": ":progs/rocketer.mdl" }) = monster_rocketeer : "Rocketeer

Default health = 70"
[
health(integer) : "Custom health amount"
]
*/
void() monster_rocketeer =
{	
	if (!SUB_ShouldSpawn()) return;
	if (nomonster()) return;
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/rocketer.mdl");
	precache_model ("progs/h_guard.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	precache_sound ("soldier/death1.wav");
	precache_sound ("soldier/idle.wav");
	precache_sound ("soldier/pain1.wav");
	precache_sound ("soldier/pain2.wav");
	precache_sound ("soldier/sight1.wav");

	precache_sound ("player/udeath.wav");		// gib death
	if (!self.health)
	self.health = 70;

	setsize (self, '-16 -16 -24', '16 16 40');
	if ( monster_spawnsetup( monster_rocketeer_spawner ) ) return;
	
	addmonster(1);
	monster_rocketeer_spawn();
}
