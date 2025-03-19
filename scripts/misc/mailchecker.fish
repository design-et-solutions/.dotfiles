#!/usr/bin/env fish

function get_unread_count
    if test -f "$argv[1]"
        set count (grep -oP '\^A1=\K[0-9a-fA-F]+' "$argv[1]" | tail -n1 | xargs -I {} printf '%d\n' 0x{})
        if test -n "$count"
            printf '%d\n' "0x$count"
        else
            echo 0
        end
    else
        echo 0
    end
end

set thunderbird_dir "$HOME/.thunderbird"
set profile_dir (grep -oP '(?<=Path=).*' "$thunderbird_dir/profiles.ini" | head -n1)

set total_unread 0
for inbox_file in $thunderbird_dir/$profile_dir/ImapMail/*/INBOX.msf
    set account_name (string split -r -m1 -f2 '/' $inbox_file | string split -f1 '.')
    set unread_count (get_unread_count "$inbox_file")
    echo "$account_name unread: $unread_count"
    set total_unread (math $total_unread + $unread_count)
end

echo $total_unread
