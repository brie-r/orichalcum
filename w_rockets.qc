const b_weapon b_rocketlauncher = {
	.name = "rocketlauncher",
	.fn_fire = fire_rocket,
	.fn_vfx = player_rocket1,

	.fn_spread = SpreadOval,
	.fn_low_ammo = NoOpEnd,
	.fn_no_ammo = NoOpEnd,
	
	.fn_hit_alive = w_missile_touch,
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
	
	.fn_hit_alive = w_grenade_touch,
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
	local float	dmg = wcvar_spread(self.w_ctx.name, "dmg");
	
	if (other.health)
	{
		T_Damage (other, self, self.trueowner, dmg, DMGTYPE_EXPLOSION | DMGTYPE_ZKILL );	// so ogre rockets kill zombies despite being too weak
	}

	// don't do radius damage to other, because all damage will be done in the impact
	T_RadiusDamage (self, self.trueowner, dmg, other, DMGTYPE_EXPLOSION);
}
Branch(float damage, vector dir) w_missile_touch {
	T_MissileTouch();
	return Branch::End;
}
void() T_MissileTouch {
	if (other == self.owner) return;		// don't explode on owner
	// if (CheckProjectilePassthru()) return;

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
void(vector origin, vector dir) fire_rocket {
	// sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
	// self.punchangle_x = -2;
	
	float speed = wcvar_spread("rocket", "speed");
	entity rocket = launch_rocket(origin, dir * speed, 1, T_MissileTouch);
	rocket.w_ctx.name = self.w_ctx.name;

	// self.attack_finished = time + wcvar(self.w_ctx.name, "attack_delay");
}

vector origin_rocket() {
	return self.origin + v_forward * 8 + '0 0 16';
}

//=============================================================================

/*
===============

GERNADES

===============
*/

void() GrenadeExplode {
	float dmg = wcvar_spread(self.w_ctx.name, "dmg");
	T_RadiusDamage (self, self.trueowner, dmg, world, DMGTYPE_EXPLOSION);
	//T_GibDownedZombies (self, 120);
	BecomeExplosion ();
}

void() GrenadeHandlePhysics;

Branch(float damage, vector dir) w_grenade_touch {
	GrenadeTouch();
	return Branch::End;
}
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
void(vector origin, vector dir) fire_grenade {
	vector vel = grenade_vel(dir);
	entity grenade = launch_grenade(origin, vel);
	grenade.w_ctx.name = self.w_ctx.name;
	grenade.touch = GrenadeTouch;
	grenade.th_die = GrenadeExplode;
}
vector grenade_origin() {
	return self.origin;
}
vector(vector dir) grenade_vel {
	vector spread = wcvar_vec(self.w_ctx.name, "spread");
	vector vel_mult = wcvar_vec("grenade", "vel_mult");
	// vector dir = SpreadOval(aim (self, AUTOAIM_DIST), spread);
	vector dir_with_spread = self.w_ctx.fn_spread(dir, spread);
	vector fwd = normalize(dir_with_spread);
	vector right = normalize(CrossProduct(fwd, VEC_UP));
	vector up = normalize(CrossProduct(right, fwd));
	return fwd * vel_mult_x + right * vel_mult_y + up * vel_mult_z;
}
