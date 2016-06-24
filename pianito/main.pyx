from .sdl cimport SDL, Chunk, Window, Renderer
from .SDL2_mixer cimport Mix_HaltChannel
from .SDL2 cimport (
    SDLK_DOWN,
    SDLK_ESCAPE,
    SDLK_UP,
    SDLK_a,
    SDLK_d,
    SDLK_f,
    SDLK_q,
    SDLK_s,
    SDL_Delay,
    SDL_Event,
    SDL_KEYDOWN,
    SDL_PollEvent,
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


def run():
    cdef SDL_Event event
    cdef Window window
    cdef Renderer renderer
    window = Window.create(
        "Pianito :O",
        SDL_WINDOWPOS_UNDEFINED,
        SDL_WINDOWPOS_UNDEFINED,
        800,
        600,
        SDL_WINDOW_SHOWN)
    renderer = Renderer.create(window.ptr, SDL_RENDERER_ACCELERATED)
    renderer.clear()
    renderer.present()
    print "Hello world! This is pianito."
    print NOTES
    chunks = [Chunk.load("notes/{}.ogg".format(n)) for n in NOTES]
    if not all(chunks):
        print "FAILUREEEE"
        return

    current = 0

    quit = False
    while not quit:
        while SDL_PollEvent(&event):
            chord = None
            if event.type == SDL_QUIT:
                quit = True
            elif event.type == SDL_KEYDOWN:
                key = event.key.keysym.sym
                if key == SDLK_q or key == SDLK_ESCAPE:
                    quit = True
                elif key == SDLK_a:
                    chord = make_chord(MAJOR, current)
                elif key == SDLK_s:
                    chord = make_chord(MAJOR, current + 7)
                elif key == SDLK_d:
                    chord = make_chord(MINOR, current + 9)
                elif key == SDLK_f:
                    chord = make_chord(MAJOR, current + 5)
                elif key == SDLK_UP:
                    current += 1
                elif key == SDLK_DOWN:
                    current -= 1
            if chord is not None:
                Mix_HaltChannel(-1)
                [chunks[n].play() for n in chord]
        SDL_Delay(10)
