# Musique

Musique is a gem for manipulating with musical constructs, such as notes,
chords and intervals.

* Source code: [https://github.com/janko-m/musique](https://github.com/janko-m/musique)
* API Documenation: [http://rubydoc.info/github/janko-m/musique/master/frames](http://rubydoc.info/github/janko-m/musique/master/frames)

Installation
------------

```sh
$ gem install musique
```

Usage
-----

### `Music::Note`

```rb
note = Music::Note.new("C#1")
note.letter     #=> "C"
note.accidental #=> "#"
note.octave     #=> 1

# Comparison
Music::Note.new("C1")  <  Music::Note.new("E1")  #=> true
Music::Note.new("C#1") == Music::Note.new("Db1") #=> true

# Transposing
major_third = Music::Interval.new(3, :major)
Music::Note.new("C1").transpose_up(major_third).name   #=> "E1"
Music::Note.new("E1").transpose_down(major_third).name #=> "C1"

# Difference
Music::Note.new("C2") - Music::Note.new("C1") #=> #<Music::Interval @number=8, @quality=:perfect>
```

### `Music::Chord`

```rb
chord = Music::Chord.new("C#7")
chord.root.name #=> "C#"
chord.kind      #=> "7"

# Notes
Music::Chord.new("C").notes.map(&:name)   #=> ["C", "E", "G"]
Music::Chord.new("Cm7").notes.map(&:name) #=> ["C", "Eb", "G", "Bb"]

# Transposing
major_third = Music::Interval.new(3, :major)
Music::Chord.new("C").transpose_up(major_third).notes.map(&:name) #=> ["E", "G#", "B"]
```

### `Music::Interval`

```rb
interval = Music::Interval.new(3, :minor)
interval.number  #=> 3
interval.quality #=> :minor

# Comparison
Music::Interval.new(3, :minor) >  Music::Interval.new(2, :major)     #=> true
Music::Interval.new(3, :minor) == Music::Interval.new(2, :augmented) #=> true

# Kinds
Music::Interval.new(6, :major).consonance?           #=> true
Music::Interval.new(6, :major).perfect_consonance?   #=> false (perfect consonances are 1, 4, and 5)
Music::Interval.new(6, :major).imperfect_consonance? #=> true
Music::Interval.new(6, :major).dissonance?           #=> false

# Size
Music::Interval.new(3, :major).size #=> 4 (semitones)
```

Limitations
-----------

* Currently only triads (C/Cm) and seventh chords (C7/Cm7) are supported.
  The goal is to support all chords in all notations.

* Double accidentals (𝄪 and 𝄫) are not supported yet.

* Double augmented/diminished intervals are not supported yet.

Social
------

You can follow me on Twitter, I'm [@m_janko](http://twitter.com/m_janko).

License
-------

This project is released under the [MIT license](/LICENSE).
