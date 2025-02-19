#!/usr/bin/env fish

set characters "⣾" "⣽" "⣻" "⢿" "⡿" "⣟" "⣯" "⣷"
set characters_count (count $characters)
set notification_id ""

echo $characters
for i in (seq 1 50)
    echo $i
    set index (math "$i % $characters_count + 1")
    echo $index
    if test -z "$notification_id"
        set notification_id $(notify-send --category loading -p "$characters[$index]")
    else
        notify-send --category loading -r "$notification_id" "$characters[$index]" "$argv[1]"
    end
    sleep 0.1
end
