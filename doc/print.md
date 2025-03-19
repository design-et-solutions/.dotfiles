# Print

Configure a new printer in the CUPS:

```sh
sudo lpadmin -p name_&&_description -E -v ipp://192.168.1.XXX/ipp/print -m everywhere
```

Example:

```sh
sudo lpadmin -p Canon_TS5100 -E -v ipp://192.168.10.122/ipp/print -m everywhere
```

Additional infos:

```txt
Manage print http://localhost:631/

Print ip ipp://192.168.100.232/ipp/print

Nmap scan report for 192.168.100.232
Host is up (0.019s latency).
Not shown: 995 closed tcp ports (conn-refused)
PORT     STATE SERVICE
80/tcp   open  http
443/tcp  open  https
515/tcp  open  printer
631/tcp  open  ipp
9100/tcp open  jetdirect
```
