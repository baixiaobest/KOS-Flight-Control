@lazyglobal off.

function VectorPid {
	parameter param_KP.
	parameter param_KI.
	parameter param_KD.
	parameter param_limit.

	local KP is param_KP.
	local KI is param_KI.
	local KD is param_KD.
	local limit is param_limit.
	local setpoint is V(0, 0, 0).
	local last_value is V(0, 0, 0).
	local integral_value is V(0, 0, 0).

	local last_time is 0.

	function set_setpoint {
		parameter param_setpoint.

		set setpoint to param_setpoint.
	}

	function init {
		set last_time to time:seconds.
	}

	function update {
		parameter value.

		local interval is time:seconds - last_time.
		if interval = 0 {
			set interval to 0.001.
		}
		local error is setpoint - value.

		local p_out is error * KP.
		local d_out is (value - last_value) / interval * KD.
		local p_d_out is p_out + d_out.

		local p_d_i_out is p_d_out + integral_value.

		// Integrator wind up, if output saturates and integrator is
		// making the output more saturated.
		if p_d_out:mag > limit and p_d_i_out:mag > p_d_out:mag {
			// No integration happend here.
		}
		else {
			set integral_value to integral_value + interval * error * KI.
		}

		set last_time to time:seconds.

		if p_d_i_out:mag > limit {
			return p_d_i_out:normalized * limit.
		}
		else {
			return p_d_i_out.
		}
	}

	return lexicon(
		"init", init@, 
		"update", update@, 
		"set_setpoint", set_setpoint@).
}