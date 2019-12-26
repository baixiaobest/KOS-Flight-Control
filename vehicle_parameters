@lazyglobal off.

local thrust_attitude_control_params is lexicon(
	"KP", 1,
	"ALPHA", 0.1).

local velocity_control_params is lexicon(
	"KP", 0.4,
	"KI", 0.1,
	"KD", 0,
	"MAX_ACCELERATION", 5,
	"CRUISE_VELOCITY", 30).

local position_control_params is lexicon(
	"KP", 0.2).

global vehicle_params is lexicon(
	"TAC", thrust_attitude_control_params,
	"VC", velocity_control_params,
	"PC", position_control_params
).