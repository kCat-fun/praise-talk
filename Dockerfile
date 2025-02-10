# Bunの公式イメージを使用
FROM oven/bun:latest

# 作業ディレクトリを設定
WORKDIR /app

# package.json と bun.lockb をコピーして依存関係をインストール
COPY package.json bun.lockb ./
RUN bun install

# ソースコードをコピー
COPY . .

# ポートを開放
EXPOSE 5173

# HTTPS付きでViteの開発サーバーを起動
CMD ["bun", "run", "dev", "--", "--host"]
