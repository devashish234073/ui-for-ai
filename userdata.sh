#!/bin/bash
apt update -y
apt-get install -y apache2
service apache2 start
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
<title>Please wait while startup script completes</title>
</head>
<body>
<h1>Please wait while startup script completes..</h1>
<script>
    function getRandomInt() {
        return Math.floor(Math.random() * 256);
    }
    var color = 'rgb(' + getRandomInt() + ',' + getRandomInt() + ',' + getRandomInt() + ')';
    document.querySelector(\"h1\").style.color = color;
    setInterval(function() {
        location.reload();
    }, 1000);
</script>
</body>
</html>
EOF
apt install git -y
gitv=$(git version)
model=qwen2:0.5b
curl -fsSL https://ollama.com/install.sh | sh
export HOME=/home/ec2-user
ollama serve&
sleep 5
ollama pull $model
curl_out1=$(curl http://localhost:11434)
curl_out2=$(curl http://localhost:11434/api/generate -d '{"model": "qwen2:0.5b","prompt": "Write a poem on goat in 10 words"}')
public_ip=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install 20
nodev=$(node -v)
git clone https://github.com/devashish234073/ui-for-ai
cd ui-for-ai
npm install
node server.js&
cd ..
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
<title>UI setup done</title>
</head>
<body>
<h1>UI setup done</h1>
<p>Git Installed: $gitv<p>
<p>Node Installed: $nodev<p>
<p>Curl for Ollama: $curl_out1<p>
<a href="http://${public_ip}:9999/index.html">Click Here To Launch AI Chat</a>
<p>Query Resp from $model: $curl_out2<p>
</body>
</html>
EOF
systemctl enable apache2