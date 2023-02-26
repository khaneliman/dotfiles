# .bash_profile -*- mode: sh -*-

# Load login settings and environment variables
if [[ -f ~/.profile ]]; then
	source ~/.profile
fi

# Load interactive settings
if [[ -f ~/.bashrc ]]; then
	source ~/.bashrc
fi

# Load environment variables
if [[ -f ~/.bashenv ]]; then
	source ~/.bashenv
fi
