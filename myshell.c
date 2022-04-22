#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <malloc.h>
#include <wait.h>
#include <stdlib.h>

typedef struct {
    int id;
    char* command;
}History;

int len(char *str) {
    int c = 0;
    for(; str[c] != '\0'; c++);
    return c;
}

char* strmrg(char* str1, char* str2) {
    int len1 = len(str1), len2 = len(str2);
    char* str = (char*) malloc(len1 + len2 +1);
    int i = 0;
    for (; i < len1; ++i) {
        str[i] = *str1 ++;
    }
    for (; i < len2 + len1; ++i) {
        str[i] = *str2 ++;
    }
    str[i] = '\0';
    return str;
}

void parseCommands(char* exe, char *commands[100]) {
    char* token = strtok(exe, " ");
    int i = 0;
    for(; token !=NULL; i++){
        commands[i] = (char*) malloc(len(token) + 1);
        strcpy(commands[i], token);
        token = strtok(NULL, " ");
    }
    commands[i] = NULL;
}

void updatePath(int argc, char **argv) {
    char* pathvar;
    char* npath;
    int i = 1;
    for (; i < argc; ++i) {
        pathvar = getenv("PATH");
        npath = strmrg(strmrg(argv[i], ":"), pathvar);
        setenv("PATH",npath, 1);
        free(npath);
    }
}

void printHistory(History history[100], int n) {
    int i = 0;
    for (; i < n; ++i) {
        printf("%d %s\n", history[i].id, history[i].command);
    }
}

void freeHistory(History history[100], int n){
    int i = 0;
    for (; i < n; ++i) {
        free(history[i].command);
    }
}

void freeCommands(char *commands[100]){
    int i = 0;
    for(; commands[i] !=NULL; i++){
        free(commands[i]);
        commands[i] = NULL;
    }
}

int main(int argc, char **argv) {
    char pwd[100];
    getcwd(pwd, 100);
    updatePath(argc, argv);
    History history[100];
    char exe[100];
    char *commands[100];
    int stat, pid, check, j = 0;
    for (; j < 100; ++j) {
        printf("$ ");
        fflush(stdout);
        scanf(" %[^\n]s",exe);
        char* commandCpy = (char *) malloc(len(exe) + 1);
        strcpy(commandCpy, exe);
        parseCommands(exe, commands);
        pid = getpid();
        if(strcmp(commands[0], "exit") == 0) {
            return 0;
        } else if(strcmp(commands[0], "cd") == 0) {
            if(chdir(commands[1]) == -1) {
                perror("chdir failed");
            }
        } else if(strcmp(commands[0], "history") == 0) {
            printHistory(history, j);
        } else {
            if((pid = fork()) == 0) {
                check = execvp(commands[0], commands);
                if(check == -1){
                    perror("execvp failed");
                    exit(0);
                }
            }
            if(pid == -1) {
                perror("fork failed");
            } else if(wait(&stat) == -1){
                perror("wait failed");
            }
        }
        history[j].id = pid;
        history[j].command = commandCpy;
        freeCommands(commands);
    }
    chdir(pwd);
    freeHistory(history, j);
}
