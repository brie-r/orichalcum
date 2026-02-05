// #include "csdefs.qc"
void() init_cvars
{
	// TODO
	// check CvarWithSpread() lines up with random()
	// check CvarWithVecSpread() lines up with random()
	// deal with crandom() instances
	// per-weapon self-damage ratio / knockback / self-knockback

	// server
	autocvar(sv_knockback, 8, "When damaged, multiply damage by this to calculate added momentum. Default: 8");
	autocvar(sv_selfdamage, 1, "Toggle whether you take damage from sources you own (eg your rocket's explosion). Doesn't affect knockback. Default: 1");
	autocvar(sv_team_passthru, 1);
	autocvar(sv_team_attack_passthru, 1);
	autocvar(sv_team_nudge, 1);
	autocvar(sv_nudge_force, 60);
	autocvar(sv_nudge_radius, 32);
	// melee	
	
	autocvar(w_axe_attack_delay, 0.49);
	autocvar(w_axe_dmg, 24);
	autocvar(w_axe_dmg_spread, 0);

	// nailguns
	
	autocvar(w_nails_max_ammo, 200);
	
	autocvar(w_nailgun_fn_fire, "nail");
	autocvar(w_nailgun_fn_spread, "oval");
	autocvar(w_nailgun_ammo_type, "nails");
	autocvar(w_nailgun_ammo_cost, 1);
	autocvar(w_nailgun_attack_delay, 0.09);
	autocvar(w_nailgun_spread, '0 0 0');
	autocvar(w_nailgun_sfx_fire, "weapons/rocket1i.wav");
	
	autocvar(w_nail_speed, 1996);
	autocvar(w_nail_speed_spread, 0);
	
	autocvar(w_nailgun_fn_origin, "circle");
	autocvar(w_nailgun_origin_base_offset, '0 11 16');
	autocvar(w_nailgun_origin_angle_change, 180);
	autocvar(w_nailgun_origin_angle_offset, 0);
	autocvar(w_nailgun_origin_circle_radius, 2.5);

	// autocvar(w_nailgun_dmg1, 0);
	// autocvar(w_nailgun_dmg2, 0);
	// autocvar(w_nailgun_dmg_spread, 0);
	autocvar(w_nailgun_shot_count, 1);
	autocvar(w_nailgun_clip_size, 0);
	autocvar(w_nailgun_reload_delay_first, 0);
	autocvar(w_nailgun_reload_delay, 0);

	autocvar(w_perforator_fn_fire, "perforator_nail");
	autocvar(w_perforator_fn_spread, "oval");
	autocvar(w_perforator0_dmg_spread, 0);
	autocvar(w_perforator1_dmg_spread, 0);
	autocvar(w_perforator_ammo_type, "nails");
	autocvar(w_perforator_ammo_cost, 2);
	autocvar(w_perforator_attack_delay, 0.09);
	autocvar(w_perforator_splash_dmg, 0);
	autocvar(w_perforator_dmg, 9);
	// autocvar(w_perforator_spread, '2.292 2.292 0');
	// perforator spread definitely converted wrong
	// redo someday
	// but for now:
	autocvar(w_perforator_spread, '7.5 7.5 0');
	autocvar(w_perforator_sfx_fire, "weapons/spike2.wav");
	
	autocvar(w_perforator_nail_speed, 980);
	autocvar(w_perforator_nail_speed0, 940);
	autocvar(w_perforator_nail_speed1, 1020);
	autocvar(w_perforator_nail_speed_spread, 30);

	autocvar(w_perforator_fn_origin, "circle");
	autocvar(w_perforator_origin_base_offset, '0 11 16');
	autocvar(w_perforator_origin_angle_change, 135);
	autocvar(w_perforator_origin_angle_offset, 45);
	autocvar(w_perforator_origin_circle_radius, 1.25);
	
	autocvar(w_perforator_shot_count, 2);
	autocvar(w_perforator_clip_size, 0);
	autocvar(w_perforator_reload_delay_first, 0);
	autocvar(w_perforator_reload_delay, 0);

	// explosive launchers
	autocvar(w_rockets_max_ammo, 100);
	
	autocvar(w_grenadelauncher_fn_fire, "grenade");
	autocvar(w_grenadelauncher_fn_origin, "rocket");
	autocvar(w_grenadelauncher_fn_spread, "oval");
	autocvar(w_grenadelauncher_ammo_type, "rockets");
	autocvar(w_grenadelauncher_ammo_cost, 1);
	autocvar(w_grenadelauncher_attack_delay, 0.6);
	autocvar(w_grenadelauncher_dmg, 120);
	autocvar(w_grenadelauncher_splash_dmg, 120);
	autocvar(w_grenadelauncher_dmg_spread, 0);
	autocvar(w_grenadelauncher_spread, '0.955 0.955 0');
	autocvar(w_grenadelauncher_shot_count, 1);
	autocvar(w_grenadelauncher_clip_size, 0);
	autocvar(w_grenadelauncher_reload_delay_first, 0);
	autocvar(w_grenadelauncher_reload_delay, 0);

	autocvar(w_grenade_speed, 600);
	autocvar(w_grenade_vel_mult, '600 0 200');
	// also splash damage

	autocvar(w_rocketlauncher_fn_fire, "rocket");
	autocvar(w_rocketlauncher_fn_origin, "rocket");
	autocvar(w_rocketlauncher_fn_spread, "oval");
	autocvar(w_rocketlauncher_ammo_type, "rockets");
	autocvar(w_rocketlauncher_ammo_cost, 1);
	autocvar(w_rocketlauncher_attack_delay, 0.8);
	autocvar(w_rocketlauncher_dmg, 120);
	autocvar(w_rocketlauncher_splash_dmg, 120);
	autocvar(w_rocketlauncher_dmg_spread, 0);
	autocvar(w_rocketlauncher_shot_count, 1);
	autocvar(w_rocketlauncher_spread, '0 0 0');
	autocvar(w_rocketlauncher_clip_size, 0);
	autocvar(w_rocketlauncher_reload_delay_first, 0);
	autocvar(w_rocketlauncher_reload_delay, 0);

	autocvar(w_rocket_speed, 1000, "Speed of rocket launcher's projectile. Default: 1000. Aims incorrectly after ~2000.");
	autocvar(w_rocket_speed_spread, 0);
	// also splash damage
	
	// shotguns
	
	autocvar(w_shells_max_ammo, 100);
	
	autocvar(w_shotgun_fn_fire, "bullet");
	autocvar(w_shotgun_fn_origin, "bullet");
	autocvar(w_shotgun_fn_spread, "oval");
	autocvar(w_shotgun_ammo_type, "shells");
	autocvar(w_shotgun_ammo_cost, 1);
	autocvar(w_shotgun_attack_delay, 0.5);
	autocvar(w_shotgun_dmg, 4);
	autocvar(w_shotgun_splash_dmg, 0);
	autocvar(w_shotgun_dmg_spread, 0);
	autocvar(w_shotgun_dmg_spread_dead, 2);
	autocvar(w_shotgun_penetration_limit, 8);
	autocvar(w_shotgun_shot_count, 6);
	autocvar(w_shotgun_spread, '2.291 2.291 0');
	autocvar(w_shotgun_punch_angle, '-2 0 0');
	autocvar(w_shotgun_sfx_fire, "weapons/guncock.wav");
	autocvar(w_shotgun_clip_size, 8);
	autocvar(w_shotgun_reload_delay_first, 1.0);
	autocvar(w_shotgun_reload_delay, 0.4);
	autocvar(w_shotgun_reload_max_ammo, 1);
	
	autocvar(w_soldiershotgun_fn_fire, "bullet");
	autocvar(w_soldiershotgun_fn_origin, "bullet");
	autocvar(w_soldiershotgun_fn_spread, "oval");
	autocvar(w_soldiershotgun_ammo_type, "shells");
	autocvar(w_soldiershotgun_ammo_cost, 0);
	autocvar(w_soldiershotgun_attack_delay, 0.5);
	autocvar(w_soldiershotgun_dmg, 4);
	autocvar(w_soldiershotgun_splash_dmg, 0);
	autocvar(w_soldiershotgun_dmg_spread, 0);
	autocvar(w_soldiershotgun_dmg_spread_dead, 0);
	autocvar(w_soldiershotgun_penetration_limit, 0);
	autocvar(w_soldiershotgun_shot_count, 4);
	autocvar(w_soldiershotgun_spread, '5.711 5.711 0');
	autocvar(w_soldiershotgun_punch_angle, '-2 0 0');
	autocvar(w_soldiershotgun_sfx_fire, "weapons/guncock.wav");
	autocvar(w_soldiershotgun_clip_size, 0);
	autocvar(w_soldiershotgun_reload_delay_first, 0);
	autocvar(w_soldiershotgun_reload_delay, 0);

	autocvar(w_supershotgun_fn_fire, "bullet");
	autocvar(w_supershotgun_fn_origin, "bullet");
	autocvar(w_supershotgun_fn_spread, "oval");
	autocvar(w_supershotgun_ammo_type, "shells");
	autocvar(w_supershotgun_ammo_cost, 2);
	autocvar(w_supershotgun_attack_delay, 0.7);
	autocvar(w_supershotgun_dmg, 4);
	autocvar(w_supershotgun_splash_dmg, 0);
	autocvar(w_supershotgun_dmg_spread, 0);
	autocvar(w_supershotgun_penetration_limit, 8);
	autocvar(w_supershotgun_shot_count, 14);
	autocvar(w_supershotgun_spread, '7.97 4.574 0');
	autocvar(w_supershotgun_punch_angle, '-4 0 0');
	autocvar(w_supershotgun_sfx_fire, "weapons/shotgn2.wav");
	autocvar(w_supershotgun_clip_size, 0);
	autocvar(w_supershotgun_reload_delay_first, 0);
	autocvar(w_supershotgun_reload_delay, 0);

	// energy weapons
	autocvar(w_cells_max_ammo, 100);
	
	// autocvar(w_lightninggun, "fn_origin");
	autocvar(w_lightninggun_ammo_type, "cells");
	autocvar(w_lightninggun_ammo_cost, 1);
	autocvar(w_lightninggun_attack_delay, 0.1);
	autocvar(w_lightninggun_dmg, 30);
	autocvar(w_lightninggun_splash_dmg, 0);
	autocvar(w_lightninggun_dmg_spread, 0);
	autocvar(w_lightninggun_spread, '0 0 0');
	autocvar(w_lightninggun_clip_size, 0);
	autocvar(w_lightninggun_reload_delay_first, 0);
	autocvar(w_lightninggun_reload_delay, 0);
	// autocvar(w_lightninggun_shot_count, 1);

}

float(string ent_name, string cvar_suffix) wcvar_spread {
	string base_cvar = strcat("w_", ent_name, "_", cvar_suffix);
	float base = cvar(base_cvar);
	string spread_cvar = strcat("w_", ent_name, "_", cvar_suffix, "_spread");
	float spread = cvar(spread_cvar);
	return base + spread * random();
}

vector(string ent_name, string cvar_suffix) wcvar_spread_vec {
	string base_cvar = strcat("w_", ent_name, "_", cvar_suffix);
	vector base = cvar_vec(base_cvar);
	string spread_cvar = strcat("w_", ent_name, "_", cvar_suffix, "_spread");
	vector spread = cvar_vec(spread_cvar);
	return base + spread * random();
}

float(string weapon, string cvar_suffix) wcvar {
	string name = strcat("w_", weapon, "_", cvar_suffix);
	return cvar(name);
}
vector(string weapon, string cvar_suffix) wcvar_vec {
	string name = strcat("w_", weapon, "_", cvar_suffix);
	return cvar_vec(name);
}
string(string weapon, string cvar_suffix) wcvar_str {
	string name = strcat("w_", weapon, "_", cvar_suffix);
	return cvar_string(name);
}
vector (string cvar) cvar_vec {
	return stov(cvar_string(cvar));
}

fnptr_fire() wcvar_fn_fire {
	string func_name = wcvar_str(self.w_ctx.name, "fn_fire");
	string lowercase = strconv(1, 0, 0, func_name);
	switch(lowercase) {
		case "fire_bullet": return fire_bullet;
		case "fire_bullets": return fire_bullet;
		case "firebullet": return fire_bullet;
		case "firebullets": return fire_bullet;
		case "bullet": return fire_bullet;
		case "bullets": return fire_bullet;
		case "fire_rocket": return fire_rocket;
		case "fire_rockets": return fire_rocket;
		case "firerocket": return fire_rocket;
		case "firerockets": return fire_rocket;
		case "rocket": return fire_rocket;
		case "rockets": return fire_rocket;
		case "fire_grenade": return fire_grenade;
		case "fire_grenades": return fire_grenade;
		case "firegrenade": return fire_grenade;
		case "firegrenades": return fire_grenade;
		case "grenade": return fire_grenade;
		case "grenades": return fire_grenade;
		case "nail": return W_FireNailgun;
		case "perforator_nail": return fire_perforator;
	}
	return FireError;
}
fnptr_spread() wcvar_fn_spread {
	string func_name = wcvar_str(self.w_ctx.name, "fn_spread");
	string lowercase = strconv(1, 0, 0, func_name);
	switch(lowercase) {
		case "rect": return SpreadRect;
		case "oval": return SpreadOval;
	}
	return spread_error;
}
// fnptr_origin() wcvar_fn_origin {
// 	string func_name = wcvar_str(self.w_ctx.name, "fn_origin");
// 	string lowercase = strconv(1, 0, 0, func_name);
// 	switch(lowercase) {
// 		case "bullet": return origin_bullet;
// 		case "circle": return origin_circle;
// 		case "rocket": return origin_rocket;
// 	}
// 	return origin_error;
// }
fnptr_origin() wcvar_fn_origin {
	string func_name = wcvar_str(self.w_ctx.name, "fn_origin");
	string lowercase = strconv(1, 0, 0, func_name);
	switch(lowercase) {
		case "bullet": return origin_bullet;
		case "circle": return origin_circle;
		case "rocket": return origin_rocket;
	}
	return origin_error;
}
typedef .float float_ref;
float_ref() w_reserve_ammo {
	string ammo_type = wcvar_str(self.w_ctx.name, "ammo_type");
	string lowercase = strconv(1, 0, 0, ammo_type);
	switch(lowercase) {
		case "shell": return ammo_shells;
		case "shells": return ammo_shells;
		case "nail": return ammo_nails;
		case "nails": return ammo_nails;
		case "rocket": return ammo_rockets;
		case "rockets": return ammo_rockets;
		case "grenade": return ammo_rockets;
		case "grenades": return ammo_rockets;
		case "cell": return ammo_cells;
		case "cells": return ammo_cells;
		case "lightning": return ammo_cells;
	}
	return __NULL__;
}
float_ref() w_primary_ammo {
	string lowercase = strconv(1, 0, 0, self.w_ctx.name);
		switch(lowercase) {
		case "shotgun": return primary_ammo_shotgun;
		case "soldiershotgun": return primary_ammo_soldiershotgun;
		case "supershotgun": return primary_ammo_supershotgun;
		case "nailgun": return primary_ammo_nailgun;
		case "perforator": return primary_ammo_perforator;
		case "grenadelauncher": return primary_ammo_grenadelauncher;
		case "rocketlauncher": return primary_ammo_rocketlauncher;
		case "lightning": return primary_ammo_lightning;
	}
	return __NULL__;
}