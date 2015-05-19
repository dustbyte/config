#!/usr/bin/env python
##
## qui.py for qui in
##
## Made by pierre wacrenier
## Login   <wacren_p@epitech.net>
##
## qui.py
##
## script python qui liste vos amis sur ns

import socket
import re
import binascii
import os
import sys
import inspect
import io

_red    	= "\033[31m"
_green  	= "\033[32m"
_yellow 	= "\033[33m"
_cyan   	= "\033[36m"
_blue   	= "\033[34m"
_cend   	= "\033[0m"

_server 	= "ns-server.epita.fr"
_port   	= 4242
_cmd    	= b"list_users "

_contacts       = ".ns_contacts"

## example:
##
## $ print 'login_1\nlogin2::Nickname\n' > ~/.ns_contacts
## or
##
## _list         = [
##     "login_1",
##     "login_2::Nickname"
##     ]

_list           = []

## regexp

_decode = re.compile(r'%([A-Fa-f0-9]{2})')

def whoami():
    return inspect.stack()[1][3]

def make_connection(sock):
    try:
        sock.connect((_server, _port))
        sock.send("auth\n".encode())
        sock.recv(1024)
    except Exception as e:
        print(whoami() + ":")
        print(e)

def get_infos(sock, user):
    try:
        sock.send(_cmd + user + b"\n")
        sock.recv(1024)
        sock.send(_cmd + user + b"\n")
        buf = sock.recv(1024)
        return (buf.decode().
                replace("rep 002 -- cmd end\n", "").split('\n'))
    except Exception as e:
        print(whoami() + ":")
        print(e)

def get_comment(line):
    string = line[8]
    # Damned python 3.2
    comment = _decode.sub(lambda code: binascii.unhexlify(code.group(0)[1:].encode()).decode(),
                          string
                          )

    return _cyan + (line[7] == "~" and line[7] or " ") + comment[:16] + _cend

def get_hostname(line):
    try:
        host = socket.gethostbyaddr(line[2])
        return host[0].split('.')[0][:26]
    except:
        return line[2]

def get_status(line):
    status = line[10].split(":")[0]
    color = _green
    if status == "connection": color = _blue
    if status == "idle" or status == "away": color = _yellow
    if status == "lock" or status == "server": color = _red
    return color + status + _cend

def get_time(line):
    time = int(line[4]) - int(line[3])
    hours = time / 3600
    minutes = (time - (hours * 3600)) / 60
    return "%02dh%02d" % (hours, minutes)

def treat_infos(sock, user):
    login = True
    user = user.split("::")
    infos = get_infos(sock, user[0].encode())
    for elem in infos:
        line = elem.split()
        if line:
            name = (login and "+ " + (
                    (len(user) == 2 and user[1] or user[0])) or ""
                    )[:10]
            login = False
            comment = get_comment(line)
            hostname = get_hostname(line)
            status = get_status(line)
            time = get_time(line)
            print("%-10s %-30s %-26s %20s   %s" % (name,
                                                   comment,
                                                   hostname,
                                                   status,
                                                   time))

def get_list():
    if _list != []:
        return _list
    try:
        file = open(os.getenv("HOME") + "/" + _contacts, 'r')
        content = file.read()
        file.close()
        return content.split('\n')
    except:
        print("No list set and no `%s' found in home" % _contacts)
        return []

def main():
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        make_connection(sock)
        if len(sys.argv) > 1:
            _list = sys.argv[1:]
        else:
            _list = get_list()
        for user in _list:
            if user != '':
                treat_infos(sock, user)
        sock.close()
    except Exception as e:
        print(whoami() + ":")
        print(e)

if __name__ == "__main__":
    main()
