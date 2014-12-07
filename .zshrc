# cdコマンドを省略できるオプションをON
setopt AUTO_CD

# cd時のディレクトリ情報を履歴として保存するオプションをON
setopt AUTO_PUSHD

# 強力な補完機能をON
autoload -Uz compinit

# Gitから取得する最新の補完プラグインを有効化
fpath=($HOME/.zsh/zsh-completions/src(N-/) $fpath)

# 補完機能をON
compinit

# 補完中、小文字と大文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'


# emacsキーバインド
bindkey -e

# Ctrl + w で単語削除する際、'/'を単語の区切りとみなす
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|" 
zstyle ':zle:*' word-style unspecified

# ^Dでzshを終了しない
setopt IGNORE_EOF

# ^Q/^S のフローコントロールを無効にする
setopt NO_FLOW_CONTROL

# beep音を鳴らさない
setopt NO_BEEP

# コマンド履歴の保存数を100000に。
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# Ctrl + r でコマンド履歴をインクリメンタル検索 (古い順)
bindkey '^r' history-incremental-pattern-search-backward
# Ctrl + s でコマンド履歴をインクリメンタル検索 (新しい順)
bindkey '^s' history-incremental-pattern-search-forward

# Ctrl + o で履歴からコマンドを補完する
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
bindkey "^o" history-beginning-search-backward-end

# cdrを有効にする
autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs

# 複数ファイル一括リネーム(zmv) を有効化
autoload -Uz zmv

# Gitリポジトリの情報をプロンプトに追加
autoload -Uz add-zsh-hook
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
#zstyle ':vcs_info:*' formats '(%s)-[%b]'
#zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'

#function _update_vcs_info_msg() {
# psvar=()
# LANG=en_US.UTF-8 vcs_info
# psvar[1]="$vcs_info_msg_0_"
#}
#add-zsh-hook precmd _update_vcs_info_msg

precmd () { vcs_info }
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'

# プロンプトの表示デザインを設定
# プロンプトに色を付ける
autoload -U colors
colors

PROMPT="
%{$fg[blue][%~]%}$reset_color
[%n]#"


# Ctrl + x Ctrll + r で、pecoを用いたコマンド選択モードへ
function peco-execute-history() {
 local item
 item=$(builtin history -n -r 1 | peco --query="$LBUFFER")
 if [[ -z "$item" ]]; then
   return 1
 fi
 
 BUFFER="$item"
 CURSOR=$#BUFFER
 zle accept-line
}
zle -N peco-execute-history
bindkey '^x^r' peco-execute-history 


# Ctrl + x Ctrl + bで、pecoを用いたcdモードへ。
function peco-cdr() {
 local item
 item=$(cdr -l | sed 's/^[^ ]\{1,\} \{1,\}//' | peco)

 if [[ -z "$item" ]]; then
   return 1
 fi

 BUFFER="cd -- $item"
 CURSOR=$#BUFFER
 zle accept-line
}
zle -N peco-cdr
bindkey '^x^b' peco-cdr


# エイリアスの設定
# 2つ上、3つ上に簡単に移動できるようにする。
alias ...='cd ../..'
alias ....='cd ../../..'