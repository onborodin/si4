#
# $Id: Makefile.am 633 2017-04-15 13:51:07Z ziggi $
#
AUTOMAKE_OPTIONS = foreign no-dependencies no-installinfo

EXTRA_DIST = \
	LICENSE

install-data-hook:
if FREEBSD_OS
	chmod a+x $(DESTDIR)/${etcdir}/rc.d/si4
endif
	$(INSTALL) -d -m 750 -o $(APP_USER) -g $(APP_GROUP) $(DESTDIR)$(APP_LOGDIR)
	$(INSTALL) -d -m 750 -o $(APP_USER) -g $(APP_GROUP) $(DESTDIR)$(APP_RUNDIR)
	for data in $(nobase_conf_DATA);do \
	  chmod 0644 $(DESTDIR)$(APP_CONFDIR)/$$data; \
	done

if FREEBSD_OS
etcdir = @prefix@/etc
nobase_etc_SCRIPTS = rc.d/si4
endif

sbin_SCRIPTS = si4

confdir = @APP_CONFDIR@
dist_conf_DATA = \
	pw.example \
	crt.example \
	key.example

nobase_dist_pkgdata_DATA = \
	public/css/app.css \
	public/css/foundation-float.css \
	public/css/foundation-float.min.css \
	public/favicon.ico \
	public/js/app.js \
	public/js/foundation.js \
	public/js/foundation.min.js \
	public/js/jquery.js \
	public/js/jquery.min.js \
	public/js/what-input.js \
	templ/not_found.erb \
	templ/index.erb \
	templ/layout.erb \
	templ/login.erb \
	templ/error.erb \
	schema.sql
#EOF
