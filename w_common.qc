enum AmmoStatus { Ok, Low, None };
enum HitOutcome { Alive, Dead, Inanimate, Damageable, Ignore, End };
enum Branch { Continue, End };

typedef void() fnptr_vfx, fnptr_sfx;
typedef void(vector dir) fnptr_fire;
typedef void(float cost) fnptr_update_ammo;
typedef Branch() fnptr_low_ammo, fnptr_no_ammo;
// typedef void(b_weapon weapon, vector dir) fnptr_fire_action;
typedef vector(vector dir, vector spread) fnptr_spread;
typedef float(float damage, vector dir) fnptr_hit_alive, fnptr_hit_dead, fnptr_hit_inanimate, fnptr_hit_damageable, fnptr_hit_ignore, fnptr_hit_end;
// typedef void(vector org, vector vel, vector shot_count);
typedef struct {
	string name;
	fnptr_fire fn_fire;
	// fnptr_update_ammo fn_update_ammo;
	fnptr_vfx fn_vfx;
	// fnptr_sfx fn_sfx;
	fnptr_spread fn_spread;
	fnptr_low_ammo fn_low_ammo;
	fnptr_no_ammo fn_no_ammo;
	// fnptr_projectile fn_projectile;
	
	fnptr_hit_alive fn_hit_alive;
	fnptr_hit_dead fn_hit_dead;
	fnptr_hit_inanimate fn_hit_inanimate;
	fnptr_hit_damageable fn_hit_damageable;
	fnptr_hit_ignore fn_hit_ignore;
	fnptr_hit_end fn_hit_end;
} b_weapon;
b_weapon w_ctx;

void(b_weapon weapon) w_fire = {
	w_ctx = weapon;
	float ammo_cost = wcvar(w_ctx.name, "ammo_cost");
	float attack_delay = wcvar(w_ctx.name, "attack_delay");
	AmmoStatus ammo_status = CheckAmmoStatus(ammo_cost);
	if (ammo_status == AmmoStatus::None) {
		// play click sound
		if (w_ctx.fn_no_ammo() == Branch::End) {
			self.attack_finished = time + attack_delay;
			return;
		}
	}
	else if (ammo_status == AmmoStatus::Low)	{
		if (w_ctx.fn_low_ammo() == Branch::Continue) {		
			self.attack_finished = time + attack_delay;
			return;
		}
	}
	w_ctx.fn_vfx();
	string sfx_fire = wcvar_str(w_ctx.name, "sfx_fire");
	sound (self, CHAN_WEAPON, sfx_fire, 1, ATTN_NORM);
	vector punch_angle = wcvar_vec(w_ctx.name, "punch_angle");
	self.punchangle = punch_angle;
	self.currentammo = self.ammo_shells = self.ammo_shells - ammo_cost;
	// w_ctx.fn_update_ammo(ammo_cost);
	local vector dir = aim (self, AUTOAIM_DIST);
	self.attack_finished = time + attack_delay;
	string fire_fn = wcvar_str(w_ctx.name, "fn_fire");
	string spread_fn = wcvar_str(w_ctx.name, "fn_spread");
	w_ctx.fn_spread = GetSpreadFunc(spread_fn);
	w_ctx.fn_fire = GetFireFunc(fire_fn);
	w_ctx.fn_fire(dir);
}

AmmoStatus(float ammo_cost) CheckAmmoStatus {
	if (self.currentammo == 0 && ammo_cost > 0) return AmmoStatus::None;
	else if (self.currentammo < ammo_cost && self.currentammo > 0) return AmmoStatus::Low;
	return AmmoStatus::Ok;
}
vector(vector dir, vector spread) SpreadRect {
	vector vec = vec_scale(spread, randomvec());
	return dir + vec_x * v_right + vec_y * v_up;
}
vector(vector dir, vector spread) SpreadOval {
	vector vec = randomvec();
	// just in case a port engine breaks id's handling of the normalize(0) case
	if (vec == '0 0 0') return dir;
	vec = random() * vec_scale(spread, normalize(vec));
	return dir + sin(vec_x * DEG2RAD) * v_right + cos((vec_y + 90) * DEG2RAD) * v_up;
}
 void(vector dir) FireError {
	dprint("ERROR: fire function not found");
 }