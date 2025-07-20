FROM ghcr.io/puppeteer/puppeteer:19.7.0

WORKDIR /usr/src/app

# Create a non-root user and set permissions
RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /usr/src/app

# Expose the port the app runs on
EXPOSE 3000

# Copy package files and set ownership
COPY --chown=pptruser:pptruser package*.json ./

# Switch to non-root user and install dependencies
USER pptruser
RUN npm install

# Copy rest of the application with correct ownership
COPY --chown=pptruser:pptruser . .

# Start the bot
CMD [ "node", "bot.js" ]
