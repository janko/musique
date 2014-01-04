# encoding: utf-8

require "spec_helper"

module Music
  describe Chord do
    describe "#initialize" do
      it "extracts chord parts from the string" do
        chord = Chord.new("C#m7")

        expect(chord.root).to eq Note.new("C#")
        expect(chord.kind).to eq "m7"
      end

      it "raises an error on invalid names" do
        expect{Chord.new("ABC")}.to raise_error(ArgumentError)
      end

      it "defaults to quintachords" do
        expect(Chord.new("Cm").kind).to eq "m5"
      end
    end

    describe "#notes" do
      it "returns notes of major quintachords" do
        expect(Chord.new("C").notes.map(&:name)).to eq %w[C E G]
      end

      it "returns notes of minor quintachords" do
        expect(Chord.new("Cm").notes.map(&:name)).to eq %w[C E♭ G]
      end

      it "returns notes of major septachords" do
        expect(Chord.new("C7").notes.map(&:name)).to eq %w[C E G B]
      end

      it "returns notes of minor septachords" do
        expect(Chord.new("Cm7").notes.map(&:name)).to eq %w[C E♭ G B♭]
      end

      it "really works with intervals, not distances between notes" do
        expect(Chord.new("C#").notes.map(&:name)).to eq %w[C# E# G#]
        expect(Chord.new("D♭").notes.map(&:name)).to eq %w[D♭ F A♭]
      end
    end

    describe "#==" do
      it "returns true when chords have the same name" do
        expect(Chord.new("C")).to eq Chord.new("C")
      end

      it "returns false when chords don't have the same name" do
        expect(Chord.new("C#")).not_to eq Chord.new("D♭")
      end
    end

    describe "#transpose_up" do
      let(:major_third) { Interval.new(3, :major) }

      it "transposes the chord up by the given interval" do
        expect(Chord.new("C").transpose_up(major_third)).to eq Chord.new("E")
      end
    end

    describe "#transpose_down" do
      let(:major_third) { Interval.new(3, :major) }

      it "transposes the chord down by the given interval" do
        expect(Chord.new("E").transpose_down(major_third)).to eq Chord.new("C")
      end
    end
  end
end
