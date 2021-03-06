// Main flight control loop
@lazyglobal off.
run once scheduler.
run once publish_subscribe.
run once messages.
run once thrust_attitude_control.
run once velocity_control.
run once position_control.
run once draw_debug.
run once subscription_data.

local scheduler_obj is Scheduler(). 
local pub_sub is PublishSubscribe().
local thrust_attitude_control is ThrustAttitudeControl().
local velocity_control is VelocityControl().
local position_control is PositionControl().
local draw_debug to DrawDebug().

scheduler_obj:add_module("thrust_attitude_control", thrust_attitude_control, 30).
scheduler_obj:add_module("velocity_control", velocity_control, 30).
scheduler_obj:add_module("position_control", position_control, 30).
scheduler_obj:add_module("draw_debug", draw_debug, 10).

local pos_sp is ship:facing * V(-650, 0, 125).

until false {
	pub_sub:publish("local_position_setpoint", LocalPositionSetpointMSG(pos_sp)).
	scheduler_obj:run().
}