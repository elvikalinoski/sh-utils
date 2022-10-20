# sh-utils

Repository for storing some useful scripts.

## List port and service
```sh
sudo netstat -tulpn
```

## Find files larger than 200MB
```sh
find / -size +200M -name "*.log" -exec ls -ltrh {} \;
```
## Generating unique id
```sh
cat /proc/sys/kernel/random/uuid
```
## Count files
```sh
find . -maxdepth 1 -type f | wc -l
```

## Rsync
### bkp
rsync -aAXv source destination
### Restaura bkp
rsync -qaHAXS source destination
