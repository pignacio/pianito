cdef extern from "logutils.h" nogil:
    void log_info(const char *template, ...)
    void log_warn(const char *template, ...)
    void log_err(const char *template, ...)
    void log_sdl_err(const char *template, ...)
    void log_sdl_warn(const char *template, ...)

