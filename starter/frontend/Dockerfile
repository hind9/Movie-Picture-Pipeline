# ---------- Build Stage ----------
FROM public.ecr.aws/docker/library/node:20-alpine AS build

# Accept API URL at build time
ARG REACT_APP_MOVIE_API_URL
ENV REACT_APP_MOVIE_API_URL=${REACT_APP_MOVIE_API_URL}

# Create app directory
WORKDIR /app

# Install dependencies first (better layer caching)
COPY package*.json ./
RUN npm install --legacy-peer-deps

# Copy source code
COPY . .

# Optional: if you actually want to format inside container
# RUN npx prettier --write .

# Prevent ESLint from breaking the production build
ENV ESLINT_NO_DEV_ERRORS=true

# Build React for production
RUN npm run build

# ---------- Runtime Stage ----------
FROM nginx:alpine

# Copy the build output to nginx's html folder
COPY --from=build /app/build /usr/share/nginx/html

# Expose the container port
EXPOSE 80

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
