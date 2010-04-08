/* Auto generated:
   $ echo '#include <sys/syscall.h>' | \
     bfin-uclinux-gcc -E -dD -P - | \
     sed -r -n '/#define __NR_/{\
         s:^.* __NR_(.*) (.*):#ifdef TARGET_SYS_\1\n# define TARGET_LINUX_\1 \2\n  [TARGET_LINUX_\1] = TARGET_\1,\n#endif:;\
         p;}'
 */
const unsigned scno_linux_to_sim_map[] = {
#ifdef TARGET_SYS_restart_syscall
# define TARGET_LINUX_restart_syscall 0
  [TARGET_LINUX_restart_syscall] = TARGET_SYS_restart_syscall,
#endif
#ifdef TARGET_SYS_exit
# define TARGET_LINUX_exit 1
  [TARGET_LINUX_exit] = TARGET_SYS_exit,
#endif
#ifdef TARGET_SYS_fork
# define TARGET_LINUX_fork 2
  [TARGET_LINUX_fork] = TARGET_SYS_fork,
#endif
#ifdef TARGET_SYS_read
# define TARGET_LINUX_read 3
  [TARGET_LINUX_read] = TARGET_SYS_read,
#endif
#ifdef TARGET_SYS_write
# define TARGET_LINUX_write 4
  [TARGET_LINUX_write] = TARGET_SYS_write,
#endif
#ifdef TARGET_SYS_open
# define TARGET_LINUX_open 5
  [TARGET_LINUX_open] = TARGET_SYS_open,
#endif
#ifdef TARGET_SYS_close
# define TARGET_LINUX_close 6
  [TARGET_LINUX_close] = TARGET_SYS_close,
#endif
#ifdef TARGET_SYS_creat
# define TARGET_LINUX_creat 8
  [TARGET_LINUX_creat] = TARGET_SYS_creat,
#endif
#ifdef TARGET_SYS_link
# define TARGET_LINUX_link 9
  [TARGET_LINUX_link] = TARGET_SYS_link,
#endif
#ifdef TARGET_SYS_unlink
# define TARGET_LINUX_unlink 10
  [TARGET_LINUX_unlink] = TARGET_SYS_unlink,
#endif
#ifdef TARGET_SYS_execve
# define TARGET_LINUX_execve 11
  [TARGET_LINUX_execve] = TARGET_SYS_execve,
#endif
#ifdef TARGET_SYS_chdir
# define TARGET_LINUX_chdir 12
  [TARGET_LINUX_chdir] = TARGET_SYS_chdir,
#endif
#ifdef TARGET_SYS_time
# define TARGET_LINUX_time 13
  [TARGET_LINUX_time] = TARGET_SYS_time,
#endif
#ifdef TARGET_SYS_mknod
# define TARGET_LINUX_mknod 14
  [TARGET_LINUX_mknod] = TARGET_SYS_mknod,
#endif
#ifdef TARGET_SYS_chmod
# define TARGET_LINUX_chmod 15
  [TARGET_LINUX_chmod] = TARGET_SYS_chmod,
#endif
#ifdef TARGET_SYS_chown
# define TARGET_LINUX_chown 16
  [TARGET_LINUX_chown] = TARGET_SYS_chown,
#endif
#ifdef TARGET_SYS_lseek
# define TARGET_LINUX_lseek 19
  [TARGET_LINUX_lseek] = TARGET_SYS_lseek,
#endif
#ifdef TARGET_SYS_getpid
# define TARGET_LINUX_getpid 20
  [TARGET_LINUX_getpid] = TARGET_SYS_getpid,
#endif
#ifdef TARGET_SYS_mount
# define TARGET_LINUX_mount 21
  [TARGET_LINUX_mount] = TARGET_SYS_mount,
#endif
#ifdef TARGET_SYS_setuid
# define TARGET_LINUX_setuid 23
  [TARGET_LINUX_setuid] = TARGET_SYS_setuid,
#endif
#ifdef TARGET_SYS_getuid
# define TARGET_LINUX_getuid 24
  [TARGET_LINUX_getuid] = TARGET_SYS_getuid,
#endif
#ifdef TARGET_SYS_stime
# define TARGET_LINUX_stime 25
  [TARGET_LINUX_stime] = TARGET_SYS_stime,
#endif
#ifdef TARGET_SYS_ptrace
# define TARGET_LINUX_ptrace 26
  [TARGET_LINUX_ptrace] = TARGET_SYS_ptrace,
#endif
#ifdef TARGET_SYS_alarm
# define TARGET_LINUX_alarm 27
  [TARGET_LINUX_alarm] = TARGET_SYS_alarm,
#endif
#ifdef TARGET_SYS_pause
# define TARGET_LINUX_pause 29
  [TARGET_LINUX_pause] = TARGET_SYS_pause,
#endif
#ifdef TARGET_SYS_access
# define TARGET_LINUX_access 33
  [TARGET_LINUX_access] = TARGET_SYS_access,
#endif
#ifdef TARGET_SYS_nice
# define TARGET_LINUX_nice 34
  [TARGET_LINUX_nice] = TARGET_SYS_nice,
#endif
#ifdef TARGET_SYS_sync
# define TARGET_LINUX_sync 36
  [TARGET_LINUX_sync] = TARGET_SYS_sync,
#endif
#ifdef TARGET_SYS_kill
# define TARGET_LINUX_kill 37
  [TARGET_LINUX_kill] = TARGET_SYS_kill,
#endif
#ifdef TARGET_SYS_rename
# define TARGET_LINUX_rename 38
  [TARGET_LINUX_rename] = TARGET_SYS_rename,
#endif
#ifdef TARGET_SYS_mkdir
# define TARGET_LINUX_mkdir 39
  [TARGET_LINUX_mkdir] = TARGET_SYS_mkdir,
#endif
#ifdef TARGET_SYS_rmdir
# define TARGET_LINUX_rmdir 40
  [TARGET_LINUX_rmdir] = TARGET_SYS_rmdir,
#endif
#ifdef TARGET_SYS_dup
# define TARGET_LINUX_dup 41
  [TARGET_LINUX_dup] = TARGET_SYS_dup,
#endif
#ifdef TARGET_SYS_pipe
# define TARGET_LINUX_pipe 42
  [TARGET_LINUX_pipe] = TARGET_SYS_pipe,
#endif
#ifdef TARGET_SYS_times
# define TARGET_LINUX_times 43
  [TARGET_LINUX_times] = TARGET_SYS_times,
#endif
#ifdef TARGET_SYS_brk
# define TARGET_LINUX_brk 45
  [TARGET_LINUX_brk] = TARGET_SYS_brk,
#endif
#ifdef TARGET_SYS_setgid
# define TARGET_LINUX_setgid 46
  [TARGET_LINUX_setgid] = TARGET_SYS_setgid,
#endif
#ifdef TARGET_SYS_getgid
# define TARGET_LINUX_getgid 47
  [TARGET_LINUX_getgid] = TARGET_SYS_getgid,
#endif
#ifdef TARGET_SYS_geteuid
# define TARGET_LINUX_geteuid 49
  [TARGET_LINUX_geteuid] = TARGET_SYS_geteuid,
#endif
#ifdef TARGET_SYS_getegid
# define TARGET_LINUX_getegid 50
  [TARGET_LINUX_getegid] = TARGET_SYS_getegid,
#endif
#ifdef TARGET_SYS_acct
# define TARGET_LINUX_acct 51
  [TARGET_LINUX_acct] = TARGET_SYS_acct,
#endif
#ifdef TARGET_SYS_umount2
# define TARGET_LINUX_umount2 52
  [TARGET_LINUX_umount2] = TARGET_SYS_umount2,
#endif
#ifdef TARGET_SYS_ioctl
# define TARGET_LINUX_ioctl 54
  [TARGET_LINUX_ioctl] = TARGET_SYS_ioctl,
#endif
#ifdef TARGET_SYS_fcntl
# define TARGET_LINUX_fcntl 55
  [TARGET_LINUX_fcntl] = TARGET_SYS_fcntl,
#endif
#ifdef TARGET_SYS_setpgid
# define TARGET_LINUX_setpgid 57
  [TARGET_LINUX_setpgid] = TARGET_SYS_setpgid,
#endif
#ifdef TARGET_SYS_umask
# define TARGET_LINUX_umask 60
  [TARGET_LINUX_umask] = TARGET_SYS_umask,
#endif
#ifdef TARGET_SYS_chroot
# define TARGET_LINUX_chroot 61
  [TARGET_LINUX_chroot] = TARGET_SYS_chroot,
#endif
#ifdef TARGET_SYS_ustat
# define TARGET_LINUX_ustat 62
  [TARGET_LINUX_ustat] = TARGET_SYS_ustat,
#endif
#ifdef TARGET_SYS_dup2
# define TARGET_LINUX_dup2 63
  [TARGET_LINUX_dup2] = TARGET_SYS_dup2,
#endif
#ifdef TARGET_SYS_getppid
# define TARGET_LINUX_getppid 64
  [TARGET_LINUX_getppid] = TARGET_SYS_getppid,
#endif
#ifdef TARGET_SYS_getpgrp
# define TARGET_LINUX_getpgrp 65
  [TARGET_LINUX_getpgrp] = TARGET_SYS_getpgrp,
#endif
#ifdef TARGET_SYS_setsid
# define TARGET_LINUX_setsid 66
  [TARGET_LINUX_setsid] = TARGET_SYS_setsid,
#endif
#ifdef TARGET_SYS_sgetmask
# define TARGET_LINUX_sgetmask 68
  [TARGET_LINUX_sgetmask] = TARGET_SYS_sgetmask,
#endif
#ifdef TARGET_SYS_ssetmask
# define TARGET_LINUX_ssetmask 69
  [TARGET_LINUX_ssetmask] = TARGET_SYS_ssetmask,
#endif
#ifdef TARGET_SYS_setreuid
# define TARGET_LINUX_setreuid 70
  [TARGET_LINUX_setreuid] = TARGET_SYS_setreuid,
#endif
#ifdef TARGET_SYS_setregid
# define TARGET_LINUX_setregid 71
  [TARGET_LINUX_setregid] = TARGET_SYS_setregid,
#endif
#ifdef TARGET_SYS_sethostname
# define TARGET_LINUX_sethostname 74
  [TARGET_LINUX_sethostname] = TARGET_SYS_sethostname,
#endif
#ifdef TARGET_SYS_setrlimit
# define TARGET_LINUX_setrlimit 75
  [TARGET_LINUX_setrlimit] = TARGET_SYS_setrlimit,
#endif
#ifdef TARGET_SYS_getrusage
# define TARGET_LINUX_getrusage 77
  [TARGET_LINUX_getrusage] = TARGET_SYS_getrusage,
#endif
#ifdef TARGET_SYS_gettimeofday
# define TARGET_LINUX_gettimeofday 78
  [TARGET_LINUX_gettimeofday] = TARGET_SYS_gettimeofday,
#endif
#ifdef TARGET_SYS_settimeofday
# define TARGET_LINUX_settimeofday 79
  [TARGET_LINUX_settimeofday] = TARGET_SYS_settimeofday,
#endif
#ifdef TARGET_SYS_getgroups
# define TARGET_LINUX_getgroups 80
  [TARGET_LINUX_getgroups] = TARGET_SYS_getgroups,
#endif
#ifdef TARGET_SYS_setgroups
# define TARGET_LINUX_setgroups 81
  [TARGET_LINUX_setgroups] = TARGET_SYS_setgroups,
#endif
#ifdef TARGET_SYS_symlink
# define TARGET_LINUX_symlink 83
  [TARGET_LINUX_symlink] = TARGET_SYS_symlink,
#endif
#ifdef TARGET_SYS_readlink
# define TARGET_LINUX_readlink 85
  [TARGET_LINUX_readlink] = TARGET_SYS_readlink,
#endif
#ifdef TARGET_SYS_reboot
# define TARGET_LINUX_reboot 88
  [TARGET_LINUX_reboot] = TARGET_SYS_reboot,
#endif
#ifdef TARGET_SYS_munmap
# define TARGET_LINUX_munmap 91
  [TARGET_LINUX_munmap] = TARGET_SYS_munmap,
#endif
#ifdef TARGET_SYS_truncate
# define TARGET_LINUX_truncate 92
  [TARGET_LINUX_truncate] = TARGET_SYS_truncate,
#endif
#ifdef TARGET_SYS_ftruncate
# define TARGET_LINUX_ftruncate 93
  [TARGET_LINUX_ftruncate] = TARGET_SYS_ftruncate,
#endif
#ifdef TARGET_SYS_fchmod
# define TARGET_LINUX_fchmod 94
  [TARGET_LINUX_fchmod] = TARGET_SYS_fchmod,
#endif
#ifdef TARGET_SYS_fchown
# define TARGET_LINUX_fchown 95
  [TARGET_LINUX_fchown] = TARGET_SYS_fchown,
#endif
#ifdef TARGET_SYS_getpriority
# define TARGET_LINUX_getpriority 96
  [TARGET_LINUX_getpriority] = TARGET_SYS_getpriority,
#endif
#ifdef TARGET_SYS_setpriority
# define TARGET_LINUX_setpriority 97
  [TARGET_LINUX_setpriority] = TARGET_SYS_setpriority,
#endif
#ifdef TARGET_SYS_statfs
# define TARGET_LINUX_statfs 99
  [TARGET_LINUX_statfs] = TARGET_SYS_statfs,
#endif
#ifdef TARGET_SYS_fstatfs
# define TARGET_LINUX_fstatfs 100
  [TARGET_LINUX_fstatfs] = TARGET_SYS_fstatfs,
#endif
#ifdef TARGET_SYS_syslog
# define TARGET_LINUX_syslog 103
  [TARGET_LINUX_syslog] = TARGET_SYS_syslog,
#endif
#ifdef TARGET_SYS_setitimer
# define TARGET_LINUX_setitimer 104
  [TARGET_LINUX_setitimer] = TARGET_SYS_setitimer,
#endif
#ifdef TARGET_SYS_getitimer
# define TARGET_LINUX_getitimer 105
  [TARGET_LINUX_getitimer] = TARGET_SYS_getitimer,
#endif
#ifdef TARGET_SYS_stat
# define TARGET_LINUX_stat 106
  [TARGET_LINUX_stat] = TARGET_SYS_stat,
#endif
#ifdef TARGET_SYS_lstat
# define TARGET_LINUX_lstat 107
  [TARGET_LINUX_lstat] = TARGET_SYS_lstat,
#endif
#ifdef TARGET_SYS_fstat
# define TARGET_LINUX_fstat 108
  [TARGET_LINUX_fstat] = TARGET_SYS_fstat,
#endif
#ifdef TARGET_SYS_vhangup
# define TARGET_LINUX_vhangup 111
  [TARGET_LINUX_vhangup] = TARGET_SYS_vhangup,
#endif
#ifdef TARGET_SYS_wait4
# define TARGET_LINUX_wait4 114
  [TARGET_LINUX_wait4] = TARGET_SYS_wait4,
#endif
#ifdef TARGET_SYS_sysinfo
# define TARGET_LINUX_sysinfo 116
  [TARGET_LINUX_sysinfo] = TARGET_SYS_sysinfo,
#endif
#ifdef TARGET_SYS_fsync
# define TARGET_LINUX_fsync 118
  [TARGET_LINUX_fsync] = TARGET_SYS_fsync,
#endif
#ifdef TARGET_SYS_clone
# define TARGET_LINUX_clone 120
  [TARGET_LINUX_clone] = TARGET_SYS_clone,
#endif
#ifdef TARGET_SYS_setdomainname
# define TARGET_LINUX_setdomainname 121
  [TARGET_LINUX_setdomainname] = TARGET_SYS_setdomainname,
#endif
#ifdef TARGET_SYS_uname
# define TARGET_LINUX_uname 122
  [TARGET_LINUX_uname] = TARGET_SYS_uname,
#endif
#ifdef TARGET_SYS_adjtimex
# define TARGET_LINUX_adjtimex 124
  [TARGET_LINUX_adjtimex] = TARGET_SYS_adjtimex,
#endif
#ifdef TARGET_SYS_mprotect
# define TARGET_LINUX_mprotect 125
  [TARGET_LINUX_mprotect] = TARGET_SYS_mprotect,
#endif
#ifdef TARGET_SYS_init_module
# define TARGET_LINUX_init_module 128
  [TARGET_LINUX_init_module] = TARGET_SYS_init_module,
#endif
#ifdef TARGET_SYS_delete_module
# define TARGET_LINUX_delete_module 129
  [TARGET_LINUX_delete_module] = TARGET_SYS_delete_module,
#endif
#ifdef TARGET_SYS_quotactl
# define TARGET_LINUX_quotactl 131
  [TARGET_LINUX_quotactl] = TARGET_SYS_quotactl,
#endif
#ifdef TARGET_SYS_getpgid
# define TARGET_LINUX_getpgid 132
  [TARGET_LINUX_getpgid] = TARGET_SYS_getpgid,
#endif
#ifdef TARGET_SYS_fchdir
# define TARGET_LINUX_fchdir 133
  [TARGET_LINUX_fchdir] = TARGET_SYS_fchdir,
#endif
#ifdef TARGET_SYS_bdflush
# define TARGET_LINUX_bdflush 134
  [TARGET_LINUX_bdflush] = TARGET_SYS_bdflush,
#endif
#ifdef TARGET_SYS_personality
# define TARGET_LINUX_personality 136
  [TARGET_LINUX_personality] = TARGET_SYS_personality,
#endif
#ifdef TARGET_SYS_setfsuid
# define TARGET_LINUX_setfsuid 138
  [TARGET_LINUX_setfsuid] = TARGET_SYS_setfsuid,
#endif
#ifdef TARGET_SYS_setfsgid
# define TARGET_LINUX_setfsgid 139
  [TARGET_LINUX_setfsgid] = TARGET_SYS_setfsgid,
#endif
#ifdef TARGET_SYS__llseek
# define TARGET_LINUX__llseek 140
  [TARGET_LINUX__llseek] = TARGET_SYS__llseek,
#endif
#ifdef TARGET_SYS_getdents
# define TARGET_LINUX_getdents 141
  [TARGET_LINUX_getdents] = TARGET_SYS_getdents,
#endif
#ifdef TARGET_SYS_flock
# define TARGET_LINUX_flock 143
  [TARGET_LINUX_flock] = TARGET_SYS_flock,
#endif
#ifdef TARGET_SYS_readv
# define TARGET_LINUX_readv 145
  [TARGET_LINUX_readv] = TARGET_SYS_readv,
#endif
#ifdef TARGET_SYS_writev
# define TARGET_LINUX_writev 146
  [TARGET_LINUX_writev] = TARGET_SYS_writev,
#endif
#ifdef TARGET_SYS_getsid
# define TARGET_LINUX_getsid 147
  [TARGET_LINUX_getsid] = TARGET_SYS_getsid,
#endif
#ifdef TARGET_SYS_fdatasync
# define TARGET_LINUX_fdatasync 148
  [TARGET_LINUX_fdatasync] = TARGET_SYS_fdatasync,
#endif
#ifdef TARGET_SYS__sysctl
# define TARGET_LINUX__sysctl 149
  [TARGET_LINUX__sysctl] = TARGET_SYS__sysctl,
#endif
#ifdef TARGET_SYS_sched_setparam
# define TARGET_LINUX_sched_setparam 154
  [TARGET_LINUX_sched_setparam] = TARGET_SYS_sched_setparam,
#endif
#ifdef TARGET_SYS_sched_getparam
# define TARGET_LINUX_sched_getparam 155
  [TARGET_LINUX_sched_getparam] = TARGET_SYS_sched_getparam,
#endif
#ifdef TARGET_SYS_sched_setscheduler
# define TARGET_LINUX_sched_setscheduler 156
  [TARGET_LINUX_sched_setscheduler] = TARGET_SYS_sched_setscheduler,
#endif
#ifdef TARGET_SYS_sched_getscheduler
# define TARGET_LINUX_sched_getscheduler 157
  [TARGET_LINUX_sched_getscheduler] = TARGET_SYS_sched_getscheduler,
#endif
#ifdef TARGET_SYS_sched_yield
# define TARGET_LINUX_sched_yield 158
  [TARGET_LINUX_sched_yield] = TARGET_SYS_sched_yield,
#endif
#ifdef TARGET_SYS_sched_get_priority_max
# define TARGET_LINUX_sched_get_priority_max 159
  [TARGET_LINUX_sched_get_priority_max] = TARGET_SYS_sched_get_priority_max,
#endif
#ifdef TARGET_SYS_sched_get_priority_min
# define TARGET_LINUX_sched_get_priority_min 160
  [TARGET_LINUX_sched_get_priority_min] = TARGET_SYS_sched_get_priority_min,
#endif
#ifdef TARGET_SYS_sched_rr_get_interval
# define TARGET_LINUX_sched_rr_get_interval 161
  [TARGET_LINUX_sched_rr_get_interval] = TARGET_SYS_sched_rr_get_interval,
#endif
#ifdef TARGET_SYS_nanosleep
# define TARGET_LINUX_nanosleep 162
  [TARGET_LINUX_nanosleep] = TARGET_SYS_nanosleep,
#endif
#ifdef TARGET_SYS_mremap
# define TARGET_LINUX_mremap 163
  [TARGET_LINUX_mremap] = TARGET_SYS_mremap,
#endif
#ifdef TARGET_SYS_setresuid
# define TARGET_LINUX_setresuid 164
  [TARGET_LINUX_setresuid] = TARGET_SYS_setresuid,
#endif
#ifdef TARGET_SYS_getresuid
# define TARGET_LINUX_getresuid 165
  [TARGET_LINUX_getresuid] = TARGET_SYS_getresuid,
#endif
#ifdef TARGET_SYS_nfsservctl
# define TARGET_LINUX_nfsservctl 169
  [TARGET_LINUX_nfsservctl] = TARGET_SYS_nfsservctl,
#endif
#ifdef TARGET_SYS_setresgid
# define TARGET_LINUX_setresgid 170
  [TARGET_LINUX_setresgid] = TARGET_SYS_setresgid,
#endif
#ifdef TARGET_SYS_getresgid
# define TARGET_LINUX_getresgid 171
  [TARGET_LINUX_getresgid] = TARGET_SYS_getresgid,
#endif
#ifdef TARGET_SYS_prctl
# define TARGET_LINUX_prctl 172
  [TARGET_LINUX_prctl] = TARGET_SYS_prctl,
#endif
#ifdef TARGET_SYS_rt_sigreturn
# define TARGET_LINUX_rt_sigreturn 173
  [TARGET_LINUX_rt_sigreturn] = TARGET_SYS_rt_sigreturn,
#endif
#ifdef TARGET_SYS_rt_sigaction
# define TARGET_LINUX_rt_sigaction 174
  [TARGET_LINUX_rt_sigaction] = TARGET_SYS_rt_sigaction,
#endif
#ifdef TARGET_SYS_rt_sigprocmask
# define TARGET_LINUX_rt_sigprocmask 175
  [TARGET_LINUX_rt_sigprocmask] = TARGET_SYS_rt_sigprocmask,
#endif
#ifdef TARGET_SYS_rt_sigpending
# define TARGET_LINUX_rt_sigpending 176
  [TARGET_LINUX_rt_sigpending] = TARGET_SYS_rt_sigpending,
#endif
#ifdef TARGET_SYS_rt_sigtimedwait
# define TARGET_LINUX_rt_sigtimedwait 177
  [TARGET_LINUX_rt_sigtimedwait] = TARGET_SYS_rt_sigtimedwait,
#endif
#ifdef TARGET_SYS_rt_sigqueueinfo
# define TARGET_LINUX_rt_sigqueueinfo 178
  [TARGET_LINUX_rt_sigqueueinfo] = TARGET_SYS_rt_sigqueueinfo,
#endif
#ifdef TARGET_SYS_rt_sigsuspend
# define TARGET_LINUX_rt_sigsuspend 179
  [TARGET_LINUX_rt_sigsuspend] = TARGET_SYS_rt_sigsuspend,
#endif
#ifdef TARGET_SYS_pread
# define TARGET_LINUX_pread 180
  [TARGET_LINUX_pread] = TARGET_SYS_pread,
#endif
#ifdef TARGET_SYS_pwrite
# define TARGET_LINUX_pwrite 181
  [TARGET_LINUX_pwrite] = TARGET_SYS_pwrite,
#endif
#ifdef TARGET_SYS_lchown
# define TARGET_LINUX_lchown 182
  [TARGET_LINUX_lchown] = TARGET_SYS_lchown,
#endif
#ifdef TARGET_SYS_getcwd
# define TARGET_LINUX_getcwd 183
  [TARGET_LINUX_getcwd] = TARGET_SYS_getcwd,
#endif
#ifdef TARGET_SYS_capget
# define TARGET_LINUX_capget 184
  [TARGET_LINUX_capget] = TARGET_SYS_capget,
#endif
#ifdef TARGET_SYS_capset
# define TARGET_LINUX_capset 185
  [TARGET_LINUX_capset] = TARGET_SYS_capset,
#endif
#ifdef TARGET_SYS_sigaltstack
# define TARGET_LINUX_sigaltstack 186
  [TARGET_LINUX_sigaltstack] = TARGET_SYS_sigaltstack,
#endif
#ifdef TARGET_SYS_sendfile
# define TARGET_LINUX_sendfile 187
  [TARGET_LINUX_sendfile] = TARGET_SYS_sendfile,
#endif
#ifdef TARGET_SYS_vfork
# define TARGET_LINUX_vfork 190
  [TARGET_LINUX_vfork] = TARGET_SYS_vfork,
#endif
#ifdef TARGET_SYS_getrlimit
# define TARGET_LINUX_getrlimit 191
  [TARGET_LINUX_getrlimit] = TARGET_SYS_getrlimit,
#endif
#ifdef TARGET_SYS_mmap2
# define TARGET_LINUX_mmap2 192
  [TARGET_LINUX_mmap2] = TARGET_SYS_mmap2,
#endif
#ifdef TARGET_SYS_truncate64
# define TARGET_LINUX_truncate64 193
  [TARGET_LINUX_truncate64] = TARGET_SYS_truncate64,
#endif
#ifdef TARGET_SYS_ftruncate64
# define TARGET_LINUX_ftruncate64 194
  [TARGET_LINUX_ftruncate64] = TARGET_SYS_ftruncate64,
#endif
#ifdef TARGET_SYS_stat64
# define TARGET_LINUX_stat64 195
  [TARGET_LINUX_stat64] = TARGET_SYS_stat64,
#endif
#ifdef TARGET_SYS_lstat64
# define TARGET_LINUX_lstat64 196
  [TARGET_LINUX_lstat64] = TARGET_SYS_lstat64,
#endif
#ifdef TARGET_SYS_fstat64
# define TARGET_LINUX_fstat64 197
  [TARGET_LINUX_fstat64] = TARGET_SYS_fstat64,
#endif
#ifdef TARGET_SYS_chown32
# define TARGET_LINUX_chown32 198
  [TARGET_LINUX_chown32] = TARGET_SYS_chown32,
#endif
#ifdef TARGET_SYS_getuid32
# define TARGET_LINUX_getuid32 199
  [TARGET_LINUX_getuid32] = TARGET_SYS_getuid32,
#endif
#ifdef TARGET_SYS_getgid32
# define TARGET_LINUX_getgid32 200
  [TARGET_LINUX_getgid32] = TARGET_SYS_getgid32,
#endif
#ifdef TARGET_SYS_geteuid32
# define TARGET_LINUX_geteuid32 201
  [TARGET_LINUX_geteuid32] = TARGET_SYS_geteuid32,
#endif
#ifdef TARGET_SYS_getegid32
# define TARGET_LINUX_getegid32 202
  [TARGET_LINUX_getegid32] = TARGET_SYS_getegid32,
#endif
#ifdef TARGET_SYS_setreuid32
# define TARGET_LINUX_setreuid32 203
  [TARGET_LINUX_setreuid32] = TARGET_SYS_setreuid32,
#endif
#ifdef TARGET_SYS_setregid32
# define TARGET_LINUX_setregid32 204
  [TARGET_LINUX_setregid32] = TARGET_SYS_setregid32,
#endif
#ifdef TARGET_SYS_getgroups32
# define TARGET_LINUX_getgroups32 205
  [TARGET_LINUX_getgroups32] = TARGET_SYS_getgroups32,
#endif
#ifdef TARGET_SYS_setgroups32
# define TARGET_LINUX_setgroups32 206
  [TARGET_LINUX_setgroups32] = TARGET_SYS_setgroups32,
#endif
#ifdef TARGET_SYS_fchown32
# define TARGET_LINUX_fchown32 207
  [TARGET_LINUX_fchown32] = TARGET_SYS_fchown32,
#endif
#ifdef TARGET_SYS_setresuid32
# define TARGET_LINUX_setresuid32 208
  [TARGET_LINUX_setresuid32] = TARGET_SYS_setresuid32,
#endif
#ifdef TARGET_SYS_getresuid32
# define TARGET_LINUX_getresuid32 209
  [TARGET_LINUX_getresuid32] = TARGET_SYS_getresuid32,
#endif
#ifdef TARGET_SYS_setresgid32
# define TARGET_LINUX_setresgid32 210
  [TARGET_LINUX_setresgid32] = TARGET_SYS_setresgid32,
#endif
#ifdef TARGET_SYS_getresgid32
# define TARGET_LINUX_getresgid32 211
  [TARGET_LINUX_getresgid32] = TARGET_SYS_getresgid32,
#endif
#ifdef TARGET_SYS_lchown32
# define TARGET_LINUX_lchown32 212
  [TARGET_LINUX_lchown32] = TARGET_SYS_lchown32,
#endif
#ifdef TARGET_SYS_setuid32
# define TARGET_LINUX_setuid32 213
  [TARGET_LINUX_setuid32] = TARGET_SYS_setuid32,
#endif
#ifdef TARGET_SYS_setgid32
# define TARGET_LINUX_setgid32 214
  [TARGET_LINUX_setgid32] = TARGET_SYS_setgid32,
#endif
#ifdef TARGET_SYS_setfsuid32
# define TARGET_LINUX_setfsuid32 215
  [TARGET_LINUX_setfsuid32] = TARGET_SYS_setfsuid32,
#endif
#ifdef TARGET_SYS_setfsgid32
# define TARGET_LINUX_setfsgid32 216
  [TARGET_LINUX_setfsgid32] = TARGET_SYS_setfsgid32,
#endif
#ifdef TARGET_SYS_pivot_root
# define TARGET_LINUX_pivot_root 217
  [TARGET_LINUX_pivot_root] = TARGET_SYS_pivot_root,
#endif
#ifdef TARGET_SYS_getdents64
# define TARGET_LINUX_getdents64 220
  [TARGET_LINUX_getdents64] = TARGET_SYS_getdents64,
#endif
#ifdef TARGET_SYS_fcntl64
# define TARGET_LINUX_fcntl64 221
  [TARGET_LINUX_fcntl64] = TARGET_SYS_fcntl64,
#endif
#ifdef TARGET_SYS_gettid
# define TARGET_LINUX_gettid 224
  [TARGET_LINUX_gettid] = TARGET_SYS_gettid,
#endif
#ifdef TARGET_SYS_readahead
# define TARGET_LINUX_readahead 225
  [TARGET_LINUX_readahead] = TARGET_SYS_readahead,
#endif
#ifdef TARGET_SYS_setxattr
# define TARGET_LINUX_setxattr 226
  [TARGET_LINUX_setxattr] = TARGET_SYS_setxattr,
#endif
#ifdef TARGET_SYS_lsetxattr
# define TARGET_LINUX_lsetxattr 227
  [TARGET_LINUX_lsetxattr] = TARGET_SYS_lsetxattr,
#endif
#ifdef TARGET_SYS_fsetxattr
# define TARGET_LINUX_fsetxattr 228
  [TARGET_LINUX_fsetxattr] = TARGET_SYS_fsetxattr,
#endif
#ifdef TARGET_SYS_getxattr
# define TARGET_LINUX_getxattr 229
  [TARGET_LINUX_getxattr] = TARGET_SYS_getxattr,
#endif
#ifdef TARGET_SYS_lgetxattr
# define TARGET_LINUX_lgetxattr 230
  [TARGET_LINUX_lgetxattr] = TARGET_SYS_lgetxattr,
#endif
#ifdef TARGET_SYS_fgetxattr
# define TARGET_LINUX_fgetxattr 231
  [TARGET_LINUX_fgetxattr] = TARGET_SYS_fgetxattr,
#endif
#ifdef TARGET_SYS_listxattr
# define TARGET_LINUX_listxattr 232
  [TARGET_LINUX_listxattr] = TARGET_SYS_listxattr,
#endif
#ifdef TARGET_SYS_llistxattr
# define TARGET_LINUX_llistxattr 233
  [TARGET_LINUX_llistxattr] = TARGET_SYS_llistxattr,
#endif
#ifdef TARGET_SYS_flistxattr
# define TARGET_LINUX_flistxattr 234
  [TARGET_LINUX_flistxattr] = TARGET_SYS_flistxattr,
#endif
#ifdef TARGET_SYS_removexattr
# define TARGET_LINUX_removexattr 235
  [TARGET_LINUX_removexattr] = TARGET_SYS_removexattr,
#endif
#ifdef TARGET_SYS_lremovexattr
# define TARGET_LINUX_lremovexattr 236
  [TARGET_LINUX_lremovexattr] = TARGET_SYS_lremovexattr,
#endif
#ifdef TARGET_SYS_fremovexattr
# define TARGET_LINUX_fremovexattr 237
  [TARGET_LINUX_fremovexattr] = TARGET_SYS_fremovexattr,
#endif
#ifdef TARGET_SYS_tkill
# define TARGET_LINUX_tkill 238
  [TARGET_LINUX_tkill] = TARGET_SYS_tkill,
#endif
#ifdef TARGET_SYS_sendfile64
# define TARGET_LINUX_sendfile64 239
  [TARGET_LINUX_sendfile64] = TARGET_SYS_sendfile64,
#endif
#ifdef TARGET_SYS_futex
# define TARGET_LINUX_futex 240
  [TARGET_LINUX_futex] = TARGET_SYS_futex,
#endif
#ifdef TARGET_SYS_sched_setaffinity
# define TARGET_LINUX_sched_setaffinity 241
  [TARGET_LINUX_sched_setaffinity] = TARGET_SYS_sched_setaffinity,
#endif
#ifdef TARGET_SYS_sched_getaffinity
# define TARGET_LINUX_sched_getaffinity 242
  [TARGET_LINUX_sched_getaffinity] = TARGET_SYS_sched_getaffinity,
#endif
#ifdef TARGET_SYS_io_setup
# define TARGET_LINUX_io_setup 245
  [TARGET_LINUX_io_setup] = TARGET_SYS_io_setup,
#endif
#ifdef TARGET_SYS_io_destroy
# define TARGET_LINUX_io_destroy 246
  [TARGET_LINUX_io_destroy] = TARGET_SYS_io_destroy,
#endif
#ifdef TARGET_SYS_io_getevents
# define TARGET_LINUX_io_getevents 247
  [TARGET_LINUX_io_getevents] = TARGET_SYS_io_getevents,
#endif
#ifdef TARGET_SYS_io_submit
# define TARGET_LINUX_io_submit 248
  [TARGET_LINUX_io_submit] = TARGET_SYS_io_submit,
#endif
#ifdef TARGET_SYS_io_cancel
# define TARGET_LINUX_io_cancel 249
  [TARGET_LINUX_io_cancel] = TARGET_SYS_io_cancel,
#endif
#ifdef TARGET_SYS_exit_group
# define TARGET_LINUX_exit_group 252
  [TARGET_LINUX_exit_group] = TARGET_SYS_exit_group,
#endif
#ifdef TARGET_SYS_lookup_dcookie
# define TARGET_LINUX_lookup_dcookie 253
  [TARGET_LINUX_lookup_dcookie] = TARGET_SYS_lookup_dcookie,
#endif
#ifdef TARGET_SYS_bfin_spinlock
# define TARGET_LINUX_bfin_spinlock 254
  [TARGET_LINUX_bfin_spinlock] = TARGET_SYS_bfin_spinlock,
#endif
#ifdef TARGET_SYS_epoll_create
# define TARGET_LINUX_epoll_create 255
  [TARGET_LINUX_epoll_create] = TARGET_SYS_epoll_create,
#endif
#ifdef TARGET_SYS_epoll_ctl
# define TARGET_LINUX_epoll_ctl 256
  [TARGET_LINUX_epoll_ctl] = TARGET_SYS_epoll_ctl,
#endif
#ifdef TARGET_SYS_epoll_wait
# define TARGET_LINUX_epoll_wait 257
  [TARGET_LINUX_epoll_wait] = TARGET_SYS_epoll_wait,
#endif
#ifdef TARGET_SYS_set_tid_address
# define TARGET_LINUX_set_tid_address 259
  [TARGET_LINUX_set_tid_address] = TARGET_SYS_set_tid_address,
#endif
#ifdef TARGET_SYS_timer_create
# define TARGET_LINUX_timer_create 260
  [TARGET_LINUX_timer_create] = TARGET_SYS_timer_create,
#endif
#ifdef TARGET_SYS_timer_settime
# define TARGET_LINUX_timer_settime 261
  [TARGET_LINUX_timer_settime] = TARGET_SYS_timer_settime,
#endif
#ifdef TARGET_SYS_timer_gettime
# define TARGET_LINUX_timer_gettime 262
  [TARGET_LINUX_timer_gettime] = TARGET_SYS_timer_gettime,
#endif
#ifdef TARGET_SYS_timer_getoverrun
# define TARGET_LINUX_timer_getoverrun 263
  [TARGET_LINUX_timer_getoverrun] = TARGET_SYS_timer_getoverrun,
#endif
#ifdef TARGET_SYS_timer_delete
# define TARGET_LINUX_timer_delete 264
  [TARGET_LINUX_timer_delete] = TARGET_SYS_timer_delete,
#endif
#ifdef TARGET_SYS_clock_settime
# define TARGET_LINUX_clock_settime 265
  [TARGET_LINUX_clock_settime] = TARGET_SYS_clock_settime,
#endif
#ifdef TARGET_SYS_clock_gettime
# define TARGET_LINUX_clock_gettime 266
  [TARGET_LINUX_clock_gettime] = TARGET_SYS_clock_gettime,
#endif
#ifdef TARGET_SYS_clock_getres
# define TARGET_LINUX_clock_getres 267
  [TARGET_LINUX_clock_getres] = TARGET_SYS_clock_getres,
#endif
#ifdef TARGET_SYS_clock_nanosleep
# define TARGET_LINUX_clock_nanosleep 268
  [TARGET_LINUX_clock_nanosleep] = TARGET_SYS_clock_nanosleep,
#endif
#ifdef TARGET_SYS_statfs64
# define TARGET_LINUX_statfs64 269
  [TARGET_LINUX_statfs64] = TARGET_SYS_statfs64,
#endif
#ifdef TARGET_SYS_fstatfs64
# define TARGET_LINUX_fstatfs64 270
  [TARGET_LINUX_fstatfs64] = TARGET_SYS_fstatfs64,
#endif
#ifdef TARGET_SYS_tgkill
# define TARGET_LINUX_tgkill 271
  [TARGET_LINUX_tgkill] = TARGET_SYS_tgkill,
#endif
#ifdef TARGET_SYS_utimes
# define TARGET_LINUX_utimes 272
  [TARGET_LINUX_utimes] = TARGET_SYS_utimes,
#endif
#ifdef TARGET_SYS_fadvise64_64
# define TARGET_LINUX_fadvise64_64 273
  [TARGET_LINUX_fadvise64_64] = TARGET_SYS_fadvise64_64,
#endif
#ifdef TARGET_SYS_mq_open
# define TARGET_LINUX_mq_open 278
  [TARGET_LINUX_mq_open] = TARGET_SYS_mq_open,
#endif
#ifdef TARGET_SYS_mq_unlink
# define TARGET_LINUX_mq_unlink 279
  [TARGET_LINUX_mq_unlink] = TARGET_SYS_mq_unlink,
#endif
#ifdef TARGET_SYS_mq_timedsend
# define TARGET_LINUX_mq_timedsend 280
  [TARGET_LINUX_mq_timedsend] = TARGET_SYS_mq_timedsend,
#endif
#ifdef TARGET_SYS_mq_timedreceive
# define TARGET_LINUX_mq_timedreceive 281
  [TARGET_LINUX_mq_timedreceive] = TARGET_SYS_mq_timedreceive,
#endif
#ifdef TARGET_SYS_mq_notify
# define TARGET_LINUX_mq_notify 282
  [TARGET_LINUX_mq_notify] = TARGET_SYS_mq_notify,
#endif
#ifdef TARGET_SYS_mq_getsetattr
# define TARGET_LINUX_mq_getsetattr 283
  [TARGET_LINUX_mq_getsetattr] = TARGET_SYS_mq_getsetattr,
#endif
#ifdef TARGET_SYS_kexec_load
# define TARGET_LINUX_kexec_load 284
  [TARGET_LINUX_kexec_load] = TARGET_SYS_kexec_load,
#endif
#ifdef TARGET_SYS_waitid
# define TARGET_LINUX_waitid 285
  [TARGET_LINUX_waitid] = TARGET_SYS_waitid,
#endif
#ifdef TARGET_SYS_add_key
# define TARGET_LINUX_add_key 286
  [TARGET_LINUX_add_key] = TARGET_SYS_add_key,
#endif
#ifdef TARGET_SYS_request_key
# define TARGET_LINUX_request_key 287
  [TARGET_LINUX_request_key] = TARGET_SYS_request_key,
#endif
#ifdef TARGET_SYS_keyctl
# define TARGET_LINUX_keyctl 288
  [TARGET_LINUX_keyctl] = TARGET_SYS_keyctl,
#endif
#ifdef TARGET_SYS_ioprio_set
# define TARGET_LINUX_ioprio_set 289
  [TARGET_LINUX_ioprio_set] = TARGET_SYS_ioprio_set,
#endif
#ifdef TARGET_SYS_ioprio_get
# define TARGET_LINUX_ioprio_get 290
  [TARGET_LINUX_ioprio_get] = TARGET_SYS_ioprio_get,
#endif
#ifdef TARGET_SYS_inotify_init
# define TARGET_LINUX_inotify_init 291
  [TARGET_LINUX_inotify_init] = TARGET_SYS_inotify_init,
#endif
#ifdef TARGET_SYS_inotify_add_watch
# define TARGET_LINUX_inotify_add_watch 292
  [TARGET_LINUX_inotify_add_watch] = TARGET_SYS_inotify_add_watch,
#endif
#ifdef TARGET_SYS_inotify_rm_watch
# define TARGET_LINUX_inotify_rm_watch 293
  [TARGET_LINUX_inotify_rm_watch] = TARGET_SYS_inotify_rm_watch,
#endif
#ifdef TARGET_SYS_openat
# define TARGET_LINUX_openat 295
  [TARGET_LINUX_openat] = TARGET_SYS_openat,
#endif
#ifdef TARGET_SYS_mkdirat
# define TARGET_LINUX_mkdirat 296
  [TARGET_LINUX_mkdirat] = TARGET_SYS_mkdirat,
#endif
#ifdef TARGET_SYS_mknodat
# define TARGET_LINUX_mknodat 297
  [TARGET_LINUX_mknodat] = TARGET_SYS_mknodat,
#endif
#ifdef TARGET_SYS_fchownat
# define TARGET_LINUX_fchownat 298
  [TARGET_LINUX_fchownat] = TARGET_SYS_fchownat,
#endif
#ifdef TARGET_SYS_futimesat
# define TARGET_LINUX_futimesat 299
  [TARGET_LINUX_futimesat] = TARGET_SYS_futimesat,
#endif
#ifdef TARGET_SYS_fstatat64
# define TARGET_LINUX_fstatat64 300
  [TARGET_LINUX_fstatat64] = TARGET_SYS_fstatat64,
#endif
#ifdef TARGET_SYS_unlinkat
# define TARGET_LINUX_unlinkat 301
  [TARGET_LINUX_unlinkat] = TARGET_SYS_unlinkat,
#endif
#ifdef TARGET_SYS_renameat
# define TARGET_LINUX_renameat 302
  [TARGET_LINUX_renameat] = TARGET_SYS_renameat,
#endif
#ifdef TARGET_SYS_linkat
# define TARGET_LINUX_linkat 303
  [TARGET_LINUX_linkat] = TARGET_SYS_linkat,
#endif
#ifdef TARGET_SYS_symlinkat
# define TARGET_LINUX_symlinkat 304
  [TARGET_LINUX_symlinkat] = TARGET_SYS_symlinkat,
#endif
#ifdef TARGET_SYS_readlinkat
# define TARGET_LINUX_readlinkat 305
  [TARGET_LINUX_readlinkat] = TARGET_SYS_readlinkat,
#endif
#ifdef TARGET_SYS_fchmodat
# define TARGET_LINUX_fchmodat 306
  [TARGET_LINUX_fchmodat] = TARGET_SYS_fchmodat,
#endif
#ifdef TARGET_SYS_faccessat
# define TARGET_LINUX_faccessat 307
  [TARGET_LINUX_faccessat] = TARGET_SYS_faccessat,
#endif
#ifdef TARGET_SYS_pselect6
# define TARGET_LINUX_pselect6 308
  [TARGET_LINUX_pselect6] = TARGET_SYS_pselect6,
#endif
#ifdef TARGET_SYS_ppoll
# define TARGET_LINUX_ppoll 309
  [TARGET_LINUX_ppoll] = TARGET_SYS_ppoll,
#endif
#ifdef TARGET_SYS_unshare
# define TARGET_LINUX_unshare 310
  [TARGET_LINUX_unshare] = TARGET_SYS_unshare,
#endif
#ifdef TARGET_SYS_sram_alloc
# define TARGET_LINUX_sram_alloc 311
  [TARGET_LINUX_sram_alloc] = TARGET_SYS_sram_alloc,
#endif
#ifdef TARGET_SYS_sram_free
# define TARGET_LINUX_sram_free 312
  [TARGET_LINUX_sram_free] = TARGET_SYS_sram_free,
#endif
#ifdef TARGET_SYS_dma_memcpy
# define TARGET_LINUX_dma_memcpy 313
  [TARGET_LINUX_dma_memcpy] = TARGET_SYS_dma_memcpy,
#endif
#ifdef TARGET_SYS_accept
# define TARGET_LINUX_accept 314
  [TARGET_LINUX_accept] = TARGET_SYS_accept,
#endif
#ifdef TARGET_SYS_bind
# define TARGET_LINUX_bind 315
  [TARGET_LINUX_bind] = TARGET_SYS_bind,
#endif
#ifdef TARGET_SYS_connect
# define TARGET_LINUX_connect 316
  [TARGET_LINUX_connect] = TARGET_SYS_connect,
#endif
#ifdef TARGET_SYS_getpeername
# define TARGET_LINUX_getpeername 317
  [TARGET_LINUX_getpeername] = TARGET_SYS_getpeername,
#endif
#ifdef TARGET_SYS_getsockname
# define TARGET_LINUX_getsockname 318
  [TARGET_LINUX_getsockname] = TARGET_SYS_getsockname,
#endif
#ifdef TARGET_SYS_getsockopt
# define TARGET_LINUX_getsockopt 319
  [TARGET_LINUX_getsockopt] = TARGET_SYS_getsockopt,
#endif
#ifdef TARGET_SYS_listen
# define TARGET_LINUX_listen 320
  [TARGET_LINUX_listen] = TARGET_SYS_listen,
#endif
#ifdef TARGET_SYS_recv
# define TARGET_LINUX_recv 321
  [TARGET_LINUX_recv] = TARGET_SYS_recv,
#endif
#ifdef TARGET_SYS_recvfrom
# define TARGET_LINUX_recvfrom 322
  [TARGET_LINUX_recvfrom] = TARGET_SYS_recvfrom,
#endif
#ifdef TARGET_SYS_recvmsg
# define TARGET_LINUX_recvmsg 323
  [TARGET_LINUX_recvmsg] = TARGET_SYS_recvmsg,
#endif
#ifdef TARGET_SYS_send
# define TARGET_LINUX_send 324
  [TARGET_LINUX_send] = TARGET_SYS_send,
#endif
#ifdef TARGET_SYS_sendmsg
# define TARGET_LINUX_sendmsg 325
  [TARGET_LINUX_sendmsg] = TARGET_SYS_sendmsg,
#endif
#ifdef TARGET_SYS_sendto
# define TARGET_LINUX_sendto 326
  [TARGET_LINUX_sendto] = TARGET_SYS_sendto,
#endif
#ifdef TARGET_SYS_setsockopt
# define TARGET_LINUX_setsockopt 327
  [TARGET_LINUX_setsockopt] = TARGET_SYS_setsockopt,
#endif
#ifdef TARGET_SYS_shutdown
# define TARGET_LINUX_shutdown 328
  [TARGET_LINUX_shutdown] = TARGET_SYS_shutdown,
#endif
#ifdef TARGET_SYS_socket
# define TARGET_LINUX_socket 329
  [TARGET_LINUX_socket] = TARGET_SYS_socket,
#endif
#ifdef TARGET_SYS_socketpair
# define TARGET_LINUX_socketpair 330
  [TARGET_LINUX_socketpair] = TARGET_SYS_socketpair,
#endif
#ifdef TARGET_SYS_semctl
# define TARGET_LINUX_semctl 331
  [TARGET_LINUX_semctl] = TARGET_SYS_semctl,
#endif
#ifdef TARGET_SYS_semget
# define TARGET_LINUX_semget 332
  [TARGET_LINUX_semget] = TARGET_SYS_semget,
#endif
#ifdef TARGET_SYS_semop
# define TARGET_LINUX_semop 333
  [TARGET_LINUX_semop] = TARGET_SYS_semop,
#endif
#ifdef TARGET_SYS_msgctl
# define TARGET_LINUX_msgctl 334
  [TARGET_LINUX_msgctl] = TARGET_SYS_msgctl,
#endif
#ifdef TARGET_SYS_msgget
# define TARGET_LINUX_msgget 335
  [TARGET_LINUX_msgget] = TARGET_SYS_msgget,
#endif
#ifdef TARGET_SYS_msgrcv
# define TARGET_LINUX_msgrcv 336
  [TARGET_LINUX_msgrcv] = TARGET_SYS_msgrcv,
#endif
#ifdef TARGET_SYS_msgsnd
# define TARGET_LINUX_msgsnd 337
  [TARGET_LINUX_msgsnd] = TARGET_SYS_msgsnd,
#endif
#ifdef TARGET_SYS_shmat
# define TARGET_LINUX_shmat 338
  [TARGET_LINUX_shmat] = TARGET_SYS_shmat,
#endif
#ifdef TARGET_SYS_shmctl
# define TARGET_LINUX_shmctl 339
  [TARGET_LINUX_shmctl] = TARGET_SYS_shmctl,
#endif
#ifdef TARGET_SYS_shmdt
# define TARGET_LINUX_shmdt 340
  [TARGET_LINUX_shmdt] = TARGET_SYS_shmdt,
#endif
#ifdef TARGET_SYS_shmget
# define TARGET_LINUX_shmget 341
  [TARGET_LINUX_shmget] = TARGET_SYS_shmget,
#endif
#ifdef TARGET_SYS_splice
# define TARGET_LINUX_splice 342
  [TARGET_LINUX_splice] = TARGET_SYS_splice,
#endif
#ifdef TARGET_SYS_sync_file_range
# define TARGET_LINUX_sync_file_range 343
  [TARGET_LINUX_sync_file_range] = TARGET_SYS_sync_file_range,
#endif
#ifdef TARGET_SYS_tee
# define TARGET_LINUX_tee 344
  [TARGET_LINUX_tee] = TARGET_SYS_tee,
#endif
#ifdef TARGET_SYS_vmsplice
# define TARGET_LINUX_vmsplice 345
  [TARGET_LINUX_vmsplice] = TARGET_SYS_vmsplice,
#endif
#ifdef TARGET_SYS_epoll_pwait
# define TARGET_LINUX_epoll_pwait 346
  [TARGET_LINUX_epoll_pwait] = TARGET_SYS_epoll_pwait,
#endif
#ifdef TARGET_SYS_utimensat
# define TARGET_LINUX_utimensat 347
  [TARGET_LINUX_utimensat] = TARGET_SYS_utimensat,
#endif
#ifdef TARGET_SYS_signalfd
# define TARGET_LINUX_signalfd 348
  [TARGET_LINUX_signalfd] = TARGET_SYS_signalfd,
#endif
#ifdef TARGET_SYS_timerfd_create
# define TARGET_LINUX_timerfd_create 349
  [TARGET_LINUX_timerfd_create] = TARGET_SYS_timerfd_create,
#endif
#ifdef TARGET_SYS_eventfd
# define TARGET_LINUX_eventfd 350
  [TARGET_LINUX_eventfd] = TARGET_SYS_eventfd,
#endif
#ifdef TARGET_SYS_pread64
# define TARGET_LINUX_pread64 351
  [TARGET_LINUX_pread64] = TARGET_SYS_pread64,
#endif
#ifdef TARGET_SYS_pwrite64
# define TARGET_LINUX_pwrite64 352
  [TARGET_LINUX_pwrite64] = TARGET_SYS_pwrite64,
#endif
#ifdef TARGET_SYS_fadvise64
# define TARGET_LINUX_fadvise64 353
  [TARGET_LINUX_fadvise64] = TARGET_SYS_fadvise64,
#endif
#ifdef TARGET_SYS_set_robust_list
# define TARGET_LINUX_set_robust_list 354
  [TARGET_LINUX_set_robust_list] = TARGET_SYS_set_robust_list,
#endif
#ifdef TARGET_SYS_get_robust_list
# define TARGET_LINUX_get_robust_list 355
  [TARGET_LINUX_get_robust_list] = TARGET_SYS_get_robust_list,
#endif
#ifdef TARGET_SYS_fallocate
# define TARGET_LINUX_fallocate 356
  [TARGET_LINUX_fallocate] = TARGET_SYS_fallocate,
#endif
#ifdef TARGET_SYS_semtimedop
# define TARGET_LINUX_semtimedop 357
  [TARGET_LINUX_semtimedop] = TARGET_SYS_semtimedop,
#endif
#ifdef TARGET_SYS_timerfd_settime
# define TARGET_LINUX_timerfd_settime 358
  [TARGET_LINUX_timerfd_settime] = TARGET_SYS_timerfd_settime,
#endif
#ifdef TARGET_SYS_timerfd_gettime
# define TARGET_LINUX_timerfd_gettime 359
  [TARGET_LINUX_timerfd_gettime] = TARGET_SYS_timerfd_gettime,
#endif
#ifdef TARGET_SYS_signalfd4
# define TARGET_LINUX_signalfd4 360
  [TARGET_LINUX_signalfd4] = TARGET_SYS_signalfd4,
#endif
#ifdef TARGET_SYS_eventfd2
# define TARGET_LINUX_eventfd2 361
  [TARGET_LINUX_eventfd2] = TARGET_SYS_eventfd2,
#endif
#ifdef TARGET_SYS_epoll_create1
# define TARGET_LINUX_epoll_create1 362
  [TARGET_LINUX_epoll_create1] = TARGET_SYS_epoll_create1,
#endif
#ifdef TARGET_SYS_dup3
# define TARGET_LINUX_dup3 363
  [TARGET_LINUX_dup3] = TARGET_SYS_dup3,
#endif
#ifdef TARGET_SYS_pipe2
# define TARGET_LINUX_pipe2 364
  [TARGET_LINUX_pipe2] = TARGET_SYS_pipe2,
#endif
#ifdef TARGET_SYS_inotify_init1
# define TARGET_LINUX_inotify_init1 365
  [TARGET_LINUX_inotify_init1] = TARGET_SYS_inotify_init1,
#endif
#ifdef TARGET_SYS_preadv
# define TARGET_LINUX_preadv 366
  [TARGET_LINUX_preadv] = TARGET_SYS_preadv,
#endif
#ifdef TARGET_SYS_pwritev
# define TARGET_LINUX_pwritev 367
  [TARGET_LINUX_pwritev] = TARGET_SYS_pwritev,
#endif
#ifdef TARGET_SYS_rt_tgsigqueueinfo
# define TARGET_LINUX_rt_tgsigqueueinfo 368
  [TARGET_LINUX_rt_tgsigqueueinfo] = TARGET_SYS_rt_tgsigqueueinfo,
#endif
#ifdef TARGET_SYS_perf_event_open
# define TARGET_LINUX_perf_event_open 369
  [TARGET_LINUX_perf_event_open] = TARGET_SYS_perf_event_open,
#endif
#ifdef TARGET_SYS_recvmmsg
# define TARGET_LINUX_recvmmsg 370
  [TARGET_LINUX_recvmmsg] = TARGET_SYS_recvmmsg,
#endif
#ifdef TARGET_SYS_syscall
# define TARGET_LINUX_syscall 371
  [TARGET_LINUX_syscall] = TARGET_SYS_syscall,
#endif
};
