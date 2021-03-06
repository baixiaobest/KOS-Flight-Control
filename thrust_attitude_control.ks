@lazyglobal off.

run once subscription_data.
run once vehicle_parameters.
run once messages.
run once draw_debug.

function ThrustAttitudeControl {
  // Subscriptions.
  local thrust_sp_sub is SubscriptionData("acceleration_setpoint", AccelerationSetpointMSG(V(0, 0, 0))).
  local throttle_sp is 0.
  local last_time is time:seconds.
  local pub_sub is PublishSubscribe().
  local thrust_integral is V(0, 0, 0).

  // Based on the magnitude of thrust and maximum thrust,
  // calculate the throttle that can generate to this thrust.
  function get_throttle_from_thrust {
    parameter thrust_mag.

    local throttle is 0.
    if ship:maxthrust = 0 {
      set throttle to 0.
    }
    else {
      set throttle to min(1, thrust_mag / (ship:maxthrust * 1e3)).
    }

    return throttle.
  }

  function combine_two_thrust {
    parameter thrust_0.
    parameter thrust_1.

    local combined_thrust is thrust_0 + thrust_1.
    local maximum_thrust is choose ship:maxthrust * 1e3 if ship:maxthrust > 0 else 1.
    if (combined_thrust:mag < maximum_thrust) {
      return combined_thrust.
    }
    else if (thrust_0:mag > maximum_thrust) {
      return thrust_0:normalized * maximum_thrust.
    }
    else if ((thrust_0 - thrust_1):mag < 0.001) {
      return thrust_0:normalized * maximum_thrust.
    }
    else if (thrust_1:mag < 0.001) {
      return thrust_0:normalized * min(thrust_0:mag, maximum_thrust).
    }
    else if (thrust_0:mag < 0.001) {
      return thrust_1:normalized * min(thrust_0:mag, maximum_thrust).
    }
    // Prioritize thrust_0 until thrust is saturated.
    else {
      local a is thrust_1 * thrust_1.
      local b is thrust_0 * thrust_1.
      local c is thrust_0 * thrust_0 - (maximum_thrust)^2.
      local alpha is (-b + sqrt(b^2 - 4 * a * c)) / (2 * a).
      return thrust_0 + alpha * thrust_1.
    }
  }

  function run {
    // Get current thrust in newton from throttle.
    local curr_thrust_mag is throttle * ship:maxthrust * 1e3.
    local curr_thrust is SHIP:FACING * V(0, 0, 1) * curr_thrust_mag.
    // Acceleration due to thrust.
    local curr_thrust_acc is curr_thrust / (ship:mass * 1e3).

    // Acceleration/thrust due to drag and gravity.
    local g_drag_acc is ship:sensors:grav.
    local g_drag_thrust is g_drag_acc * ship:mass * 1e3.
    
    // Acceleration/thrust setpoint.
    local acc_sp is thrust_sp_sub:get():acceleration.
    local acc_sp_thrust is acc_sp * ship:mass * 1e3.

    // Desired thrust that counter gravity and drag and try it best
    // to acheive acceleration setpoint.
    local acc_error_thrust is (acc_sp - ship:sensors:acc) * ship:mass * 1e3.
    local desired_thrust is combine_two_thrust(-g_drag_thrust, acc_sp_thrust + acc_error_thrust * vehicle_params:TAC:KP).

    // Code below this line might be separated into actuator module.
    // Actuator module execute a desired thrust.

    local actual_thrust_mag is desired_thrust:mag * max(0, cos(vang(desired_thrust, curr_thrust))).

    set throttle to get_throttle_from_thrust(actual_thrust_mag).
    // Attitude control.
    set steering to desired_thrust.

    set last_time to time:seconds.

    // draw_debug_vector("g_drag_acc", V(0, 0, 0), g_drag_acc).
    // draw_debug_vector("acc_sp", V(0, 0, 0), acc_sp).
    // draw_debug_vector("acc", V(0, 0, 0), ship:sensors:acc).
    // draw_debug_vector("desired_thrust_acc", V(0, 0, 0), desired_thrust / (ship:mass * 1e3)).
  
    return 0.
  }

  return lexicon (
    "run", run@
  ).
}