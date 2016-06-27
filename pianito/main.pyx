from .logutils cimport (
    log_info,
)
from .sdl cimport (
    SDL,
    Chunk,
    Window,
    Renderer,
    Font,
    Texture,
)
from .SDL2_mixer cimport Mix_HaltChannel
from .SDL2 cimport (
    SDL_Keycode,
    SDLK_DOWN,
    SDLK_ESCAPE,
    SDLK_UP,
    SDLK_a,
    SDLK_b,
    SDLK_c,
    SDLK_d,
    SDLK_e,
    SDLK_f,
    SDLK_g,
    SDLK_h,
    SDLK_n,
    SDLK_q,
    SDLK_r,
    SDLK_s,
    SDLK_t,
    SDLK_v,
    SDLK_w,
    SDLK_x,
    SDLK_y,
    SDLK_z,
    SDL_Color,
    SDL_Delay,
    SDL_Event,
    SDL_KEYDOWN,
    SDL_PollEvent,
    SDL_Rect,
    SDL_QUIT,
    SDL_RENDERER_ACCELERATED,
    SDL_WINDOWPOS_UNDEFINED,
    SDL_WINDOWPOS_UNDEFINED,
    SDL_WINDOW_SHOWN,
)
import time

cpdef main():
    sdl = SDL()
    run()

SCALE = ["A", "Bb", "B", "C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab"]

NOTES = ["{}{}".format(n, o) for o in "34" for n in SCALE]

MINOR = [0, 3, 7, 12]
MAJOR = [0, 4, 7, 12]
MINOR_7 = [0, 3, 7, 10, 12]
MAJOR_7 = [0, 4, 7, 10, 12]


def make_chord(chord, base):
    base %= 12
    return [n + base for n in chord]


cdef make_text(text, Font font, Renderer renderer):
    surface = font.render_text_blended(text, SDL_Color(255, 255, 255, 255))
    return renderer.texture_from_surface(surface)

cdef copy_to(Renderer renderer, Texture texture, int x, int y):
    cdef SDL_Rect dest = SDL_Rect(x, y, texture.width, texture.height)
    renderer.copy(texture, NULL, &dest)


cdef class Chord:
    cdef SDL_Keycode key
    cdef list chord
    cdef int diff

    @staticmethod
    cdef create(SDL_Keycode key, list chord, int diff):
        res = Chord()
        res.key = key
        res.chord = chord
        res.diff = diff
        return res

CHORDS = [
    Chord.create(SDLK_q, MAJOR, 0),
    Chord.create(SDLK_w, MAJOR, 5),
    Chord.create(SDLK_e, MAJOR, 9),
    Chord.create(SDLK_r, MAJOR_7, 0),
    Chord.create(SDLK_t, MAJOR_7, 5),
    Chord.create(SDLK_y, MAJOR_7, 9),
    Chord.create(SDLK_a, MINOR, 9),
    Chord.create(SDLK_s, MINOR, 2),
    Chord.create(SDLK_d, MINOR, 4),
    Chord.create(SDLK_f, MINOR_7, 9),
    Chord.create(SDLK_g, MINOR_7, 2),
    Chord.create(SDLK_h, MINOR_7, 4),
    Chord.create(SDLK_z, MAJOR_7, 9),
    Chord.create(SDLK_x, MAJOR_7, 2),
    Chord.create(SDLK_c, MAJOR_7, 4),
]

def run():
    cdef SDL_Event event
    cdef Window window
    cdef Renderer renderer
    cdef Texture text
    cdef Texture current_text
    cdef Chord chord

    window = Window.create(
        "Pianito :O",
        SDL_WINDOWPOS_UNDEFINED,
        SDL_WINDOWPOS_UNDEFINED,
        800,
        600,
        SDL_WINDOW_SHOWN)
    renderer = Renderer.create(window.ptr, SDL_RENDERER_ACCELERATED)
    font = Font.open("Inconsolata.otf", 30)
    texts = [make_text(n, font, renderer) for n in SCALE]
    minor_texts = [make_text(n + "m", font, renderer) for n in SCALE]
    seventh_texts = [make_text(n + "7", font, renderer) for n in SCALE]
    minor_seventh_texts = [make_text(n + "m7", font, renderer) for n in SCALE]
    current_text = make_text("Current: ", font, renderer)

    chunks = [Chunk.load("notes/{}.ogg".format(n)) for n in NOTES]
    if not all(chunks):
        print "FAILUREEEE"
        return

    current = 0

    quit = False
    while not quit:
        chord = None
        while SDL_PollEvent(&event):
            if event.type == SDL_QUIT:
                quit = True
            elif event.type == SDL_KEYDOWN:
                key = event.key.keysym.sym
                if key == SDLK_ESCAPE:
                    quit = True
                elif key == SDLK_UP:
                    current += 1
                elif key == SDLK_DOWN:
                    current -= 1
                for chord in CHORDS:
                    if key == chord.key:
                        break
                else:
                    chord = None

            if chord is not None:
                Mix_HaltChannel(-1)
                [chunks[n].play() for n in make_chord(chord.chord, current + chord.diff)]

        renderer.clear()

        text = texts[current%12]
        copy_to(renderer, current_text, 30, 30)
        copy_to(renderer, text, 30 + current_text.width, 30)

        for pos, diff in enumerate([0, 5, 7]):
            text = texts[(current + diff) % 12]
            copy_to(renderer, text, 100 * (pos + 1), 100)
            text = seventh_texts[(current + diff) % 12]
            copy_to(renderer, text, 300 + 100 * (pos + 1), 100)

        for pos, diff in enumerate([9, 2, 4]):
            text = minor_texts[(current + diff) % 12]
            copy_to(renderer, text, 100 * (pos + 1), 150)
            text = minor_seventh_texts[(current + diff) % 12]
            copy_to(renderer, text, 300 + 100 * (pos + 1), 150)
            text = seventh_texts[(current + diff) % 12]
            copy_to(renderer, text, 100 * (pos + 1), 200)

        renderer.present()
        SDL_Delay(10)
