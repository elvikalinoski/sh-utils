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


# Gerar senha linux
https://terminalroot.com.br/2019/12/gerar-senha-linux.html

# Removendo comentários de uma arquivo
```sh
grep -v "^#" arquivo.bkp | sed '/^$/d' > arquivo
```

Explicação:
O "grep -v "^#" arquivo.bkp" retira as linhas que iniciam com "#";
sed '/^$/d' apaga as linhas em branco.


# Mostra as primeiras linha de um arquivo
head

# Mostra as ultimas linha de um arquivo
tail

# Mostra arquivo ao poucos
less

# Remove diretórios
rmdir

# Nome da máquina
hostname

# Lista processos
ps
ps aux

# Mostra estrutura de pastas
lsblk
