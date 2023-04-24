FROM archlinux:latest

# Install required packages
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm sudo git base-devel && \
    rm -rf /var/cache/pacman/pkg/*

# Add a new user
RUN useradd -m -G wheel -s /bin/bash admin && \
    echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/wheel

# Switch to the new user
USER admin
WORKDIR /home/admin

# Install auracle-git
RUN git clone https://aur.archlinux.org/auracle-git.git && \
    cd auracle-git && \
    makepkg -sri --noconfirm && \
    cd .. && \
    rm -rf auracle-git

# Install yay
RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -sri --noconfirm && \
    cd .. && \
    rm -rf yay

# Install additional packages
RUN yay -S --noconfirm lf zsh zsh-autosuggestions trash-cli htop lsd procs fzf bat

# Set the default shell to zsh
SHELL ["/bin/zsh", "-c"]

# Set up zsh and zsh-autosuggestions
RUN echo 'source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' >> $HOME/.zshrc && \
    echo 'set -o vi' >> $HOME/.zshrc && \
    echo 'export TERM=xterm-256color' >> $HOME/.zshrc

# Set the working directory to the user's home directory
WORKDIR /home/admin

# Start zsh
CMD ["/bin/zsh"]

