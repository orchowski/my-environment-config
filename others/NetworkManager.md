create file 
```
sudo vim /etc/NetworkManager/NetworkManager.conf
```

```
[main]
plugins=keyfile

[keyfile]
unmanaged-devices=none
```
and 
`sudo systemctl restart NetworkManager `
to change network now : `sudo nmtui-connect` or just `nmtui`
bluetooth - `sudo bluetui`
