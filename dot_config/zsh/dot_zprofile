emulate sh -c 'source /etc/profile'
export PATH=$HOME/.local/bin:$PATH
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi
