class Shortener
  RANGE_SYM = "-".freeze
  CAPITAL_LETTERS_ASCII_NUMBERS_RANGE = (65..90).to_a
  SMALL_LETTERS_ASCII_NUMBERS_RANGE = (97..122).to_a
  DIGITS_ASCII_NUMBERS_RANGE = (48..57).to_a

  def initialize(string, options = {})
    @string = string
    @dup_string = options[:case_sensitive] ? string : string.downcase
    @range_starts_index = string.length - 1
  end

  def shorted_string
    replace_ranges_starting_from_end
    string
  end

  private

  attr_reader :string, :dup_string, :previous_numbers_diff, :range_starts_index

  def replace_ranges_starting_from_end # rubocop:disable Metrics/AbcSize
    range_starts_index.downto(0) do |index|
      number1 = ascii_number(dup_string[index])
      number2 = ascii_number(dup_string[index - 1])
      numbers_diff = number1 - number2
      is_range = range?(numbers_diff, index: index, numbers: [number1, number2])
      is_new_range = new_range?(numbers_diff)

      replace_previous_range(index) unless is_range
      update_range_starts_index(index, is_range: is_range, is_new_range: is_new_range)
      update_previous_numbers_diff(numbers_diff)
    end
  end

  def range?(numbers_diff, index:, numbers:)
    return false if index.zero?

    numbers_diff.abs == 1 && from_one_ascii_numbers_range?(numbers)
  end

  def from_one_ascii_numbers_range?(numbers)
    (CAPITAL_LETTERS_ASCII_NUMBERS_RANGE & numbers).length == 2 ||
      (SMALL_LETTERS_ASCII_NUMBERS_RANGE & numbers).length == 2 ||
      (DIGITS_ASCII_NUMBERS_RANGE & numbers).length == 2
  end

  def new_range?(numbers_diff)
    !previous_numbers_diff || numbers_diff != previous_numbers_diff
  end

  def replace_previous_range(index)
    return if range_less_than_two_sym?(index)

    string[index + 1..range_starts_index - 1] = RANGE_SYM
  end

  def update_range_starts_index(index, is_range:, is_new_range:)
    @range_starts_index = index if is_new_range
    @range_starts_index = index - 1 unless is_range
  end

  def update_previous_numbers_diff(numbers_diff)
    @previous_numbers_diff = numbers_diff
  end

  def ascii_number(sym)
    sym.ord
  end

  def range_less_than_two_sym?(index)
    range_starts_index - index < 2
  end
end
