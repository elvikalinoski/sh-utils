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
```sh
rsync -aAXv source destination
```
### move aquivos entre diretorios *deleta os arquivos do source.
```sh
rsync -avh --progress --remove-source-files demo/* demo1/
```
### Restaura bkp
```sh
rsync -qaHAXS source destination
```

## Bash 1 line
VAR=$(df -h | grep /mnt/sdb); if [ "$VAR" ]; then echo "true"; else echo "false"; fi

## List file
```sh
tree -if --noreport .

ls -m
ls -d $PWD/*
ls -R
ls -g e ls -G
ls -d */
ls -lh
ls -1
ls -l *.extensao
ls -s
ls -ltr
ls -lt
ls -t
ls -a
ls -l
```



