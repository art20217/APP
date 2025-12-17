# 第一階段：建置環境 (Node.js)
FROM node:18-alpine as build-stage

# 設定工作目錄
WORKDIR /app

# 複製 package.json 來安裝依賴
COPY package.json package-lock.json ./
RUN npm install

# 複製所有程式碼並執行打包 (Build)
COPY . .
RUN npm run build

# 第二階段：執行環境 (Nginx)
# 因為瀏覽器只看得懂 HTML/CSS/JS，不需要 Node.js，改用 Nginx 伺服器最快最穩
FROM nginx:stable-alpine as production-stage

# 把剛剛第一階段打包好的 dist 資料夾，複製到 Nginx 的預設目錄
COPY --from=build-stage /app/dist /usr/share/nginx/html

# 讓 Cloud Run 知道我們要開 Port 80 (Nginx 預設)
EXPOSE 80

# 啟動 Nginx
CMD ["nginx", "-g", "daemon off;"]