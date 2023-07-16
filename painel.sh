#!/bin/bash

while true; do
    read -p "Digite um nome: " nome

    nome_formatado=$(echo "$nome" | sed 's/ /%20/g')
    url="https://skyraid.tech/api/basic/nome/$nome_formatado"

    temp_file=$(mktemp)
    curl -s "$url" > "$temp_file"

    if [[ $(jq -r '.data' "$temp_file") == "null" ]]; then
        echo "Nenhum resultado encontrado para o nome '$nome'."
    else
        echo "Resultados encontrados para o nome '$nome':"
        echo "-------------------------------------------"
        jq -r '.data[] | "CPF: " + .cpf, "Nome: " + .nome, "Sexo: " + .sexo, "Nascimento: " + .nascimento, "-------------------------------------------"' "$temp_file"
    fi

    read -p "Deseja fazer outra consulta? (s/n): " resposta
    if [[ $resposta != "s" ]]; then
        break
    fi
done
