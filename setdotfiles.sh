for dotfile in .gitconfig .vimrc .zshrc
do
	if [ -e ~/$dotfile ]; then
		rm -fr ~/$dotfile
	fi
	ln -nfs $PWD/$dotfile ~/$dotfile
done