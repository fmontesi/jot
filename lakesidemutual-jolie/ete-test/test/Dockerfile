FROM jolielang/jolie:edge-dev AS Build

USER root

COPY /assertions /assertions
COPY /customer-core /customer-core
COPY /customer-management /customer-management
WORKDIR /app/test
COPY ete-test/test .
RUN npm install -g @jolie/jot
RUN jpm install
CMD ["jot", "jot.json"]
