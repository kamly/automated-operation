#!/bin/bash                                                                                                                                                  

clear

# 提供help帮助 --help
if [ ${#@} -ne 0 ] && [ "${@#"--help"}" = "" ];then
	printf -- './vim.sh <options...> <software> \n';
	printf -- 'options:\n';
	printf -- ' 	     -s           指定插件安装\n';
	printf -- ' 	     -v         指定插件不安装\n';
	printf -- ' 	     -all            全部安装\n';
	printf -- 'software:\n';
	printf -- '   Syntastic\n';
	printf -- '  SimpylFold\n';
	printf -- '    NERDTree\n';
	printf -- '     AirLine\n';
	printf -- '     Taglist\n';
	printf -- '       Theme\n';
	printf -- 'example:\n';
	printf -- ' ./vim.sh -s Syntastic NERDTree\n';
	printf -- ' ./vim.sh -v Syntastic Theme\n';
	printf -- ' ./vim.sh -all\n';
	printf -- ' ./vim.sh -menu\n';
fi

# 检查git安装
_=$(command -v git)
if [ "$?" != "0" ];then
	printf -- 'You dont not seem to have git installed \n'; 
	printf -- 'Get it: .... \n'; 
	printf -- 'Exiting with status code 127. \n'; 
	exit 127;
fi

# 判断Vim的版本是不是basic，如果是，返回0；否则返回1
function checkVimVersion() {
	# 先获取vim可执行命令的位置
	vimLoc=$(which vim || which vi)

	# 如果该位置的文件是链接文件
	while [ -L $vimLoc ]; do
		# 通过ls -l命令以及sed命令取出该链接文件对应的文件
		vimLoc=$(ls -l $vimLoc | sed -r 's/.+-> ([^ ]+).*/\1/')
	done

	# 最终得到vim命令对应的可执行文件对应的位置，
	# 通过sed命令取出vim对应的版本，比如: tiny, basic等
	vimVersion=$(echo $vimLoc | sed -r 's/.+vim\.(.+)/\1/')
	echo -e "\033[32m你系统VIM的版本为：$vimVersion\033[0m"

	if [ $vimVersion == basic ]; then
		return 0
	else
		return 1
	fi
}

# vim基本配置以及vundle插件初始化
function configVimBasic() {

    # 判断Vim的版本是不是basic
	if checkVimVersion; then
		echo -e "\033[32m无需升级VIM\033[0m"
	else
		echo -e "\033[32m升级VIM\033[0m"
		# 卸载vim-tiny版本
		sudo apt-get remove vim-tiny vim-commoin
		# 安装full版vim
		sudo apt-get install vim
	fi
	# 安装Git
	sudo apt-get install git
	# 判断vundle插件是否已经安装
	if [ -d ~/.vim/bundle/Vundle.vim ]; then
		echo -e "\033[32m你已经安装了Vundle插件管理工具\033[0m"
	else
		echo -e "\033[32m安装Vundle插件管理工具\033[0m"
		# 下载vundle插件
		git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	fi
	# 在$HOME目录下新建.vimrc配置文件
	#touch $HOME/.vimrc
	echo -e "\033[32m配置用户的Vim配置文件.vimrc\033[0m"
	# 将vim基本配置以及vundle插件的初始化代码插入到.vimrc
	cat ./conf/vim_conf/VimBasicConf.txt > $HOME/.vimrc
}

# 安装，配置语法检查插件syntastic
function configSyntastic() {
	echo -e "\033[32m安装语法检查插件syntastic\033[0m"
	# 获取安装Github插件代码的结束位置，并在该位置之前插入安装
	# syntastic插件的代码
	sed -i "/^\" Github Plugin End/i\Plugin 'vim-syntastic/syntastic'" $HOME/.vimrc
	# 安装
	vim +PluginInstall +qall 
	# 在.vimrc文件尾部追加该插件的配置
	cat ./conf/vim_conf/SyntasticConf.txt >> $HOME/.vimrc
}

# 安装，配置代码折叠插件SimpylFold
function configSimpylFold() {
	echo -e "\033[32m安装代码折叠插件SimpylFold\033[0m"
	# 获取安装Github插件代码的结束位置，并在该位置之前插入安装
	# SimpylFold插件的代码
	sed -i "/^\" Github Plugin End/i\Plugin 'tmhedberg/SimpylFold'" $HOME/.vimrc
	# 安装
	vim +PluginInstall +qall 
	# 在.vimrc文件尾部追加该插件的配置
	cat ./conf/vim_conf/SimpylFoldConf.txt >> $HOME/.vimrc
}

# 安装，配置显示文件树/文件目录插件NERDTree
function configNERDTree() {
	echo -e "\033[32m安装显示文件树/文件目录插件NERDTree\033[0m"
	# 获取安装Github插件代码的结束位置，并在该位置之前插入安装
	# NERDTree插件的代码
	sed -i "/^\" Github Plugin End/i\Plugin 'scrooloose/nerdtree'" $HOME/.vimrc
	# 安装
	vim +PluginInstall +qall 
	# 在.vimrc文件尾部追加该插件的配置
	cat ./conf/vim_conf/NERDTreeConf.txt >> $HOME/.vimrc
}

# 安装，配置状态栏增强插件vim-airline
function configVimAirLine() {
	echo -e "\033[32m安装状态栏增强插件vim-airline\033[0m"
	# 获取安装Github插件代码的结束位置，并在该位置之前插入安装
	# vim-airline插件的代码
	sed -i "/^\" Github Plugin End/i\Plugin 'vim-airline/vim-airline'" $HOME/.vimrc
	sed -i "/^\" Github Plugin End/i\Plugin 'vim-airline/vim-airline-themes'" $HOME/.vimrc
	# 安装
	vim +PluginInstall +qall 
	# 在.vimrc文件尾部追加该插件的配置
	cat ./conf/vim_conf/AirLineConf.txt >> $HOME/.vimrc
}

# 安装，配置查看显示代码文件中的宏，函数，变量定义等的插件taglist
function configTaglist() {
	echo -e "\033[32m安装查看显示代码文件中的宏，函数，变量定义等的插件taglist\033[0m"
	# 获取安装Github插件代码的结束位置，并在该位置之前插入安装
	# majutsushi/tagbar 插件的代码
	sed -i "/^\" Github Plugin End/i\Plugin 'majutsushi/tagbar'" $HOME/.vimrc
	# 安装
	vim +PluginInstall +qall 
	# 在.vimrc文件尾部追加该插件的配置
	cat ./conf/vim_conf/TaglistConf.txt >> $HOME/.vimrc 
	# 需要安装ctags插件
	sudo apt-get install ctags 
}

# 安装 vim 主题 Plugin 'tomasr/molokai'
function configTheme() {
	echo -e "\033[32m安装查看显示代码文件中的宏，函数，变量定义等的插件taglist\033[0m"
	# 获取安装Github插件代码的结束位置，并在该位置之前插入安装
	# majutsushi/tagbar 插件的代码
	sed -i "/^\" Github Plugin End/i\Plugin 'tomasr/molokai'" $HOME/.vimrc
	# 安装
	vim +PluginInstall +qall 
	# 在.vimrc文件尾部追加该插件的配置
	cat ./conf/vim_conf/ThemeConf.txt >> $HOME/.vimrc 
}


# 定义存储插件名称以及对应配置安装函数的字典
declare -A plugin_dict
plugin_dict=(
	[Syntastic]=configSyntastic
	[SimpylFold]=configSimpylFold
	[NERDTree]=configNERDTree
	[AirLine]=configVimAirLine
	[Taglist]=configTaglist
	[Theme]=configTheme
)

configVimBasic # vim基本配置以及vundle插件初始化

echo -e "\033[32m正在进行插件安装......\033[0m"

# 命令行参数判断
case $1 in
	-s) # 安装指定的插件
		for plugin in $@
		do
			${plugin_dict[$plugin]}
		done
		;;
	-v) # 不安装指定的插件
		# 遍历plugin_dict所有的key
		for plugin_name in ${!plugin_dict[*]}
		do 
			canINS=true
			# 检查该key是否在命令行参数中
			for plugin in $@
			do 
				if [ $plugin_name == $plugin ]; then
					canINS=false
				fi
			done
			if $canINS; then
				${plugin_dict[$plugin_name]}
			fi
		done
		;;
    -all | *) # 全部安装
		# 遍历plugin_dict所有的value
		for plugin_install in ${plugin_dict[*]}
		do 
			$plugin_install
		done
		;;
esac

echo -e "\033[32m插件安装完成！\033[0m"
echo -e "\033[32mEnjoy...\033[0m"




