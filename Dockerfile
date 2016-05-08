FROM ubuntu:14.04

# Debian packages

RUN apt -y update      && \
    apt-get -y install    \
               wget       \
               make       \
               m4         \
               patch      \
               unzip      \
               vim        \
               git        \
               g++        \
               libev-dev  \
               pkg-config \
               libncurses5-dev \
               gcc

# OCaml installation 

ADD https://github.com/ocaml/opam/releases/download/1.2.2/opam-1.2.2-x86_64-Linux /usr/local/bin/opam

RUN chmod a+x /usr/local/bin/opam \
 && opam init -y --comp=4.03.0    \
 && opam install -y \
         ocp-indent \
         merlin     \
         lwt        \
         ppx_deriving_protobuf

# Dotfiles setup

RUN    cd $HOME \
    && git clone https://github.com/mransan/dotfiles.git dotfiles.git \
    && echo ". $HOME/dotfiles.git/bashrc" >> ~/.bashrc                \
    && ln -s $HOME/dotfiles.git/vimrc ~/.vimrc                        \
    && ln -s $HOME/dotfiles.git/vim ~/.vim                            \
    && ln -s $HOME/dotfiles.git/gitconfig ~/.gitconfig

# Protobuf

ADD https://github.com/google/protobuf/releases/download/v3.0.0-beta-2/protobuf-cpp-3.0.0-beta-2.tar.gz /root/
RUN    tar xzvf root/protobuf-cpp-3.0.0-beta-2.tar.gz -C root/ \
   &&  cd root/protobuf-3.0.0-beta-2     \
   &&  ./configure                       \
   &&  make                              \
   &&  make check                        \
   &&  make install                      \
   &&  cd ../                            \
   &&  rm -rf protobuf-3.0.0-beta-2  
