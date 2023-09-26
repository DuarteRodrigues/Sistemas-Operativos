#!/bin/bash

## ########################################################## ##
## - Projeto - Night_Owls.sh 				    - ##
## 							      ##
## Aluno: Duarte Rodrigues				      ##
## Nº de Aluno: Duarte Rodrigues			      ##
## UC: Sistemas Operativos				      ##
## Curso: Licenciatura de Engenharia Informática e Aplicações ##
## Docente: João Leitão                                       ##
##							      ##
## ########################################################## ##

# Definir diretorias
I_log_dir="/home/inaenimated/Documents/Log_File_TXTs"

# Listar as cópias feitas pela máquina
Copias=($(find "$I_log_dir" -maxdepth 1 -mindepth 1 -type d))

# Verificar se existem cópias feitas, se sim, continua com o processo
if  [ ${#Copias[@]} -eq 0 ]; then
	echo "Nenhuma cópia encontrada no diretório $I_log_dir"
	exit 1
else
	# Mostrar as cópias em formato de lista
	echo "Cópias disponíveis em $I_log_div:"
	for ((i=0; i<${#Copias[@]}; i++)) ; do
		echo "$((i+1)) - $(basename "${Copias[$i]}")"
	done

	# Pedir ao utilizador que cópia quer verificar
	read -p "Indique o número correspondente à cópia que quer analizar: " Escolha

	# Validar o input do utilizador
	if ! [[ "$Escolha"=~^[1-9][0-9]*$ ]] || [ "$Escolha" -lt 1] || [ "$Escolha" -gt ${#Copias[@]} ]; then
		echo "Escolha inválida."
	fi

	# Registar em memória a cópia requisitada
	Copia_esc="${Copias[$((Escolha-1))]}"
	# Registar o nome da cópia requisitada sem a diretoria
	Nome_copia_esc="$(basename "$Copia_esc")"
	echo "A cópia escolhida: $(basename "$Copia_esc")"

	# Definir a diretoria do ficheiro syslog
        Copia_syslog_dir=$(ls -1t "$Copia_esc"/syslog-*.txt 2>/dev/null | head -1)
	# # Registar o nome do ficheiro syslog da cópia  requisitada
	Nome_copia_syslog="$(basename "$Copia_syslog_dir")"
	echo "O ficheiro da cópia escolhida: $Nome_copia_syslog"

	if [ -n "$Copia_syslog_dir" ]; then
		echo "Execuções em linha de comandos com sudo da cópia $Nome_copia_syslog:"
		# Pesquisar nas linhas do auth.log.txt por sudo
		awk  '$3~/^00/ || $3~/^01/ || $3~/^02/ ||$3~/^03/ || $3~/^04/ || $3~/^05/ || $3~/^06/ || $3~/^07/'  "$Copia_syslog_dir"
	else
		echo "$Nome_copia_syslog não existe na pasta de cópia $Copia_esc"
	fi
fi
