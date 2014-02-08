local l2dbus = require("l2dbus")
local l2dbus_ev = require("l2dbus_ev")
local dbt = l2dbus.DbusTypes

local mainLoop = l2dbus_ev.MainLoop.new()
local disp = l2dbus.Dispatcher.new(mainLoop)
assert(nil ~= disp)
local conn = l2dbus.Connection.openStandard(disp, l2dbus.Dbus.BUS_SESSION)
assert(nil ~= conn)

local icon_file = ""

our_id = 0
now = os.time()

function notify(summary, body)
   local dbus_msg = l2dbus.Message.newMethodCall({destination="org.freedesktop.Notifications",
						  path="/org/freedesktop/Notifications",
						  interface="org.freedesktop.Notifications",
						  method="Notify"})

   -- DBUS Notify signature is (STRING app_name, UINT32 replaces_id, STRING app_icon,
   --    STRING summary, STRING body, ARRAY actions, DICT hints, INT32 expire_timeout)

   dbus_msg:addArgs("Telegram", dbt.Uint32.new(0), icon_file,
		    summary, body, 
		    dbt.Array.new({}, "as"),
		    dbt.Dictionary.new({}, "a{sv}"),
		    dbt.Int32.new(-1))

   local reply, errName, errMsg = conn:sendWithReplyAndBlock(dbus_msg)
   if reply == nil then
      print("Request Failed =>  " .. tostring(errName) .. " : " .. tostring(errMsg))
   end
end

print ("HI, this is lua script")


function on_msg_receive (msg)
   if msg.date < now then
      return
   end
   if msg.out then
      return
   end
   if msg.text == nil then
      return
   end
   if msg.unread == 0 then
      return
   end

   notify("Message from " .. msg.from.print_name, msg.text)
end

function on_our_id (id)
   our_id = id
end

function on_secret_chat_created (peer)
end

function on_user_update (user)
end

function on_chat_update (user)
end

function on_get_difference_end ()
end

function on_binlog_replay_end ()
end

