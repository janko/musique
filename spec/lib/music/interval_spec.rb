require "spec_helper"

module Music
  describe Interval do
    describe "#initialize" do
      it "raises an error if the number doesn't have the given quality" do
        expect{Interval.new(1, :minor)}.to raise_error(ArgumentError)
      end

      it "raises an error if the quality was spelled wrong" do
        expect{Interval.new(1, :diminshed)}.to raise_error(ArgumentError)
      end
    end

    describe "#<=>" do
      it "returns 0 when names are equal" do
        expect(Interval.new(3, :major) <=> Interval.new(3, :major)).to eq 0
      end

      it "returns 0 when names are different, but sizes are equal" do
        expect(Interval.new(3, :major) <=> Interval.new(4, :diminished)).to eq 0
      end

      it "returns -1 when left size is smaller than right size" do
        expect(Interval.new(1, :perfect) <=> Interval.new(3, :major)).to eq -1
        expect(Interval.new(3, :minor) <=> Interval.new(3, :major)).to eq -1
      end

      it "returns 1 when left size is bigger than right size" do
        expect(Interval.new(3, :major) <=> Interval.new(1, :perfect)).to eq 1
        expect(Interval.new(3, :major) <=> Interval.new(3, :minor)).to eq 1
      end

      it "ignores the sign" do
        expect(Interval.new(3, :major) <=> -Interval.new(3, :major)).to eq 0
      end
    end

    describe "#==" do
      it "returns true when intervals are equal" do
        expect(Interval.new(1, :perfect)).to eq Interval.new(1, :perfect)
      end

      it "returns false when intervals are different by number" do
        expect(Interval.new(1, :perfect)).not_to eq Interval.new(4, :perfect)
      end

      it "returns false when intervals are different by quality" do
        expect(Interval.new(1, :perfect)).not_to eq Interval.new(1, :augmented)
      end
    end

    describe "#perfect_consonance?" do
      it "returns true for perfect unisons, fourths and fifths" do
        [1, 4, 5].each do |number|
          [:perfect].each do |quality|
            expect(Interval.new(number, quality).perfect_consonance?).to eq true
          end
        end
      end

      it "returns true for perfect octaves, elevenths and twelfths" do
        [8, 11, 12].each do |number|
          [:perfect].each do |quality|
            expect(Interval.new(number, quality).perfect_consonance?).to eq true
          end
        end
      end

      it "returns false for augmented/diminished unisons, fourths and fifths" do
        [1, 4, 5].each do |number|
          [:augmented, :diminished].each do |quality|
            expect(Interval.new(number, quality).perfect_consonance?).to eq false
          end
        end
      end

      it "returns false for other intervals" do
        [2, 3, 6, 7, 9, 10, 13, 14].each do |number|
          Interval::QUALITIES.each do |quality|
            begin
              expect(Interval.new(number, quality).perfect_consonance?).to eq false
            rescue ArgumentError
            end
          end
        end
      end
    end

    describe "#imperfect_consonance?" do
      it "returns true for minor/major thirds and sixths" do
        [3, 6].each do |number|
          [:minor, :major].each do |quality|
            expect(Interval.new(number, quality).imperfect_consonance?).to eq true
          end
        end
      end

      it "returns true for minor/major tenths and thirteenths" do
        [10, 13].each do |number|
          [:minor, :major].each do |quality|
            expect(Interval.new(number, quality).imperfect_consonance?).to eq true
          end
        end
      end

      it "returns false for augmented/diminished thirds and sixths" do
        [3, 6].each do |number|
          [:augmented, :diminished].each do |quality|
            expect(Interval.new(number, quality).imperfect_consonance?).to eq false
          end
        end
      end

      it "returns false for other intervals" do
        [1, 2, 4, 5, 7, 8, 9, 11, 12, 14, 15].each do |number|
          Interval::QUALITIES.each do |quality|
            begin
              expect(Interval.new(number, quality).imperfect_consonance?).to eq false
            rescue ArgumentError
            end
          end
        end
      end
    end

    describe "#consonance?" do
      it "returns true for all perfect and imperfect consonances" do
        [3, 6, 10, 13].each do |number|
          [:minor, :major].each do |quality|
            expect(Interval.new(number, quality).dissonance?).to eq false
          end
        end

        [1, 4, 5, 8, 11, 12].each do |number|
          [:perfect].each do |quality|
            expect(Interval.new(number, quality).dissonance?).to eq false
          end
        end
      end
    end

    describe "#dissonance?" do
      it "returns true for seconds and sevenths" do
        [2, 7].each do |number|
          [:minor, :major, :augmented, :diminished].each do |quality|
            expect(Interval.new(number, quality).dissonance?).to eq true
          end
        end
      end

      it "returns true for ninths and fourteenths" do
        [9, 14].each do |number|
          [:minor, :major, :augmented, :diminished].each do |quality|
            expect(Interval.new(number, quality).dissonance?).to eq true
          end
        end
      end

      it "returns true for all augmented/diminished intervals" do
        (1..15).each do |number|
          [:augmented, :diminished].each do |quality|
            expect(Interval.new(number, quality).dissonance?).to eq true
          end
        end
      end

      it "returns false for all consonances" do
        [3, 6, 10, 13].each do |number|
          [:minor, :major].each do |quality|
            expect(Interval.new(number, quality).dissonance?).to eq false
          end
        end

        [1, 4, 5, 8, 11, 12].each do |number|
          [:perfect].each do |quality|
            expect(Interval.new(number, quality).dissonance?).to eq false
          end
        end
      end
    end

    describe "#size" do
      it "handles perfect intervals" do
        expect(Interval.new(5, :perfect).size).to eq 7
      end

      it "handles minor/major intervals" do
        expect(Interval.new(3, :minor).size).to eq 3
        expect(Interval.new(3, :major).size).to eq 4
      end

      it "handles augmented/diminished perfect/imperfect intervals" do
        expect(Interval.new(5, :augmented).size).to eq 8
        expect(Interval.new(5, :diminished).size).to eq 6

        expect(Interval.new(3, :augmented).size).to eq 5
        expect(Interval.new(3, :diminished).size).to eq 2
      end

      it "handles compound intervals" do
        expect(Interval.new(8, :perfect).size).to eq 12
        expect(Interval.new(9, :minor).size).to eq 13
      end

      it "returns negative value for negative intervals" do
        expect((-Interval.new(3, :major)).size).to eq -4
      end
    end

    describe "#diff" do
      it "returns the difference in notes" do
        expect(Interval.new(1, :perfect).diff).to eq 0
        expect(Interval.new(3, :perfect).diff).to eq 2
      end

      it "returns negative value for negative intervals" do
        expect((-Interval.new(3, :perfect)).diff).to eq -2
      end
    end
  end
end
