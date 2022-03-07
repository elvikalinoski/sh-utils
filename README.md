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