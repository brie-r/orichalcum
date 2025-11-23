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

vector(float angle_change, float angle_offset, float distance) origin_star {
	float angle = angle_change * self.cnt + angle_offset;
	vector offset = Vector(cos(angle * DEG2RAD), 0, sin(angle * DEG2RAD)) * distance;
	return (self.origin + '0 0 16' + 
			11 * v_forward +
			offset_x * v_right +
			offset_z * v_up);
}

void() W_FireNailgun {

	// TODO: nail spread here

	vector v, dir;
	// remember sv_aim
	dir = aim( self, AUTOAIM_DIST );
	v = vectoangles( dir );
	v_x *= -1;	// pitch comes back inverted from vectoangles :|
	makevectors( v );

	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	self.currentammo = self.ammo_nails = self.ammo_nails - wcvar("nailgun", "ammo_cost");

	// vector shot_origin = origin_star(122, 0, 10);
	vector shot_origin = origin_star(180, 0, 2.5);
	float speed = wcvar_spread("nail", "speed");
	// default sv_maxvelocity is 2000, any higher leads to weird 
	// angular offsets caused by clamping the velocity
	launch_nail(shot_origin, dir * speed);
	self.attack_finished += wcvar("nailgun", "attack_delay");
}

void() spike_unfatten { self.movetype = MOVETYPE_FLY; }

vector() perforator_origin {
	float angle = 135 * self.cnt + 45;
	vector offset = Vector(cos(angle * DEG2RAD), 0, sin(angle * DEG2RAD)) * 1.25;
	return (self.origin + '0 0 16' + 
			// originally 11
			11 * v_forward +
			offset_x * v_right +
			offset_z * v_up);
}

void() W_FirePerforator {
	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.currentammo = self.ammo_nails = self.ammo_nails - wcvar("perforator", "ammo_cost");

	vector spread1 = wcvar_vec("perforator", "spread1");
	vector spread2 = wcvar_vec("perforator", "spread2");
	float speed1 = wcvar_spread("perforator_nail", "speed1");
	float speed2 = wcvar_spread("perforator_nail", "speed2");
	vector dir1 = SpreadOval(v_forward, spread1);
	vector dir2 = SpreadOval(v_forward, spread2);

	entity spike1 = launch_nail(origin_star(135, 45, 1.25), dir1 * speed1);
	entity spike2 = launch_nail(origin_star(135, 45, 1.25), dir2 * speed2);

	// weaken the SNG at long distance while keeping the spread under control
	spike1.think = spike_unfatten;
	spike2.think = spike_unfatten;
	spike1.nextthink = time + 0.25;
	spike2.nextthink = time + 0.3;
	
	self.attack_finished += wcvar("perforator", "attack_delay");
	
	if (has_quad(self))
	{
		// here's a silly thing:
		// one vanilla SNG nail does 18 dmg, 72 with quad, enough to gib zombies and grunts.
		// two copper nails do 9 each, 36 each with quad, for the same total damage, but that
		//   only kills grunts and knocks zombies down because the second nail doesn't hit.
		
		// the dumb solution is to make one nail do 0 dmg and the other do 18 in quad mode
		//   so the math works out like the old math and the quad SNG still feels right
		spike1.dmg = wcvar_spread("perforator", "dmg1");
		spike2.dmg = wcvar_spread("perforator", "dmg2");
		spike1.buddy = spike1;
		spike2.buddy = spike2;
		// first one to hit does its damage and then nerfs its 'buddy'
	}
}

void() W_FireSpikes {
	if (self.ammo_nails < 1 || (self.ammo_nails < 2 && !(self.items & IT_NAILGUN)))
	{
		W_SelectBestWeapon();
		return;
	}
	self.attack_finished = time;
	if (self.ammo_nails >= 2 && self.weapon == IT_SUPER_NAILGUN)
	{
		W_FirePerforator();
	}
	else
	{
		W_FireNailgun();
	}
	self.punchangle_x = -2;
	self.cnt += 1;
	// self.cnt = cycle(self.cnt,8);
}

float() CheckValidSpikeTouch =
{
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


void() spike_touch =
{
	if (!CheckValidSpikeTouch()) return;
	
	if (self.dmg)
	{
		if (other.takedamage)
		{
			spawn_touchblood (self.dmg);
			T_Damage (other, self, self.trueowner, self.dmg);
		}
		else
		{
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
		
		if (self.classname == "laser")
		{
			sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
			particle (self.origin, self.velocity*-0.01, 235, 15);
		}
	}
	// nonsense for combining quad SNG spike damage
	if (self.buddy)
		self.buddy.dmg = 0;
	remove(self);
}


