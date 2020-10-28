[1] export HISTIGNORE='echo "' && echo 'echo "janVanHelsing69"' > vault_pass.sh
[2] echo '90ba60b0-c56d-43c9-aff7-0ead7d9db309' > .vagrant/machines/default/virtualbox/id
[3] echo "Microservices" > README.md
[4] echo -e 'export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH" \n export MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH" ' >> ~/.bashrc
[5] echo $USER
[6] echo $GH_TOKEN
[7] echo $GITHUB_TOKEN
[8] echo "# 404-scripts" >> README.md
[9] echo "set rtp+=/usr/local/opt/fzf" >> ~/.vimrc
[10] echo $HUGO_VERSION
[11] echo $SSH
[12] echo $SSH_AUTH_SOCK
[13] echo -ne "\n\n\r=====\n\n\r"
[14] echo -ne "\n\n\r"
[15] echo [ -f "config.yaml" ]
[16] echo [-f "config.yaml"]
[17] history delete echo janVanHelsing69 > vault_pass.sh
[18] echo "$HISTSIZE"
[19] echo "# nginx-infra" >> README.md
git init
git add README.md
git commit -m "first commit"
git remote add origin git@github.com:loic-roux-404/nginx-infra.git
git push -u origin master
[20] echo 'node_modules' >> .markdownlintignore
[21] echo 'theme = "ananke"' >> config.toml
[22] echo $PUB
[23] echo $PRIV
[24] echo 'janVanHelsing69' | zip -er id_rsa.pub id_rsa
[25] echo 'build:
  docker:
    web: Dockerfile
run:
  web: bundle exec puma -C config/puma.rb' >> heroku.yml
[26] echo "src/files/" >> .gitignore
[27] ps -A | grep "app.ts" | awk '{print $1}' | xargs -n1 | echo
[28] ps -A | grep "app.ts" | awk '{print $1}' | xargs -n1 | echo $1
[29] wait 800 echo '69Lolo14' > ssh-copy-id loic-roux-404@144.91.67.171; make first-run
[30] ssh root@loicroux.com < echo -n dcc69171D04ABEC2CB86B2D4769973DF0FD488E2
[31] echo -n dcc69171D04ABEC2CB86B2D4769973DF0FD488E2 > ssh root@loicroux.com
[32] echo -n dcc69171D04ABEC2CB86B2D4769973DF0FD488E2 >> ssh root@loicroux.com
[33] timeout 10 echo "bite"
[34] echo 'export PATH="/Users/loic/.deno/bin:$PATH"' >> ~/.config/fish/config.fish
[35] echo 'denon --completion-fish | source' >> ~/.config/fish/config.fish
[36] echo $PATH
[37] echo "node_modules/ \n vendor \n /var/cache \n *.log" >> .gitignore
[38] echo "node_modules/ \n vendor \n /var/cache \n *.log"
[39] echo "node_modules/ "
[40] echo "node_modules/"
[41] echo 'import { Application } from "https://deno.land/x/oak/mod.ts";
import { APP_HOST, APP_PORT } from "./config.js";
import router from "./routes.js";
import _404 from "./controllers/404.js";
import errorHandler from "./controllers/errorHandler.js";

const app = new Application();

app.use(errorHandler);
app.use(router.routes());
app.use(router.allowedMethods());
app.use(_404);

console.log(`Listening on port:${APP_PORT}...`);

await app.listen(`${APP_HOST}:${APP_PORT}`);' >> index.js
[42] touch hosts && echo 'server01 ansible_host=loicroux.com'
[43] echo '- name: role-basics
  src: ssh://git@github.com/loic-roux-404/role-basics.git
  version: "configs"
  scm: git' >> roles/requirements.txt
[44] bash -c   ' echo "[[ Launch vbox disk conversions ]]"
                                      echo "[[ Name = $VM_NAME ]]"
                                      echo "[[ Work folder = $OUTPUT ]]"
                                      echo "[[ Files presents $(echo buster.*) ]]"'
[45] echo buster.*
[46] echo *
[47] bash -c   ' echo "[[ Launch vbox disk conversions ]]"
    echo "[[ Name = $VM_NAME ]]" 
    echo "[[ Work folder = $OUTPUT ]]"
    echo "[[ Files presents $(ls buster.*) ]]"'
[48] bash -c '    if [ ! -f "$OVF" ] && ! which guestfish > /dev/null ; then
        echo "[ ---- Use temp VM to get an ovf file ---- ]"
        vagrant up --provision || vagrant up || true
        scp -P 2222 vagrant@localhost:/home/vagrant/buster.ovf ./
        vagrant halt
        echo "[ ---- done ovf file placed on project ---- ]"
    elif [ ! -f "$OVF" ]; then
        convert
    fi'
[49] bash -c '    if [ ! -f "$OVF" ] && [ ! which guestfish > /dev/null ]; then
        echo "[ ---- Use temp VM to get an ovf file ---- ]"
        vagrant up --provision || vagrant up || true
        scp -P 2222 vagrant@localhost:/home/vagrant/buster.ovf ./
        vagrant halt
        echo "[ ---- done ovf file placed on project ---- ]"
    elif [ ! -f "$OVF" ]; then
        convert
    fi'
[50] bash -c '    if [ ! -f "$OVF" ] && ! which guestfish >/dev/null; then
        echo "[ ---- Use temp VM to get an ovf file ---- ]"
        vagrant up --provision || vagrant up || true
        scp -P 2222 vagrant@localhost:/home/vagrant/buster.ovf ./
        vagrant halt
        echo "[ ---- done ovf file placed on project ---- ]"
    elif [ ! -f "$OVF" ]; then
        convert
    fi'
[51] bash -c '    if [ ! -f "$OVF" ] && [! which guestfish >/dev/null]; then
        echo "[ ---- Use temp VM to get an ovf file ---- ]"
        vagrant up --provision || vagrant up || true
        scp -P 2222 vagrant@localhost:/home/vagrant/buster.ovf ./
        vagrant halt
        echo "[ ---- done ovf file placed on project ---- ]"
    elif [ ! -f "$OVF" ]; then
        convert
    fi'
[52] bash -c '    # On darwin Vagrantfile retry this all script on a VM
    if [ ! -f "$OVF" ] && [! which guestfish >/dev/null]; then
        echo "[ ---- Use temp VM to get an ovf file ---- ]"
        vagrant up --provision || vagrant up || true
        scp -P 2222 vagrant@localhost:/home/vagrant/buster.ovf ./
        vagrant halt
        echo "[ ---- done ovf file placed on project ---- ]"
    elif [ ! -f "$OVF" ]
        convert
    fi'
[53] bash -c 'if ! which guestfish >/dev/null; then
    echo exists
else
    echo does not exist
fi'
[54] bash -c 'if !which guestfish >/dev/null; then
    echo exists
else
    echo does not exist
fi'
[55] bash -c 'if which guestfish >/dev/null; then
    echo exists
else
    echo does not exist
fi'
[56] bash -c 'if [ !-z `guestfish --version` ]; then echo "no pthone" ;fi'
[57] bash -c 'if [ -z `guestfish --version` ]; then echo "no pthone" ;fi'
[58] if  [ -f `guestfish --version` ]; echo 'good'; end
[59] echo --help
[60] echo -e  [ -f `guestfish --version` ]
[61] echo  [ -f `guestfish --version` ]
[62] echo -n [ -f `guestfish --version` ]
[63] echo 'playbook-*' >> .gitignore
[64] man echo
[65] echo -h
[66] echo
[67] touch test.ts && echo 'import { serve } from "https://deno.land/std@v0.42.0/http/server.ts";
const s = serve({ port: 8000 });
console.log("http://localhost:8000/");
for await (const req of s) {
  req.respond({ body: "Hello World\\n" });
}
' >> test.ts
[68] bash -c 'if [ -z `pythone -v` ]; then echo "no pthone" ;fi'
[69] bash -c 'if [ -z pythone -v ]; then echo "no pthone" ;fi'
[70] bash -c 'if [-z pythone -v ]; then echo "no pthone" ;fi'
[71] touch .manala.yml && echo 'manala:
    description: My company\'s PHP recipe
    sync:
        - .manala' >> .manala.yml
[72] echo "# src-ctt-server" >> README.md
git init
git add README.md
git commit -m "first commit"
git remote add origin git@github.com:g4-dev/src-ctt-server.git
git push -u origin master
[73] echo "alias ctt=`cd (pwd)`" >> ~/.config/fish/config.fish
[74] echo -test [[ 'prod' == "prod" ]]
[75] echo -n [[ 'prod' == "prod" ]]
[76] echo [[ 'prod' == "prod" ]]
[77] echo 'set -g fish_user_paths "/usr/local/opt/icu4c/bin" $fish_user_paths' >> ~/.config/fish/config.fish
[78] echo "# node-tp" >>README.md
[79] echo $CLASSPATH
[80] echo $JAVA_HOME
[81] for i in (ls /Users/loic/Desktop/DEV/sim-game/speedcoding/app/); echo $i ;end
[82] for i in (ls /Users/loic/Desktop/DEV/sim-game/speedcoding/app/); echo i ;end
[83] su loic -f "echo "
[84] su -c 'echo "bite"'
[85] echo; printf $SSH_AUTH_SOCK
[86] echo $XDG_CONFIG_HOME
[87] echo $VAULT_TOKEN
[88] echo 'alias pvps="OPS && cd playbook-vps"' >> ~/.config/fish/config.fish
[89] echo $VM_NAME
[90] echo $OSTYPE
[91] echo 'vagrant'|scp -P 2222 vagrant@localhost:/vagrant/buster.ovf ./
[92] touch vagrant-libvirt-net.xml && echo '<network connections=\'1\'>
  <name>vagrant-libvirt</name>
  <forward mode=\'nat\'>
    <nat>
      <port start=\'1024\' end=\'65535\'/>
    </nat>
  </forward>
  <bridge name=\'virbr1\' stp=\'on\' delay=\'0\'/>
  <ip address=\'192.168.121.1\' netmask=\'255.255.255.0\'>
    <dhcp>
      <range start=\'192.168.121.2\' end=\'192.168.121.254\'/>
    </dhcp>
  </ip>
</network>' >> vagrant-libvirt-net.xml
[93] echo 'set -g fish_user_paths "/usr/local/sbin" $fish_user_paths' >> ~/.config/fish/config.fish
[94] echo $PERL5LIB
[95] echo %PERL5LIB%
[96] echo $PKG_CONFIG_PATH
[97] echo "/usr/local/var/run/libvirt/libvirt-sock" >> /usr/local/etc/libvirt/libvirtd.conf
[98] echo 'export PKG_CONFIG_PATH="/usr/local/opt/libguestfs@1.32/lib/pkgconfig";export CPPFLAGS="-I/usr/local/opt/libguestfs@1.32/include"
 export LDFLAGS="-L/usr/local/opt/libguestfs@1.32/lib" ' >> ~/.bashrc
[99] echo 'export PKG_CONFIG_PATH="/usr/local/opt/libguestfs@1.32/lib/pkgconfig";export CPPFLAGS="-I/usr/local/opt/libguestfs@1.32/include"
 export LDFLAGS="-L/usr/local/opt/libguestfs@1.32/lib" ' >> ~/.config/fish/fish_variables
[100] echo '

export PKG_CONFIG_PATH="/usr/local/opt/libguestfs@1.32/lib/pkgconfig"export CPPFLAGS="-I/usr/local/opt/libguestfs@1.32/include"
 export LDFLAGS="-L/usr/local/opt/libguestfs@1.32/lib"

'
[101] echo ''
[102] echo 'set -g fish_user_paths "/usr/local/opt/python@3.8/bin" $fish_user_paths' >> ~/.config/fish/config.fish
[103] echo $PATH  | grep 'python'
[104] /bin/bash curr=(whoami) ;echo $curr
[105] /bin/bash curr=(whoami) echo $curr
[106] echo 'janVanHelsing69' | ssh-copy-id lastico@144.91.67.171
[107] zsh -c 'vagrant rsync-auto > /dev/null & || echo "rsync "'
[108] bash -c 'vagrant rsync-auto > /dev/null & || echo "rsync "'
[109] bash -c 'vagrant rsync-auto > /dev/null & |& echo "rsync daemon launched"'
[110] echo 'eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"' >> ~/.config/fish/config.fish
[111] echo 'set -g fish_user_paths "/usr/local/opt/libpcap/bin" $fish_user_paths' >> ~/.config/fish/config.fish
[112] echo 'set -g fish_user_paths "/usr/local/opt/ncurses/bin" $fish_user_paths' >> ~/.config/fish/config.fish
[113] echo 'set -g fish_user_paths "/usr/local/opt/mysql@5.7/bin" $fish_user_paths' >> ~/.config/fish/config.fish
[114] echo 'alias sf="php bin/console"' >> ~/.config/fish/config.fish
[115] echo $PATH | grep "ruby"
[116] echo PATH
[117] echo 'set -g fish_user_paths "/usr/local/opt/ruby/bin" $fish_user_paths' >> ~/.config/fish/config.fish
[118] echo $GZIP
[119] touch fixmacos.sh && echo "extBinPath=/usr/local/opt
vagrantRepo=$extBinPath/vagrant
vagrantBin=$vagrantRepo/exec/vagrant

git clone https://github.com/hashicorp/vagrant.git $extBinPath

cd $vagrantRepo

sudo bundle install
sudo bundle --binstubs exec

$vagrantBin bin init -m hashicorp/bionic64

# Symlink to system binaries index (vagrant CLi is now available)
ln -sf $vagrantBin /usr/local/bin/vagrant" >> fixmacos.sh
[120] echo $UID
[121] echo "Comment faire un cherry pick ? \n " >> text.txt
[122] echo alias ecs="cd (pwd)" >> ~/.config/fish/config.fish
[123] echo 2 >>index4.css
[124] echo "1" >> index2.css
[125] echo "1" >> index.css
[126] echo "alias gp='git push'" >> ~/.config/fish/config.fish
[127] echo "Maxime Fabri \n Alexandre Chapelle \n Valentin freychet\n loic Roux \n Antoine Henrionnet" >> membres_equipe
[128] php -r "echo ini_get('memory_limit').PHP_EOL;"
[129] git remote add origin git@github.com:g4-dev/playbook-echoservice.git
[130] git remote add origin git@github.com:forks-loic-roux-404/playbook-echoservice.git
git push -u origin master
[131] echo "alias gd='git diff'" >> ~/.config/fish/config.fish
[132] echo "alias s='brew services'" >> ~/.config/fish/config.fish
[133] echo "alias vh='vagrant halt'" >> ~/.config/fish/config.fish
[134] echo (cat aliases) >> ~/.config/fish/plugins/additionals.fish
[135] echo aliases >> ~/.config/fish/plugins/additionals.fish
[136] echo "alias pbc='php bin/console'" >> ~/.config/fish/config.fish
[137] echo 'alias ofinder="open -a Finder.app ./"' >> ~/.config/fish/config.fish
[138] echo 'alias gpristine=\'git reset --hard && git clean -dfx\'
' >> ~/.config/fish/config.fish
[139] echo 'alias=alias gpristine=\'git reset --hard && git clean -dfx\'
' >> ~/.config/fish/config.fish
[140] echo 'alias=alias gpristine=\'git reset --hard && git clean -dfx\'
'
[141] echo 'alias phpunit="php ~/.composer/vendor/phpunit/phpunit"' >> ~/.config/fish/config.fish
[142] echo 'alias phpunit="php ~/.composer/vendor/phpunit/phpunit"'
[143] echo 'alias phpunit="php ~/.composer/vendor/phpunit/phpunit:wq"'
[144] echo "alias python=/usr/local/bin/python3.7" >> ~/.config/fish/config.fish
[145] echo 'set -g fish_user_paths "/usr/local/opt/apr-util/bin" $fish_user_paths' >> ~/.config/fish/config.fish
[146] echo 'alias go-mtest="go test -v -bench=. -benchmem -memprofile=mem.out"' >> ~/.config/fish/config.fish
[147] echo 'alias gotest="go test -v -bench=. -benchmem -memprofile=mem.out"' >> ~/.config/fish/config.fish
[148] echo 'set -gx PKG_CONFIG_PATH "/usr/local/opt/sqlite/lib/pkgconfig"' >> ~/.config/fish/config.fish
[149] echo 'set -gx LDFLAGS "-L/usr/local/opt/sqlite/lib"
  set -gx CPPFLAGS "-I/usr/local/opt/sqlite/include"' >> ~/.config/fish/config.fish
[150] echo 'set -g fish_user_paths "/usr/local/opt/sqlite/bin" $fish_user_paths' >> ~/.config/fish/config.fish
[151] echo "alias gst="git status"" >> ~/.config/fish/config.fish
[152] export HISTIGNORE='echo "' && echo 'echo "janVanHelsing69"' > vault_pass.sh
[153] history delete echo janVanHelsing69 > vault_pass.sh
[154] echo 'janVanHelsing69' | zip -er id_rsa.pub id_rsa
[155] ssh root@loicroux.com -pjanVanHelsing69
[156] vault kv put playbook-vps/deploy passw=janVanHelsing69
[157] vault login -method=userpass \
    username=ansible_vault \
    password=janVanHelsing69
[158] echo 'janVanHelsing69' | ssh-copy-id lastico@144.91.67.171
[159] 'janVanHelsing69' | ssh-copy-id lastico@144.91.67.171

Enter nothing to cancel the delete, or
Enter one or more of the entry IDs separated by a space, or
Enter "all" to delete all the matching entries.


Deleting history entry 1: "export HISTIGNORE='echo "' && echo 'echo "janVanHelsing69"' > vault_pass.sh"
