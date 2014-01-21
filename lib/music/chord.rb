# encoding: utf-8

module Music

  class Chord

    RULES = {
      "5"  => ["1", "major 3", "5"],
      "m5" => ["1", "minor 3", "5"],

      "7"  => ["1", "major 3", "5", "major 7"],
      "m7" => ["1", "minor 3", "5", "minor 7"],
    }

    REGEXP = /
      (?<root> [CDEFGAB][#♭b]? )
      (?<kind> m?\d*           )
    /x

    ##
    # @return [Music::Note]
    # @example
    #   Chord.new("C").root #=> #<Music::Note @letter="C">
    #
    attr_reader :root
    ##
    #
    # @return [String]
    # @example
    #   Chord.new("C7").kind #=> "7"
    #
    attr_reader :kind

    ##
    # @param name [String]
    #
    def initialize(name)
      unless match = name.match(/^#{REGEXP}$/)
        raise ArgumentError, "invalid chord format: #{name}"
      end

      @root = Note.new(match[:root])

      @kind = match[:kind]
      @kind << "5" if @kind !~ /\d+/
    end

    def name
      [root, kind].join
    end

    ##
    # Compares the names.
    #
    def ==(other)
      self.name == other.name
    end

    ##
    # @return [Array<Music::Note>]
    #
    def notes
      RULES[kind].map do |interval_name|
        quality  = interval_name[/^[a-z]+/] || "perfect"
        number   = interval_name[/\d+$/]
        interval = Interval.new(number.to_i, quality.to_sym)

        root.transpose_by(interval)
      end
    end

    ##
    # @param interval [Music::Interval]
    # @return [Music::Note]
    # @example
    #   major_third = Interval.new(3, :major)
    #   Chord.new("C7").transpose_by(major_third) == Note.new("E7") #=> true
    #   Note.new("E7").transpose_by(-major_third) == Note.new("C7") #=> true
    #
    def transpose_by(interval)
      Chord.new(root.transpose_by(interval).name + kind)
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

  end

end
