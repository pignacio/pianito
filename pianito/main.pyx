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
    SDLK_DOWN,
    SDLK_ESCAPE,
    SDLK_UP,
    SDLK_a,
    SDLK_c,
    SDLK_d,
    SDLK_f,
    SDLK_q,
    SDLK_s,
    SDLK_v,
    SDLK_x,
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


def run():
    cdef SDL_Event event
    cdef Window window
    cdef Renderer renderer
    cdef SDL_Rect dest
    cdef Texture text

    window = Window.create(
        "Pianito :O",
        SDL_WINDOWPOS_UNDEFINED,
        SDL_WINDOWPOS_UNDEFINED,
        800,
        600,
        SDL_WINDOW_SHOWN)
    renderer = Renderer.create(window.ptr, SDL_RENDERER_ACCELERATED)
    font = Font.open("Inconsolata.otf", 30)
    texts = [font.render_text_blended("Current: {}".format(n), SDL_Color(255, 255, 255, 255))
             for n in SCALE]
    texts = [renderer.texture_from_surface(t) for t in texts]
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
                elif key == SDLK_z:
                    chord = make_chord(MAJOR_7, current)
                elif key == SDLK_x:
                    chord = make_chord(MAJOR_7, current + 7)
                elif key == SDLK_c:
                    chord = make_chord(MINOR_7, current + 9)
                elif key == SDLK_v:
                    chord = make_chord(MAJOR_7, current + 5)
                elif key == SDLK_UP:
                    current += 1
                elif key == SDLK_DOWN:
                    current -= 1
            if chord is not None:
                Mix_HaltChannel(-1)
                [chunks[n].play() for n in chord]

        renderer.clear()

        text = texts[current%12]
        dest.x = dest.y = 30
        dest.w = text.width
        dest.h = text.height
        renderer.copy(text, NULL, &dest)
        renderer.present()
        SDL_Delay(10)
