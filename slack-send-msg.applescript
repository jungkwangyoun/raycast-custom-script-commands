#!/usr/bin/osascript

# Required parameters:
# @raycast.author kwangyoun.jung
# @raycast.authorURL 
# @raycast.schemaVersion 1
# @raycast.title issue
# @raycast.mode silent
# @raycast.packageName Slack
# @raycast.description 이슈등록 자동 입력
# @raycast.needsConfirmation true
# @raycast.argument1 { "type": "text", "placeholder": "Title", "optional": true, }
# @raycast.argument2 { "type": "text", "placeholder": "User (default: @)", "optional": true, }


on openChannel(channel)
	tell application "Slack"
		activate
		tell application "System Events"
			keystroke "k" using {command down}
			delay 0.5
			keystroke channel
			delay 0.5
			key code 36
			delay 0.5
		end tell
	end tell
end openChannel

on sendMessage(titleToSend, userMention)
	tell application "Slack"
		activate
		tell application "System Events"
      my stringToClipboard("")  -- TODO: cmd
      keystroke "v" using command down
      delay 0.3

      my stringToClipboard(titleToSend & " ")
      keystroke "v" using command down
      delay 0.3

      my stringToClipboard(UserMention)
      keystroke "v" using command down
      delay 0.3
      key code 36
      delay 0.3
      key code 36
		end tell
	end tell
end sendMessage

on stringToClipboard(t1)
    do shell script "/usr/bin/python3 -c 'import sys;from AppKit import NSPasteboard, NSPasteboardTypeString; cb=NSPasteboard.generalPasteboard();cb.declareTypes_owner_([NSPasteboardTypeString], None);cb.setString_forType_(sys.argv[1], NSPasteboardTypeString)' " & quoted form of t1
end stringToClipboard

on run argv
    set title to item 1 of argv
    set user to item 2 of argv

    set channelToSendTo to "#"  -- TODO: slack channel

-- if no title
    if title = "" then
        set titleToSend to "issue created temporarily"
    else
        set titleToSend to title
    end if

-- if no user
    if user = "" then
        set userMention to "@"  -- TODO: slack user
    else
        set userMention to user
    end if

    openChannel(channelToSendTo)
    sendMessage(titleToSend, userMention)

    log "Issue created nicely in" & channelToSendTo & "!"
end run
