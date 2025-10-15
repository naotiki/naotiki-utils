FROM node:22-alpine

# 必要なパッケージをインストール
RUN apk add --no-cache \
    git \
    python3 \
    make \
    g++

# 作業ディレクトリを設定
WORKDIR /opt/meshcentral

# MeshCentralをグローバルにインストール
RUN npm install meshcentral

# データディレクトリを作成
RUN mkdir -p /opt/meshcentral/meshcentral-data

# ポート443と80を公開
EXPOSE 443 80

# MeshCentralを起動
CMD ["node", "./node_modules/meshcentral", "--port", "443", "--aliasport", "80"]
