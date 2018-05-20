# 環境変数
export LANG=ja_JP.UTF-8
export LSCOLORS=cxfxcxdxbxegedabagacad

export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

# 日本語ファイル名を表示
setopt print_eight_bit
# cdでpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups
# '#' 以降をコメントとして扱う
setopt interactive_comments


########################################
# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# 補完色
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S '


########################################
# alias

# https://qiita.com/itkrt2y/items/0671d1f48e66f21241e2
#alias g='cd $(ghq root)/$(ghq list | peco)'
alias g='cd $(ghq list -p | peco)'
alias gh='hub browse $(ghq list | peco | cut -d "/" -f 3,4)'

alias -g P='| peco'
if [ -x "`which peco`" ]; then
	alias ls='ls -la | peco'
fi

alias -g B='`git branch | peco | sed -e "s/^\*[ ]*//g"`'

alias f='find ./ -type f -print | xargs grep -n --color'

alias sshlist="cat ~/.ssh/config |grep ^Host\  |sed -e 's/^Host\ //g'"
alias pssh="sshlist | peco | xargs -I{} sh -c 'ssh {} </dev/tty' ssh"

########################################
# Prompt
. /usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh

########################################
# ツール設定

#fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# direnv
eval "$(direnv hook zsh)"


########################################
# 便利系

# ctrl+yでコピー ctrl+pで貼り付け
pbcopy-buffer(){ 
	print -rn $BUFFER | pbcopy
    zle -M "pbcopy: ${BUFFER}" 
}

zle -N pbcopy-buffer
bindkey '^y^p' pbcopy-buffer

s() {
    local str opt
    if [ $# != 0 ]; then
        for i in $*; do
            # $strが空じゃない場合、検索ワードを+記号でつなぐ(and検索)
            str="$str${str:++}$i"
        done
        opt='search?num=100'
        opt="${opt}&q=${str}"
    fi
    open -a Google\ Chrome http://www.google.co.jp/$opt
}
