const b_weapon b_rocketlauncher = {
	.name = "rocketlauncher",
	.fn_fire = fire_rocket,
	.fn_vfx = player_rocket1,

	.fn_spread = SpreadOval,
	.fn_low_ammo = NoOpEnd,
	.fn_no_ammo = NoOpEnd,
	
	.fn_hit_alive = T_MissileTouch,
	.fn_hit_dead = NoOpHitEnd,
	.fn_hit_inanimate = NoOpHitEnd,
	.fn_hit_damageable = NoOpHitEnd,
	.fn_hit_ignore = NoOpHitContinue,
	.fn_hit_end = NoOpHitEnd
};
const b_weapon b_grenadelauncher = {
	.name = "grenadelauncher",
	.fn_fire = fire_grenade,
	.fn_vfx = player_rocket1,

	.fn_spread = SpreadOval,
	.fn_low_ammo = NoOpEnd,
	.fn_no_ammo = NoOpEnd,
	
	.fn_hit_alive = GrenadeTouch,
	.fn_hit_dead = NoOpHitEnd,
	.fn_hit_inanimate = NoOpHitEnd,
	.fn_hit_damageable = NoOpHitEnd,
	.fn_hit_ignore = NoOpHitContinue,
	.fn_hit_end = NoOpHitEnd
};

// const b_weapon b_rocketlauncher = {
// 	.fn_fire_action = fire_rocket,
// 	.fn_spread = SpreadOval,
// 	.fn_low_ammo = NoOpVoid,
// 	// .fn_projectile = NoOpVoid,
	
// 	.fn_hit_alive = BulletHitAlive,
// 	.fn_hit_dead = BulletHitDead,
// 	.fn_hit_inanimate = BulletHitInanimate,
// 	.fn_hit_damageable = BulletHitDamageable,
// 	.fn_hit_ignore = NoOpHitContinue,
// 	.fn_hit_end = NoOpHitEnd
// };

void(vector org, float rad) T_GibDownedZombies {
	if (rad < 72) return;	// not a big enough blast
	entity head;
	
	// look a little too high since we'll assume zombies are lower than their 
	// actual origin, which is 24u off the ground
	head = findradiusplus(org + '0 0 16', rad, type, "zombie");
	
	while(head)
	{
		if ( head.customflags & CFL_KNOCKEDDOWN &&	// on ground
			 head.solid == SOLID_NOT && // can't be hurt otherwise
			CanDamage(head, org) &&	// in sight
			rad - vlen(head.origin - org) > 0.5 * head.health	// close enough to hurt
			)
		{
			T_Damage (head, self, self.trueowner, head.health + 10);
		}
		head = head.chain;
	}
}


// =======================================================

void() T_ExplosiveTouch {
	if (other.classname == "monster_shambler")
		BecomeWeakExplosion();
	else
		BecomeExplosion();
}

void() T_MissileExplode {
	local float	dmg = wcvar_spread(w_ctx.name, "dmg");
	
	if (other.health)
	{
		T_Damage (other, self, self.trueowner, dmg, DMGTYPE_EXPLOSION | DMGTYPE_ZKILL );	// so ogre rockets kill zombies despite being too weak
	}

	// don't do radius damage to other, because all damage will be done in the impact
	T_RadiusDamage (self, self.trueowner, 120, other, DMGTYPE_EXPLOSION);
}

void() T_MissileTouch {
	if (other == self.owner) return;		// don't explode on owner
	if (CheckProjectilePassthru()) return;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	T_MissileExplode();

	self.origin = self.origin - 8*normalize(self.velocity);
	T_ExplosiveTouch();
}

/*
================
fire_rocket
player rocket launch inherited from generic launch_rocket
================
*/
void(vector dir) fire_rocket {
	float ammo_cost = wcvar(w_ctx.name, "ammo_cost");
	if (self.currentammo == 0 && ammo_cost > 0) {
		// play click sound
		return;
	}
	self.currentammo = self.ammo_rockets = self.ammo_rockets - ammo_cost;
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
	self.punchangle_x = -2;
	
	makevectors (self.v_angle);
	vector shot_origin = self.origin + v_forward * 8 + '0 0 16';
	
	float speed = wcvar_spread("rocket", "speed");
	float shot_count = wcvar(w_ctx.name, "shot_count");
	vector spread = wcvar_vec(w_ctx.name, "spread");
	for(float i = 0; i < shot_count; i++) {
		vector dir_with_spread = SpreadOval(v_forward, spread);
		launch_rockets(shot_origin, dir_with_spread * speed, 1, T_MissileTouch);
	}

	self.attack_finished = time + wcvar(w_ctx.name, "attack_delay");
}

//=============================================================================

/*
===============

GERNADES

===============
*/

void() GrenadeExplode {
	float dmg = wcvar_spread(w_ctx.name, "dmg");
	// self.origin_z = self.origin_z + 4;
	T_RadiusDamage (self, self.trueowner, dmg, world, DMGTYPE_EXPLOSION);
	//T_GibDownedZombies (self, 120);
	// self.solid = SOLID_NOT;
	BecomeExplosion ();
}

void() GrenadeHandlePhysics;

void() GrenadeTouch {
	if (other == self.owner ) return;		// don't explode on owner
	if (CheckProjectilePassthru()) return;
	if (other.takedamage == DAMAGE_AIM)
	{
		self.velocity = '0 0 0';
		T_MissileExplode();
		T_ExplosiveTouch();
		return;
	}

	GrenadeHandlePhysics();

	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);	// bounce sound
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
}

/*
================
fire_grenade
================
*/
void(vector dir) fire_grenade {
	entity grenade;
	
	self.currentammo = self.ammo_rockets = self.ammo_rockets - wcvar(w_ctx.name, "ammo_cost");
	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
	self.punchangle_x = -2;

	vector vel = grenade_vel(dir);

	grenade = launch_grenade(self.origin, vel);
	self.attack_finished = time + wcvar(w_ctx.name, "attack_delay");
	grenade.touch = GrenadeTouch;
	grenade.th_die = GrenadeExplode;
}
vector(vector dir) grenade_vel {

	vector spread = wcvar_vec(w_ctx.name, "spread");
	vector vel_mult = wcvar_vec("grenade", "vel_mult");
	// vector dir = SpreadOval(aim (self, AUTOAIM_DIST), spread);
	vector dir_with_spread = w_ctx.fn_spread(dir, spread);
	vector fwd = normalize(dir_with_spread);
	vector right = normalize(CrossProduct(fwd, VEC_UP));
	vector up = normalize(CrossProduct(right, fwd));
	return fwd * vel_mult_x + right * vel_mult_y + up * vel_mult_z;
}
