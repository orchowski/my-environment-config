prompt_install() {
	echo -n "$1 is not installed. Would you like to install it? (y/n) " >&2
	old_stty_cfg=$(stty -g)
	stty raw -echo
	answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
	stty $old_stty_cfg && echo
	if echo "$answer" | grep -iq "^y" ;then
		# This could def use community support
		if [ -x "$(command -v apt-get)" ]; then
			sudo apt-get install $1 -y

		elif [ -x "$(command -v brew)" ]; then
			brew install $1

		elif [ -x "$(command -v zypper)" ]; then
			sudo zypper install $1

		elif [ -x "$(command -v pkg)" ]; then
			sudo pkg install $1

		elif [ -x "$(command -v pacman)" ]; then
			sudo pacman -S $1

		else
			echo "I'm not sure what your package manager is! Please install $1 on your own and run this deploy script again. Tests for package managers are in the deploy script you just ran starting at line 13. Feel free to make a pull request at https://github.com/parth/dotfiles :)" 
		fi 
	fi
}

check_for_software() {
	echo "Checking to see if $1 is installed"
	if ! [ -x "$(command -v $1)" ]; then
		prompt_install $1
	else
		echo "$1 is installed."
	fi
}

check_oh_my_zsh(){
  echo "Checking to see if ohmyzsh is installed"
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  else
	echo "OhMyZsh installed"
  fi
}

check_tmux_plugin_manager(){
  echo "Checking to see if tmux plugin manager is installed"
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    tmux new -d -s foo
    tmux send-keys -t foo.0 $HOME/.tmux/plugins/tpm/tpm && $HOME/.tmux/plugins/tpm/scripts/install_plugins.sh ENTER
  else
	echo "tmux plugin manager installed"
  fi
}

configure_vim(){
  echo "Checking to see if vim plugin manager is installed"
  if [ ! -d "$HOME/.vim/bundle" ]; then
    mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle && curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    git clone https://github.com/scrooloose/nerdtree.git $HOME/.vim/bundle/nerdtree
  else
	echo "vim plugins installed"
  fi
}


configure_git(){
  echo -e "Configuring git...\n"
  echo "email:"
  read email
  echo "name:"
  read name
  git config --global user.name "$name"
  git config --global user.email "$email"
  git config --global mergetool.keepBackup false
  git config --global core.autocrlf false
  git config --global merge.tool kdiff3
}
check_default_shell() {
	if [ -z "${SHELL##*zsh*}" ] ;then
			echo "Default shell is zsh."
	else
		echo -n "Default shell is not zsh. Do you want to chsh -s \$(which zsh)? (y/n)"
		old_stty_cfg=$(stty -g)
		stty raw -echo
		answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
		stty $old_stty_cfg && echo
		if echo "$answer" | grep -iq "^y" ;then
			chsh -s $(which zsh)
		fi
	fi
}

echo -e "I'll install some software.\nLet's get started? (y/n)"
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
	echo 
else
	echo "Quitting, nothing was changed."
	exit 0
fi
sudo apt-get update
check_for_software git
echo
check_for_software gitk
echo
check_for_software curl
echo
check_for_software zsh
echo 
check_for_software vim
echo
check_for_software tmux
echo
check_for_software kdiff3
echo
check_oh_my_zsh
echo
check_tmux_plugin_manager
echo
configure_vim
echo
configure_git
echo
check_for_software terminator
echo
check_for_software keepassx
echo
check_default_shell

echo
echo -n "Would you like to backup your current configurations? (y/n) "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
	mv ~/.zshrc ~/.zshrc.old
	mv ~/.tmux.conf ~/.tmux.conf.old
	mv ~/.vimrc ~/.vimrc.old
fi

printf "source '$(dirname $(readlink -f $0))/zsh/zshrc'" > "$HOME/.zshrc"
printf "so $(dirname $(readlink -f $0))/vim/vimrc.vim" > ~/.vimrc
printf "source-file '$(dirname $(readlink -f $0))/tmux/tmux.conf'" > "$HOME/.tmux.conf"

echo
echo "Please log out and log back in for default shell to be initialized."



echo "It's ubuntu? (y/n)"
xxx=$(stty -g)
answer2=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $xxx
if echo "$answer2" | grep -iq "^y" ;then
	echo 
else
	echo "Then thanks :)"
	exit 0
fi

sudo apt-get update
sudo apt-get install software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt-get update
sudo apt-get install code

sudo apt install openjdk-8-jdk
sudo apt install openjdk-11-jdk

echo -e "Select which java you want to use now:\n"

sudo update-alternatives --config java


