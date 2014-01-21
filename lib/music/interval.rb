module Music

  class Interval

    include Comparable

    ##
    # @private
    #
    SIZES = {
      1 => [0],
      2 => [1, 2],
      3 => [3, 4],
      4 => [5],
      5 => [7],
      6 => [8, 9],
      7 => [10, 11],
      8 => [12],
    }

    ##
    # @private
    #
    OCTAVE = 8

    QUALITIES = [:minor, :major, :perfect, :augmented, :diminished]

    ##
    # @return [Integer]
    #
    attr_reader :number
    ##
    # @return [Symbol]
    #
    attr_reader :quality
    ##
    # Indicates if the interval is positive or negative.
    #
    # @return [1, -1]
    #
    attr_reader :direction

    ##
    # @param number [Integer]
    # @param quality [Symbol] See the {QUALITIES} constant for the list of
    #   possible values.
    #
    # @example
    #   Interval.new(3, :major)   # a major third
    #   Interval.new(5, :perfect) # a perfect fifth
    #
    def initialize(number, quality)
      if not QUALITIES.include?(quality)
        raise ArgumentError, "invalid interval quality: #{quality}"
      elsif [1, 4, 5].include?((number.abs - 1) % 7 + 1) and [:major, :minor].include?(quality)
        raise ArgumentError, "interval #{number} doesn't have quality \"#{quality}\""
      end

      @number, @quality = number.abs, quality
      @direction = number >= 0 ? +1 : -1
    end

    ##
    # Perfect consonants are perfect unisons, fourths and fifths (and their
    # compound intervals).
    #
    # @return [Boolean]
    #
    def perfect_consonance?
      [1, 4, 5].include?(normalized_number) and [:perfect].include?(quality)
    end

    ##
    # Imperfect consonants are minor/major thirds and sixths (and their compound
    # intervals).
    #
    # @return [Boolean]
    #
    def imperfect_consonance?
      [3, 6].include?(normalized_number) and [:minor, :major].include?(quality)
    end

    ##
    # Consonances are perfect and imperfect consonances together.
    #
    # @return [Boolean]
    #
    # @see #perfect_consonance?
    # @see #imperfect_consonance?
    #
    def consonance?
      perfect_consonance? or imperfect_consonance?
    end

    ##
    # Disonances are all intervals that are not consonances.
    #
    # @return [Boolean]
    #
    # @see #consonance?
    #
    def dissonance?
      not consonance?
    end

    ##
    # Returns the same interval with changed direction.
    #
    # @return [Music::Interval]
    #
    def -@
      Interval.new((-1 * direction) * number, quality)
    end

    ##
    # Returns the number of semitones that interval covers.
    #
    # @return [Integer]
    #
    def size
      result = 0
      current_number = number

      while current_number >= OCTAVE
        result += SIZES[OCTAVE][0]
        current_number -= OCTAVE - 1
      end

      sizes = SIZES.fetch(current_number)
      result +=
        case quality
        when :diminished then sizes.first - 1
        when :minor      then sizes.first
        when :perfect    then sizes[0]
        when :major      then sizes.last
        when :augmented  then sizes.last  + 1
        end

      result * direction
    end

    ##
    # Compares intervals by their size.
    #
    # @param other [Music::Interval]
    # @example
    #   Interval.new(3, :major) >  Interval.new(4, :perfect)    #=> true
    #   Interval.new(3, :major) == Interval.new(4, :diminished) #=> true
    #
    def <=>(other)
      self.size.abs <=> other.size.abs
    end

    ##
    # The actual diatonic difference. For example, seconds are numbered with
    # `2`, but the actual diatonic difference between two notes that
    # are in a second is `1`.
    #
    # @return [Integer]
    #
    def diff
      (number - 1) * direction
    end

    private

    def normalized_number
      (number - 1) % 7 + 1
    end

  end

end
