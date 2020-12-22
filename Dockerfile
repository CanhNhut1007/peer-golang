FROM golang:alpine3.12 as builder

FROM acloudfan/k8s-hlf-acme-peer:2.0 

COPY cc-test.sh /var/hyperledger/bins/cc-test.sh
RUN chmod +x /var/hyperledger/bins/cc-test.sh

COPY --from=builder /usr/local/go /usr/local/go
COPY --from=builder /go /go
ENV PATH=/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV GOPATH=/go

RUN apk add jq \
&& apk add git 

RUN cd /go/src
RUN mkdir /go/src/medicalrecord
COPY  medicalrecord /go/src/medicalrecord
RUN go get -u github.com/hyperledger/fabric-chaincode-go/shim
RUN go get -u github.com/hyperledger/fabric-protos-go/peer
RUN go get -u github.com/hyperledger/fabric-protos-go/ledger/queryresult
RUN go get -u github.com/hyperledger/fabric/common/util

CMD peer node start
