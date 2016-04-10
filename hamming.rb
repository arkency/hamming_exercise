class Hamming

  VERSION = 1

  def self.compute(dna_1, dna_2)
    begin
      strand_1 = DNA::Strand.from_string(dna_1)
      strand_2 = DNA::Strand.from_string(dna_2)

      InformationTheory::hamming_distance(strand_1.to_s, strand_2.to_s)
    rescue DNA::IncorrectDNACode
      raise ArgumentError
    rescue InformationTheory::DifferentLengths
      raise ArgumentError
    end

  end
end

module InformationTheory
  class DifferentLengths < StandardError; end

  def self.hamming_distance(string_1, string_2)
    raise DifferentLengths if string_1.length != string_2.length
    (string_1.chars.zip(string_2.chars)).count {|l, r| l != r}
  end
end

module DNA
  class IncorrectDNACode < StandardError; end

  class Strand

    def self.from_string(dna_string)
      self.new(dna_string.split("").map { |char| Nucleotide.new(char) })
    end

    def initialize(nucleotides)
      @nucleotides = nucleotides
    end

    def to_s
      @nucleotides.map(&:base).join
    end
  end

  class Nucleotide
    attr_accessor :base

    def initialize(base)
      raise IncorrectDNACode if ! possible_DNA_bases.include?(base)
      @base = base
    end

    def possible_DNA_bases
      %w{A G T C}
    end
  end
end

