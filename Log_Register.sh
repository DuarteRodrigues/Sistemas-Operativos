#!/bin/bash

## ########################################################## ##
## - Projeto - Log_Register.sh                              - ##
##                                                            ##
## Aluno: Duarte Rodrigues                                    ##
## Nº de Aluno: a22206488                                     ##
## UC: Sistemas Operativos                                    ##
## Curso: Licenciatura de Engenharia Informática e Aplicações ##
## Docente: João Leitão                                       ##
##                                                            ##
## ########################################################## ##

# Obter a data final da leitura dos logs/Data Atual
end_date=$(date +%Y-%m-%d)

# Obter a data inicial de leitura dos logs/Data do início da semana
start_date=$(date -d "1 week ago" +%Y-%m-%d)

# Mostrar data do dia
echo "$end_date"

# Definir o diretório onde os logs originais estão
I_log_dir="/var/log"

# Definir o diretório de destino dos ficheiros dos logs
O_log_dir="/home/inaenimated/Documents/Log_File_TXTs/Logs-$end_date"

# Verificar se o diretório de destino já existe
if [ -d "$O_log_dir" ]; then
	echo "O diretório $O_log_dir já existe."
else
	# Cria o diretório
	mkdir -p "$O_log_dir"
	echo "Diretório $destino criado com sucesso."
fi


# Percorre os arquivos no diretório de logs
for fich in "$I_log_dir"/*; do
	# Verifica se o arquivo foi editado na última semana
	if [[ $(stat -c %y "$fich" | cut -d' ' -f1)>"$start_date" && \ $(stat -c %y "$fich" | cut -d' ' -f1)<="$end_date" && \ "$fich"!="*.gz" ]]; then

		# Altera o nome do ficheiro (usando o nome do arquivo sem extensão)
		filename=$(basename "$fich-$end_date")
		filename_no_ext="${filename%.*}"

		# Copia o log e salva como arquivo de texto no diretório de destino específico
		cp "$fich" "$O_log_dir/$filename_no_ext.txt"
		chmod +r "$O_log_dir/$filename_no_ext.txt"
		echo "Log copiado: $O_log_dir/$filename_no_ext.txt"
	fi
done
