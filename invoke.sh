#!/bin/bash

# this is a little helper script to launch my local dev instance of Mastodon
# TODO: make it work without this absolute path to my local machine,
# submit to the main repo

function elephant_nap {
	echo -e "\ngoodnight elephant friend ❤️\n"
	pg_ctl -D /Users/egypt/Documents/code/dragonstyle/postgres stop
	pkill redis-server
}

trap elephant_nap 0 1 2 15

# launch mastodon
echo -e "\nhello elephant friend! 🐘\n"
pg_ctl -D /Users/egypt/Documents/code/dragonstyle/postgres start
redis-server --daemonize yes
foreman start

