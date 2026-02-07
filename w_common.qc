enum AmmoStatus { Ok, Low, None };
enum ClipStatus { Primary, Reserve, Error };
enum HitOutcome { Alive, Dead, Inanimate, Damageable, Ignore, End };
enum Branch { Continue, End };
enum ReloadType { First, Subsequent };

typedef void() fnptr_vfx, fnptr_sfx;
typedef void(vector origin, vector dir) fnptr_fire;
typedef void(float cost) fnptr_update_ammo;
typedef Branch() fnptr_low_ammo, fnptr_no_ammo;
// typedef void(b_weapon weapon, vector dir) fnptr_fire_action;
typedef vector(vector dir, vector spread) fnptr_spread;
typedef Branch(float damage, vector dir) fnptr_hit_alive, fnptr_hit_dead, fnptr_hit_inanimate, fnptr_hit_damageable, fnptr_hit_ignore, fnptr_hit_end;
typedef vector(	vector base_offset, float angle_change, float angle_offset, float circle_radius) fnptr_origin;
// typedef void(vector org, vector vel, vector shot_count);
typedef struct {
	string name;
	fnptr_fire fn_fire;
	// fnptr_update_ammo fn_update_ammo;
	fnptr_vfx fn_vfx;
	fnptr_origin fn_origin;

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
	
	float count;
	// entity b = __NULL__;
} b_weapon;
.b_weapon w_ctx;

void(b_weapon weapon) w_fire {

	self.buddy_requested = __NULL__;
	self.shot_num = 0;

	self.w_ctx = weapon;
	float ammo_cost = wcvar(self.w_ctx.name, "ammo_cost");
	float attack_delay = wcvar(self.w_ctx.name, "attack_delay");
	reserve_ammo = w_reserve_ammo();
	primary_ammo = w_primary_ammo();

	ClipStatus clip_status = check_clip_status();
	switch (clip_status) {
		case ClipStatus::Primary: break;
		case ClipStatus::Reserve: primary_ammo = reserve_ammo; break;
		case ClipStatus::Error: dprint("Clip Status Error"); return;
	}
	AmmoStatus ammo_status = CheckAmmoStatus(ammo_cost);
	if (ammo_status == AmmoStatus::None) {
		// play click sound
		if (self.w_ctx.fn_no_ammo() == Branch::End) {
			self.attack_finished = time + attack_delay;
			return;
		}
	}
	else if (ammo_status == AmmoStatus::Low) {
		if (self.w_ctx.fn_low_ammo() == Branch::Continue) {		
			self.attack_finished = time + attack_delay;
			return;
		}
	}

	w_reload_cancel();

	self.w_ctx.fn_vfx();
	string sfx_fire = wcvar_str(self.w_ctx.name, "sfx_fire");
	sound (self, CHAN_WEAPON, sfx_fire, 1, ATTN_NORM);
	vector punch_angle = wcvar_vec(self.w_ctx.name, "punch_angle");
	self.punchangle = punch_angle;
	
	self.primary_ammo -= ammo_cost;

	self.attack_finished = time + attack_delay;

	makevectors(self.v_angle);
	local vector dir = aim (self, AUTOAIM_DIST);

	self.w_ctx.fn_origin = wcvar_fn_origin();
	self.w_ctx.fn_spread = wcvar_fn_spread();

	self.w_ctx.fn_fire = wcvar_fn_fire();

	float shot_count = wcvar(self.w_ctx.name, "shot_count");
	vector base_offset = wcvar_vec(self.w_ctx.name, "origin_base_offset");
	float angle_change = wcvar(self.w_ctx.name, "origin_angle_change");
	float angle_offset = wcvar(self.w_ctx.name, "origin_angle_offset");
	float circle_radius = wcvar(self.w_ctx.name, "origin_circle_radius");
	vector spread = wcvar_vec(self.w_ctx.name, "spread");
	ClearMultiDamage ();
	for (float shot = 0; shot < shot_count; shot++) {
		vector origin = self.w_ctx.fn_origin(base_offset, angle_change, angle_offset, circle_radius);
		vector dir_with_spread = self.w_ctx.fn_spread(dir, spread);
		self.w_ctx.fn_fire(origin, dir_with_spread);
		self.shot_num += 1;
	}
	ApplyMultiDamage ();
	
	self.currentammo = self.primary_ammo;
	if (clip_status == ClipStatus::Primary && self.primary_ammo == 0) {
		w_try_reload(ReloadType::First);
	}
	self.cnt += 1;
}

AmmoStatus(float ammo_cost) CheckAmmoStatus {
	if (self.primary_ammo == 0 && ammo_cost > 0) return AmmoStatus::None;
	else if (self.primary_ammo < ammo_cost && self.primary_ammo > 0) return AmmoStatus::Low;
	return AmmoStatus::Ok;
}
vector(vector dir, vector spread) SpreadRect {
	vector vec = vec_scale(spread, randomvec());
	return dir + vec_x * v_right + vec_y * v_up;
}
vector(vector dir, vector spread) SpreadOval {
	// randomvec doesn't produce a unit vec, so normalize(vec) won't be uniform :/
	// come back to this later, I guess
	vector vec = randomvec();
	// in case a port engine breaks id's handling of normalize(0)
	if (vec == '0 0 0') return dir;
	vec = random() * vec_scale(spread, normalize(vec));
	return dir + sin(vec_x * DEG2RAD) * v_right + cos((vec_y + 90) * DEG2RAD) * v_up;
}
void(vector origin, vector dir_with_spread) FireError {
	dprint("ERROR: fire function not found");
}
vector(vector _1, float _2, float _3, float _4) origin_error {
	dprint("ERROR: origin function not found");
	return '0 0 0';
}
vector(vector _1, vector _2) spread_error {
	dprint("ERROR: spread function not found");
	return '0 0 0';
}
void(ReloadType reload_type) w_try_reload {
	dprint("can reload? ");
	float a = w_can_reload();
	// dprint(ftos(a));
	dprint("\n");
	if (a == TRUE) {
		w_reload_start(reload_type);
	}
}
float() w_can_reload {
	// check: has no clips
	if (check_has_clips() == FALSE) {
		dprint("NO: has no clips.");
		return FALSE;
	}
	// check: no reserve ammo
	if (self.reserve_ammo <= 0) {
		dprint("NO: has no reserve ammo (");
		dprint(ftos(self.reserve_ammo));
		dprint(").");
		return FALSE;
	}
	// check: clip already full
	float clip_size = wcvar(self.w_ctx.name, "clip_size");
	if (self.primary_ammo >= clip_size) {
		dprint("NO: clip is already full (primary ammo: ");
		dprint(ftos(self.primary_ammo));
		dprint(" >= clip size: ");
		dprint(ftos(clip_size));
		dprint(").");
		return FALSE;
	}
	// check: already reloading
	if (self.reload_end_time != __NULL__ && self.reload_end_time > time) {
		dprint("NO: already reloading (reload end time: ");
		dprint(ftos(self.reload_end_time));
		dprint(" > time: ");
		dprint(ftos(time));
		dprint(").");
		return FALSE;
	}
	dprint("YES.");
	return TRUE;
}
void(ReloadType reload_type) w_reload_start {
	float reload_delay;
	if (reload_type == ReloadType::First) {
		reload_delay = wcvar(self.w_ctx.name, "reload_delay_first");
	}
	else {
		reload_delay = wcvar(self.w_ctx.name, "reload_delay");
	}
	if (reload_delay == 0) {
		w_reload_end();
		return;
	}
	self.reload_end_time = time + reload_delay;
	// reload start sound
}
void() w_reload_end {
	float clip_size = wcvar(self.w_ctx.name, "clip_size");
	float r_max1 = max(clip_size - self.primary_ammo, 0);
	float r_max2 = max(self.reserve_ammo, 0);
	float ammo_to_reload = min(r_max1, r_max2);
	float max_per_reload = wcvar(self.w_ctx.name, "reload_max_ammo");
	float reload_again = FALSE;
	// check sentinel: <= 0 means reload full clip
	if (max_per_reload > 0 && max_per_reload < ammo_to_reload) {
			reload_again = TRUE;
			ammo_to_reload = max_per_reload;
	}
	self.primary_ammo += ammo_to_reload;
	self.reserve_ammo -= ammo_to_reload;
	self.currentammo = self.primary_ammo;

	// reload end sound
	if (reload_again) {
		// float reload_delay = wcvar(self.w_ctx.name, "reload_delay");
		// self.reload_end_time = time + reload_delay;
		w_try_reload(ReloadType::Subsequent);
	}
	else {
		self.reload_end_time = __NULL__;
	}
	// if not reloaded, 
}
void() w_reload_cancel {
	self.reload_end_time = __NULL__;
}

float() check_has_clips {
	if (wcvar(self.w_ctx.name, "clip_size") <= 0) {
		return FALSE;
	}
	return TRUE;
}
ClipStatus() check_clip_status {
	float has_clips = check_has_clips();
	reserve_ammo = w_reserve_ammo();
	primary_ammo = w_primary_ammo();

	if (has_clips == TRUE && primary_ammo != __NULL__) {
		return ClipStatus::Primary;
	}
	else if (has_clips == FALSE && reserve_ammo != __NULL__) {
		return ClipStatus::Reserve;
	}
	return ClipStatus::Error;
}