@lazyglobal off.

run once subscription_data.
run once publish_subscribe.
run once vector_pid.
run once vehicle_parameters.

function VelocityControl {
	local pid is VectorPid(
		vehicle_params:VC:KP, vehicle_params:VC:KI, vehicle_params:VC:KD,
		vehicle_params:VC:MAX_ACCELERATION).

	local velocity_sub is SubscriptionData("velocity_setpoint").
	local pub_sub is PublishSubscribe().

	function init {
		pid:init().
	}

	function run {
		if not velocity_sub:is_ever_published() {
			return.
		}

		local sp_vel is velocity_sub:get():velocity.

		// Constraint the setpint velocity.
		if sp_vel:mag > vehicle_params:VC:CRUISE_VELOCITY {
			set sp_vel to sp_vel:normalized * vehicle_params:VC:CRUISE_VELOCITY.
		}
		pid:set_setpoint(sp_vel).

		local sp_acc is pid:update(ship:velocity:surface).

		// Send the acceleration setpoint to thrust attitude control.
		pub_sub:publish("acceleration_setpoint", AccelerationSetpointMSG(sp_acc)).
	}

	return lexicon(
		"init", init@,
		"run", run@).
}