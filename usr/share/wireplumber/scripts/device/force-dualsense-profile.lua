-- Force pro-audio profile for DualSense controllers,
-- overriding any stored profile preference.

cutils = require ("common-utils")
log = Log.open_topic ("s-device")

SimpleEventHook {
  name = "device/force-dualsense-profile",
  before = "device/find-stored-profile",
  interests = {
    EventInterest {
      Constraint { "event.type", "=", "select-profile" },
    },
  },
  execute = function (event)
    local device = event:get_subject ()
    local dev_name = device.properties["device.name"] or ""

    if not string.find(dev_name, "DualSense.*Wireless_Controller") then
      return
    end

    for p in device:iterate_params ("EnumProfile") do
      local profile = cutils.parseParam (p, "EnumProfile")
      if profile.name == "pro-audio" then
        log:info (device, string.format (
            "Forcing pro-audio profile for DualSense device '%s'", dev_name))
        event:set_data ("selected-profile", profile)
        return
      end
    end
  end
}:register()
