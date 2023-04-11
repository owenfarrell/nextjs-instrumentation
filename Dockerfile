FROM node:18-alpine AS base

# 1. Install dependencies only when needed
FROM base AS deps
WORKDIR /app

RUN apk add --no-cache libc6-compat python3 make g++

COPY package.json package-lock.json ./

RUN npm ci

# 2. Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY . .

ARG NEXT_PUBLIC_APPLICATIONINSIGHTS_CONNECTION_STRING

ENV NEXT_PUBLIC_APPLICATIONINSIGHTS_CONNECTION_STRING ${NEXT_PUBLIC_APPLICATIONINSIGHTS_CONNECTION_STRING}

RUN npm run build

# 3. Production image, copy all the files and run next
FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production

RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT 3000

CMD ["node", "server.js"]
