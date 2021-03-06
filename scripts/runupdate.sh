#!/bin/sh
date -u
RE_RUN_SERVERS="official"
RE_RUN_CURHOUR=`date "+%M"`

echo "site: checking.."
cd "/webspace/redeclipse.net" 2>&1 >/dev/null
git pull --rebase

echo "home: checking.."
cd "${HOME}/master" 2>&1 >/dev/null
RE_CUR_HOME=`git rev-parse HEAD`
git pull --rebase
RE_RUN_HOME=`git rev-parse HEAD`
echo "home: ${RE_CUR_HOME} -> ${RE_RUN_HOME}"
if [ "${RE_CUR_HOME}" != "${RE_RUN_HOME}" ]; then
  for i in ${RE_RUN_SERVERS}; do
    RE_PID=`pgrep -f "redeclipse-${i}"`
    if [ -n "${RE_PID}" ]; then
      echo "sending HUP to ${i} (${RE_PID})"
      kill -s HUP ${RE_PID}
    fi
  done
fi

#cd "${HOME}" 2>&1 >/dev/null
#echo "checking servers.."
#if curl --connect-timeout 30 -L -k -f "http://play.redeclipse.net:28800/version"; then
#  for i in ${RE_RUN_SERVERS}; do
#    echo "${i}: checking.."
#    RE_CUR_VER=`cat "${HOME}/redeclipse-${i}/bin/version.txt"`
#    RE_CUR_BRN=`cat "${HOME}/redeclipse-${i}/branch.txt"`
#    RE_RUN_VER=`curl --connect-timeout 30 -L -k -f "https://raw.githubusercontent.com/redeclipse/deploy/master/${RE_CUR_BRN}/bins.txt"`
#    echo "${i}: ${RE_CUR_VER} -> ${RE_RUN_VER}"
#    if [ -n "${RE_RUN_VER}" ] && [ "${RE_CUR_VER}" != "${RE_RUN_VER}" ]; then
#      RE_PID=`pgrep -f "redeclipse-${i}"`
#      if [ -n "${RE_PID}" ]; then
#        echo "${i}: sending TERM to ${RE_PID}"
#        kill -s TERM ${RE_PID}
#      fi
#    fi
#  done
#else
#  echo "master server not responding, killing all servers!"
#  killall -KILL redeclipse_server_linux
#fi

echo "-"
