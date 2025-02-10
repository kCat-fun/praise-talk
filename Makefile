init:
	bun create vite@latest . --template ${PROJECT_NAME}
	bun install
	docker compose build
	docker compose up -d
	docker compose run bun-vue bun add -D @vitejs/plugin-basic-ssl
	docker compose down
	rm -rf vite.config.ts
	git clone https://github.com/kCat-fun/basic-ssl-vite-config/
	cp ./basic-ssl-vite-config/vite.config.ts ./
	rm -rf basic-ssl-vite-config