#!/usr/bin/env python
import re
import subprocess

def get_keychain_pass(account, server):
    command = [ "sudo", "-u", "keith", "/usr/bin/security",
            "find-internet-password", "-w", "-a", account, "-s", server,
            "/Users/keith/Library/Keychains/login.keychain"
        ]
    output = subprocess.check_output(command)
    return output.strip()
# end def

def gmail_local_nametrans(folder):
    data = {
            "Archive":   "[Gmail]/All Mail",
            "Drafts":    "[Gmail]/Drafts",
            "Important": "[Gmail]/Important",
            "Sent":      "[Gmail]/Sent Mail",
            "Spam":      "[Gmail]/Spam",
            "Starred":   "[Gmail]/Starred",
            "Trash":     "[Gmail]/Trash",
        }
    return data.get(folder, folder)
# end def gmail_local_nametrans

def gmail_remote_nametrans(folder):
    data = {
            "[Gmail]/All Mail":  "Archive",
            "[Gmail]/Drafts":    "Drafts",
            "[Gmail]/Important": "Important",
            "[Gmail]/Sent Mail": "Sent",
            "[Gmail]/Spam":      "Spam",
            "[Gmail]/Starred":   "Starred",
            "[Gmail]/Trash":     "Trash",
        }
    return data.get(folder, folder)
# end def gmail_remote_nametrans

