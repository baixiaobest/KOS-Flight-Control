@lazyglobal off.

function AccelerationSetpointMSG {
	parameter acceleration is V(0, 0, 0).

	return lexicon("acceleration", acceleration).
}

function VelocitySetpointMSG {
	parameter velocity is V(0, 0, 0).

	return lexicon("velocity", velocity).
}

function PositinoSetpointMSG {
	parameter position is V(0, 0, 0).

	return lexicon("position", position).
}

function LocalPositionMSG {
	parameter local_position is V(0, 0, 0).
	// Intial position in KSP reference frame.
	parameter initial_position is V(0, 0, 0).

	return lexicon(
		"local_position", local_position,
		"initial_position", initial_position).
}

function LocalPositionSetpointMSG {
	parameter position is V(0, 0, 0).

	return lexicon(
		"position", position).
}
