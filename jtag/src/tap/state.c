/*
 * $Id: state.c 392 2003-03-13 19:37:29Z telka $
 *
 * TAP state handling
 * Copyright (C) 2002 ETC s.r.o.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
 * 02111-1307, USA.
 *
 * Written by Marcel Telka <marcel@telka.sk>, 2002.
 *
 */

#include "state.h"
#include "chain.h"


int dump_tap_state = 0;

static const char *
tap_state_name (int state)
{
	const char *state_name;

	if (state == Unknown_State)
		state_name = "Unknown_State";
	else if (state == Test_Logic_Reset)
		state_name = "Test_Logic_Reset";
	else if (state == Run_Test_Idle)
		state_name = "Run_Test_Idle";
	else if (state == Select_DR_Scan)
		state_name = "Select_DR_Scan";
	else if (state == Capture_DR)
		state_name = "Capture_DR";
	else if (state == Shift_DR)
		state_name = "Shift_DR";
	else if (state == Exit1_DR)
		state_name = "Exit1_DR";
	else if (state == Pause_DR)
		state_name = "Pause_DR";
	else if (state == Exit2_DR)
		state_name = "Exit2_DR";
	else if (state == Update_DR)
		state_name = "Update_DR";
	else if (state == Select_IR_Scan)
		state_name = "Select_IR_Scan";
	else if (state == Capture_IR)
		state_name = "Capture_IR";
	else if (state == Shift_IR)
		state_name = "Shift_IR";
	else if (state == Exit1_IR)
		state_name = "Exit1_IR";
	else if (state == Pause_IR)
		state_name = "Pause_IR";
	else if (state == Exit2_IR)
		state_name = "Exit2_IR";
	else if (state == Update_IR)
		state_name = "Update_IR";
	else
		state_name = "??????";

	return state_name;
}

static void
tap_state_dump(int state)
{
	if (dump_tap_state)
		printf ("tap_state: %s\n", tap_state_name (state));
}

static void
tap_state_dump_2 (int state0, int state1, int tms)
{
	if (dump_tap_state)
		printf ("tap_state: %16s =(tms:%d)=> %s\n",
			tap_state_name (state0), tms, tap_state_name (state1));
}

int
tap_state( chain_t *chain )
{
	return chain->state;
}

int
tap_state_init( chain_t *chain )
{
	tap_state_dump (Unknown_State);
	return chain->state = Unknown_State;
}

int
tap_state_done( chain_t *chain )
{
	tap_state_dump (Unknown_State);
	return chain->state = Unknown_State;
}

int
tap_state_reset( chain_t *chain )
{
	tap_state_dump (Test_Logic_Reset);
	return chain->state = Test_Logic_Reset;
}

int
tap_state_set_trst( chain_t *chain, int old_trst, int new_trst )
{
	old_trst = old_trst ? 1 : 0;
	new_trst = new_trst ? 1 : 0;

	if (old_trst != new_trst) {
		if (new_trst)
			chain->state = Test_Logic_Reset;
		else
			chain->state = Unknown_State;
	}

	tap_state_dump (chain->state);
	return chain->state;
}

int
tap_state_clock( chain_t *chain, int tms )
{
	int oldstate = chain->state;

	if (tms) {
		switch (chain->state) {
			case Test_Logic_Reset:
				break;
			case Run_Test_Idle:
			case Update_DR:
			case Update_IR:
				chain->state = Select_DR_Scan;
				break;
			case Select_DR_Scan:
				chain->state = Select_IR_Scan;
				break;
			case Capture_DR:
			case Shift_DR:
				chain->state = Exit1_DR;
				break;
			case Exit1_DR:
			case Exit2_DR:
				chain->state = Update_DR;
				break;
			case Pause_DR:
				chain->state = Exit2_DR;
				break;
			case Select_IR_Scan:
				chain->state = Test_Logic_Reset;
				break;
			case Capture_IR:
			case Shift_IR:
				chain->state = Exit1_IR;
				break;
			case Exit1_IR:
			case Exit2_IR:
				chain->state = Update_IR;
				break;
			case Pause_IR:
				chain->state = Exit2_IR;
				break;
			default:
				chain->state = Unknown_State;
				break;
		}
	} else {
		switch (chain->state) {
			case Test_Logic_Reset:
			case Run_Test_Idle:
			case Update_DR:
			case Update_IR:
				chain->state = Run_Test_Idle;
				break;
			case Select_DR_Scan:
				chain->state = Capture_DR;
				break;
			case Capture_DR:
			case Shift_DR:
			case Exit2_DR:
				chain->state = Shift_DR;
				break;
			case Exit1_DR:
			case Pause_DR:
				chain->state = Pause_DR;
				break;
			case Select_IR_Scan:
				chain->state = Capture_IR;
				break;
			case Capture_IR:
			case Shift_IR:
			case Exit2_IR:
				chain->state = Shift_IR;
				break;
			case Exit1_IR:
			case Pause_IR:
				chain->state = Pause_IR;
				break;
			default:
				chain->state = Unknown_State;
				break;
		}
	}

	tap_state_dump_2 (oldstate, chain->state, tms);
	return chain->state;
}
