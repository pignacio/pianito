from SDL2 cimport (
    SDL_Rect,
    SDL_Color,
    Uint8,
)
from .sdl cimport (
    Renderer,
)

WHITE_KEYS = (0, 2, 3, 5, 7, 8, 10)
BLACK_KEYS = (1, None, 4, 6, None, 9, 11)

cdef SDL_Color WHITE = SDL_Color(255, 255, 255, 255)
cdef SDL_Color BLACK = SDL_Color(0, 0, 0, 255)
cdef SDL_Color RED = SDL_Color(255, 0, 0, 255)
cdef SDL_Color DARK_RED = SDL_Color(100, 0, 0, 255)


cdef draw_bordered_rect(Renderer renderer, SDL_Rect dest ,SDL_Color color, int border=1):
    assert dest.h >= 2 * border
    assert dest.w >= 2 * border
    renderer.set_draw_color(50, 50, 50, 255)
    renderer.fill_rect(&dest)
    dest.x += border
    dest.y += border
    dest.w -= 2 * border
    dest.h -= 2 * border
    renderer.set_draw_color(color.r, color.g, color.b, color.a)
    renderer.fill_rect(&dest)


cdef draw_keyboard(Renderer renderer, SDL_Rect dest, list state):
    cdef int base_width = dest.w // 24
    cdef int base_height = dest.h // 3
    cdef int white_width = (3 * base_width) // 2
    cdef int white_height = dest.h
    cdef int black_width = base_width
    cdef int black_height = 2 * base_height
    cdef SDL_Color color
    cdef SDL_Rect key = SDL_Rect(
        dest.x,
        dest.y,
        white_width,
        white_height,
    )
    cdef int pos = 0
    for octave in range(2):
        for pos in range(7):
            note = WHITE_KEYS[pos] + octave * 12
            color = RED if state[note] else WHITE
            draw_bordered_rect(renderer, key, color)
            key.x += white_width

    draw_bordered_rect(renderer, key, WHITE)

    key = SDL_Rect(
        dest.x + white_width - black_width // 2,
        dest.y,
        black_width,
        black_height,
    )
    for octave in range(2):
        for pos in range(7):
            note = BLACK_KEYS[pos]
            if note is not None:
                note += octave * 12
                color = DARK_RED if state[note] else BLACK
                draw_bordered_rect(renderer, key, color)
            key.x += white_width




