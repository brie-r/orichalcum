const b_weapon b_shotgun = {
	.name = "shotgun",
	.fn_fire = fire_bullet,
	.fn_vfx = player_shot1,
	.fn_origin = origin_bullet,

	.fn_spread = SpreadOval,
	.fn_low_ammo = NoOpEnd,
	.fn_no_ammo = NoOpEnd,
	
	.fn_hit_alive = TraceHitAlive,
	.fn_hit_dead = TraceHitDead,
	.fn_hit_inanimate = TraceHitInanimate,
	.fn_hit_damageable = TraceHitDamageable,
	.fn_hit_ignore = NoOpHitContinue,
	.fn_hit_end = NoOpHitEnd
};
const b_weapon b_soldiershotgun = {
	.name = "soldiershotgun",
	.fn_fire = fire_bullet,
	.fn_vfx = player_shot1,
	.fn_origin = origin_bullet,

	.fn_spread = SpreadOval,
	.fn_low_ammo = NoOpEnd,
	.fn_no_ammo = NoOpEnd,
	
	.fn_hit_alive = TraceHitAlive,
	.fn_hit_dead = TraceHitDead,
	.fn_hit_inanimate = TraceHitInanimate,
	.fn_hit_damageable = TraceHitDamageable,
	.fn_hit_ignore = NoOpHitContinue,
	.fn_hit_end = NoOpHitEnd
};
const b_weapon b_supershotgun = {
	.name = "supershotgun",
	.fn_fire = fire_bullet,
	.fn_vfx = player_shot1,
	.fn_origin = origin_bullet,

	.fn_spread = SpreadOval,
	.fn_low_ammo = supershotgun_low_ammo,
	.fn_no_ammo = NoOpEnd,

	.fn_hit_alive = trace_explode_hit_alive,
	// .fn_hit_alive = TraceHitAlive,
	.fn_hit_dead = trace_explode_hit_dead,
	// .fn_hit_dead = TraceHitDead,
	.fn_hit_inanimate = trace_explode_hit_inanimate,
	// .fn_hit_inanimate = TraceHitInanimate,
	.fn_hit_damageable = trace_explode_hit_damageable,
	// .fn_hit_damageable = TraceHitDamageable,
	.fn_hit_ignore = NoOpHitContinue,
	.fn_hit_end = NoOpHitEnd
};

void() NoOpVoid {}
Branch() NoOpContinue { return Branch::Continue; }
Branch() NoOpEnd { return Branch::End; }

Branch() supershotgun_low_ammo {
	if (self.items & IT_SHOTGUN) w_try_fire(b_shotgun);
	return Branch::End;
}
Branch(vector dir) NoOpHitContinue { return Branch::Continue; }
Branch(vector dir) NoOpHitEnd { return Branch::End; }
void(float damage, vector dir) TraceHitFlesh {
	vector origin = trace_endpos - dir*4;
	vector reflect_dir = dir - trace_plane_normal * 2 * DotProduct(dir, trace_plane_normal);
	reflect_dir = normalize(reflect_dir);
	AddMultiDamage (trace_ent, damage);
	pointparticles(p_hit_flesh, origin, reflect_dir, 1);
}
Branch(vector dir) TraceHitAlive {
	float dmg = wcvar(self.w_ctx.name, "dmg");
	TraceHitFlesh(dmg, dir);
	return Branch::End;
}
Branch(vector dir) TraceHitDead {
	float dmg = wcvar(self.w_ctx.name, "dmg");
	float dmg_dead = 0.5 * (dmg + dmg * random());
	TraceHitFlesh(dmg_dead, dir);
	return Continue;
}
Branch(vector dir) TraceHitObject {
	vector origin = trace_endpos;
	vector reflect_dir = dir - trace_plane_normal * 2 * DotProduct(dir, trace_plane_normal);
	reflect_dir = normalize(reflect_dir);
	pointparticles(p_hit_inanimate, origin, reflect_dir, 1);
	return Branch::End;
}
Branch(vector dir) TraceHitInanimate {
	return TraceHitObject(dir);
}
Branch(vector dir) TraceHitDamageable {
	float dmg = wcvar(self.w_ctx.name, "dmg");
	AddMultiDamage (trace_ent, dmg);
	return TraceHitObject(dir);
}
Branch(entity t) HasBeenShotToDeath {
	if (t.multi_dmg < t.health) return Branch::End;
	if (DamageCanKill(t, t.multi_dmg)) return Branch::Continue;
	return Branch::End;
}
HitOutcome(entity ignore_ent, float penetrations) HitBranch {
	if (trace_fraction == 1.0) return HitOutcome::End;
	if (trace_ent == ignore_ent) return HitOutcome::Ignore;
	float is_creature = trace_ent.flags & FL_MONSTER || trace_ent.classname == "Player";
	float dead_soon = HasBeenShotToDeath(trace_ent);
	if (is_creature) {
		if (dead_soon) return HitOutcome::Dead;
		else return HitOutcome::Alive;
	}
	if (trace_ent.takedamage) return HitOutcome::Damageable;
	if (penetrations == 0) return HitOutcome::Inanimate;
	return HitOutcome::End;
}
entity(vector origin, vector dir_with_spread) fire_bullet {
	TraceHitscan(origin, dir_with_spread, self);
	return __NULL__;
}
void(vector origin, vector dir_with_spread, entity initial_ignore) TraceHitscan {
	vector destination;
	entity ignore_ent = initial_ignore;
	float max_len =  wcvar(self.w_ctx.name, "trace_len");
	float remaining_len = max_len;
	// penetrate dead enemies, but deal damage to potentially gib
	for (float penetrations = 0; penetrations <= 8; penetrations++)
	{
		destination = origin + dir_with_spread * remaining_len;
		traceline2(origin, destination, ignore_ent, 0);
		HitOutcome outcome = HitBranch(ignore_ent, penetrations);
		Branch cont = hit_branch(outcome, dir_with_spread);
		if (cont == Branch::Continue) {
			float traveled = vlen(trace_endpos - origin);
			origin = trace_endpos + dir_with_spread * 0.1;
			ignore_ent = trace_ent;
			remaining_len -= (traveled + 0.1);
			continue;
		}
		break;
	}
}
vector() origin_bullet {
	vector shot_origin = self.origin + v_forward * 10;
	// + v_up * -10;
	// thought this might fix the no knockback when looking straight down issue, no luck
	shot_origin_z = self.absmin_z + self.size_z * 0.7;
	return shot_origin;
}
// void() test {
// 	hashtable t = hash_createtab(64, EV_STRING);
// }