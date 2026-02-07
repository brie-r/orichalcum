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

	.fn_hit_alive = TraceHitAlive,
	.fn_hit_dead = TraceHitDead,
	.fn_hit_inanimate = TraceHitInanimate,
	.fn_hit_damageable = TraceHitDamageable,
	.fn_hit_ignore = NoOpHitContinue,
	.fn_hit_end = NoOpHitEnd
};

void() NoOpVoid {}
Branch() NoOpContinue { return Branch::Continue; }
Branch() NoOpEnd { return Branch::End; }

float() supershotgun_low_ammo {
	if (self.items & IT_SHOTGUN) w_fire(b_shotgun);
	return FALSE;
}
Branch(float damage, vector dir) NoOpHitContinue { return Branch::Continue; }
Branch(float damage, vector dir) NoOpHitEnd { return Branch::End; }
void(float damage, vector dir) TraceHitFlesh {
	vector origin = trace_endpos - dir*4;
	vector reflect_dir = dir - trace_plane_normal * 2 * DotProduct(dir, trace_plane_normal);
	reflect_dir = normalize(reflect_dir);
	AddMultiDamage (trace_ent, damage);
	pointparticles(p_hit_flesh, origin, reflect_dir, 1);
}
Branch(float damage, vector dir) TraceHitAlive {
	TraceHitFlesh(damage, dir);
	return Branch::End;
}
Branch(float damage, vector dir) TraceHitDead {
	TraceHitFlesh(damage, dir);
	return Continue;
}
Branch(float damage, vector dir) TraceHitObject {
	vector origin = trace_endpos;
	vector reflect_dir = dir - trace_plane_normal * 2 * DotProduct(dir, trace_plane_normal);
	reflect_dir = normalize(reflect_dir);
	pointparticles(p_hit_inanimate, origin, reflect_dir, 1);
	return Branch::End;
}
Branch(float damage, vector dir) TraceHitInanimate {
	return TraceHitObject(damage, dir);
}
Branch(float damage, vector dir) TraceHitDamageable {
	AddMultiDamage (trace_ent, damage);
	return TraceHitObject(damage, dir);
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
void(vector origin, vector dir_with_spread) fire_bullet {
	TraceHitscan(origin, dir_with_spread, self);
}
void(vector origin, vector dir_with_spread, entity initial_ignore) TraceHitscan {
	float dmg, dmg_dead;
	vector destination;
	entity ignore_ent = initial_ignore;
	// penetrate dead enemies, but deal damage to potentially gib
	for (float penetrations = 0; penetrations <= 8; penetrations++)
	{
		// dmg_dead: sum half original damage, half original damage as spread, half original spread?
		dmg = wcvar_spread(self.w_ctx.name, "dmg");
		dmg_dead = 0.5 * (dmg + dmg * random());
		destination = origin + dir_with_spread * 2048;
		traceline2(origin, destination, ignore_ent, 0);
		HitOutcome outcome = HitBranch(ignore_ent, penetrations);
		Branch cont = hit_callbacks(outcome, dmg, dmg_dead, dir_with_spread);
		if (cont == Branch::Continue) {
			origin = trace_endpos + dir_with_spread * 0.1;
			ignore_ent = trace_ent;
			continue;
		}
		break;
	}
}
Branch(HitOutcome outcome, float dmg, float dmg_dead, vector dir_with_spread) hit_callbacks {
	switch (outcome) {
		case HitOutcome::Dead: return self.w_ctx.fn_hit_dead(dmg_dead, dir_with_spread);
		case HitOutcome::Ignore: return self.w_ctx.fn_hit_ignore(dmg, dir_with_spread);
		case HitOutcome::Alive: return self.w_ctx.fn_hit_alive(dmg, dir_with_spread);
		case HitOutcome::Inanimate: return self.w_ctx.fn_hit_inanimate(dmg, dir_with_spread);
		case HitOutcome::Damageable: return self.w_ctx.fn_hit_damageable(dmg, dir_with_spread);
		case HitOutcome::End: return self.w_ctx.fn_hit_end(dmg, dir_with_spread);
	}
	return Branch::End;
}
vector(vector _1, float _2, float _3, float _4) origin_bullet {
	vector shot_origin = self.origin + v_forward * 10;
	shot_origin_z = self.absmin_z + self.size_z * 0.7;
	return shot_origin;
}