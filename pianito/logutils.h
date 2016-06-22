#ifndef LOGUTILS_H_
#define LOGUTILS_H_

#include <stdio.h>
#include <time.h>

#include "SDL2/SDL.h"

inline void print_ts() {
  time_t timer;
  char buffer[26];
  struct tm *tm_info;

  time(&timer);
  tm_info = localtime(&timer);

  strftime(buffer, 26, "%Y:%m:%d %H:%M:%S", tm_info);
  printf("[%s] ", buffer);
}

//  printf(" %5s - (%s:%d) ", level, __FILE__, __LINE__);
#define __log(level, M, ...)                                                   \
  print_ts();                                                                  \
  printf("%5s - ", level);                                                     \
  printf(M, ##__VA_ARGS__)

#define _log(level, M, ...)                                                    \
  __log(level, M, ##__VA_ARGS__);                                              \
  printf("\n")

#define log_err(M, ...) _log("ERROR", M, ##__VA_ARGS__)
#define log_warn(M, ...) _log("WARN", M, ##__VA_ARGS__)
#define log_info(M, ...) _log("INFO", M, ##__VA_ARGS__)

#define _log_sdl(level, M, ...)                                                \
  __log(level, M, ##__VA_ARGS__);                                              \
  printf(". Last SDL error: '%s'\n", SDL_GetError())

#define log_sdl_err(M, ...) _log_sdl("ERROR", M, ##__VA_ARGS__)
#define log_sdl_warn(M, ...) _log_sdl("WARN", M, ##__VA_ARGS__)
#define log_sdl_info(M, ...) _log_sdl("INFO", M, ##__VA_ARGS__)

#endif
