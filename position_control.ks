@lazyglobal off.

run once subscription_data.
run once publish_subscribe.
run once vector_pid.
run once vehicle_parameters.
run once messages.

function PositionControl {
	// This is vehicle initial position on a weird KSP origin.
	local initial_position is V(0, 0, 0).
	local local_position_setpoint_sub is SubscriptionData("local_position_setpoint").
	local pub_sub is PublishSubscribe().
	local pid is VectorPid (
		vehicle_params:PC:KP,
		0,
		0,
		vehicle_params:VC:CRUISE_VELOCITY).


	function init {
		set initial_position to ship:body:position.
		pid:init().
	}

	function run {
		// Publish a local ship position.
		local local_position is initial_position - ship:body:position.
		pub_sub:publish("local_position", LocalPositionMSG(local_position, initial_position)).

		// Not to process local position setpoint it if it is not ever published.
		if not local_position_setpoint_sub:is_ever_published() {
			return.
		}
		local pos_sp is local_position_setpoint_sub:get():position.

		pid:set_setpoint(pos_sp).
		local vel_sp is pid:update(local_position).

		pub_sub:publish("velocity_setpoint", VelocitySetpointMSG(vel_sp)).

		// Debug.
		draw_debug_vector("local_position", -local_position, local_position).
		draw_debug_vector("setpoint_position", -local_position, pos_sp).
		draw_debug_vector("velocity_setpoint", V(0, 0, 0), vel_sp).
	}

	return lexicon(
		"init", init@,
		"run", run@).
}