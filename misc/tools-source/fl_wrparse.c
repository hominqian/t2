/*
 * --- T2-COPYRIGHT-NOTE-BEGIN ---
 * This copyright note is auto-generated by ./scripts/Create-CopyPatch.
 * 
 * T2 SDE: misc/tools-source/fl_wrparse.c
 * Copyright (C) 2004 - 2005 The T2 SDE Project
 * Copyright (C) 1998 - 2003 ROCK Linux Project
 * 
 * More information can be found in the files COPYING and README.
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License. A copy of the
 * GNU General Public License can be found in the file COPYING.
 * --- T2-COPYRIGHT-NOTE-END ---
 */

#define _GNU_SOURCE

#include <string.h>
#include <stdio.h>
#include <sys/stat.h>
#include <unistd.h>
#include <dirent.h>

char * get_realname(char * origname) {
	static char buf[FILENAME_MAX];
	char *file, odir[FILENAME_MAX];

	if (! strcmp(origname, "/")) return "/";
	
	strcpy(buf,origname);
	if ( (file=strrchr(buf,'/')) == NULL ) {
		file = origname;
		strcpy(buf, ".");
	} else {
		*file=0; file++;
		file = origname + (file-buf);
	}
	
	getcwd(odir, FILENAME_MAX); chdir(buf);
	getcwd(buf, FILENAME_MAX);  chdir(odir);

	if (strcmp(buf, "/")) strcat(buf,"/");
	strcat(buf, file);

	return buf;
}

int dir_empty(char * nam) {
	struct dirent **namelist; int n;
	n = scandir(nam, &namelist, 0, alphasort);
	if (n < 0) perror("scandir");
	while (n--)
		if ( strcmp(namelist[n]->d_name,".") &&
		     strcmp(namelist[n]->d_name,"..") ) return 0;
	return 1;
}

int main(int argc, char ** argv) {
	char *fn, buf[FILENAME_MAX], *n;
	char realrootdir[FILENAME_MAX];
	char *package = NULL;
	char *rootdir = NULL;
	struct stat st;
	int opt, nodircheck = 0;
	int stripinfo = 0;
	int debug = 0;

	while ( (opt = getopt(argc, argv, "dDr:sp:")) != -1 ) {
		switch (opt) {
		    case 'd':
			debug = 1;
			break;

		    case 'D':
			nodircheck = 1;
			break;

		    case 's':
			stripinfo = 1;
			break;

		    case 'p':
			package = optarg;
			break;

		    case 'r':
			strcpy(realrootdir, get_realname(optarg));
			rootdir = realrootdir;
			break;

		    default:
			fprintf(stderr, "Usage: %s [-D] [-r rootdir] [-s] "
					"[-p pkg]\n", argv[0]);
			return 1;
		}
	}

	if ( rootdir != NULL ) chdir(rootdir);

	while ( fgets(buf, FILENAME_MAX, stdin) != NULL ) {

		if (stripinfo) {
			fn = strpbrk(buf, "\t ");
			if ( fn++ == NULL ) continue;
		} else fn = buf;
		if ( (n = strchr(fn, '\n')) != NULL ) *n = '\0';
		if ( *fn == 0 ) continue;

		if ( lstat(fn,&st) ) {
		    if (debug) fprintf(stderr, "DEBUG: Can't stat file: %s.\n", fn);
		    continue;
                }

		if ( S_ISDIR(st.st_mode) ) {
		    if (!nodircheck && dir_empty(fn) ) {
			if (debug) fprintf(stderr, "DEBUG: Non-empty dir: %s.\n", fn);
			continue;
		    }
		}

		fn = get_realname(fn);
		if (rootdir) {
			if (! strncmp(rootdir, fn, strlen(rootdir))) {
				fn += strlen(rootdir);
			} else {
				if (debug) fprintf(stderr, "DEBUG: Outside "
				                  "root (%s): %s.\n",
				                   rootdir, fn);
				continue;
			}
		}

		if (! package) printf("%s\n", fn);
		else printf("%s: %s\n", package, fn);
	}
	return 0;
}
