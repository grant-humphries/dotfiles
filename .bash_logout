# if there are no other bash shells open kill the ssh-agent
# pgrep doesn't have -c flag on macOS thus this approach, the minus
# one is to account for the sub-shell the pids are calculated within
bash_count=$(( $(pidof bash | wc -w) - 1 ))

if (( ${bash_count} < 2 )) && [ -n "${SSH_AGENT_PID}" ] ; then
    ssh-add -D
    ssh-agent -k
fi
