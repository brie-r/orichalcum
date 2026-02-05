const b_weapon b_nailgun = {
	.name = "nailgun",
	.fn_fire = W_FireNailgun,
	.fn_vfx = player_nail,
	.fn_origin = origin_circle,

	.fn_spread = SpreadOval,
	.fn_low_ammo = NoOpEnd,
	.fn_no_ammo = NoOpEnd,
	
	.fn_hit_alive = NoOpHitEnd,
	.fn_hit_dead = NoOpHitContinue,
	.fn_hit_inanimate = NoOpHitEnd,
	.fn_hit_damageable = NoOpHitEnd,
	.fn_hit_ignore = NoOpHitContinue,
	.fn_hit_end = NoOpHitEnd
	
	// origin params: '0 0 16', 11, 180, 0, 2.5
};
const b_weapon b_perforator = {
	.name = "perforator",
	.fn_fire = fire_perforator,
	.fn_vfx = player_nail,
	.fn_origin = origin_circle,

	.fn_spread = SpreadOval,
	.fn_low_ammo = NoOpEnd,
	.fn_no_ammo = NoOpEnd,
	
	.fn_hit_alive = NoOpHitEnd,
	.fn_hit_dead = NoOpHitContinue,
	.fn_hit_inanimate = NoOpHitEnd,
	.fn_hit_damageable = NoOpHitEnd,
	.fn_hit_ignore = NoOpHitContinue,
	.fn_hit_end = NoOpHitEnd
	// origin params: '0 0 16', 11, 135, 45, 1.25
};
/*
================
spawn_touchblood

only used by nailguns so now it's here
================
*/
void(float damage) spawn_touchblood =
{
	local vector	vel;

	vel = normalize(self.velocity) * -1;
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	
	//vel = vel + 2*trace_plane_normal;
	// nailguns don't do traces so there is no valid trace plane normal
	// (which explains why nailgun blood spurts always seemed to be caught in some strange wind)
	
	SpawnBlood (self.origin + vel, vel * 40, damage);
}



// --------------------------------

vector(
	vector base_offset,
	float angle_change,
	float angle_offset,
	float circle_radius
) origin_circle {
	float angle = angle_change * self.cnt + angle_offset;
	vector offset = Vector(cos(angle * DEG2RAD), 0, sin(angle * DEG2RAD)) * circle_radius;
	return (self.origin +
		(base_offset_x + offset_x) * v_right +
		base_offset_y * v_forward + 
		(base_offset_z + offset_z) * v_up);
}

void(vector origin, vector dir_with_spread) W_FireNailgun {
	// default sv_maxvelocity is 2000, any higher leads to weird
	// angular offsets caused by clamping the velocity
	if (self.cnt >= 2) {
		self.cnt = 0;
	}
	float speed = wcvar_spread("nail", "speed");
	launch_nail(origin, dir_with_spread * speed);
}

void() spike_unfatten { self.movetype = MOVETYPE_FLY; }

void(vector origin, vector dir_with_spread) fire_perforator {
	if (self.cnt >= 8) {
		self.cnt = 0;
	}


	float nail = self.shot_num % 2;


	// vector spread = wcvar_vec("perforator", "spread");
	// float speed1 = wcvar_spread("perforator_nail", "speed1");
	// float speed2 = wcvar_spread("perforator_nail", "speed2");
	// vector dir1 = SpreadOval(v_forward, spread);
	// vector dir2 = SpreadOval(v_forward, spread);
	// float index = w_ctx.count % 2;
	// float speed = wcvar(w_ctx.name, strcat("speed", ftos(index)));
	float speed = wcvar_spread("perforator_nail", "speed");
	entity spike1 = launch_nail(origin, dir_with_spread * speed);
	
	
	// entity spike1 = launch_nail(origin, dir_with_spread * speed);
	// entity spike2 = launch_nail(origin, dir_with_spread * speed);
	// entity spike1 = launch_nail(origin_circle('0 11 16', 135, 45, 1.25), dir1 * speed1);
	// entity spike2 = launch_nail(origin_circle('0 11 16', 135, 45, 1.25), dir2 * speed2);
	
	// weaken the SNG at long distance while keeping the spread under control
	spike1.think = spike_unfatten;
	// spike2.think = spike_unfatten;
	spike1.nextthink = time + 0.25;
	// spike2.nextthink = time + 0.3;
	
	if (has_quad(self))
	{
		// here's a silly thing:
		// one vanilla SNG nail does 18 dmg, 72 with quad, enough to gib zombies and grunts.
		// two copper nails do 9 each, 36 each with quad, for the same total damage, but that
		//   only kills grunts and knocks zombies down because the second nail doesn't hit.
		
		// the dumb solution is to make one nail do 0 dmg and the other do 18 in quad mode
		//   so the math works out like the old math and the quad SNG still feels right
		spike1.dmg = wcvar("perforator", "dmg") * 2;
		// spike2.dmg = wcvar_spread("perforator", "dmg1");
		spike1.buddy = spike1;
		// spike2.buddy = spike2;
		// first one to hit does its damage and then nerfs its 'buddy'
	}
	// self.cnt += 1;
}

void(b_weapon weapon) fire_nailgun {
	// launch_nail(origin, dir_with_spread * speed);
	// self.cnt = cycle(self.cnt,8);
}
float() perforator_low_ammo {
	if (self.items & IT_NAILGUN) w_fire(b_nailgun);
	return FALSE;
}

float() CheckValidSpikeTouch {
	if (other == self.owner) return FALSE;
	if (other.solid == SOLID_TRIGGER) return FALSE;
	if (CheckProjectilePassthru()) return FALSE;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return FALSE;
	}
	
	return TRUE;
}


void() spike_touch {
	if (!CheckValidSpikeTouch()) return;
	
	if (self.dmg) {
		if (other.takedamage) {
			spawn_touchblood (self.dmg);
			T_Damage (other, self, self.trueowner, self.dmg);
		}
		else {
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			switch(self.classname)
			{
			case "wizspike":
				WriteByte (MSG_BROADCAST, TE_WIZSPIKE); break;
			case "knightspike":
				WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE); break;
			case "laser":
				WriteByte(MSG_BROADCAST, TE_GUNSHOT); break;
			default:
				WriteByte (MSG_BROADCAST, TE_SPIKE);
			}
			WriteCoord (MSG_BROADCAST, self.origin_x);
			WriteCoord (MSG_BROADCAST, self.origin_y);
			WriteCoord (MSG_BROADCAST, self.origin_z);
		}
		
		if (self.classname == "laser") {
			sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
			particle (self.origin, self.velocity*-0.01, 235, 15);
		}
	}
	// nonsense for combining quad SNG spike damage
	if (self.buddy)
		self.buddy.dmg = 0;
	remove(self);
}