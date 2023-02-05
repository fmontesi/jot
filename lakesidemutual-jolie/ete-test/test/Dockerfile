FROM jolielang/jolie:edge-dev AS Build

USER root

WORKDIR /app/test
COPY . .

RUN jpm install

FROM jolielang/jolie:edge
WORKDIR /app
COPY --from=Build /app .
RUN apt-get install -y npm && npm install -g @jolie/jot

# CMD ["jolie", "--params", "/config/params.json", "main.ol"]
# CMD ["jolie", "main.ol"]
CMD ["jot", "jot.json"]