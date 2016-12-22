# if there are no other bash shells open kill the ssh-agent (for some
# reason there's always an extra instance of bash running when the
# logout file runs, thus the '3')
bash_count=$( pgrep -c bash )

if (( ${bash_count} < 3 )) && [ -n "${SSH_AGENT_PID}" ] ; then
    ssh-add -D
    ssh-agent -k
fi
