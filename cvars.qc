#include "csdefs.qc"
void() init_cvars =
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
	// // autocvar(w_axe_ammo_cost, 1);
	// // autocvar(w_axe_projectile_speed, 0);6
	// // autocvar(w_axe_projectile_speed_spread, 0);
	// // autocvar(w_axe_shot_count, 1);
	// // autocvar(w_axe_spread, '0 0 0');

	// nailguns
	
	autocvar(w_nails_max_ammo, 200);

	autocvar(w_nailgun_ammo_cost, 1);
	autocvar(w_nailgun_attack_delay, 0.09);
	autocvar(w_nailgun_spread, '0 0 0');
	autocvar(w_nailgun_fn_spread, "SpreadOval");

	autocvar(w_nail_speed, 1996);
	autocvar(w_nail_speed_spread, 0);

	// autocvar(w_nailgun_dmg1, 0);
	// autocvar(w_nailgun_dmg2, 0);
	// autocvar(w_nailgun_dmg_spread, 0);
	// autocvar(w_nailgun_shot_count, 1);

	autocvar(w_perforator1_dmg_spread, 0);
	autocvar(w_perforator2_dmg_spread, 0);
	autocvar(w_perforator_ammo_cost, 2);
	autocvar(w_perforator_attack_delay, 0.09);
	autocvar(w_perforator_dmg1, 18);				// wait this number is in has_quad i'm confused
	autocvar(w_perforator_dmg2, 18);				// wait this number is in has_quad i'm confused
	autocvar(w_perforator_spread1, '0.02 0.02 0');
	autocvar(w_perforator_spread2, '0.02 0.02 0');
	autocvar(w_perforator_fn_spread, "SpreadOval");

	autocvar(w_perforator_nail_speed1, 940);
	autocvar(w_perforator_nail_speed2, 1020);
	autocvar(w_perforator_nail_speed_spread1, 30);
	autocvar(w_perforator_nail_speed_spread2, 30);

	// autocvar(w_perforator_shot_count, 1);

	// explosive launchers
	autocvar(w_rockets_max_ammo, 100);
	
	autocvar(w_grenadelauncher_fn_fire, "grenade");
	autocvar(w_grenadelauncher_ammo_cost, 1);
	autocvar(w_grenadelauncher_attack_delay, 0.6);
	autocvar(w_grenadelauncher_dmg, 120);
	autocvar(w_grenadelauncher_dmg_spread, 0);
	autocvar(w_grenadelauncher_spread, '0.955 0.955 0');
	autocvar(w_grenadelauncher_shot_count, 1);
	autocvar(w_grenadelauncher_fn_spread, "SpreadOval");
	
	autocvar(w_grenade_speed, 600);
	autocvar(w_grenade_vel_mult, '600 0 200');
	// also splash damage
	
	autocvar(w_rocketlauncher_fn_fire, "rocket");
	autocvar(w_rocketlauncher_ammo_cost, 1);
	autocvar(w_rocketlauncher_attack_delay, 0.8);
	autocvar(w_rocketlauncher_dmg, 120);
	autocvar(w_rocketlauncher_dmg_spread, 0);
	autocvar(w_rocketlauncher_shot_count, 1);
	autocvar(w_rocketlauncher_spread, '0 0 0');
	autocvar(w_rocketlauncher_fn_spread, "SpreadOval");
	
	autocvar(w_rocket_speed, 1000, "Speed of rocket launcher's projectile. Default: 1000. Aims incorrectly after ~2000.");
	autocvar(w_rocket_speed_spread, 0);
	// also splash damage
	
	// shotguns
	
	autocvar(w_shells_max_ammo, 100);
	
	autocvar(w_shotgun_fn_fire, "bullet");
	autocvar(w_shotgun_ammo_cost, 1);
	autocvar(w_shotgun_attack_delay, 0.5);
	autocvar(w_shotgun_dmg, 4);
	autocvar(w_shotgun_dmg_spread, 0);
	autocvar(w_shotgun_dmg_spread_dead, 2);
	autocvar(w_shotgun_penetration_limit, 8);
	autocvar(w_shotgun_shot_count, 6);
	autocvar(w_shotgun_spread, '2.291 2.291 0');
	autocvar(w_shotgun_punch_angle, '-2 0 0');
	autocvar(w_shotgun_sfx_fire, "weapons/guncock.wav");
	autocvar(w_shotgun_fn_spread, "SpreadOval");

	// // autocvar(w_shotgun_projectile_speed, 0);
	// // autocvar(w_shotgun_projectile_speed_spread, 0);

	autocvar(w_soldiershotgun_fn_fire, "bullet");
	autocvar(w_soldiershotgun_ammo_cost, 0);
	autocvar(w_soldiershotgun_attack_delay, 0.5);
	autocvar(w_soldiershotgun_dmg, 4);
	autocvar(w_soldiershotgun_dmg_spread, 0);
	autocvar(w_soldiershotgun_dmg_spread_dead, 0);
	autocvar(w_soldiershotgun_penetration_limit, 0);
	autocvar(w_soldiershotgun_shot_count, 4);
	autocvar(w_soldiershotgun_spread, '5.711 5.711 0');
	autocvar(w_soldiershotgun_punch_angle, '-2 0 0');
	autocvar(w_soldiershotgun_sfx_fire, "weapons/guncock.wav");
	autocvar(w_soldiershotgun_fn_spread, "SpreadOval");

	autocvar(w_supershotgun_fn_fire, "bullet");
	autocvar(w_supershotgun_ammo_cost, 2);
	autocvar(w_supershotgun_attack_delay, 0.7);
	autocvar(w_supershotgun_dmg, 4);
	autocvar(w_supershotgun_dmg_spread, 0);
	autocvar(w_supershotgun_penetration_limit, 8);
	autocvar(w_supershotgun_shot_count, 14);
	autocvar(w_supershotgun_spread, '7.97 4.574 0');
	autocvar(w_supershotgun_punch_angle, '-4 0 0');
	autocvar(w_supershotgun_sfx_fire, "weapons/shotgn2.wav");
	autocvar(w_supershotgun_fn_spread, "SpreadOval");

	

	// // autocvar(w_supershotgun_projectile_speed, 0);
	// // autocvar(w_supershotgun_projectile_speed_spread, 0);
	
	// energy weapons
	
	autocvar(w_cells_max_ammo, 100);

	autocvar(w_lightninggun_ammo_cost, 1);
	autocvar(w_lightninggun_attack_delay, 0.1);
	autocvar(w_lightninggun_dmg, 30);
	autocvar(w_lightninggun_dmg_spread, 0);
	autocvar(w_lightninggun_spread, '0 0 0');
	// autocvar(w_lightninggun_shot_count, 1);
	// // autocvar(w_lightninggun_projectile_speed, 0);
	// // autocvar(w_lightninggun_projectile_speed_spread, 0);

}

float(string ent_name, string cvar_suffix) wcvar_spread = {
	string base_cvar = strcat("w_", ent_name, "_", cvar_suffix);
	float base = cvar(base_cvar);
	string spread_cvar = strcat("w_", ent_name, "_", cvar_suffix, "_spread");
	float spread = cvar(spread_cvar);
	return base + spread * random();
}

vector(string ent_name, string cvar_suffix) wcvar_spread_vec = {
	string base_cvar = strcat("w_", ent_name, "_", cvar_suffix);
	vector base = cvar_vec(base_cvar);
	string spread_cvar = strcat("w_", ent_name, "_", cvar_suffix, "_spread");
	vector spread = cvar_vec(spread_cvar);
	return base + spread * random();
}

float(string weapon, string cvar_suffix) wcvar = {
	string name = strcat("w_", weapon, "_", cvar_suffix);
	return cvar(name);
}
vector(string weapon, string cvar_suffix) wcvar_vec = {
	string name = strcat("w_", weapon, "_", cvar_suffix);
	return cvar_vec(name);
}
string(string weapon, string cvar_suffix) wcvar_str = {
	string name = strcat("w_", weapon, "_", cvar_suffix);
	return cvar_string(name);
}
vector (string cvar) cvar_vec = {
	return stov(cvar_string(cvar));
}

fnptr_fire(string func_name) GetFireFunc = {
	string lowercase = strconv(1, 0, 0, func_name);
	switch(lowercase) {
		case "fire_bullet": return fire_bullet;
		case "fire_bullets": return fire_bullet;
		case "firebullet": return fire_bullet;
		case "firebullets": return fire_bullet;
		case "bullet": return fire_bullet;
		case "bullets": return fire_bullet;
		case "fire_rocket":  return fire_rocket;
		case "fire_rockets":  return fire_rocket;
		case "firerocket":  return fire_rocket;
		case "firerockets":  return fire_rocket;
		case "rocket":  return fire_rocket;
		case "rockets":  return fire_rocket;
		case "fire_grenade": return fire_grenade;
		case "fire_grenades": return fire_grenade;
		case "firegrenade": return fire_grenade;
		case "firegrenades": return fire_grenade;
		case "grenade": return fire_grenade;
		case "grenades": return fire_grenade;
	}
	
	return FireError;
};
fnptr_spread(string func_name) GetSpreadFunc = {
	string lowercase = strconv(1, 0, 0, func_name);
	switch(lowercase) {
		case "SpreadRect": return SpreadRect;
		case "SpreadOval": return SpreadOval;
	}
	return SpreadOval;
};