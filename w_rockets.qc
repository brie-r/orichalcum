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
Branch(vector dir) w_missile_touch {
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
entity(vector origin, vector dir_with_spread) fire_rocket {
	vector vel = local_to_world(wcvar_vec((self.w_ctx.name), "vel"), dir_with_spread);
	entity projectile = launch_rocket(origin, vel);
	projectile.w_ctx.name = self.w_ctx.name;
	projectile.touch = T_MissileTouch;
	return projectile;
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

Branch(vector dir) w_grenade_touch {
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
entity(vector origin, vector dir_with_spread) fire_grenade {
	
	vector vel = local_to_world(wcvar_vec(self.w_ctx.name, "vel"), dir_with_spread);
	entity projectile = launch_grenade(origin, vel);
	projectile.w_ctx.name = self.w_ctx.name;
	projectile.touch = GrenadeTouch;
	projectile.th_die = GrenadeExplode;
	return projectile;
}
vector grenade_origin() {
	return self.origin;
}