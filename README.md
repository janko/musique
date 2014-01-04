# Musique

Musique is a gem for manipulating with musical constructs, such as notes,
chords and intervals.

Installation
------------

```sh
$ gem install musique
```

Usage
-----

### `Music::Note`

```rb
require "musique"

include Music

note = Note.new("C#1")
note.letter     #=> "C"
note.accidental #=> "#"
note.octave     #=> 1

# Comparison
Note.new("C1")  <  Note.new("E1")  #=> true
Note.new("C#1") == Note.new("D♭1") #=> true

# Transposing
major_third = Interval.new(3, :major)
Note.new("C1").transpose_up(major_third).name   #=> "E1"
Note.new("E1").transpose_down(major_third).name #=> "C1"

# Difference
Note.new("C2") - Note.new("C1") #=> #<Music::Interval @number=8, @quality=:perfect>
```

### `Music::Chord`

```rb
require "musique"

include Music

chord = Chord.new("C#7")
chord.root.name #=> "C#"
chord.kind      #=> "7"

# Notes
Chord.new("C").notes.map(&:name)   #=> ["C", "E", "G"]
Chord.new("Cm7").notes.map(&:name) #=> ["C", "E♭", "G", "B♭"]

# Transposing
major_third = Interval.new(3, :major)
Chord.new("C").transpose_up(major_third).notes.map(&:name) #=> ["E", "G#", "B"]
```

Into `Chord.new(...)` you should be able to pass in any chord name. For example,
`"Cm"` and `"Cmin"` both represent the "C minor" chord, and both can be passed in.

If you come across a chord name that doesn't work, please open an issue,
I would like to know about it.

### `Music::Interval`

```rb
require "musique"

include Music

interval = Interval.new(3, :minor)
interval.number  #=> 3
interval.quality #=> :minor

# Comparison
Interval.new(3, :minor) >  Interval.new(2, :major)     #=> true
Interval.new(3, :minor) == Interval.new(2, :augmented) #=> true

# Kinds
Interval.new(6, :major).consonance?           #=> true
Interval.new(6, :major).perfect_consonance?   #=> false (perfect consonances are 1, 4, and 5)
Interval.new(6, :major).imperfect_consonance? #=> true
Interval.new(6, :major).dissonance?           #=> false

# Size
Interval.new(3, :major).size #=> 4 (semitones)
```

Social
------

You can follow me on Twitter, I'm [@m_janko](http://twitter.com/m_janko).

License
-------

This project is released under the [MIT license](/LICENSE).
