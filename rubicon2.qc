float 	BREAKABLE_NO_MONSTERS = 1;
float		BREAK_EXPLODE = 2;
float		BREAK_CUSTOM = 4;
float		BREAK_TRIGGERABLE = 8;  // J_D: for compatibility with the "start invisible" spawnflag

// J_D: from progs_dump's player.qc, needed for breakables
vector(float dm) VelocityForDamage =
{
	local vector v;

	v_x = 100 * crandom();
	v_y = 100 * crandom();
	v_z = 200 + 100 * random();

	if (dm > -50)
	{
		v = v * 0.7;
	}
	else if (dm > -200)
	{
		v = v * 2;
	}
	else
		v = v * 10;

	return v;
}

// J_D: used here just for exploding breakables
void () func_explobox_explode_silent =
{
	self.takedamage = DAMAGE_NO;
	self.origin = ((self.absmin + self.absmax) * 0.5);
	self.classname = "explo_box";
	T_RadiusDamage (self, self, self.dmg, world, DMGTYPE_EXPLOSION);
	BecomeExplosion ();
}

/*
===============================================================================
func_breakable
===============================================================================
*/

.string break_template1;
.string break_template2;
.string break_template3;
.string break_template4;
.string break_template5;
.float brk_obj_count1;
.float brk_obj_count2;
.float brk_obj_count3;
.float brk_obj_count4;
.float brk_obj_count5;


// template system from Qmaster -- dumptruck_ds
void() make_breakable_templates_debris = {
	local float i;
	local entity new;

	i = 0;
	if (self.break_template1 != "") {
		while (i < self.brk_obj_count1) {
			new = spawn();
			new.model = self.break_template1;
			new.origin_x = (self.maxs_x - self.mins_x)*random() + self.mins_x;
			new.origin_y = (self.maxs_y - self.mins_y)*random() + self.mins_y;
			new.origin_z = (self.maxs_z - self.mins_z)*random() + self.mins_z;
			setmodel (new, new.model); //dumptruck_ds
			setsize (new, '0 0 0', '0 0 0');
			new.velocity = VelocityForDamage (self.health*2);
			new.movetype = MOVETYPE_BOUNCE;
			new.solid = SOLID_NOT;
			new.avelocity_x = random()*600;
			new.avelocity_y = random()*600;
			new.avelocity_z = random()*600;
			new.think = SUB_Remove;
			new.ltime = time;
			new.nextthink = time + 10 + random()*10;
			new.flags = 0;
			i++;
		}
	}

	i = 0;
	if (self.break_template2 != "") {
		while (i < self.brk_obj_count2) {
			new = spawn();
			new.model = self.break_template2;
			new.origin_x = (self.maxs_x - self.mins_x)*random() + self.mins_x;
			new.origin_y = (self.maxs_y - self.mins_y)*random() + self.mins_y;
			new.origin_z = (self.maxs_z - self.mins_z)*random() + self.mins_z;
			setmodel (new, new.model); //dumptruck_ds
			setsize (new, '0 0 0', '0 0 0');
			new.velocity = VelocityForDamage (self.health*2);
			new.movetype = MOVETYPE_BOUNCE;
			new.solid = SOLID_NOT;
			new.avelocity_x = random()*600;
			new.avelocity_y = random()*600;
			new.avelocity_z = random()*600;
			new.think = SUB_Remove;
			new.ltime = time;
			new.nextthink = time + 10 + random()*10;
			new.flags = 0;
			i++;
		}
	}

	i = 0;
	if (self.break_template3 != "") {
		while (i < self.brk_obj_count3) {
			new = spawn();
			new.model = self.break_template3;
			new.origin_x = (self.maxs_x - self.mins_x)*random() + self.mins_x;
			new.origin_y = (self.maxs_y - self.mins_y)*random() + self.mins_y;
			new.origin_z = (self.maxs_z - self.mins_z)*random() + self.mins_z;
			setmodel (new, new.model); //dumptruck_ds
			setsize (new, '0 0 0', '0 0 0');
			new.velocity = VelocityForDamage (self.health*2);
			new.movetype = MOVETYPE_BOUNCE;
			new.solid = SOLID_NOT;
			new.avelocity_x = random()*600;
			new.avelocity_y = random()*600;
			new.avelocity_z = random()*600;
			new.think = SUB_Remove;
			new.ltime = time;
			new.nextthink = time + 10 + random()*10;
			new.flags = 0;
			i++;
		}
	}

	i = 0;
	if (self.break_template4 != "") {
		while (i < self.brk_obj_count4) {
			new = spawn();
			new.model = self.break_template4;
			new.origin_x = (self.maxs_x - self.mins_x)*random() + self.mins_x;
			new.origin_y = (self.maxs_y - self.mins_y)*random() + self.mins_y;
			new.origin_z = (self.maxs_z - self.mins_z)*random() + self.mins_z;
			setmodel (new, new.model); //dumptruck_ds
			setsize (new, '0 0 0', '0 0 0');
			new.velocity = VelocityForDamage (self.health*2);
			new.movetype = MOVETYPE_BOUNCE;
			new.solid = SOLID_NOT;
			new.avelocity_x = random()*600;
			new.avelocity_y = random()*600;
			new.avelocity_z = random()*600;
			new.think = SUB_Remove;
			new.ltime = time;
			new.nextthink = time + 10 + random()*10;
			new.flags = 0;
			i++;
		}
	}

	i = 0;
	if (self.break_template5 != "") {
		while (i < self.brk_obj_count5) {
			new = spawn();
			new.model = self.break_template5;
			new.origin_x = (self.maxs_x - self.mins_x)*random() + self.mins_x;
			new.origin_y = (self.maxs_y - self.mins_y)*random() + self.mins_y;
			new.origin_z = (self.maxs_z - self.mins_z)*random() + self.mins_z;
			setmodel (new, new.model); //dumptruck_ds
			setsize (new, '0 0 0', '0 0 0');
			new.velocity = VelocityForDamage (self.health*2);
			new.movetype = MOVETYPE_BOUNCE;
			new.solid = SOLID_NOT;
			new.avelocity_x = random()*600;
			new.avelocity_y = random()*600;
			new.avelocity_z = random()*600;
			new.think = SUB_Remove;
			new.ltime = time;
			new.nextthink = time + 10 + random()*10;
			new.flags = 0;
			i++;
		}
	}
}


//Below this is from Rubicon2 -- dumptruck_ds

void() make_breakable_debris = {
	local float i;
	i = 0;
	while (i < self.cnt)
	{
		local	entity new;

		new = spawn();
		new.origin_x = (self.maxs_x - self.mins_x)*random() + self.mins_x;
		new.origin_y = (self.maxs_y - self.mins_y)*random() + self.mins_y;
		new.origin_z = (self.maxs_z - self.mins_z)*random() + self.mins_z;
		// setmodel (new, "progs/debris.mdl"); this was originally just an mdl from Rubicon2, now you set custom model via spawnflag or use the builtin from Rubicon2 -- dumptruck_ds
		setmodel (new, self.mdl_debris); //dumptruck_ds
		setsize (new, '0 0 0', '0 0 0');
		new.velocity = VelocityForDamage (self.health*2);
		new.movetype = MOVETYPE_BOUNCE;
		new.solid = SOLID_NOT;
		new.avelocity_x = random()*600;
		new.avelocity_y = random()*600;
		new.avelocity_z = random()*600;
		new.think = SUB_Remove;
		new.ltime = time;
		new.nextthink = time + 10 + random()*10;
		new.flags = 0;

		// randomly choose size
		if (random() > 0.333)
			new.frame = 1; //larger
		else
			new.frame = 2; //smaller

		// choose skin based on "style" key
		if (self.style == 1)
			new.skin = 1;
		if (self.style == 2)
			new.skin = 2;
		if (self.style == 3) // new debris skins start here - dumptruck_ds
			new.skin = 3;
		if (self.style == 4)
		new.skin = 4;
		if (self.style == 5)
		new.skin = 5;
		if (self.style == 6)
		new.skin = 6;
		if (self.style == 7)
		new.skin = 7;
		if (self.style == 8)
		new.skin = 8;
		if (self.style == 9)
		new.skin = 9;
		if (self.style == 10)
		new.skin = 10;
		if (self.style == 11)
		new.skin = 11;
		if (self.style == 12)
		new.skin = 12;
		if (self.style == 13)
		new.skin = 13;
		if (self.style == 14)
		new.skin = 14;
		if (self.style == 15)
		new.skin = 15;
		if (self.style == 16)
		new.skin = 16;
		if (self.style == 17)
		new.skin = 17;
		if (self.style == 18)
		new.skin = 18;
		if (self.style == 19)
		new.skin = 19;
		if (self.style == 20)
		new.skin = 20;
		if (self.style == 21)
		new.skin = 21;
		if (self.style == 22)
		new.skin = 22;
		if (self.style == 23)
		new.skin = 23;
		if (self.style == 24)
		new.skin = 24;
		if (self.style == 25)
		new.skin = 25;
		if (self.style == 26)
		new.skin = 26;
		if (self.style == 27)
		new.skin = 27;
		if (self.style == 28)
		new.skin = 28;
		if (self.style == 29)
		new.skin = 29;
		if (self.style == 30)
		new.skin = 30;
		if (self.style == 31)// new debris skins end here - dumptruck_ds
		new.skin = 31;

		i = i + 1;
	}
}

void () func_breakable_die = {
	//dumptruck_ds -- set the spawnflag for cosmetic explosion effect; use "dmg" value to hurt the player
	{
		local entity ent; //thanks to Qmaster!!! He helped me sort out noise1 playing from 0 0 0 with this temp entity - dumptruck_ds

		ent = spawn();
		ent.origin = ((self.absmin + self.absmax) * 0.5);
		setsize (ent, '0 0 0', '0 0 0');
		ent.solid = SOLID_NOT;
		ent.think = SUB_Remove;
		// ent.ltime = time;
		ent.nextthink = time + 60;

		sound(ent, CHAN_AUTO, self.noise1, 1, ATTN_NORM);
		// remove (self);
	}

	// this is to ensure that any debris from another func_breakable
	// which is resting on top of this func_breakable is not left
	// floating in mid-air after this entity is removed -- iw
	SUB_DislodgeRestingEntities ();

	if (self.spawnflags & BREAK_EXPLODE) {
		if (self.spawnflags & BREAK_CUSTOM) {
			make_breakable_templates_debris ();
		} else {
			make_breakable_debris ();
		}
		func_explobox_explode_silent();  // to let us use noise2
		// sound(self, CHAN_VOICE, self.noise2, 1, ATTN_NORM); this is broken as of 1.1.0 no custom explosion sound for now -- dumptruck_ds
		remove (self);
	} else {
		self.origin = ((self.absmin + self.absmax) * 0.5);
		setorigin (self, self.origin);
		// DropStuff();  // J_D: not used in Metallicus
		if (self.spawnflags & BREAK_CUSTOM) {
			if (self.switchshadstyle) lightstyle(self.switchshadstyle, "m");
			make_breakable_templates_debris ();
			remove (self);
		} else {
			if (self.switchshadstyle) lightstyle(self.switchshadstyle, "m");
			make_breakable_debris ();
			remove (self);
		}
	}
}

void () func_breakable_killed =
{
	activator = damage_attacker;
	SUB_UseTargets ();
	func_breakable_die ();
}

void () func_breakable_use =
{
	activator = other;
	SUB_UseTargets ();
	func_breakable_die ();
}

void() break_template_setup = {
	if (self.break_template1 != "") precache_model(self.break_template1);
	if (self.break_template2 != "") precache_model(self.break_template2);
	if (self.break_template3 != "") precache_model(self.break_template3);
	if (self.break_template4 != "") precache_model(self.break_template4);
	if (self.break_template5 != "") precache_model(self.break_template5);
}

/*QUAKED func_breakable (0 .5 .8) ? NO_MONSTERS EXPLOSION USE_CUSTOM_MODELS
Breakable - See the mapping guide for full details

Defaults to built-in .mdl file with 32 styles, cnt is number of pieces of debris to spawn (built-in only)
Or use spawnflag 4 and break_template1-4 to set path of custom .mdl or .bsp models.
brk_object_count1-4 sets the number of pieces of each break_template when using custom .mdl or bsp models.
If noise1 is not set it will default to various sounds in sounds/break folder
Use spawnflag 2 for an explosion, dmg is amount of damage inflicted

Flags:
"no_monsters" only the player can break it, not monsters
"explosion" produces explosion effect and sound
"use_custom_models" uses models specified in break_template1, 2, etc.

Keys:
"style" built-in debris style
0 : Green Metal (default)
1 : Red Metal
2 : Concrete
3 : Pine wood
4 : Brown wood
5 : Red wood
6 : Stained Glass Yellow Flames
7 : Stained Glass Red Rays
8 : Stained Glass Yellow Dragon
9 : Stained Glass Blue Dragon
10 : Stained Glass Red Dragon
11 : Light Copper
12 : Dark Copper
13 : Tan Bricks Large
14 : Brown Bricks Large
15 : Green Bricks Large
16 : Generic Light Brown
17 : Red Brown Computer
18 : Grey Black Computer
19 : Blue Green Metal
20 : Blue Green Runic Wall
21 : Brown Metal
22 : Dark Brown Metal
23 : Medium Brown Metal
24 : Blue Metal
25 : Green Stonework
26 : Blue Stonework
27 : Brown Bricks
28 : Tan Blue Bricks
29 : Red Bricks
30 : Blue Bricks
31 : Metal Rivets

"noise1" break noise sound file (overrides default sounds)
"cnt" number of pieces of debris to spawn (default is 5)
"health" health of breakable (default is 20)
"dmg" amount of explosive damage
"break_template1" template 1 model path, e.g. maps/break/brk.bsp or progs/brick.mdl
"break_template2" template 2 model path, e.g. maps/break/brk.bsp or progs/brick.mdl
"break_template3" template 3 model path, e.g. maps/break/brk.bsp or progs/brick.mdl
"break_template4" template 4 model path, e.g. maps/break/brk.bsp or progs/brick.mdl
"break_template5" template 5 model path, e.g. maps/break/brk.bsp or progs/brick.mdl
"brk_obj_count1" template 1 spawn count
"brk_obj_count2" template 2 spawn count
"brk_obj_count3" template 3 spawn count
"brk_obj_count4" template 4 spawn count
"brk_obj_count5" template 5 spawn count
*/
/*FGD
@SolidClass base(Target, Targetname, Appearflags, Func) = func_breakable : "Breakable - See the mapping guide for full details

Defaults to built-in .mdl file with 32 styles, cnt is number of pieces of debris to spawn (built-in only)

Or use spawnflag 4 and break_template1-4 to set path of custom .mdl or .bsp models.

brk_object_count1-4 sets the number of pieces of each break_template when using custom .mdl or bsp models.

If noise1 is not set it will default to various sounds in sound/break folder

Use spawnflag 2 for an explosion, dmg is amount of damage inflicted" [
	    spawnflags(flags) = [
					1 :	"No Damage from Monsters" : 0
	        2 : "Explosion" : 0
	        4 : "Use custom mdls or bsp models" : 0
	    ]
	    noise1(string) : "Path to custom break sound"
			style(choices) : "Built-in debris style" : 0 =
				[
				0 : "Green Metal (default)"
				1 : "Red Metal"
				2 : "Concrete"
				3 : "Pine wood -- wood1_1"
				4 : "Brown wood -- wizwood1_3"
				5 : "Red wood -- dung01_2"
				6 : "Stained Glass Yellow Flames -- window02_1"
				7 : "Stained Glass Red Rays -- window01_4"
				8 : "Stained Glass Yellow Dragon -- window01_3"
				9 : "Stained Glass Blue Dragon -- window01_2"
				10 : "Stained Glass Red Dragon -- window01_1"
				11 : "Light Copper -- cop2_3"
				12 : "Dark Copper -- cop1_1"
				13 : "Tan Bricks Large -- wiz1_4"
				14 : "Brown Bricks Large -- wbrick1_5"
				15 : "Green Bricks Large -- wswamp2_1"
				16 : "Generic Light Brown -- tlight08"
				17 : "Red Brown Computer -- comp1_5"
				18 : "Grey Black Computer -- comp1_1"
				19 : "Blue Green Metal -- metal4_5"
				20 : "Blue Green Runic Wall -- metal4_4"
				21 : "Brown Metal -- metal2_2"
				22 : "Dark Brown Metal -- metal1_3"
				23 : "Medium Brown Metal -- metal1_2"
				24 : "Blue Metal -- m5_8"
				25 : "Green Stonework -- city8_2"
				26 : "Blue Stonework -- city6_7"
				27 : "Brown Bricks -- city2_8"
				28 : "Tan Blue Bricks -- city2_7"
				29 : "Red Bricks -- city2_1"
				30 : "Blue Bricks -- city2_5"
				31 : "Metal Rivets -- wizmet1_2"
				]
	    cnt(integer) : "Number of pieces of debris to spawn" : 5
			health(integer) : "Health of breakable" : 20
			dmg(integer) : "Amount of Explosive Damage" : 20
	    break_template1(string) : "Template 1 model path, e.g. maps/break/brk.bsp or progs/brick.mdl"
	    break_template2(string) : "Template 2 model path, e.g. maps/break/brk.bsp or progs/brick.mdl"
	    break_template3(string) : "Template 3 model path, e.g. maps/break/brk.bsp or progs/brick.mdl"
	    break_template4(string) : "Template 4 model path, e.g. maps/break/brk.bsp or progs/brick.mdl"
	    break_template5(string) : "Template 5 model path, e.g. maps/break/brk.bsp or progs/brick.mdl"
	    brk_obj_count1(integer) : "Template 1 spawn count"
	    brk_obj_count2(integer) : "Template 2 spawn count"
	    brk_obj_count3(integer) : "Template 3 spawn count"
	    brk_obj_count4(integer) : "Template 4 spawn count"
			brk_obj_count5(integer) : "Template 5 spawn count"
]
*/
void () func_breakable = {
	if (!SUB_ShouldSpawn()) return;

	break_template_setup();

	self.mdl_debris = "progs/debris.mdl";
	precache_model (self.mdl_debris);
	precache_sound ("blob/hit1.wav");

	if (self.noise1 != "") precache_sound(self.noise1);
// adding new default sounds for "simple" breakables in 1.2.0 -- dumptruck_ds
// here's genreic metal breaking
	if (self.style == 0 || self.style == 11 || self.style == 12 || self.style == 17 || self.style == 18 || self.style == 19
		|| self.style == 24 || self.style == 31)
		if !(self.noise1)
	{
		precache_sound("break/metal2.wav");
		self.noise1 = "break/metal2.wav";
	}
	if (self.style == 3 || self.style == 4 || self.style == 5)
		if !(self.noise1)
	{
		precache_sound("break/wood1.wav");
		precache_sound("break/wood2.wav");
		if (random() > 0.6) // wood only randomized
		self.noise1 = "break/wood1.wav";
		else
		self.noise1 = "break/wood2.wav";
	}
	// glass sounds -- this is more of a shattering sound anyway
	if (self.style == 6 || self.style == 7 || self.style == 8 || self.style == 9 || self.style == 10)
		if !(self.noise1)
	{
		precache_sound("break/metal1.wav");
		self.noise1 = "break/metal1.wav";
	}
	if (self.style == 1 || self.style == 2 || self.style == 13 || self.style == 14
		|| self.style == 15 || self.style == 16 || self.style == 20 || self.style == 21
		|| self.style == 22 || self.style == 23)
		if !(self.noise1)
	{
		precache_sound("break/stones1.wav");
		precache_sound("break/bricks1.wav");
		if (random() > 0.6) // wood only randomized
		self.noise1 = "break/bricks1.wav";
		else
		self.noise1 = "break/stones1.wav";
	}
	if (self.style == 25 || self.style == 26 || self.style == 27 || self.style == 28 || self.style == 29 || self.style == 30)
		if !(self.noise1)
	{
		precache_sound("break/stones1.wav");
		precache_sound("break/bricks1.wav");
		if (random() > 0.6) // wood only randomized
		self.noise1 = "break/stones1.wav";
		else
		self.noise1 = "break/bricks1.wav";
	}
	// else
	// 	(self.noise1 = "blob/hit1.wav");

	if (!self.cnt)
		self.cnt = 5; // was 6 dumptruck_ds

	if (self.spawnflags & 128)
		self.use = func_breakable_spawn;
	else
		func_breakable_spawn();
}

void() func_breakable_spawn =
{
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setmodel (self, self.model);

	if (!self.health)
		self.health = 20;
	self.max_health = self.health;

	if (self.targetname != "" && (self.spawnflags & BREAK_TRIGGERABLE))
	{
		self.use = func_breakable_use;
	}
	else
	{
		self.takedamage = DAMAGE_YES;
		self.th_die = func_breakable_killed;
	}

	if (self.switchshadstyle) lightstyle(self.switchshadstyle, "a");
}

/*
===============================================================================
trigger_ladder
===============================================================================
*/

void() ladder_touch =
{
	if (self.customflags & CFL_LOCKED) return;
	if (!CheckValidTouch()) return;

	// prevent the player "sticking" to a ladder if they are standing on
	// the platform at the top of the ladder with the bottom of their
	// bounding box flush with the top of the trigger -- iw
	if (other.absmin_z + 1 >= self.absmax_z - 1)
		return;

	// if the trigger has an angles field, check player's facing direction
	if (self.movedir != '0 0 0')
	{
		makevectors (other.angles);
		if (v_forward * self.movedir < 0)
			return;		// not facing the right way
	}
	other.onladder = 1;
}

/*QUAKED trigger_ladder (.5 .0 .5) ? ? ? TRIGGER_FIRST
Invisible ladder entity. When player is touching this entity, he can climb by pushing 'jump'.

Flags:
"trigger_first" won't be touchable until triggered once by something else

Keys:
"angle" the direction player must be facing to climb ladder
*/
/*FGD
@SolidClass base(TriggerNoTargets) = trigger_ladder : "Invisible ladder entity.

When player is touching this entity, he can climb by pushing jump."
[
	angle(integer) : "The direction player must be facing to climb ladder"
]
*/
void() trigger_ladder =
{
	if (!SUB_ShouldSpawn()) return;

	// ignore an "up" or "down" angle (doesn't make sense for a ladder)
	if (self.angles_y == -1 || self.angles_y == -2)
	{
		dprint ("WARNING: trigger_ladder ignored bad 'angle' value: ");
		dprint (ftos (self.angles_y));
		dprint ("\n");

		self.angles_y = 0;
	}

	InitTrigger ();
	self.touch = ladder_touch;
}
