from .sdl cimport SDL, Chunk
from .SDL2_mixer cimport Mix_HaltChannel
import time

cpdef main():
    sdl = SDL()
    run()

SCALE = ["A", "Bb", "B", "C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab"]

NOTES = ["{}{}".format(n, o) for o in "34" for n in SCALE]

FOUR_CHORDS = [
    [0, 4, 7, 12],
    [7, 11, 14, 19],
    [9, 12, 16, 21],
    [5, 9, 12, 17],
]

def run():
    print "Hello world! This is pianito."
    print NOTES
    chunks = [Chunk.load("notes/{}.ogg".format(n)) for n in NOTES]
    if not all(chunks):
        print "FAILUREEEE"
        return
    for x in xrange(2):
        for chord in FOUR_CHORDS:
            notes = [chunks[i] for i in chord]
            [n.play() for n in notes]
            time.sleep(1.5)
            Mix_HaltChannel(-1)

