from .SDL2 cimport (
    SDL_Rect,
)
from .sdl cimport (
    Renderer,
)


cdef draw_keyboard(Renderer renderer, SDL_Rect dest, list state)
