#include <stdio.h>
void  ReadLine(FILE* fp);
int main(int argC, char* argV[])
{
     FILE* fpI = NULL;
     //FILE* fpO = NULL;

	if(argC < 2)
        {
          	fprintf(stderr, "No input file found\n");
          	return 0;
        }
      	fpI = fopen(argV[1], "r");
      	if(!fpI)
      	{
          	fprintf(stderr, "Unable to open the file %s\n", argV[1]);
          	return;
      	}
        ReadLine(fpI);	
        return 0;
}

void  ReadLine(FILE* fp)
{
    int i = 0, j = 0;
    char ch;
    char line[80];
    memset(line, '\0', 80);
    do
     {
        if(1 != fread(&ch, 1, 1, fp))
         {
              j = 1;
             break;
          }
         line[i++] = ch;
      }
      while('\n' != ch);
     if(!j)
         ReadLine(fp);
     fprintf(stdout, "%s", line);
}
