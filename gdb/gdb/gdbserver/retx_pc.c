
#include <stdio.h>
#include <sys/ptrace.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>


int errno;
int
linux_create_inferior (char *program, char **allargs)
{
  void *new_process;
  int pid;

  pid = vfork ();
  if (pid < 0)
    fprintf (stderr, "vfork");

  if (pid == 0)
    {
      ptrace (PTRACE_TRACEME, 0, 0, 0);

      signal (__SIGRTMIN + 1, SIG_DFL);

      setpgid (0, 0);

      execv (program, allargs);

      fprintf (stderr, "Cannot exec %s: %s.\n", program,
	       strerror (errno));
      fflush (stderr);
      _exit (0177);
    }

  return pid;
}

int
main()
{
   char *program="/bin/hello";
   char *args[] = {"/bin/hello", NULL};
   int pid;
   int signal = 0;
   long val;
   int  waitval;
   long pc;

   pid = linux_create_inferior(program, args);

   getchar();

   /* now peek some data */
   val = ptrace (PTRACE_PEEKTEXT, pid, (long) 0x44, 0);
fprintf(stderr, "peek is %x\n", val);

   /* poke junk there */
   ptrace (PTRACE_POKETEXT, pid, (long) 0x44, 0x00a16fa6);
fprintf(stderr, "peek is %x\n", ptrace (PTRACE_PEEKTEXT, pid, (long) 0x44, 0));
   pc = ptrace (PTRACE_PEEKUSER, pid, (long)24, 0);
fprintf(stderr, "at first wait, pc=%x\n", (int)pc);

   /* now let us call ptrace to simulate continue */
   ptrace (PTRACE_CONT, pid, 0, signal);
   waitpid(pid, &waitval, 0);
printf("returned from sigwait with WIFSTOPPED %d WSTOPSIG %d WIFSIGNALLED %d WTERMSIG %d\n", WIFSTOPPED (waitval), WSTOPSIG (waitval), WIFSIGNALED(waitval), WTERMSIG(waitval));
    pc = ptrace (PTRACE_PEEKUSER, pid, (long)24, 0);
fprintf(stderr, "ptrace returned pc=%x\n", (int)pc);
   getchar();
   ptrace (PTRACE_POKETEXT, pid, (long) 0x44, val);
   ptrace (PTRACE_CONT, pid, 0, signal);
   waitpid(pid, &waitval, 0);
printf("returned from sigwait with WIFSTOPPED %d WSTOPSIG %d WIFSIGNALLED %d WTERMSIG %d\n", WIFSTOPPED (waitval), WSTOPSIG (waitval), WIFSIGNALED(waitval), WTERMSIG(waitval));

}
