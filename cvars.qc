void(float f) test {
	print("lookin good");
	print(ftos(f));
}
// #include "csdefs.qc"
void() init_cvars
{

	if (isfunction("test")) {
		callfunction(3, "test");
	}
	else {
		print("false");
	}

	// TODO
	// check CvarWithSpread() lines up with random()
	// check CvarWithVecSpread() lines up with random()
	// deal with crandom() instances
	// per-weapon self-damage ratio / knockback / self-knockback



	autocvar(sv_respawn, TRUE);
	autocvar(sv_last_player_standing, TRUE);
	autocvar(sv_rounds_per_map, TRUE);
	autocvar(sv_maps_per_game, TRUE);
	autocvar(sv_respawn, TRUE);
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

fnptr_fire() wcvar_fn_fire { return fire_error; }
fnptr_spread() wcvar_fn_spread { return spread_error; }
fnptr_origin() wcvar_fn_origin { return origin_error; }
typedef .float float_ref;
float_ref() w_reserve_ammo { return __NULL__; }
float_ref() w_primary_ammo { return __NULL__; }
