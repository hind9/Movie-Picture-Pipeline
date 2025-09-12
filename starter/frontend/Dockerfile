# Use Node 20 (matches cheerio/undici requirements)
FROM public.ecr.aws/docker/library/node:20-alpine

# Set build-time environment variable
ARG REACT_APP_MOVIE_API_URL
ENV REACT_APP_MOVIE_API_URL=${REACT_APP_MOVIE_API_URL}

# Set working directory
WORKDIR /app

# Copy dependency files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the source code
COPY . .

# Optional: fix formatting (inside container)
RUN npx prettier --write .

# Disable ESLint for production build to prevent build failure
ENV ESLINT_NO_DEV_ERRORS=true

# Build the React app
RUN npm run build

# Use nginx to serve the production build
FROM nginx:alpine
COPY --from=0 /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
