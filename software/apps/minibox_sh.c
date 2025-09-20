// minibox.c — ChatGPT brutally small multicall Busybox-ish core.
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <dirent.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>


#define BUFSZ 4096
static void die(const char *m){write(2,m,strlen(m));write(2,"\n",1);_exit(1);}
static ssize_t xwrite(int fd,const void*buf,size_t n){ssize_t r;size_t o=0;while(o<n&&(r=write(fd,(char*)buf+o,n-o))>0)o+=r;return (r<0)?r:o;}


// --- cat: cat [files...] (stdin if none) --- ~20 lines
static int app_cat(int argc,char**argv){char b[BUFSZ];int i=1;ssize_t r; if(argc==1){while((r=read(0,b,sizeof b))>0)xwrite(1,b,r);return 0;} for(;i<argc;i++){int fd=!strcmp(argv[i],"-")?0:open(argv[i],O_RDONLY); if(fd<0){perror(argv[i]);continue;} while((r=read(fd,b,sizeof b))>0)xwrite(1,b,r); if(fd)close(fd);} return 0;}


// --- echo: echo [args...] --- ~10 lines
static int app_echo(int argc,char**argv){for(int i=1;i<argc;i++){xwrite(1,argv[i],strlen(argv[i])); if(i+1<argc)xwrite(1," ",1);} xwrite(1,"\n",1); return 0;}


// --- true/false --- ~4 lines
static int app_true(int a,char**b){(void)a;(void)b;return 0;} static int app_false(int a,char**b){(void)a;(void)b;return 1;}


// --- ls: ls [dir] --- names only, one per line. ~25 lines
static int app_ls(int argc,char**argv){const char* d= (argc>1)?argv[1]:"."; DIR*dp=opendir(d); if(!dp){perror(d); return 1;} struct dirent*e; while((e=readdir(dp))){const char*n=e->d_name; if(!strcmp(n, ".")||!strcmp(n,".."))continue; xwrite(1,n,strlen(n)); xwrite(1,"\n",1);} closedir(dp); return 0;}


// --- cp: cp SRC DST (no dirs, no perms) --- ~25 lines
static int app_cp(int argc,char**argv){if(argc<3)die("usage: cp SRC DST"); int in=open(argv[1],O_RDONLY); if(in<0)die("cp: open src"); int out=open(argv[2],O_WRONLY|O_CREAT|O_TRUNC,0644); if(out<0)die("cp: open dst"); char b[BUFSZ]; ssize_t r; while((r=read(in,b,sizeof b))>0) if(xwrite(out,b,r)<0)die("cp: write"); close(in); close(out); return 0;}


// --- mv: mv SRC DST (rename, fallback to cp+rm) --- ~25 lines
static int app_mv(int argc,char**argv){if(argc<3)die("usage: mv SRC DST"); if(!rename(argv[1],argv[2]))return 0; // fallback
int r=app_cp(argc,argv); if(!r) unlink(argv[1]); return r;}


// --- rm: rm FILE... --- no -r. ~10 lines
static int app_rm(int argc,char**argv){int rc=0; for(int i=1;i<argc;i++) if(unlink(argv[i])){perror(argv[i]); rc=1;} return rc;}


// --- mkdir/rmdir --- ~10 lines each
static int app_mkdir(int argc,char**argv){if(argc<2)die("usage: mkdir DIR"); return mkdir(argv[1],0777);}
static int app_rmdir(int argc,char**argv){if(argc<2)die("usage: rmdir DIR"); return rmdir(argv[1]);}


// --- wc: wc [-c|-l] [file] --- bytes or lines (default lines). ~35 lines
static int app_wc(int argc,char**argv){int count_bytes=0; const char*path=NULL; for(int i=1;i<argc;i++){ if(!strcmp(argv[i],"-c"))count_bytes=1; else if(!strcmp(argv[i],"-l"))count_bytes=0; else path=argv[i]; }
int fd= path?open(path,O_RDONLY):0; if(fd<0)die("wc: open"); char b[BUFSZ]; ssize_t r; unsigned long long c=0; if(count_bytes){ while((r=read(fd,b,sizeof b))>0)c+=r; } else { while((r=read(fd,b,sizeof b))>0) for(ssize_t i=0;i<r;i++) if(b[i]=='\n')c++; }
char out[64]; int n=snprintf(out,sizeof out,"%llu\n",c); xwrite(1,out,n); if(fd)close(fd); return 0;}


// --- head: head [-n N] [file] --- ~40 lines
static int app_head(int argc,char**argv){int nlines=10; const char*path=NULL; for(int i=1;i<argc;i++){ if(!strcmp(argv[i],"-n") && i+1<argc){ nlines=atoi(argv[++i]); } else path=argv[i]; }
int fd= path?open(path,O_RDONLY):0; if(fd<0)die("head: open"); char b[BUFSZ]; ssize_t r; while(nlines>0 && (r=read(fd,b,sizeof b))>0){ for(ssize_t i=0;i<r;i++){ xwrite(1,&b[i],1); if(b[i]=='\n' && --nlines==0){ if(fd)close(fd); return 0; } } }
if(fd)close(fd); return 0;}


// --- grep: grep SUBSTR [file] --- naive substring search. ~45 lines
static int app_grep(int argc,char**argv){if(argc<2)die("usage: grep SUBSTR [file]"); const char*sub=argv[1]; size_t sl=strlen(sub); const char*path = (argc>2)?argv[2]:NULL; FILE*f = path?fopen(path,"r"):stdin; if(!f)die("grep: open"); char *line=NULL; size_t cap=0; ssize_t n; int rc=1; while((n=getline(&line,&cap,f))!=-1){ for(ssize_t i=0;i+ (ssize_t)sl<=n;i++){ if(!memcmp(line+i,sub,sl)){ xwrite(1,line,n); rc=0; break; } } }
if(path)fclose(f); free(line); return rc;}


// --- hostname: hostname [name] --- ~20 lines
static int app_hostname(int argc,char**argv){char b[256]; if(argc==1){ if(gethostname(b,sizeof b))die("hostname: get"); size_t n=strnlen(b,sizeof b); xwrite(1,b,n); xwrite(1,"\n",1); return 0; } else { if(sethostname(argv[1],strlen(argv[1]))) die("hostname: set"); return 0; } }


// --- netcat-lite: nc HOST PORT --- pipes stdin↔socket. ~60 lines
static int app_nc(int argc,char**argv){if(argc<3)die("usage: nc HOST PORT"); struct addrinfo hints={0},*ai; hints.ai_socktype=SOCK_STREAM; if(getaddrinfo(argv[1],argv[2],&hints,&ai))die("nc: gai"); int s=-1; for(struct addrinfo*p=ai;p;p=p->ai_next){ s=socket(p->ai_family,p->ai_socktype,p->ai_protocol); if(s<0)continue; if(!connect(s,p->ai_addr,p->ai_addrlen))break; close(s); s=-1; } freeaddrinfo(ai); if(s<0)die("nc: connect");
for(;;){ fd_set rf; FD_ZERO(&rf); FD_SET(0,&rf); FD_SET(s,&rf); int mx = s>0?s:0; if(select(mx+1,&rf,0,0,0)<0)break; char b[BUFSZ]; if(FD_ISSET(0,&rf)){ ssize_t r=read(0,b,sizeof b); if(r<=0)break; if(xwrite(s,b,r)<0)break; } if(FD_ISSET(s,&rf)){ ssize_t r=read(s,b,sizeof b); if(r<=0)break; if(xwrite(1,b,r)<0)break; } }
close(s); return 0;}


// --- httpd-mini: httpd [port] [docroot] --- GET only, no mime, no dirs. ~80 lines
static int app_httpd(int argc,char**argv){const char*port=(argc>1)?argv[1]:"8080"; const char*root=(argc>2)?argv[2]:"."; int lsock,csock; struct addrinfo hints={0},*ai; hints.ai_socktype=SOCK_STREAM; hints.ai_flags=AI_PASSIVE; if(getaddrinfo(NULL,port,&hints,&ai))die("httpd: gai"); lsock=socket(ai->ai_family,ai->ai_socktype,0); int on=1; setsockopt(lsock,SOL_SOCKET,SO_REUSEADDR,&on,sizeof on); bind(lsock,ai->ai_addr,ai->ai_addrlen); freeaddrinfo(ai); listen(lsock,16);
char req[2048],path[1024],file[1300]; for(;;){ csock=accept(lsock,NULL,NULL); if(csock<0)continue; ssize_t n=read(csock,req,sizeof req-1); if(n<=0){close(csock);continue;} req[n]=0; // parse: GET /foo HTTP/1.1
char method[8], url[1024]; if(sscanf(req,"%7s %1023s",method,url)!=2){close(csock);continue;} if(strcmp(method,"GET")){xwrite(csock,"HTTP/1.0 405\r\n\r\n",19); close(csock); continue;}
// prevent .. traversal
if(strstr(url,"..")) {xwrite(csock,"HTTP/1.0 400\r\n\r\n",19); close(csock); continue;}
snprintf(path,sizeof path,"%s%s",root, strcmp(url,"/")?url:"/index.html"); int fd=open(path,O_RDONLY); if(fd<0){xwrite(csock,"HTTP/1.0 404\r\n\r\n",19); close(csock); continue;} xwrite(csock,"HTTP/1.0 200 OK\r\n\r\n",21); ssize_t r; while((r=read(fd,file,sizeof file))>0) xwrite(csock,file,r); close(fd); close(csock); }
return 0;}


// --- tar-lite: create only. tar c ARCHIVE FILE... (ustar-ish headers minimal). ~95 lines
struct ustar{char name[100]; char mode[8]; char uid[8]; char gid[8]; char size[12]; char mtime[12]; char chksum[8]; char typeflag; char linkname[100]; char magic[6]; char version[2]; char uname[32]; char gname[32]; char devmajor[8]; char devminor[8]; char prefix[155]; char pad[12];};
static void oct(char*s,size_t n,unsigned long v){snprintf(s,n,"%0*lo",(int)n-1,v);}
static int app_tar(int argc,char**argv){if(argc<4||argv[1][0]!='c')die("usage: tar c ARCHIVE FILE..."); int out=open(argv[2],O_WRONLY|O_CREAT|O_TRUNC,0644); if(out<0)die("tar: open"); char b[BUFSZ]; for(int i=3;i<argc;i++){struct stat st; if(stat(argv[i],&st)<0)continue; int in=open(argv[i],O_RDONLY); if(in<0)continue; struct ustar h={0}; strncpy(h.name,argv[i],sizeof h.name); memcpy(h.magic,"ustar",5); memcpy(h.version,"00",2); oct(h.mode,8,0644); oct(h.uid,8,0); oct(h.gid,8,0); oct(h.size,12,(unsigned long)st.st_size); oct(h.mtime,12,(unsigned long)st.st_mtime); h.typeflag='0'; unsigned sum=0; memset(h.chksum,' ',8); for(size_t k=0;k<sizeof h;k++) sum+=((unsigned char*)&h)[k]; snprintf(h.chksum,8,"%06o\0 ",(unsigned)sum); xwrite(out,&h,sizeof h); ssize_t r; while((r=read(in,b,sizeof b))>0) xwrite(out,b,r); // pad to 512
size_t pad = (512 - (st.st_size % 512)) % 512; if(pad){memset(b,0,pad); xwrite(out,b,pad);} close(in);} // two empty blocks
memset(b,0,1024); xwrite(out,b,1024); close(out); return 0;}


// --- gzip? nah. Provide RLE as toy: rle e|d IN OUT --- ~50 lines
static int app_rle(int argc,char**argv){if(argc<4)die("usage: rle e|d IN OUT"); int in=open(argv[2],O_RDONLY), out=open(argv[3],O_WRONLY|O_CREAT|O_TRUNC,0644); if(in<0||out<0)die("rle: open"); char b[BUFSZ]; if(argv[1][0]=='e'){ int c,prev=-1,count=0; while((c=read(in,b,1))>0){unsigned char ch=b[0]; if(prev==-1||ch==prev){prev=ch; if(++count==255){unsigned char pkt[2]={count,(unsigned char)prev}; xwrite(out,pkt,2); count=0; prev=-1;} } else {unsigned char pkt[2]={count,(unsigned char)prev}; if(count)xwrite(out,pkt,2); prev=ch; count=1;} } if(count){unsigned char pkt[2]={count,(unsigned char)prev}; xwrite(out,pkt,2);} } else { unsigned char pair[2]; while(read(in,pair,2)==2){ for(int i=0;i<pair[0];i++) xwrite(out,&pair[1],1);} }
close(in); close(out); return 0;}



static int app_sh(int argc,char**argv);

// --- dispatcher --- ~35 lines
struct app{const char*name; int(*fn)(int,char**);};
static struct app apps[]={
{"cat",app_cat},{"echo",app_echo},{"true",app_true},{"false",app_false},
{"ls",app_ls},{"cp",app_cp},{"mv",app_mv},{"rm",app_rm},
{"mkdir",app_mkdir},{"rmdir",app_rmdir},{"wc",app_wc},{"head",app_head},
{"grep",app_grep},{"hostname",app_hostname},{"nc",app_nc},
{"httpd",app_httpd},{"tar",app_tar},{"rle",app_rle},{"sh",app_sh},
{0,0}
};


static int run_applet(const char*name,int argc,char**argv){for(struct app*a=apps;a->name;a++) if(!strcmp(name,a->name)) return a->fn(argc,argv); return -1;}


int main(int argc,char**argv){const char*base=strrchr(argv[0],'/'); base=base?base+1:argv[0]; if(run_applet(base,argc,argv)>=0) return 0; if(argc>1 && run_applet(argv[1],argc-1,argv+1)>=0) return 0; // ./minibox <applet>
dprintf(2,"minibox: unknown applet (%s). Available:\n", base); for(struct app*a=apps;a->name;a++) dprintf(2," %s\n",a->name); return 1;}


// ============================================================================
// APPLET: sh  — microscopic shell core (drop-in for minibox)
// Register by adding this line to the applet table:  {"sh", app_sh},
// ============================================================================
static int run_applet(const char*name,int argc,char**argv); // forward decl


// ==================== tiny shell with pipes, redirs, if/while ====================

static int run_applet(const char*name,int argc,char**argv); // forward decl

// Tokenizer: whitespace split, '#' comment-to-EOL, no quotes/globs.
static int tokenize_simple(char *line, char **argv, int maxv){
  int n=0; char *p=line;
  while(*p && n<maxv){
    while(*p==' '||*p=='\t'||*p=='\n'||*p=='\r') ++p;
    if(!*p) break;
    if(*p=='#') break;
    argv[n++]=p;
    // token ends on whitespace
    while(*p && !(*p==' '||*p=='\t'||*p=='\n'||*p=='\r')) ++p;
    if(*p){ *p=0; ++p; }
  }
  return n;
}

static void sh_help_list_applets(void){
  for (int i=0; apps[i].name; ++i){
    dprintf(1,"%s%s", apps[i].name, apps[i+1].name ? " " : "\n");
  }
}

// ---- parsing for a single command stage (argv + redirections) ----
struct stage {
  char *argv[32]; // command + args (NULL-terminated later)
  char *infile;   // for '<'
  char *outfile;  // for '>' or '>>'
  int   app_mode; // 0=normal, 1=append for '>>'
};

// Build one stage from tokens [lo, hi)
static int build_stage(char **tok, int lo, int hi, struct stage *st){
  memset(st, 0, sizeof(*st));
  int ac=0;
  for(int i=lo;i<hi;i++){
    if(!strcmp(tok[i], "<")){
      if(i+1>=hi) { dprintf(2,"sh: syntax: < requires file\n"); return -2; }
      st->infile = tok[++i];
      continue;
    }
    if(!strcmp(tok[i], ">") || !strcmp(tok[i], ">>")){
      if(i+1>=hi) { dprintf(2,"sh: syntax: > requires file\n"); return -2; }
      st->outfile = tok[++i];
      st->app_mode = (tok[i-1][1]=='>'); // ">>"
      continue;
    }
    if(ac<(int)(sizeof(st->argv)/sizeof(st->argv[0]))-1) st->argv[ac++] = tok[i];
  }
  st->argv[ac]=0;
  if(ac==0) return -1; // empty stage
  return ac;
}

// Try builtins in parent (no pipes) — returns: -1 if not a builtin, else exit code
static int run_builtin_parent(char **argv){
  if(!argv[0]) return 0;
  if(!strcmp(argv[0],"exit")) return (argv[1]?atoi(argv[1]):0);
  if(!strcmp(argv[0],"cd")){
    if(argv[1]){ if(chdir(argv[1])!=0) dprintf(2,"cd: %s\n", strerror(errno)); }
    return 0;
  }
  if(!strcmp(argv[0],"help")){ sh_help_list_applets(); return 0; }
  return -1;
}

// Execute a single stage in child: applies redirections and runs applet/builtin
static void exec_stage_child(struct stage *st){
  // redirections
  if(st->infile){
    int fd = open(st->infile, O_RDONLY);
    if(fd<0){ dprintf(2,"sh: cannot open %s: %s\n", st->infile, strerror(errno)); _exit(127); }
    dup2(fd, 0); close(fd);
  }
  if(st->outfile){
    int flags = O_WRONLY|O_CREAT|(st->app_mode?O_APPEND:O_TRUNC);
    int fd = open(st->outfile, flags, 0644);
    if(fd<0){ dprintf(2,"sh: cannot open %s: %s\n", st->outfile, strerror(errno)); _exit(127); }
    dup2(fd, 1); close(fd);
  }
  // builtins allowed in child (for pipelines)
  if(!strcmp(st->argv[0],"help")){ sh_help_list_applets(); _exit(0); }
  if(!strcmp(st->argv[0],"cd")){ // in child, cd is meaningless for parent state—just attempt.
    int rc = (st->argv[1]? (chdir(st->argv[1])?errno:0) : 0);
    _exit(rc);
  }
  if(!strcmp(st->argv[0],"exit")){
    _exit(st->argv[1]?atoi(st->argv[1]):0);
  }
  // dispatch to applet
  int rc = run_applet(st->argv[0], 0 /*we don't rely on argc here*/, st->argv);
  if(rc<0){ dprintf(2,"sh: unknown: %s\n", st->argv[0]); _exit(127); }
  _exit(rc);
}

// Execute pipeline separated by '|' in tok[0..ntok). Return exit code of last stage.
static int run_pipeline(char **tok, int ntok){
  // Split indices by '|'
  int cuts[16]; int nc=0; int last=0;
  for(int i=0;i<ntok;i++){
    if(!strcmp(tok[i],"|")){
      cuts[nc++] = i;
    }
  }
  // Single stage? try parent builtins, redir-only path
  if(nc==0){
    struct stage st; int ac=build_stage(tok,0,ntok,&st);
    if(ac<0) return (ac==-1)?0:127;
    int b = run_builtin_parent(st.argv);
    if(b>=0 && !st.infile && !st.outfile){
      // builtin handled in parent, no redirs needed
      return b;
    }
    // fork child to handle redirs and run
    pid_t pid = fork();
    if(pid==0){ exec_stage_child(&st); }
    int status=0; waitpid(pid,&status,0);
    if(WIFEXITED(status)) return WEXITSTATUS(status);
    return 128;
  }

  // Build stages as ranges
  int ranges[18]; int rn=0;
  ranges[rn++]=0;
  for(int i=0;i<nc;i++){ ranges[rn++]=cuts[i]; ranges[rn++]=cuts[i]+1; }
  ranges[rn++]=ntok;
  // Normalize: pairs [ranges[0],ranges[2]) etc
  int nst = (rn-1)/2;

  int pipes[16][2];
  for(int i=0;i<nst-1;i++) if(pipe(pipes[i])<0){ dprintf(2,"sh: pipe failed\n"); return 127; }

  pid_t pids[16];
  for(int s=0;s<nst;s++){
    struct stage st; int lo=ranges[s*2], hi=ranges[s*2+2? s*2+2 : s*2+1];
    // fix indexing: pairs are (0,2), (2,4), ... so hi index: ranges[s*2+2]
    hi = ranges[s*2+2];
    int ac=build_stage(tok,lo,hi,&st);
    if(ac<0) { dprintf(2,"sh: empty stage\n"); return 127; }
    pid_t pid = fork();
    if(pid==0){
      // connect pipes
      if(s>0){ dup2(pipes[s-1][0], 0); }
      if(s<nst-1){ dup2(pipes[s][1], 1); }
      // close all pipe fds in child
      for(int i=0;i<nst-1;i++){ close(pipes[i][0]); close(pipes[i][1]); }
      exec_stage_child(&st);
    }
    pids[s]=pid;
  }
  // parent closes pipes
  for(int i=0;i<nst-1;i++){ close(pipes[i][0]); close(pipes[i][1]); }
  // wait all, track last
  int status=0;
  for(int s=0;s<nst;s++){
    int stv=0; waitpid(pids[s], &stv, 0);
    if(s==nst-1) status = stv;
  }
  if(WIFEXITED(status)) return WEXITSTATUS(status);
  return 128;
}

// Re-parse a sub-sequence of tokens back into a single-line (by joining with spaces)
static void join_tokens(char **tok, int lo, int hi, char *out, int outsz){
  int pos=0;
  for(int i=lo;i<hi;i++){
    int n = (int)strlen(tok[i]);
    if(pos+n+1 >= outsz) break;
    memcpy(out+pos, tok[i], n); pos+=n;
    if(i+1<hi) out[pos++]=' ';
  }
  out[pos]=0;
}

// Execute a single command line (may contain pipes/redirs). Returns exit code.
static int exec_line_tokens(char **tok, int ntok){
  if(ntok<=0) return 0;
  return run_pipeline(tok, ntok);
}

// Control constructs: single-line "if <cond>; then <body>; fi"
// and "while <cond>; do <body>; done"
static int try_control_line(char **tok, int ntok, int *handled_rc){
  // find keywords
  if(ntok>=3 && !strcmp(tok[0],"if")){
    int then_i=-1, fi_i=-1;
    for(int i=1;i<ntok;i++){ if(!strcmp(tok[i],"then")){ then_i=i; break; } }
    for(int i=then_i+1;i<ntok;i++){ if(!strcmp(tok[i],"fi")){ fi_i=i; break; } }
    if(then_i>0 && fi_i>then_i+1){
      int rc = exec_line_tokens(tok+1, then_i-1);
      if(rc==0){
        rc = exec_line_tokens(tok+then_i+1, fi_i-then_i-1);
      }
      *handled_rc = rc; return 1;
    } else { dprintf(2,"sh: syntax: if <cmd>; then <cmd>; fi\n"); *handled_rc=2; return 1; }
  }
  if(ntok>=3 && !strcmp(tok[0],"while")){
    int do_i=-1, done_i=-1;
    for(int i=1;i<ntok;i++){ if(!strcmp(tok[i],"do")){ do_i=i; break; } }
    for(int i=do_i+1;i<ntok;i++){ if(!strcmp(tok[i],"done")){ done_i=i; break; } }
    if(do_i>0 && done_i>do_i+1){
      int rc=0;
      for(;;){
        rc = exec_line_tokens(tok+1, do_i-1);
        if(rc!=0) break;
        rc = exec_line_tokens(tok+do_i+1, done_i-do_i-1);
      }
      *handled_rc = rc; return 1;
    } else { dprintf(2,"sh: syntax: while <cmd>; do <cmd>; done\n"); *handled_rc=2; return 1; }
  }
  return 0;
}

// Main shell applet
static int app_sh(int argc,char**argv){
  int interactive = isatty(0);
  char buf[512];
  char *v[128];

  // one-shot: sh -c "command ..."
  if (argc >= 3 && strcmp(argv[1], "-c")==0){
    strncpy(buf, argv[2], sizeof(buf)-1); buf[sizeof(buf)-1]=0;
    int n = tokenize_simple(buf, v, (int)(sizeof(v)/sizeof(v[0])));
    if(n<=0) return 0;
    int rc=0, handled=0;
    if(try_control_line(v, n, &rc)) return rc;
    return exec_line_tokens(v, n);
  }

  if(interactive) dprintf(1, "minibox$ ");
  while (fgets(buf, sizeof(buf), stdin)){
    int n = tokenize_simple(buf, v, (int)(sizeof(v)/sizeof(v[0])));
    if(n<=0){ if(interactive) dprintf(1,"minibox$ "); continue; }

    // Builtins without redirs/pipes are allowed to short-circuit
    if(!strcmp(v[0],"exit")) return (n>1)?atoi(v[1]):0;
    if(!strcmp(v[0],"cd")){
      if(n>1){ if(chdir(v[1])!=0) dprintf(2,"cd: %s\n", strerror(errno)); }
      if(interactive) dprintf(1,"minibox$ ");
      continue;
    }
    if(!strcmp(v[0],"help")){ sh_help_list_applets(); if(interactive) dprintf(1,"minibox$ "); continue; }

    int rc=0, handled=0;
    if(try_control_line(v, n, &rc)){
      // control structure handled
      (void)rc;
    } else {
      rc = exec_line_tokens(v, n);
    }
    (void)rc; // we ignore status at prompt; could expose as $?
    if(interactive) dprintf(1,"minibox$ ");
  }
  return 0;
}


