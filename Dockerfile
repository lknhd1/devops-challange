# Use an official Node.js image as the base image
FROM node:18-bookworm

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install the app dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Expose the port that your app listens on
EXPOSE 80

# Set default environment variables for the app (optional, override in runtime)
ENV LISTEN_ADDRESS=0.0.0.0
ENV LISTEN_PORT=80

# expose ports
EXPOSE 80 2222

# set entrypoint
ENTRYPOINT ["node", "app.js"] 
