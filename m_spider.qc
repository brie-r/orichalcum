/*==============================================================================
SPIDER (Hexen2 model by Raven Software)
==============================================================================*/
$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8
$frame idle9 idle10 idle11 idle12 idle13

$frame idleup1 idleup2 idleup3 idleup4 idleup5 idleup6 idleup7 idleup8
$frame idleup9 idleup10 idleup11 idleup12 idleup13

$frame drop1 drop2 drop3 drop4 drop5 drop6

$frame grow1 grow2 grow3 grow4 grow5 grow6 grow7 grow8 grow9 grow10

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8
$frame walk9 walk10 walk11 walk12 walk13 walk14 walk15 walk16

// Lift spider up on to back legs
$frame atkup1 atkup2 atkup3 atkup4 atkup5 atkup6 atkup7 atkup8
$frame atkup9 atkup10 atkup11 atkup12

// Forward attacking (looping)
$frame atkloop1 atkloop2 atkloop3 atkloop4 atkloop5 atkloop6 atkloop7 atkloop8
$frame atkloop9 atkloop10

// Jumping up
$frame jump1 jump2 jump3 jump4 jump5 jump6 jump7 jump8
$frame jump9 jump10 jump11 jump12 jump13 jump14 jump15 jump16

// on all legs (pain backwards)
$frame paindown1 paindown2 paindown3 paindown4 paindown5 paindown6 paindown7 paindown8
$frame paindown9 paindown10

// On back legs (pain backwards)
$frame painup1 painup2 painup3 painup4 painup5 painup6 painup7 painup8

// roll over death on back (looks odd)
$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12 death13 death14 death15 death16
$frame death17 death18 death19 death20

//======================================================================

const float MON_SPIDER_CEILING = 2;  // spider-spawn-on-ceiling spawnflag

/*
================
spider_bite

================
*/
void() spider_bite =
{
	vector	delta;

	if (!self.enemy)
		return;

	ai_charge(10);
	if (self.deadflag) return;

	if (!CanDamage (self.enemy, self.origin))
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 80)
		return;

	if (random() < 0.5)
		sound (self, CHAN_WEAPON, "spider/atkmunch.wav", 1, ATTN_NORM);
	else
		sound(self, CHAN_WEAPON, "spider/atktear.wav", 1, ATTN_NORM);
		
	T_Damage(self.enemy, self, self, 5 + 4 * random(), DMGTYPE_MELEE);
}

void()	Spider_JumpTouchGround =
{
	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	// jump randomly to not get hung up
			self.touch = SUB_Null;
			self.think = spider_leap1;
			self.nextthink = time + 0.1;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	self.think = spider_run1;
	self.nextthink = time + 0.1;
}

void()	Spider_JumpTouch =
{
	if (self.health <= 0)
		return;
		
	if (other.classname != "monster_spider" &&	other.takedamage)
	{	
		if ( vlen(self.velocity) > 300 )
		{
			if (other.classname != "player" || time > self.touch_time)	// fix for landing on the player's head
			{
				if (other.classname == "player")
				{
					self.touch_time = time + 0.2;
				}
				T_Damage(other, self, self, 5 + 5*random(), DMGTYPE_MELEE);	
			}
		}
	}
	Spider_JumpTouchGround();
}

void() spider_airthink =
{
	self.think = spider_airthink;
	self.nextthink = time + 0.1;
	
	// if three seconds pass, assume spider is stuck and jump again
	if (time >= self.lifetime_finished)
	{
		spider_leap1();
		return;
	}
	// we aren't moving, assume leap is over so we don't get stuck
	if (self.origin == self.oldorigin && self.flags & FL_ONGROUND)
	{
		spider_run1();
		return;
	}
	self.oldorigin = self.origin;
}

// ========

void() spider_idlesound =
{
	local   float   r;

	r = random();
	if (r > 0.9) 
		sound (self, CHAN_VOICE, "spider/idle1.wav", 1, ATTN_IDLE);
	else if (r < 0.1)
		sound (self, CHAN_VOICE, "spider/hiss2.wav", 1, ATTN_IDLE);
}

void() spider_combatidlesound =
{
	local   float   r;

	r = random();
	if (r > 0.9) 
		sound (self, CHAN_VOICE, "spider/idle1.wav", 1, ATTN_IDLE);
	else if (r < 0.1)
		sound (self, CHAN_VOICE, "spider/hiss3.wav", 1, ATTN_IDLE);
}

void() spider_idle1 =[ $idle1, spider_idle2] {ai_stand();
	if (!(self.spawnflags & 1))     // Possibility of sound only if not in ambush mode.
        spider_idlesound();
}
void() spider_idle2 =[ $idle2, spider_idle3] {ai_stand();}
void() spider_idle3 =[ $idle3, spider_idle4] {ai_stand();}
void() spider_idle4 =[ $idle4, spider_idle5] {ai_stand();}
void() spider_idle5 =[ $idle5, spider_idle6] {ai_stand();}
void() spider_idle6 =[ $idle6, spider_idle7] {ai_stand();}
void() spider_idle7 =[ $idle7, spider_idle8] {ai_stand();}
void() spider_idle8 =[ $idle8, spider_idle9] {ai_stand();}
void() spider_idle9 =[ $idle9, spider_idle10] {ai_stand();}
void() spider_idle10 =[ $idle10, spider_idle11] {ai_stand();}
void() spider_idle11 =[ $idle11, spider_idle12] {ai_stand();}
void() spider_idle12 =[ $idle12, spider_idle13] {ai_stand();}
void() spider_idle13 =[ $idle13, spider_idle1] {ai_stand();}


void() spider_walk1 =[ $walk1, spider_walk2] {spider_idlesound(); ai_walk(4);}
void() spider_walk2 =[ $walk3, spider_walk3] {ai_walk(3);}
void() spider_walk3 =[ $walk5, spider_walk4] {ai_walk(4);}
void() spider_walk4 =[ $walk7, spider_walk5] {ai_walk(5);}
void() spider_walk5 =[ $walk9, spider_walk6] {ai_walk(4);}
void() spider_walk6 =[ $walk11, spider_walk7] {ai_walk(3);}
void() spider_walk7 =[ $walk13, spider_walk8] {ai_walk(4);}
void() spider_walk8 =[ $walk15, spider_walk1] {ai_walk(5);}


void()	spider_run1 =[ $walk1, spider_run2 ] {nmfast();spider_combatidlesound();ai_run(12);}
void()	spider_run2 =[ $walk3, spider_run3 ] {nmfast();ai_run(10);}
void()	spider_run3 =[ $walk5, spider_run4 ] {nmfast();ai_run(12);}
void()	spider_run4 =[ $walk7, spider_run5 ] {nmfast();ai_run(14);}
void()	spider_run5 =[ $walk9, spider_run6 ] {nmfast();ai_run(12);}
void()	spider_run6 =[ $walk11, spider_run7 ] {nmfast();ai_run(10);}
void()	spider_run7 =[ $walk13, spider_run8 ] {nmfast();ai_run(12);}
void()	spider_run8 =[ $walk15, spider_run1 ] {nmfast();ai_run(14);}


void() spider_bite1 = [ $atkup1, spider_bite2 ] {nmfast();ai_charge(10);}
void() spider_bite2 = [ $atkup5, spider_bite3 ] {nmfast();ai_charge(10);}
void() spider_bite3 = [ $atkup7, spider_bite4 ] {nmfast();ai_charge(10);}
void() spider_bite4 = [ $atkup9, spider_bite5 ] {nmfast();ai_charge(10);}
void() spider_bite5 = [ $atkup11, spider_bite6 ] {nmfast();ai_charge(10);}
void() spider_bite6 = [ $atkloop1, spider_bite7 ] {nmfast();ai_charge(10);}
void() spider_bite7=[ $atkloop3, spider_bite8 ] {nmfast();ai_charge(10);}
void() spider_bite8 = [ $atkloop5, spider_bite9 ] {nmfast(); spider_bite();}
void() spider_bite9 = [ $atkloop7, spider_bite10 ] {nmfast();ai_charge(10);}
void() spider_bite10 = [ $atkloop9, spider_bite11 ] {nmfast();ai_charge(10);}
void() spider_bite11 = [ $atkup7, spider_bite12 ] {nmfast();ai_charge(10);}
void() spider_bite12 = [ $atkup5, spider_run1 ] {nmfast();ai_charge(10);}


void() spider_leap1 =[ $jump1, spider_leap2 ] {nmfast();ai_face();
	self.jump_flag = time + 2; // Stop jumping so much
	spider_combatidlesound();
}
void() spider_leap2 =[ $jump3, spider_leap3 ] {nmfast();ai_face();}
void() spider_leap3 =[ $jump5, spider_leap4 ] {
	nmfast();
	ai_face();
	self.jump_flag = time + 2; // Stop jumping so much
	ai_attack_finished(0.2);
	if (self.flags & FL_ONGROUND || self.velocity_z == 0)
	{	
		makevectors (self.angles);
		self.flags = not(self.flags, FL_ONGROUND);
		self.velocity = v_forward * 400 + '0 0 200';
		self.touch = Spider_JumpTouch;
	}
}
void() spider_leap4 =[ $jump7, spider_leap5 ] {nmfast();}
void() spider_leap5 =[ $jump8, spider_leap6 ] {nmfast();}
void() spider_leap6 =[ $jump9, spider_leap7 ] {nmfast();}
void() spider_leap7 =[ $jump10, spider_leap8 ] {nmfast();}
void() spider_leap8 =[ $jump11, spider_leap9] {nmfast();};
void() spider_leap9 =[ $jump13, spider_leap10] {nmfast();};
void() spider_leap10 =[ $jump15, spider_airthink] {
	self.oldorigin = self.origin;
	self.lifetime_finished = time + 1;
}


//======================================================================
// CEILING SPIDERS - Idle/Drop/Touch/Land functions
//======================================================================
void()	spider_idleup1	=[	$idleup1,	spider_idleup2	] {ai_stand();
	if (!(self.spawnflags & 1))     // Possibility of sound only if not in ambush mode.
        spider_idlesound();
}
void()	spider_idleup2	=[	$idleup2,	spider_idleup3	] {ai_stand();}
void()	spider_idleup3	=[	$idleup3,	spider_idleup4	] {ai_stand();}
void()	spider_idleup4	=[	$idleup4,	spider_idleup5	] {ai_stand();}
void()	spider_idleup5	=[	$idleup5,	spider_idleup6	] {ai_stand();}
void()	spider_idleup6	=[	$idleup6,	spider_idleup7	] {ai_stand();}
void()	spider_idleup7	=[	$idleup7,	spider_idleup8	] {ai_stand();}
void()	spider_idleup8	=[	$idleup8,	spider_idleup9	] {ai_stand();}
void()	spider_idleup9	=[	$idleup9,	spider_idleup10	] {ai_stand();}
void()	spider_idleup10	=[	$idleup10,	spider_idleup11	] {ai_stand();}
void()	spider_idleup11	=[	$idleup11,	spider_idleup12	] {ai_stand();}
void()	spider_idleup12	=[	$idleup12,	spider_idleup13	] {ai_stand();}
void()	spider_idleup13	=[	$idleup13,	spider_idleup1	] {ai_stand();}

//----------------------------------------------------------------------
void() spider_droptouch =
{
	// Check if landed on something that is not the ground?
	if (!checkbottom(self)) {
		// Is the spider standing on something?
		if (self.flags & FL_ONGROUND) {
			self.flags = not(self.flags, FL_ONGROUND);
			self.origin_z = self.origin_z + 8;
			setorigin(self, self.origin);		// raise up
			self.lip = time + 1;		// reset timer (.lip used because it's convenient)
			
			makevectors (self.angles);
			self.velocity = v_forward * 100 + '0 0 200';
		}
		return;
	}

	// No more flying, back to running
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setsize(self, '-16 -16 -24', '16 16 16');

	// Reset view offset (based on bbox height)
	self.view_ofs = '0 0 0';
	self.view_ofs_z = self.maxs_z*0.5;

	self.touch = SUB_Null;			// No more jump touching
	FoundTarget();			// Setup goals and warn other monsters

	// Restore all think state functions (spider is off the ceiling)
	self.th_stand = spider_idle1;
	self.th_walk = spider_walk1;
	self.th_run = spider_run1;
	self.th_melee = spider_bite1;
	self.th_missile = spider_leap1;

	// Back to running or standing around!
	if (!self.enemy) self.think = self.th_stand;
	else self.think = self.th_run;
	self.nextthink = time + 0.1;
}

//----------------------------------------------------------------------
void()	spider_drop1 =[	$drop1,	spider_drop2 ] {}
void()	spider_drop2 =[	$drop2,	spider_drop3 ] {}
void()	spider_drop3 =[	$drop3,	spider_drop4 ] {}
void()	spider_drop4 =[	$drop4,	spider_drop5 ] {}
void()	spider_drop5 =[	$drop5,	spider_drop6 ] {}
void()	spider_drop6 =[	$drop6,	spider_drop6 ] {
	if (self.lip < time || self.velocity_z == 0) spider_droptouch();}

//----------------------------------------------------------------------------
void() spider_wakeup =
{
	// Dead already?
	if (self.health < 1) return;
		
	// Only call wakeup function once
	self.th_walk = self.th_run = SUB_Null;

	// No longer need cling to ceiling spawnflag, remove it
	self.spawnflags = self.spawnflags - (self.spawnflags & MON_SPIDER_CEILING);

	self.flags = FL_MONSTER;			// reset flags
	
	self.origin_z = self.origin_z - 8;	// Unstick from ceiling
	setorigin(self, self.origin);		// Move down slightly
	
	self.movetype = MOVETYPE_TOSS;		// Affected by gravity
	self.solid = SOLID_SLIDEBOX;
	self.lip = time + 1;		// Stuck timer (.lip used because it's convenient)

	self.pain_finished = time + 1.5;	// No pain
	ai_attack_finished(2 + random());	// No attacking
		
	makevectors (self.angles);			// Move towards face direction
	self.velocity = v_forward * 50;		// Slight nudge forward

	self.touch = spider_droptouch;		// Touch something?
	if (!self.jump_flag) 
	self.jump_flag = time + 1 + random()*2;	// Don't jump straight away
	spider_drop1();						// Turn around, cat tricks!
}

//============================================================================

void() spider_paind1	=[	$paindown1,	spider_paind2	] {nmfast();}
void() spider_paind2	=[	$paindown3,	spider_paind3	] {nmfast();}
void() spider_paind3	=[	$paindown5,	spider_paind4	] {nmfast();}
void() spider_paind4	=[	$paindown7,	spider_paind5	] {nmfast();}
void() spider_paind5	=[	$paindown9,	spider_run1	] {nmfast();}

// Front legs up (in melee or missile attack)
void() spider_painu1	=[	$painup1,	spider_painu2	] {nmfast();}
void() spider_painu2	=[	$painup3,	spider_painu3	] {nmfast();}
void() spider_painu3	=[	$painup5,	spider_painu4	] {nmfast();}
void() spider_painu4	=[	$painup6,	spider_run1	] {nmfast();}


void(entity attacker, float damage) spider_pain =
{
	// Has the spider been hit while on the ceiling?
	if (self.spawnflags & MON_SPIDER_CEILING) {
		PainFinished(1);
		spider_wakeup();
		return;
	}

	if (time < self.pain_finished) return;

	if (random() < 0.5)
		sound (self, CHAN_VOICE, "spider/pain1.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "spider/pain2.wav", 1, ATTN_NORM);

	// Different types of pain animations based on current attack
	if (self.frame > $atkup8 && self.frame < $atkloop10)
		spider_painu1();
	else
		spider_paind1();

	PainFinished(1);
}


void() spider_die1		=[	$death1,	spider_die2	] {}
void() spider_die2		=[	$death3,	spider_die3	] {}
void() spider_die3		=[	$death5,	spider_die4	] {self.solid = SOLID_NOT;};
void() spider_die4		=[	$death7,	spider_die5	] {}
void() spider_die5		=[	$death9,	spider_die6	] {}
void() spider_die6		=[	$death11,	spider_die7	] {}
void() spider_die7		=[	$death13,	spider_die8	] {}
void() spider_die8		=[	$death15,	spider_die9	] {}
void() spider_die9		=[	$death17,	spider_die10] {}
void() spider_die10		=[	$death19,	SUB_Null] {}


void() spider_die =
{
// check for gib
	if (self.health < -30 || self.spawnflags & MON_SPIDER_CEILING)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowGib ("progs/spid_leg.mdl", GibVelocityForHealth(self.health));
		ThrowGib ("progs/spid_bod.mdl", GibVelocityForHealth(self.health));
		
		if (damage_attacker.classname == "func_void")
		{
			SUB_Remove();
			return;
		}

		ThrowHead ("progs/h_spider.mdl", self.health);
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "spider/death1.wav", 1, ATTN_NORM);
	spider_die1();
}

// ========

/*
==============
CheckSpiderMelee

Returns TRUE if a melee attack would hit right now
==============
*/
float()	CheckSpiderMelee =
{
	if (enemy_range == RANGE_MELEE && z_overlap(self.enemy))
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	return FALSE;
}

/*
==============
CheckSpiderJump
==============
*/
float()	CheckSpiderJump =
{
	local	vector	dist;
	local	float	d;

	// can't jump all the time
	if (self.jump_flag >= time)
		return FALSE;

	if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z
	+ 0.75 * self.enemy.size_z)
		return FALSE;
		
	if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z
	+ 0.25 * self.enemy.size_z)
		return FALSE;
		
	dist = self.enemy.origin - self.origin;
	dist_z = 0;
	
	d = vlen(dist);
	
	if (d < 90)
		return FALSE;
		
	if (d > 200)
		return FALSE;
		
	return TRUE;
}

float()	SpiderCheckAttack =
{
// if close enough for biting, go for it
	if (CheckSpiderMelee ())
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	
	if (CheckSpiderJump ())
	{
		self.attack_state = AS_MISSILE;
		return TRUE;
	}
	
	return FALSE;
}

//===========================================================================

void() monster_spider_spawn =
{
	self.classname = "monster_spider";
		
	self.solid = SOLID_SLIDEBOX;
	//self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/spider.mdl");

	setsize (self, '-16 -16 -24', '16 16 16');
	if (!self.health)
	self.health = 35;
	self.customflags |= CFL_MELEEONLY;

	self.th_pain = spider_pain;
	self.th_die = spider_die;
	self.th_checkattack = SpiderCheckAttack;

	if (self.spawnflags & MON_SPIDER_CEILING)
	{
		self.th_stand = self.th_walk = spider_idleup1;
		self.th_run = spider_wakeup;
		self.th_melee = self.th_missile = spider_wakeup;
	}
	else
	{
		self.th_stand = spider_idle1;
		self.th_walk = spider_walk1;
		self.th_run = spider_run1;
		self.th_melee = spider_bite1;
		self.th_missile = spider_leap1;
	}

	if (self.deathtype == string_null)
		self.deathtype = "was bitten badly by a Dire Spider";

	nmspeed(0.07);

	walkmonster_start();
}

void() monster_spider_spawner = {mon_spawner_use(monster_spider_spawn);}

/*QUAKED monster_spider (1 0 0) (-16 -16 -24) (16 16 16) AMBUSH ON_CEILING ? ? TRIGGERED NOTFOG NOTELEFRAG INSTAWAKE
Dire Spider, 35 health points.

Flags:
"ambush" only wake up on seeing the player, not another monster getting angry
"Triggered"	will not spawn until triggered - triggering again will wake him up. Set 'count' to make this a multi-use spawner.
"NoTfog" 	supress teleport glitter when spawned with 'triggered'
"NoTelefrag" will silently fail to spawn if doing so would telefrag an existing monster. will try again automatically 2x/second until it succeeds.
"Instawake" spawn angry at activator

"On_Ceiling" is used for the spider to start upside down on the ceiling. For this, the spider should be placed in the map adjacent to the ceiling.
It will drop to attack only if triggered or attacked; merely seeing the player won't do it. The spider will occasionally make sounds when idle,
whether on the ceiling or not, unless the "ambush" spawnflag is used.

Keys:
"health" adjusted health amount
"target" entity to trigger when killed
"targetname" entity name
"movedir" set to a velocity to make the monster jump on awakening
"no_infight" if set to 1 (or higher), this individual won't infight ever (doesn't provoke and isn't provoked)
*/
/*FGD
@PointClass base(Monster) size(-16 -16 -24, 16 16 16) model({ "path": ":progs/spider.mdl" }) = monster_spider : "Dire Spider

Default health = 35

The 'On Ceiling' spawnflag is used to have the spider start upside down on the ceiling. For this the spider should be placed in the map adjacent to the ceiling. It will drop to attack only if triggered or attacked; merely seeing the player or hearing about them won't do it. The spider will occasionally make sounds when idle, whether on the ceiling or not, unless the 'Ambush' spawnflag is used."
[
	spawnflags(Flags) =
	[
		2 : "On Ceiling" : 0
	]
	health(integer) : "Custom health amount"
]
*/
void() monster_spider =
{
	if (!SUB_ShouldSpawn()) return;
	if (nomonster()) return;
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/h_spider.mdl");
	precache_model ("progs/spider.mdl");
	precache_model ("progs/spid_leg.mdl");
	precache_model ("progs/spid_bod.mdl");

	precache_sound ("spider/atkmunch.wav");
	precache_sound ("spider/atktear.wav");
	precache_sound ("spider/death1.wav");
	precache_sound ("spider/hiss1.wav");
	precache_sound ("spider/hiss2.wav");
	precache_sound ("spider/hiss3.wav");
	precache_sound ("spider/idle1.wav");
	precache_sound ("spider/pain1.wav");
	precache_sound ("spider/pain2.wav");

	if (!self.health)
	self.health = 35;
	setsize (self, '-16 -16 -24', '16 16 16');
	if ( monster_spawnsetup( monster_spider_spawner ) ) return;

	addmonster(1);
	monster_spider_spawn();
}
