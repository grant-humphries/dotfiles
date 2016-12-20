# if there are no other bash shells open kill the ssh-agent
bash_count=$( pgrep -c bash )
if (( ${bash_count} < 2 )) && [ -n "${SSH_AGENT_PID}" ] ; then
    kill "${SSH_AGENT_PID}"
fi