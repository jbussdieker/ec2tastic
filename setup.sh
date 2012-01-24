# > /dev/null 2>&1
function install_build_tools() {
	sudo apt-get install -y build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion 
	if [ $? -ne 0 ]; then
		return 1
	fi

	return 0
}

function install_system_rvm() {
	sudo bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )
	if [ $? -ne 0 ]; then
		return 1
	fi

	source /etc/profile.d/rvm.sh
	if [ $? -ne 0 ]; then
		return 1
	fi

	rvmsudo rvm install 1.9.2-p180
	if [ $? -ne 0 ]; then
		return 1
	fi

	return 0
}

function create_user() {
	sudo useradd -G admin -m -s /bin/bash -p \$6\$OrQ49xU4\$gSmXXLyvMTJULInax0BTAyRl9JD2VdBjxOTr/dnX4ipsBNCFvnav8rfF40qVoaRz6nvFXAkNDhukvxxKQPz3g1 $1
	sudo mkdir -p /home/$1/.ssh
	echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8tkChMszepqJQG6j4B71Qc3y/MR4zv29qkBM6DGA/nlWfdCnelQI0Z881e4FNEaBN6D85fYBZ0YNDPajwYy3dHHjHcEL3qeZ7a2H67e13LwSLcWavarr3yUooAh3zLg68XnxABcvLpqv6gb/tc3mB8G54320UE9ie+IO1AyICybHQgOjVx9BK/jWnZuQoa8EHCt+cHpPddIT+3vovpKYv7ygKG7TtTuMYNBME2+gaDb0hZj6Afg+CoJeg5XoK2DvZE2Vebh3Ty0MFmpHQIeMkSk8UcMXh0jqrgiwe3AWJR19h3Dn+lricVvBWVIQax3ye3e0iv42VsYLkJrH0m5gv josh.bussdieker@moovweb.com" > authorized_keys
	sudo cp authorized_keys /home/$1/.ssh/authorized_keys
	sudo chown $1:$1 /home/$1/.ssh/authorized_keys
	rm authorized_keys
}

echo "Setting up server..."
date
echo "Installing build tools (~2 minutes)..."
install_build_tools > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Failed"
	exit 1
fi
date
echo "Installing system RVM (~forever)..."
install_system_rvm > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Failed"
	exit 1
fi
date

echo "Creating new user..."
create_user "jbussdieker"

echo "Done"

