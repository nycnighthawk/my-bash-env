#!/bin/bash

vim_profile_dir=vim
source_dir=$(dirname $(readlink -f ${BASH_SOURCE}))
echo "source dir: ${source_dir}"

scaffold() {
    echo "scaffolding .vim directory..."
    mkdir -p ~/.vim/{after,view}
}

init_env() {
    export NODE_TLS_REJECT_UNAUTHORIZED=0
    export NPM_CONFIG_STRICT_SSL=false
}

cleanup_env() {
    unset NODE_TLS_REJECT_UNAUTHORIZED
    unset NPM_CONFIG_STRICT_SSL
}

create_symlinks() {
    echo "creating symbolic links..."
    local source_dir=$1
    local vim_profile_dir="${source_dir}/../$2"
    echo "vim proifle dir: ${vim_profile_dir}"
    local file_list=$(create_file_list ${vim_profile_dir})
    cd ~/.vim
    for vim_file in $file_list
    do
        vim_file=${vim_file%\"}
        vim_file=${vim_file#\"}
        echo "linking: $vim_file"
        ln -s "${vim_file}" ./
    done
    cd ~
    ln -s ~/.vim/vimrc ./.vimrc
}

create_file_list() {
    local vim_profile_dir=$1
    local file_list=""
    for vim_file in ${vim_profile_dir}/*.vim \
        ${vim_profile_dir}/vimrc \
        ${vim_profile_dir}/coc-settings.json
    do
        if [ -n "${file_list}" ]
        then
            file_list="${file_list} \"$(readlink -f ${vim_file})\""
        else
            file_list="\"$(readlink -f ${vim_file})\""
        fi
    done
    echo ${file_list}
}

update_vim() {
    echo "Install vim plugins..."
    vim +PlugInstall +qall
    echo "Updating Coc..."
    vim +CocUpdateSync +qall
}

check_requirements() {
    echo "checking requirements..."
    command -v curl || exit_with "curl must be installed!" 1
    command -v git || exit_with "git must be installed!" 1
}

exit_with() {
    echo "${1}"
    status=${2:-1}
    exit ${status}
}

install_vim_plug() {
    curl_opts="-fLo"
    if [ -n "${NO_SSL_VERIFY}" ]
    then
        git config --global --add http.sslverify false
        curl_opts="-kfLo"
    fi

    echo "installing vim plug..."
    curl ${curl_opts} ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    if [ -n "${NO_SSL_VERIFY}" ]
    then
        git config --global --unset-all http.sslverify
    fi
}

main_entry() {
    check_requirements
    init_env
    install_vim_plug
    scaffold
    create_symlinks ${source_dir} ${vim_profile_dir}
    update_vim
    cleanup_env
}

main_entry