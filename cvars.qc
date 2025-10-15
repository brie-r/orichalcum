#include "csdefs.qc"
void() init_cvars =
{




	// TODO
	// check CvarWithSpread() lines up with random()
	// check CvarWithVecSpread() lines up with random()
	// deal with crandom() instances





	autocvar(sv_selfdamage, 1, "Toggle whether you take damage from sources you own (eg your rocket's explosion). Doesn't affect knockback. Default: 1");
	autocvar(sv_knockback, 8, "When damaged, multiply damage by this to calculate added momentum. Default: 8");
	
	// COMPLETE
	autocvar(w_shotgun_attack_delay, 0.5);
	autocvar(w_supershotgun_attack_delay, 0.7);
	autocvar(w_nailgun_attack_delay, 0.09);
	autocvar(w_perforator_attack_delay, 0.09);
	autocvar(w_grenadelaucher_attack_delay, 0.6);
	autocvar(w_rocketlauncher_attack_delay, 0.8);
	autocvar(w_lightninggun_attack_delay, 0.1);
	autocvar(w_axe_attack_delay, 0.49);

	// // autocvar(w_shotgun_projectile_speed, 0);
	// // autocvar(w_supershotgun_projectile_speed, 0);
	autocvar(w_nail_speed, 1996);
	autocvar(w_perforator_nail_speed1, 940);
	autocvar(w_perforator_nail_speed2, 1020);
	autocvar(w_grenade_speed, 200);
	autocvar(w_rocket_speed, 1000, "Speed of rocket launcher's projectile. Default: 1000. Aims incorrectly after ~2000.");

	// // autocvar(w_lightninggun_projectile_speed, 0);
	// // autocvar(w_axe_projectile_speed, 0);

	// // autocvar(w_shotgun_projectile_speed_spread, 0);
	// // autocvar(w_supershotgun_projectile_speed_spread, 0);
	autocvar(w_nail_speed_spread, 0);
	autocvar(w_perforator_nail_speed_spread1, 30);
	autocvar(w_perforator_nail_speed_spread2, 30);
	autocvar(w_grenade_speed_spread, 0);
	autocvar(w_rocket_speed_spread, 0);
	// // autocvar(w_lightninggun_projectile_speed_spread, 0);
	// // autocvar(w_axe_projectile_speed_spread, 0);

	autocvar(w_shotgun_ammo_cost, 1);
	autocvar(w_supershotgun_ammo_cost, 2);
	autocvar(w_nailgun_ammo_cost, 1);
	autocvar(w_perforator_ammo_cost, 2);
	autocvar(w_grenadelaucher_ammo_cost, 1);
	autocvar(w_rocketlauncher_ammo_cost, 1);
	autocvar(w_lightninggun_ammo_cost, 1);
	// // autocvar(w_axe_ammo_cost, 1);

	// INCOMPLETE
	autocvar(w_shotgun_shot_count, 6);
	autocvar(w_supershotgun_shot_count, 14);
	// autocvar(w_nailgun_shot_count, 1)
	// autocvar(w_perforator_shot_count, 1)
	// autocvar(w_grenadelaucher_shot_count, 1)
	// autocvar(w_rocketlauncher_shot_count, 1)
	// autocvar(w_lightninggun_shot_count, 1)
	// // autocvar(w_axe_shot_count, 1);

	// autocvar(w_shotgun_spread, 0);
	// autocvar(w_supershotgun_spread, 0);
	// autocvar(w_nailgun_spread, 0)
	autocvar(w_perforator_spread1, 0.02);
	autocvar(w_perforator_spread2, 0.02);
	// autocvar(w_grenadelaucher_spread, 0)
	// autocvar(w_rocketlauncher_spread, 0)
	// autocvar(w_lightninggun_spread, 0)
	// // autocvar(w_axe_spread, 0);

	autocvar(w_shotgun_spread_vec, '0.04 0.04 0');
	autocvar(w_supershotgun_spread_vec, '0.14 0.08 0');
	// autocvar(w_nailgun_spread_vec, '0 0 0')
	// autocvar(w_perforator_spread_vec1, '0.02 0.02 0')
	// autocvar(w_perforator_spread_vec2, '0.02 0.02 0')
	// autocvar(w_grenadelaucher_spread_vec, '0 0 0')
	// autocvar(w_rocketlauncher_spread_vec, '0 0 0')
	// autocvar(w_lightninggun_spread_vec, '0 0 0')
	// // autocvar(w_axe_spread_vec, '0 0 0');

	autocvar(w_shotgun_dmgA, 2);
	autocvar(w_shotgun_dmgB, 4);
	// autocvar(w_supershotgun_dmgA, 2)				// not currently used; uses shotgun cvars
	// autocvar(w_supershotgun_dmgB, 4)				// not currently used; uses shotgun cvars
	// autocvar(w_nailgun_dmg1, 0)
	// autocvar(w_nailgun_dmg2, 0)
	autocvar(w_perforator_dmg1, 18);				// wait this number is in has_quad i'm confused
	autocvar(w_perforator_dmg2, 18);				// wait this number is in has_quad i'm confused
	autocvar(w_grenadelaucher_dmg, 120);
	// also splash
	autocvar(w_rocketlauncher_dmg, 120);
	// also splash
	autocvar(w_lightninggun_dmg, 30);
	autocvar(w_axe_dmg, 24);

	autocvar(w_shotgun_dmg_spreadA, 2);
	autocvar(w_shotgun_dmg_spreadB, 0);
	// autocvar(w_supershotgun_dmg_spreadA, 2)		// not currently used; uses shotgun cvars
	// autocvar(w_supershotgun_dmg_spreadB, 0)		// not currently used; uses shotgun cvars
	// autocvar(w_nailgun_dmg_spread, 0)
	autocvar(w_perforator1_dmg_spread, 0);
	autocvar(w_perforator2_dmg_spread, 0);
	autocvar(w_grenadelaucher_dmg_spread, 0);
	autocvar(w_rocketlauncher_dmg_spread, 0);
	autocvar(w_lightninggun_dmg_spread, 0);
	autocvar(w_axe_dmg_spread, 0);
}

float(string ent_name, string cvar_type) CvarWithSpread = {
	string base_cvar = strcat("w_", ent_name, "_", cvar_type);
	float base = cvar(base_cvar);
	string spread_cvar = strcat("w_", ent_name, "_", cvar_type, "_spread");
	float spread = cvar(spread_cvar);
	return base + spread * random();
}

vector(string ent_name, string cvar_type) CvarWithVecSpread = {
	string base_cvar = strcat("w_", ent_name, "_", cvar_type);
	vector base = cvar_vec(base_cvar);
	string spread_cvar = strcat("w_", ent_name, "_", cvar_type, "_spread");
	vector spread = cvar_vec(spread_cvar);
	return base + spread * random();
}

// float(string ent_name, string cvar_type) CvarWithSpread = {
// 	return 0;
// }

// vector(string ent_name, string cvar_type) CvarWithVecSpread = {
// 	return '0 0 0';
// }


// predictably didn't work, need more examples of stov io
// debug printing?
vector (string cvar) cvar_vec = {
	return stov(cvar_string("my_vector_cvar"));
}