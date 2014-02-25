local icon_file = ""

our_id = 0
now = os.time()

--http://superuser.com/questions/114798/is-there-a-way-to-escape-single-quotes-in-the-shell#114844
function escape(unescaped_string)
  return string.gsub(unescaped_string, "\'", "\'\\'\'")
end

function notify(summary, body)
  local msg = "notify-send '" .. escape(summary) .. "' '" .. escape(body) .. "' -i " .. icon_file
  io.popen (msg)
end

--print ("HI, this is lua script")

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

