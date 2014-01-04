# encoding: utf-8

require "spec_helper"

module Music
  describe Note do
    describe "#initialize" do
      it "extracts note parts from the string" do
        note = Note.new("C#1")

        expect(note.letter).to eq "C"
        expect(note.accidental).to eq "#"
        expect(note.octave).to eq 1
      end

      it "accepts accidentals in ASCII letters" do
        expect(Note.new("Db")).to eq Note.new("D♭")
      end

      it "accepts negative octaves" do
        expect(Note.new("C-1").octave).to eq -1
      end

      it "raises an error on invalid letter" do
        expect{Note.new("J")}.to raise_error(ArgumentError)
      end

      it "raises an error on invalid accidental" do
        expect{Note.new("C@")}.to raise_error(ArgumentError)
      end
    end

    describe "#name" do
      it "returns the name of the chord" do
        expect(Note.new("C#1").name).to eq "C#1"
      end
    end

    describe "#to_s" do
      it "returns the name of the chord" do
        expect(Note.new("C#1").to_s).to eq "C#1"
      end
    end

    describe "#<=>" do
      it "returns 0 when notes have same pitch and same symbol" do
        expect(Note.new("C1") <=> Note.new("C1")).to eq 0
      end

      it "returns 0 when notes have same pitch, but different symbol" do
        expect(Note.new("C#1") <=> Note.new("D♭1")).to eq 0
      end

      it "returns -1 when left note is lower than right note by symbol" do
        expect(Note.new("C1") <=> Note.new("D1")).to eq -1
      end

      it "returns -1 when left note is lower than right note by octave" do
        expect(Note.new("C1") <=> Note.new("C2")).to eq -1
      end

      it "returns 1 when left note is higher than right note by symbol" do
        expect(Note.new("D1") <=> Note.new("C1")).to eq 1
      end

      it "returns 1 when left note is higher than right note by octave" do
        expect(Note.new("C1") <=> Note.new("C0")).to eq 1
      end
    end

    describe "#transpose_up" do
      let(:minor_third) { Interval.new(3, :minor) }
      let(:major_third) { Interval.new(3, :major) }

      it "transposes the note up by an interval" do
        expect(Note.new("C1").transpose_up(major_third)).to eq Note.new("E1")
      end

      it "correctly keeps accidentals" do
        expect(Note.new("C#1").transpose_up(major_third)).to eq Note.new("E#1")
        expect(Note.new("C♭1").transpose_up(major_third)).to eq Note.new("E♭1")
      end

      it "correctly adds accidentals" do
        expect(Note.new("D1").transpose_up(major_third)).to eq Note.new("F#1")
        expect(Note.new("C1").transpose_up(minor_third)).to eq Note.new("E♭1")
      end

      it "correctly removes accidentals" do
        expect(Note.new("C#1").transpose_up(minor_third)).to eq Note.new("E1")
        expect(Note.new("D♭1").transpose_up(major_third)).to eq Note.new("F1")
      end

      it "correctly changes the octave" do
        expect(Note.new("A1").transpose_up(minor_third)).to eq Note.new("C2")
      end

      it "handles octaveless notes" do
        expect(Note.new("A").transpose_up(minor_third)).to eq Note.new("C")
      end
    end

    describe "#transpose_down" do
      let(:minor_third) { Interval.new(3, :minor) }
      let(:major_third) { Interval.new(3, :major) }

      it "transposes the note up by an interval" do
        expect(Note.new("E1").transpose_down(major_third)).to eq Note.new("C1")
      end

      it "correctly keeps accidentals" do
        expect(Note.new("E#1").transpose_down(major_third)).to eq Note.new("C#1")
        expect(Note.new("E♭1").transpose_down(major_third)).to eq Note.new("C♭1")
      end

      it "correctly adds accidentals" do
        expect(Note.new("E1").transpose_down(minor_third)).to eq Note.new("C#1")
        expect(Note.new("F1").transpose_down(major_third)).to eq Note.new("D♭1")
      end

      it "correctly removes accidentals" do
        expect(Note.new("F#1").transpose_down(major_third)).to eq Note.new("D1")
        expect(Note.new("E♭1").transpose_down(minor_third)).to eq Note.new("C1")
      end

      it "correctly changes the octave" do
        expect(Note.new("C1").transpose_down(minor_third)).to eq Note.new("A0")
      end

      it "handles octaveless notes" do
        expect(Note.new("C").transpose_down(minor_third)).to eq Note.new("A")
      end
    end

    describe "#-" do
      it "returns the interval between the notes" do
        expect(Note.new("D#1") - Note.new("C1")).to eq Interval.new(2, :augmented)
        expect(Note.new("C1") - Note.new("D#1")).to eq -Interval.new(2, :augmented)
      end

      it "handles different octaves" do
        expect(Note.new("C2") - Note.new("C1")).to eq Interval.new(8, :perfect)
        expect(Note.new("C1") - Note.new("C2")).to eq -Interval.new(8, :perfect)
      end

      it "handles octaveless notes" do
        expect(Note.new("E") - Note.new("C")).to eq Interval.new(3, :major)
        expect(Note.new("C") - Note.new("E")).to eq -Interval.new(3, :major)
      end
    end
  end
end
