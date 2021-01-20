.PHONY: lint generate test race default linux darwin macos windows all

name?=$(shell basename `pwd`)
ProjectDir=$(shell pwd)
OSName=`uname -s | tr 'A-Z' 'a-z'`
OSARCH:=
ifeq ($(OS),Windows_NT)
	ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
		OSARCH = amd64
	endif
	ifeq ($(PROCESSOR_ARCHITECTURE),x86)
		OSARCH = 386
	endif
else
	UNAME_P := $(shell uname -m)
	ifeq ($(UNAME_P),x86_64)
		OSARCH = amd64
	endif
	ifneq ($(filter %86,$(UNAME_P)),)
		OSARCH = 386
	endif
	ifneq ($(filter arm%,$(UNAME_P)),)
		OSARCH = arm
	endif
endif
OutputDir=$(ProjectDir)/_bin/
V2rayFilePath=$(ProjectDir)/main
V2ctlFilePath=$(ProjectDir)/infra/control/main
GoModName=`head -n 1 go.mod | cut -d ' ' -f 2`
PkgList=$(shell go list ./... | grep -v /vendor/)
BuildGoVersion=`go version|sed -e 's/go version //g'`
BuildTime=`date '+%Y%m%d.%H%M%S'`
BuildFlags=-ldflags "-s -w"

lint:
	@golangci-lint run

generate:
	@go generate $(PkgList)

test:
	@go test -v $(PkgList)

race:
	@go test -race -short $(PkgList)

default:
	@go build $(BuildFlags) -o $(OutputDir)-$(OSName)-$(OSARCH) $(MainFilePath)

all: linux darwin windows

linux:
	@cd $(V2rayFilePath) && \
	GOOS=linux GOARCH=amd64 go build $(BuildFlags) -tags timetzdata -o $(OutputDir)v2ray-linux-amd64 && \
	cd $(V2ctlFilePath) && \
	GOOS=linux GOARCH=amd64 go build $(BuildFlags) -tags timetzdata -o $(OutputDir)v2ctl-linux-amd64

darwin macos:
	@cd $(V2rayFilePath) && \
	GOOS=darwin GOARCH=amd64 go build $(BuildFlags) -tags timetzdata -o $(OutputDir)v2ray-darwin-amd64 && \
	cd $(V2ctlFilePath) && \
	GOOS=darwin GOARCH=amd64 go build $(BuildFlags) -tags timetzdata -o $(OutputDir)v2ctl-darwin-amd64

windows:
	@cd $(V2rayFilePath) && \
	GOOS=windows GOARCH=amd64 go build $(BuildFlags) -tags timetzdata -o $(OutputDir)v2ray-windows-amd64.exe && \
	cd $(V2ctlFilePath) && \
	GOOS=linux GOARCH=amd64 go build $(BuildFlags) -tags timetzdata -o $(OutputDir)v2ctl-windows-amd64.exe
