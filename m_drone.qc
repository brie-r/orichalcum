/*
=============================================================================

DRONE

=============================================================================
*/
$cd /raid/quake/id1/models/drone1
$origin 0 0 -24
$base base
$skin skin
$scale 1

// 0
$frame base1

// 1-11
$frame cam1 cam2 cam3 cam4 cam5 cam6 cam7 cam8 cam9 cam10 cam11 

// 12-17
$frame att1 att2 att3 att4 att5 att6

// 18-27
$frame idl1 idl2 idl3 idl4 idl5 idl6 idl7 idl8 idl9 idl10

// 28-33
$frame paa1 paa2 paa3 paa4 paa5

// 34-40
$frame pab1 pab2 pab3 pab4 pab5 pab6 pab7




void(float offset) drone_fire =
{
	/* OUM - drone may misfire when damaged. */
	local vector org, vec;
	local float ouch, ouch1;
	local entity dlaser;

	ouch = 4 - skill;
	ouch1 = 4 * random();
	if ((self.ammo_shells < ouch) && (ouch1 < ouch) && (self.health < self.max_health * 0.75))
	{
		sound (self, CHAN_VOICE, "drone/drngasp.wav", 0.6, ATTN_NORM);
		self.ammo_shells = self.ammo_shells + 1;
		return;
	}

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, CHAN_WEAPON, "drone/enfire.wav", 1, ATTN_NORM);

	org = self.origin + v_right * -3 + v_forward * 2.5 + v_up * -6.5;
	vec = normalize(enemy_vispos() + v_right * offset - org + enemy_aim_vertical());

	makevectors (self.angles);
	if (angledif(self.ideal_yaw, self.angles_y) > 80)	// no ass lasers
	{
		vec_x = v_forward_x;
		vec_y = v_forward_y;
		vec = normalize(vec);
	}

	dlaser = launch_laser(org, vec * 600);
	if (skill == 3)
		dlaser.dmg = 14;
	else
		dlaser.dmg = 10;

	ai_attack_finished(3);
}


void()  drn_stand1      =[      $idl1,                drn_stand2      ] {ai_stand();}
void()  drn_stand2      =[      $idl2,                drn_stand3      ] {ai_stand();}
void()  drn_stand3      =[      $idl3,                drn_stand4      ] {ai_stand();}
void()  drn_stand4      =[      $idl4,                drn_stand5      ] {ai_stand();}
void()  drn_stand5      =[      $idl5,                drn_stand6      ] {ai_stand();}
void()  drn_stand6      =[      $idl6,                drn_stand7      ] {ai_stand();}
void()  drn_stand7      =[      $idl7,                drn_stand8      ] {ai_stand();}
void()  drn_stand8      =[      $idl8,                drn_stand9      ] {ai_stand();}
void()  drn_stand9      =[      $idl9,                drn_stand10     ] {ai_stand();}
void()  drn_stand10     =[      $idl1,                drn_stand1      ] {ai_stand();}


void()  drn_walk1       =[      $idl1,                drn_walk2       ] {ai_walk(8);}
void()  drn_walk2       =[      $idl2,                drn_walk3       ] {ai_walk(8);}
void()  drn_walk3       =[      $idl3,                drn_walk4       ] {ai_walk(8);}
void()  drn_walk4       =[      $idl4,                drn_walk5       ] {ai_walk(8);}
void()  drn_walk5       =[      $idl5,                drn_walk6       ] 
{
	ai_walk(8);
	if (!(self.spawnflags & 1))
	{
		if (random() < 0.1)
			sound (self, CHAN_VOICE, "drone/drnidle.wav", 0.6, ATTN_IDLE);
	}
}
void()  drn_walk6       =[      $idl6,                drn_walk7       ] {ai_walk(8);}
void()  drn_walk7       =[      $idl7,                drn_walk8       ] {ai_walk(8);}
void()  drn_walk8       =[      $idl8,                drn_walk9       ] {ai_walk(8);}
void()  drn_walk9       =[      $idl9,                drn_walk10      ] {ai_walk(8);}
void()  drn_walk10      =[      $idl1,                drn_walk1       ] 
{
	ai_walk(8);
	if (!(self.spawnflags & 1))
	{
		if (random() < 0.1)
		{
			if (random() > 0.5)
				sound (self, CHAN_VOICE, "drone/drnidle2.wav", 0.6, ATTN_IDLE);
			else
				sound (self, CHAN_VOICE, "drone/drnidle.wav", 0.6, ATTN_IDLE);
		}
	}
}


void()  drn_runa1        =[      $idl1,          drn_runa2        ] {ai_run(13);}
void()  drn_runa2        =[      $idl2,          drn_runa3        ] {ai_run(13);}
void()  drn_runa3        =[      $idl3,          drn_runa4        ] {ai_run(13);}
void()  drn_runa4        =[      $idl4,          drn_runa5        ] {ai_run(13);}
void()  drn_runa5        =[      $idl5,          drn_runa6        ] 
{
	ai_run(13);
	if (random() < 0.2)
	{
		if (self.health < self.max_health)
			sound (self, CHAN_VOICE, "drone/drngasp.wav", 0.6, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "drone/drnhunt.wav", 1, ATTN_NORM);
	}
}
void()  drn_runa6        =[      $idl6,          drn_runa7        ] {ai_run(13);}
void()  drn_runa7        =[      $idl7,          drn_runa8        ] {ai_run(13);}
void()  drn_runa8        =[      $idl8,          drn_runa9        ] {ai_run(13);}
void()  drn_runa9        =[      $idl9,          drn_runa10       ] {ai_run(13);}
void()  drn_runa10       =[      $idl1,          drn_run          ] 
{
	ai_run(13);
	if (crandom() > 0.5)
	{
		if (self.health < self.max_health / 2)
			sound (self, CHAN_VOICE, "drone/drngasp2.wav", 0.6, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "drone/drnhunt.wav", 1, ATTN_NORM);
	}
}

void()  drn_runb1        =[      $idl1,          drn_runb2        ] {ai_run(1);ai_run_slide(12);}
void()  drn_runb2        =[      $idl2,          drn_runb3        ] {ai_run(1);ai_run_slide(12);}
void()  drn_runb3        =[      $idl3,          drn_runb4        ] {ai_run(1);ai_run_slide(12);}
void()  drn_runb4        =[      $idl4,          drn_runb5        ] {ai_run(1);ai_run_slide(12);}
void()  drn_runb5        =[      $idl5,          drn_runb6        ] 
{
	ai_run(1);ai_run_slide(12);
	if (crandom() > 0.5)
		sound (self, CHAN_VOICE, "drone/drnhunt.wav", 1, ATTN_NORM);
}
void()  drn_runb6        =[      $idl6,          drn_runb7        ] {ai_run(1);ai_run_slide(12);}
void()  drn_runb7        =[      $idl7,          drn_runb8        ] {ai_run(1);ai_run_slide(12);}
void()  drn_runb8        =[      $idl8,          drn_runb9        ] {ai_run(1);ai_run_slide(12);}
void()  drn_runb9        =[      $idl9,          drn_runb10       ] {ai_run(1);ai_run_slide(12);}
void()  drn_runb10       =[      $idl1,          drn_run          ] 
{
	ai_run(1);ai_run_slide(12);
	if (crandom() > 0.5)
		sound (self, CHAN_VOICE, "drone/drnhunt.wav", 1, ATTN_NORM);
}

void() drn_run =
{
	if (range(self.enemy) >= RANGE_FAR || !visible(self.enemy))
	{
		drn_runa1 ();
		return;
	}

	local float	r;
	r = random();
		if (r < 0.5)
		drn_runa1 ();
		else
		drn_runb1 ();
}


void()  drn_atta1       =[      $att1,               drn_atta2       ] {ai_face();drone_fire(125);}
void()  drn_atta2       =[      $att2,               drn_atta3       ] {ai_face();drone_fire(75);}
void()  drn_atta3       =[      $att3,               drn_atta4       ] {ai_face();drone_fire(25);}
void()  drn_atta4       =[      $att4,               drn_atta5       ] {ai_face();drone_fire(0);}
void()  drn_atta5       =[      $att5,               drn_atta6       ] {ai_face();drone_fire(-25);}
void()  drn_atta6       =[      $att6,               drn_atta7       ] {ai_face();drone_fire(-75);}
void()  drn_atta7       =[      $cam1,               drn_atta8       ] {
	ai_face();
	drone_fire(-125);
	self.ammo_shells = 0;
}
void()  drn_atta8       =[      $cam2,               drn_atta9       ] {ai_face();}
void()  drn_atta9       =[      $cam3,               drn_atta10      ] {ai_face();}
void()  drn_atta10      =[      $cam4,               drn_atta11      ] {ai_face();}
void()  drn_atta11      =[      $cam5,               drn_atta12      ] {ai_face();}
void()  drn_atta12      =[      $cam6,               drn_atta13      ] {ai_face();}
void()  drn_atta13      =[      $cam7,               drn_atta14      ] {ai_face();}
void()  drn_atta14      =[      $cam8,               drn_atta15      ] {ai_face();}
void()  drn_atta15      =[      $cam9,               drn_atta16      ] {ai_face();}
void()  drn_atta16      =[      $cam10,              drn_atta17      ] {ai_face();}
void()  drn_atta17      =[      $cam10,              drn_atta18      ] {ai_face();}
void()  drn_atta18      =[      $cam10,              drn_run         ] {ai_face();}


void()  drn_paina1       =[      $paa1,         drn_paina2       ] {ai_nop();}
void()  drn_paina2       =[      $paa2,         drn_paina3       ] {ai_nop();}
void()  drn_paina3       =[      $paa3,         drn_paina4       ] {ai_nop();}
void()  drn_paina4       =[      $paa4,         drn_paina5       ] {ai_nop();}
void()  drn_paina5       =[      $paa5,         drn_run         ] {ai_nop();}

void()  drn_painb1       =[      $pab1,         drn_painb2       ] {ai_nop();}
void()  drn_painb2       =[      $pab2,         drn_painb3       ] {ai_nop();}
void()  drn_painb3       =[      $pab3,         drn_painb4       ] {ai_nop();}
void()  drn_painb4       =[      $pab4,         drn_painb5       ] {ai_nop();}
void()  drn_painb5       =[      $pab5,         drn_run         ] {ai_nop();}

void(entity attacker, float damage) drn_pain =
{
	if (self.health <= 0) return;
	if (self.pain_finished > time) return;

	if (skill == 3)
	{
		if (random()*60 > damage)
			return;		// didn't flinch
	}

	if (random() > 0.75)
		sound (self, CHAN_VOICE, "drone/drnpain2.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "drone/drnpain.wav", 1, ATTN_NORM);

	ThrowGib ("progs/spikeold.mdl", GibVelocityForHealth(-10));

	if (random() > 0.5)
		drn_paina1 ();
	else
		drn_painb1 ();

	PainFinished(1);
}


void()  drn_die1        =[      $paa1,            drn_die2      ] {self.takedamage = DAMAGE_NO;
	sound(self, CHAN_VOICE, "drone/drndeth.wav", 1, ATTN_NORM);
	//self.movetype = MOVETYPE_BOUNCEMISSILE;
	self.movetype = MOVETYPE_BOUNCE;
	setsize(self, '0 0 0', '0 0 0');

	self.touch = drn_dead_touch;

	self.velocity_x = -200 + 400*random();
	self.velocity_y = -200 + 400*random();
	self.velocity_z =  100 + 100*random();

	self.flags = self.flags - (self.flags & FL_ONGROUND);
}
void()  drn_die2         =[      $paa1,         drn_die3       ] {}
void()  drn_die3         =[      $paa2,         drn_die4       ] {}
void()  drn_die4         =[      $paa3,         drn_die5       ] {}
void()  drn_die5         =[      $paa4,         drn_die6       ] {}
void()  drn_die6         =[      $paa5,         drn_die6       ] {
	self.think = drn_explode;
	self.nextthink = time + 0.5;
}

void() drn_explode =
{
	ThrowGib("progs/drngib1.mdl", GibVelocityForHealth(-65));
	ThrowGib("progs/drngib2.mdl", GibVelocityForHealth(-65));
	ThrowHead("progs/drngib3.mdl", -65);

	T_RadiusDamage (self, self, 50, world, DMGTYPE_EXPLOSION);

	BecomeExplosion();
}

void() drn_die =
{
	if (self.health < -40) 
		drn_explode();
	else 
		drn_die1();
}

void() drn_dead_touch =
{
	if (other.solid == SOLID_BSP || other.solid == SOLID_BBOX || other.solid == SOLID_SLIDEBOX)
		drn_explode();
}

// ========

void() monster_drone_spawn =
{
	self.classname = "monster_drone";
	self.type = "soldier";  // so it doesn't fight its human masters
		
	self.solid = SOLID_SLIDEBOX;
	//self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/drone1.mdl");

	setsize (self, '-16 -16 -16','16 16 24');
	if (!self.health)
	self.health = 100;

	self.th_stand = drn_stand1;
	self.th_walk = drn_walk1;
	self.th_run = drn_run;
	self.th_missile = drn_atta1;
	self.th_pain = drn_pain;
	self.th_die = drn_die;
	self.th_checkattack = CheckAttack;

	self.ammo_shells = 0;  // used to avoid misfiring too much

	if (self.deathtype == string_null)
		self.deathtype = "was drilled by a Drone";

	self.height = zeroconvertdefault(self.height, 35);
	self.jump_flag = self.height;	// remember original value for short term nav tweaking
	flymonster_start();
}

void() monster_drone_spawner = {mon_spawner_use(monster_drone_spawn);}

/*QUAKED monster_drone (1 0 0) (-16 -16 -16) (16 16 24) AMBUSH ? ? ? TRIGGERED NOTFOG NOTELEFRAG INSTAWAKE
Drone, 100 health points.

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
@PointClass base(Monster) size(-16 -16 -16, 16 16 24) model({ "path": ":progs/drone1.mdl" }) = monster_drone : "Drone

Default health = 100"
[
health(integer) : "Custom health amount"
]
*/
void() monster_drone =
{
	if (!SUB_ShouldSpawn()) return;
	if (nomonster()) return;
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/drone1.mdl");
	precache_model ("progs/drngib1.mdl");
	precache_model ("progs/drngib2.mdl");
	precache_model ("progs/drngib3.mdl");
	precache_model ("progs/laser.mdl");
	precache_model ("progs/spikeold.mdl");

	precache_sound2 ("drone/drnidle2.wav");
	precache_sound2 ("drone/drnidle.wav");
	precache_sound2 ("drone/drnwake.wav");
	precache_sound2 ("drone/drnhunt.wav");
	precache_sound2 ("drone/enfire.wav");
	precache_sound2 ("drone/drnpain.wav");
	precache_sound2 ("drone/drnpain2.wav");
	precache_sound2 ("drone/drngasp.wav");
	precache_sound2 ("drone/drngasp2.wav");
	precache_sound2 ("drone/drndeth.wav");
	precache_sound2 ("enforcer/enfstop.wav");

	if (!self.health)
	self.health = 100;
	setsize (self, '-16 -16 -16','16 16 24');
	if ( monster_spawnsetup( monster_drone_spawner ) ) return;
	
	addmonster(1);
	monster_drone_spawn();
}
