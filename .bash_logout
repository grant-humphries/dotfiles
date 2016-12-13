# prevents stray ssh-agent processes
if [ -n "${SSH_AGENT_PID}" ]; then
    kill "${SSH_AGENT_PID}"
fi