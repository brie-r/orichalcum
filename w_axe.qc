/*
===============

THE AXE

===============
*/

// SOUNDS

void() W_AxeWhiffSound =
{
		sound (self, CHAN_OTHER, "weapons/ax1.wav", 1, ATTN_NORM);
}

void() W_AxeHitSound =
{
	if (random() < 0.5)
		sound (self, CHAN_WEAPON, "weapons/axhit1.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_WEAPON, "weapons/axhit2.wav", 1, ATTN_NORM);
}

void(float foff) W_AxeCycle =
{
	// lip and touch_time are overloaded on the player for animation event timing
	// lip = 10fps player anim clock (axe animates at 20 so player has to think on 20s)
	// touch_time = timer for the actual weapon attack trace event
	self.weaponframe = min(57, self.weaponframe + foff);
	
	// entire axe swing anim is scheduled to be done by now
	if (self.attack_finished <= time)
	{
		// stop the player anim cycle and restore normal thinking
		W_SetIdleWeaponFrame();
		player_run();
		return;
	}
	
	if (self.touch_time && self.touch_time <= time)
	{
		self.touch_time = 0;
		W_FireAxe();
	}
	// time for a regular animation think
	else if (self.lip <= time)
	{
		self.think1();	// advance the player anim on the standard 10fps clock
		self.lip = time + 0.1;
	}
	self.nextthink = time + 0.05;
}

void() W_AxeThink = { self.think = W_AxeThink; W_AxeCycle(1);  } 
void() W_AxeThinkReverse = {  self.think = W_AxeThinkReverse; W_AxeCycle(-1); } 

void() W_AxeSwing =
{
	W_AxeWhiffSound();
		self.weaponframe = 10 * (floor(4.99 * random()));
		self.touch_time = time + 0.1;
		self.attack_finished = time + wcvar("axe","attack_delay");
	self.think1 = player_axe;
	W_AxeThink();
}


/*
================
W_FireAxe
================
*/
void() W_FireAxe =
{
}


