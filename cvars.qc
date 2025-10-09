void() init_cvars =
{
	autocvar(w_rocket_speed, 1000, "Speed of rocket launcher's projectile. Default: 1000. Aims incorrectly after ~2000.");
	autocvar(sv_selfdamage, 1, "Toggle whether you take damage from sources you own (eg your rocket's explosion). Doesn't affect knockback. Default: 1");
	autocvar(sv_knockback, 8, "When damaged, multiply damage by this to calculate added momentum. Default: 8");
}