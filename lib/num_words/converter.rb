# lib/num_words/converter.rb
# frozen_string_literal: true

module NumWords
  ONES = %w[zero one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen].freeze
  TENS = %w[zero ten twenty thirty forty fifty sixty seventy eighty ninety].freeze

  AM_EXPONENTS = {
    3 => 'thousand', 6 => 'million', 9 => 'billion', 12 => 'trillion',
    15 => 'quadrillion', 18 => 'quintillion', 21 => 'sexillion', 24 => 'septillion',
    27 => 'octillion', 30 => 'nonillion', 33 => 'decillion', 36 => 'undecillion',
    39 => 'duodecillion', 42 => 'tredecillion', 45 => 'quattuordecillion', 48 => 'quindecillion',
    51 => 'sexdecillion', 54 => 'septendecillion', 57 => 'octodecillion', 60 => 'novemdecillion',
    63 => 'vigintillion', 66 => 'unvigintillion', 69 => 'duovigintillion'
  }.freeze

  EU_EXPONENTS = {
    3 => 'thousand', 6 => 'million', 9 => 'milliard', 12 => 'billion',
    15 => 'billiard', 18 => 'trillion', 21 => 'trilliard', 24 => 'quadrillion',
    27 => 'quadrilliard', 30 => 'quintillion', 33 => 'quintilliard', 36 => 'sextillion',
    39 => 'sextilliard', 42 => 'septillion', 45 => 'septilliard', 48 => 'octillion',
    51 => 'octilliard', 54 => 'noventillion', 57 => 'noventilliard', 60 => 'decillion',
    63 => 'decilliard', 66 => 'undecillion', 69 => 'undecilliard'
  }.freeze

  UK_EXPONENTS = {
    3 => 'thousand', 6 => 'million', 12 => 'billion', 15 => 'billiard',
    18 => 'trillion', 21 => 'trilliard', 24 => 'quadrillion'
  }.freeze

  FR_EXPONENTS = {
    3 => 'mille', 6 => 'million', 9 => 'milliard', 12 => 'billion',
    15 => 'billiard', 18 => 'trillion', 21 => 'trilliard'
  }.freeze

  INDIAN_UNITS = ['', 'thousand', 'lakh', 'crore'].freeze

  COUNTRY_EXPONENTS = {
    us: AM_EXPONENTS,
    eu: EU_EXPONENTS,
    uk: UK_EXPONENTS,
    fr: FR_EXPONENTS,
    in: INDIAN_UNITS
  }.freeze

  class << self
    def to_words(number, country: :us, include_and: true)
      return to_words_indian(number) if country == :in

      val = number.to_i.abs
      return 'zero' if val.zero?

      exp_hash = COUNTRY_EXPONENTS[country] || AM_EXPONENTS
      to_words_generic(val, exp_hash, include_and)
    end

    def to_words_indian(num)
      integer_part, decimal_part = num.to_s.split('.')
      integer_words = indian_units_to_words(integer_part.to_i)
      return integer_words if decimal_part.nil? || decimal_part.to_i.zero?

      decimal_words = decimal_part.chars.map { |d| sub_thousand_to_words(d.to_i) }.join(' ')
      "#{integer_words} and #{decimal_words}"
    end

    private

    def to_words_generic(val, exp_hash, include_and)
      chunks = []
      while val.positive?
        chunks << val % 1000
        val /= 1000
      end

      result = []
      chunks.each_with_index do |chunk, index|
        next if chunk.zero?
        words = hundreds_to_words(chunk, include_and && index.zero?)
        result.unshift("#{words} #{exp_hash[index * 3]}".strip)
      end
      result.join(' ').strip
    end

    def hundreds_to_words(val, include_and = false)
      return '' if val.zero?

      words = []
      if val >= 100
        words << "#{ONES[val / 100]} hundred"
        val %= 100
        words << 'and' if val.positive? && include_and
      end

      words << TENS[val / 10] if val >= 20
      val %= 10 if val >= 20
      words << ONES[val] if val.positive?
      words.join(' ').strip
    end

    def indian_units_to_words(num)
      num = num.to_i
      return 'zero' if num.zero?
      words = []
      unit_index = 0

      loop do
        break if num.zero?

        num, remainder = unit_index.zero? ? num.divmod(1000) : num.divmod(100)
        words.unshift("#{sub_thousand_to_words(remainder)} #{INDIAN_UNITS[unit_index]}".strip) if remainder.positive?
        unit_index += 1
      end

      words.join(' ').strip
    end

    def sub_thousand_to_words(num)
      num = num.to_i
      return ONES[num] if num < 20
      return "#{ONES[num / 100]} hundred" if num >= 100 && (num % 100).zero?

      if num < 100
        "#{TENS[num / 10]} #{ONES[num % 10]}".strip
      else
        "#{ONES[num / 100]} hundred and #{sub_thousand_to_words(num % 100)}"
      end
    end
  end
end
