#!/usr/bin/env fish

function get_unread_mail
    grep '(^A1=' "$argv[1]" | tail -n1 | sed -r 's/.*\(\^A1=(\w+)\).*/\1/' | xargs -n1 -L1 --replace=__ printf '%d\n' 0x__
end

# Gmail unread count
set gmail_file "/home/me/.thunderbird/odk6gi5m.default/ImapMail/imap.gmail.com/INBOX.msf"
set gmail_unread (get_unread_count "$gmail_file")
echo "Gmail unread: $gmail_unread"

# Outlook unread count
set outlook_file="/home/me/.thunderbird/odk6gi5m.default/ImapMail/outlook.office365.com/INBOX.msf"
set outlook_unread (get_unread_count "$outlook_file")
echo "Outlook unread: $outlook_unread"

# Total unread count
set total_unread (gmail_unread + outlook_unread)
echo "Total unread: $total_unread"
