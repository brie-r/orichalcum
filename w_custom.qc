Branch(vector dir) trace_explode_hit_alive {
	dprint("Alive");
	float dmg = wcvar(self.w_ctx.name, "dmg");
	// kaboom(trace_endpos, dmg, self, 0);
	BecomeExplosion();
	// TraceHitFlesh(dmg, dir);
	return Branch::End;
}
Branch(vector dir) trace_explode_hit_dead {
	dprint("Dead");
	float dmg = wcvar(self.w_ctx.name, "dmg");
	kaboom(trace_endpos - dir * 4, dmg, self, 0);
	return Continue;
}
Branch(vector dir) trace_explode_hit_inanimate {
	dprint("Inanimate");
	return trace_explode_hit_object(dir);
}
Branch(vector dir) trace_explode_hit_damageable {
	dprint("Damageable");
	float dmg = wcvar(self.w_ctx.name, "dmg");
	AddMultiDamage (trace_ent, dmg);
	return trace_explode_hit_object(dir);
}
Branch(vector dir) trace_explode_hit_object {
	dprint("Object");
	float dmg = wcvar(self.w_ctx.name, "dmg");
	kaboom(trace_endpos - dir * 4, dmg, self, 0);
	// vector reflect_dir = dir - trace_plane_normal * 2 * DotProduct(dir, trace_plane_normal);
	// reflect_dir = normalize(reflect_dir);
	// pointparticles(p_hit_inanimate, origin, reflect_dir, 1);
	return Branch::End;
}
void() claw_think {
	// self.velocity = 0;
	// if (time > self.lifetime_finished) {
	// 	T_MissileExplode();
	// 	return;
	// }
	// stopped on the ground
	// also try lerping from max vel to 0 based on lifetime version
	if (self.velocity != VEC_ORIGIN) {
		self.velocity = self.velocity * 0.999;
		self.nextthink = time;
	} else {
		self.think = T_MissileExplode;
		self.nextthink = time + self.delay;
		return;
	}

	// self.flags = not(self.flags, FL_ONGROUND);
	// self.oldvelocity = self.velocity;
	// self.nextthink = time + 0.05;	// 10hz is probably enough, but 20hz is surely twice as good
}
entity(vector org, vector dir_with_spread) fire_claw
{
	vector vel = local_to_world(wcvar_vec(self.w_ctx.name, "vel"), dir_with_spread);
	entity projectile = launch_projectile(org, vel, "claw_rocket");
	projectile.w_ctx.name = self.w_ctx.name;
	projectile.type = "projectile";

	projectile.dmg = wcvar(self.w_ctx.name, "dmg");
	projectile.delay = wcvar(self.w_ctx.name, "timer");
	projectile.think = claw_think;
	projectile.nextthink = time;
	projectile.touch = projectile_touch_dispatch;

	SUB_ChangeModel(projectile, "progs/missile.mdl");
	return projectile;
}