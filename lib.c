#include <stdio.h>

int asm_strlen(char *str);
char *asm_strchr(char *str, char search);
int asm_strcmp(char *str1, char* str2);
char *asm_strcpy(char *dest, char * src);
char *asm_strrchr(char *str, int letter); 
void *asm_memchr(void *ptr, int chr, size_t num);
void *asm_memset(void *ptr, int value, size_t num);
void *memcpy(void *destination, void *source, size_t num );
int asm_execute(int (*fonc)(int,int,int),int var1,int va2,int var3);
char *asm_substr(char *str, size_t start, size_t end);
size_t asm_strcspn (char * str1, char * str2 );

int add(int var, int var2, int var3);

int main(){
  char *pch;
  char word[] = "Hello world";
  char key[] = "Secret";
  char input[80];
  char str1[]="Sample string";
  char str2[40];
  char str3[40];
  char str[] = "fcba73";
  char keys[] = "1234567890";
  char *substring;
  int i;
  
  
  printf("%s's length is  %d\n",word,asm_strlen(word));
  pch=asm_strchr(word,'l');
  while(pch!=NULL){
	 printf("Using asm_strchr, 'l' is at position : %d\n",pch-word+1);
	 pch=asm_strchr(pch+1,'l');
  }
  
  pch = (char*) asm_memchr(word, 'l', asm_strlen(word));
  if (pch!=NULL)
    printf ("Using asm_memchr, 'l' found at position %d.\n", pch-word+1);
  else
    printf ("'l' not found.\n");
  
  printf("Using asm_memset, %s is now : ",word);
  asm_memset(word,'-',6);
  puts (word);
  
  do{
     printf ("Type 'Secret' to quit (using asm_strcmp)\n");
     gets (input);
  } while (asm_strcmp (key,input) != 0);
  
  pch = asm_strcpy(str2,"asm_strcpy is awesome");
  asm_strcpy (str3,"Yeah, really awesome");
  printf ("str1: %s\nstr2: %s\nstr3: %s\n",pch,str2,str3);
  
  pch=asm_strrchr(key,'e');
  printf ("With asm_strrchr, the last occurence of 'e' was found at %d \n",pch-key+1);
  
  printf ("Using asm_execute, the result of add(3,4,5) is : %d\n",asm_execute(add,3,4,5));
  

  i = asm_strcspn (str,keys);
  printf ("Using asm_strcspn, the first number in %s  is at position %d.\n",str,i+1);
  
   substring = asm_substr(keys,-3,3);
  printf("The three last chars of %s are %s\n",keys, substring);
    substring = asm_substr(keys,0,3);
  printf("And the three first chars of %s are %s\n",keys, substring);
  
  asm_memcpy (str3,"copy successful",16);
  printf("%s\n", str3);
  return 0;
  
}

int add(int var,int var2,int var3){
    return var+var2+var3;
}
