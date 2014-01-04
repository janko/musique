# encoding: utf-8

module Music

  class Note

    include Comparable

    CHROMATIC_SCALE = %w[C C/D D D/E E F F/G G G/A A A/B B]
    DIATONIC_SCALE  = %w[C D E F G A B]

    ACCIDENTALS     = %w[# ♭]

    REGEXP = /
      (?<letter>     [CDEFGAB] )
      (?<accidental> [#♭b]?    )
      (?<octave>     (-?\d+)?  )
    /x

    ##
    # C, D, E, F, G, A or B.
    #
    # @return [String]
    #
    attr_reader :letter
    ##
    # \# or ♭.
    #
    # @return [String]
    #
    attr_reader :accidental
    ##
    # An integer.
    #
    # @return [Integer]
    #
    attr_reader :octave

    ##
    # @param name [String] Consists of a letter (C, D, E, F, G, A, B),
    #   accidental (# or ♭) and octave (any integer).
    #
    # @example
    #   Note.new("C")
    #   Note.new("C#")
    #   Note.new("C♭") #=> or Note.new("Cb")
    #
    #   Note.new("C1")
    #   Note.new("B-1")
    #
    def initialize(name)
      unless match = name.match(/^#{REGEXP}$/)
        raise ArgumentError, "invalid note name: #{name} (example: C#1)"
      end

      @letter     = match[:letter]
      @accidental = match[:accidental].sub("b", "♭") unless match[:accidental].empty?
      @octave     = match[:octave].to_i              unless match[:octave].empty?
    end

    def name
      [letter, accidental, octave].join
    end
    alias to_s name

    ##
    # Compares notes by their pitch.
    #
    # @param other [Music::Note]
    # @example
    #   Note.new("C#") == Note.new("D♭") #=> true
    #   Note.new("C")  <  Note.new("D")  #=> true
    #   Note.new("C2") >  Note.new("C1") #=> true
    #
    def <=>(other)
      self.pitch <=> other.pitch
    end

    ##
    # @param interval [Music::Interval]
    # @return [Music::Note]
    # @example
    #   major_third = Interval.new(3, :major)
    #   Note.new("C").transpose_by(major_third)  == Note.new("E") #=> true
    #   Note.new("E").transpose_by(-major_third) == Note.new("C") #=> true
    #
    def transpose_by(interval)
      transposed_pitch = pitch + interval.size
      transposed_pitch %= CHROMATIC_SCALE.size if octave.nil?

      transposed_diatonic_idx = (diatonic_idx + interval.diff) % DIATONIC_SCALE.size
      transposed_letter = DIATONIC_SCALE.fetch(transposed_diatonic_idx)

      transposed_octave = octave + (diatonic_idx + interval.diff) / DIATONIC_SCALE.size if octave

      transposed_accidental = ACCIDENTALS.find do |accidental|
        note = Note.new [transposed_letter, accidental, transposed_octave].join
        note.pitch == transposed_pitch
      end

      Note.new [transposed_letter, transposed_accidental, transposed_octave].join
    end

    ##
    # @param (see #transpose_by)
    # @return (see #transpose_by)
    #
    # @see #transpose_by
    #
    def transpose_up(interval)
      transpose_by(interval)
    end

    ##
    # @param (see #transpose_by)
    # @return (see #transpose_by)
    #
    # @see #transpose_by
    #
    def transpose_down(interval)
      transpose_by(-interval)
    end

    ##
    # @param other [Music::Note]
    # @return [Music::Interval]
    # @example
    #   Note.new("E") - Note.new("C") #=> #<Music::Interval @number=3, @quality=:major>
    #
    def -(other)
      number = (self.diatonic_idx - other.diatonic_idx).abs + 1
      number += (self.octave - other.octave).abs * DIATONIC_SCALE.size unless octave.nil?

      distance = (self.pitch - other.pitch).abs
      quality = Interval::QUALITIES.find do |quality|
        begin; Interval.new(number, quality).size == distance; rescue ArgumentError; end
      end

      interval = Interval.new(number, quality)
      self >= other ? interval : -interval
    end

    protected

    ##
    # Internal integer representation on the note.
    #
    # @return [Integer]
    #
    def pitch
      result = chromatic_idx + (octave.to_i * CHROMATIC_SCALE.size)
      result %= CHROMATIC_SCALE.size if octave.nil?
      result
    end

    ##
    # @return [Integer] An integer from 0 to 6
    #
    def diatonic_idx
      DIATONIC_SCALE.index(letter)
    end

    ##
    # @return [Integer] An integer from 0 to 11
    #
    def chromatic_idx
      accidental_effect = {"#" => +1, "♭" => -1}.fetch(accidental, 0)
      CHROMATIC_SCALE.index(letter) + accidental_effect
    end

  end

end
