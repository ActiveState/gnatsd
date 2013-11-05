#
# Makefile for stackato-gnatsd
#
# Used solely by packaging systems.
# Must support targets "all", "install", "uninstall".
#
# During the packaging install phase, the native packager will
# set either DESTDIR or prefix to the directory which serves as
# a root for collecting the package files.
#
# Additionally, stackato-pkg sets STACKATO_PKG_BRANCH to the
# current git branch of this package, so that we may use it to
# fetch other git repos with the corresponding branch.
#
# The resulting package installs in /home/stackato,
# is not intended to be relocatable.
#
# Push any resulting changes to the git repo
# in order to trigger generation of a new package.
#

NAME=gnatsd

SRCDIR=src/github.com/apcera/$(NAME)

INSTALLHOME=/home/stackato
INSTALLROOT=$(INSTALLHOME)/stackato
GOBINDIR=$(INSTALLROOT)/go/bin

INSTDIR=$(DESTDIR)$(prefix)

INSTHOMEDIR=$(INSTDIR)/$(INSTALLHOME)
INSTROOTDIR=$(INSTDIR)/$(INSTALLROOT)
INSTGOPATH=$(INSTDIR)/$(INSTALLROOT)/go
INSTBINDIR=$(INSTDIR)/$(INSTALLHOME)/bin

BUILDGOPATH=$$PWD/.gopath

GOARGS=-v

all:	repos compile

# Note: not using goget yet (gnatsd has no dependencies)
repos:
	mkdir -p $(BUILDGOPATH)/$(SRCDIR)
	git archive HEAD | tar -x -C $(BUILDGOPATH)/$(SRCDIR)

compile:	
	GOPATH=$(BUILDGOPATH) GOROOT=/usr/local/go /usr/local/go/bin/go install $(GOARGS) github.com/apcera/gnatsd

install:	
	mkdir -p $(INSTGOPATH)
	rsync -a $(BUILDGOPATH)/bin $(INSTGOPATH)
	rsync -a stackato-gnatsd $(INSTGOPATH)/bin/
	rsync -a .stackato-pkg/etc $(INSTROOTDIR)
	chown -Rh stackato.stackato $(INSTHOMEDIR)

clean: 
	GOPATH=$(BUILDGOPATH) GOROOT=/usr/local/go /usr/local/go/bin/go clean
