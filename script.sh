#!/bin/bash

main() {
	clear
	echo "Bem-vindo!"
	echo "Opções: "
	echo "1) Criar ou excluir usuário"
	echo "2) Modificar arquivo"
	echo "3) Sair"
	echo "Digite sua opção: "; read escolha


	case $escolha in
		1) usuario;;
		2) modificar;;
		3) return 0;;
		*) echo "Opção Inváida!"		   
		   main;;
	esac
}	   	   
	

usuario() {
	clear
	echo "Opções: "
        echo "1) Criar usuário"
	echo "2) Excluir usuário"
	echo "3) Voltar"
	read opcaoUser

	case $opcaoUser in
		1) addUser;;
		2) removeUser;;
		3) main;;
		*) usuario;;
	esac
		
}

addUser() {
	clear
	echo "Digite o nome do usuário: "; read nomeUser;
	adduser $nomeUser
	echo "Usuário adicionado!"
	sleep 1
	main
}

removeUser() {
	clear
	echo "Digite o nome do usuário a ser removido"; read nomeToRemove
	userdel $nomeToRemove
	echo "Feito!"
	sleep 1
	main 
}


modificar() {
	clear
	echo "Selecione o que você deseja modificar"
	echo "Opções:"
	echo "1) Dono de um arquivo ou diretório"
	echo "2) Grupo de um arquivo ou diretório"
	echo "3) Permissões de um arquivo ou diretório"
	echo "4) Voltar"
	read opcaoModificar
	
	case $opcaoModificar in
		1) mudarDono;;
		2) mudarGrupo;;
		3) mudarPermissoes;;
		4) main;;
		*) echo "Opção Inválida!"
		   sleep 1
		   modificar;;
	esac
	
}

mudarDono() {
	clear
	cd /
	cd home
	echo "Você está em ./HOME, digite o nome da pasta que o arquivo está"
	echo "Pastas disponíveis: "
	ls
	read pasta
	cd $pasta
	echo ""
	echo "Você está em ./HOME/$pasta, digite o nome do arquivo ou diretório que deseja modificar"
	ls
	read nomeArquivo
	echo "Digite agora o novo usuário dono do arquivo: "; read nomeUsuarioDono
	chown $nomeUsuarioDono $nomeArquivo
	echo "Feito!"
	sleep 1
	main
}

mudarGrupo() {
	clear
	cd /
	cd home
	echo "Você está em ./HOME, digite o nome da pasta que o arquivo está"
	echo "Pastas disponíveis: "
	ls
	read pasta
	cd $pasta
	echo ""
	echo "Você está em ./HOME/$pasta, digite o nome do arquivo ou diretório que deseja modificar"
	ls
	read nomeArquivo
	echo "Digite agora o novo grupo dono do arquivo: "; read nomeGrupoDono
	chgrp $nomeGrupoDono $nomeArquivo
	echo "Feito!"
	sleep 1
	main
}

mudarPermissoes() {
	clear
	arquivo=""
	grupo=""
	permissoes=""

	escolherArquivo arquivo
	
	loop=true
	while $loop
	do
		escolherGrupo grupo
		escolherPermissoes permissoes

		clear
		chmod $grupo-$permissoes $arquivo

		echo "Feito!"
		echo "Deseja continuar modificando o arquivo? (s/n)"; read opcao;

		if [ $opcao = "n" ]
		then
			loop=false
		fi
	done
	main
}

escolherArquivo() {
	local -n returnValue=$1
	
	cd /
	cd home
	echo "Você está em ./HOME, digite o nome da pasta que o arquivo está"
	echo "Pastas disponíveis: "
	ls
	read pasta
	cd $pasta
	echo ""
	echo "Você está em ./HOME/$pasta, digite o nome do arquivo ou diretório que 	deseja modificar"
	ls
	read nomeArquivo
	returnValue=$nomeArquivo
}

escolherGrupo() {
	local -n returnValue=$1

	echo "Deseja modificar as permissões para:"
	echo "1) Dono do arquivo"
	echo "2) Grupo do arquivo"
	echo "3) Outros usuários"
	echo "4) Voltar"
	read opcaoPermissoes
	
	grupoEscolhido=""
	case $opcaoPermissoes in
		1) grupoEscolhido="u";;
		2) grupoEscolhido="g";;
		3) grupoEscolhido="o";;
		*) mudarPermissoes;;
	esac
	returnValue=$grupoEscolhido
}

escolherPermissoes() {
	local -n returnValue=$1
	echo "Escolha quais permissões devem ser definidas:"
	echo "1) Nenhuma permissão"
	echo "2) Leitura"
	echo "3) Escrita"
	echo "4) Execução"
	read permissaoEscolhida;

	case $permissaoEscolhida in
		1) permissaoEscolhida="-rwx";;
		2) permissaoEscolhida="+r";;
		3) permissaoEscolhida="+w";;
		4) permissaoEscolhida="+x";;
		*) mudarPermissoes;;
	esac
	returnValue=$permissaoEscolhida
}
