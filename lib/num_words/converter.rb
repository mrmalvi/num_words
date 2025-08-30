# lib/num_words/converter.rb
# frozen_string_literal: true

module NumWords
  # --- English words ---
  ONES_EN = %w[zero one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen].freeze
  TENS_EN = %w[zero ten twenty thirty forty fifty sixty seventy eighty ninety].freeze

  # --- Hindi words ---
  ONES_HI = %w[शून्य एक दो तीन चार पाँच छह सात आठ नौ दस ग्यारह बारह तेरह चौदह पंद्रह सोलह सत्रह अठारह उन्नीस].freeze
  TENS_HI = %w[शून्य दस बीस तीस चालीस पचास साठ सत्तर अस्सी नब्बे].freeze
  INDIAN_UNITS_HI = ['', 'हज़ार', 'लाख', 'करोड़', 'अरब', 'खरब'].freeze

  # --- English exponents ---
  AM_EXPONENTS = {
    3 => 'thousand', 6 => 'million', 9 => 'billion', 12 => 'trillion',
    15 => 'quadrillion', 18 => 'quintillion', 21 => 'sexillion', 24 => 'septillion',
    27 => 'octillion', 30 => 'nonillion', 33 => 'decillion', 36 => 'undecillion'
  }.freeze

  INDIAN_UNITS_EN = ['', 'thousand', 'lakh', 'crore', 'arab', 'kharab'].freeze

  COUNTRY_EXPONENTS = {
    us: AM_EXPONENTS,
    in: INDIAN_UNITS_EN
  }.freeze

  class << self
    # Main method: convert number to words
    # language: :en or :hi
    def to_words(number, country: :us, language: :en, include_and: true)
      if [:in].include?(country) && language == :hi
        return to_words_indian(number, language: language)
      end

      val = number.to_i.abs
      return 'zero' if val.zero?

      exp_hash = COUNTRY_EXPONENTS[country] || AM_EXPONENTS
      ones_array = language == :hi ? ONES_HI : ONES_EN
      tens_array = language == :hi ? TENS_HI : TENS_EN
      units = language == :hi ? INDIAN_UNITS_HI : INDIAN_UNITS_EN

      if country == :in
        to_words_indian(number, language: language)
      else
        to_words_generic(val, exp_hash, include_and, ones_array, tens_array)
      end
    end

    # Indian system (supports English & Hindi)
    def to_words_indian(num, language: :en)
      integer_part, decimal_part = num.to_s.split('.')
      ones_array = language == :hi ? ONES_HI : ONES_EN
      tens_array = language == :hi ? TENS_HI : TENS_EN
      units = language == :hi ? INDIAN_UNITS_HI : INDIAN_UNITS_EN

      integer_words = indian_units_to_words(integer_part.to_i, ones_array, tens_array, units)
      return integer_words if decimal_part.nil? || decimal_part.to_i.zero?

      decimal_words = decimal_part.chars.map { |d| sub_thousand_to_words(d.to_i, ones_array, tens_array) }.join(' ')
      "#{integer_words} and #{decimal_words}"
    end

    private

    def to_words_generic(val, exp_hash, include_and, ones_array, tens_array)
      chunks = []
      while val.positive?
        chunks << val % 1000
        val /= 1000
      end

      result = []
      chunks.each_with_index do |chunk, index|
        next if chunk.zero?
        words = hundreds_to_words(chunk, include_and && index.zero?, ones_array, tens_array)
        result.unshift("#{words} #{exp_hash[index * 3]}".strip)
      end
      result.join(' ').strip
    end

    def hundreds_to_words(val, include_and, ones_array, tens_array)
      return '' if val.zero?

      words = []
      if val >= 100
        words << "#{ones_array[val / 100]} #{ones_array == ONES_HI ? 'सौ' : 'hundred'}"
        val %= 100
        words << 'and' if val.positive? && include_and && ones_array != ONES_HI
      end

      words << tens_array[val / 10] if val >= 20
      val %= 10 if val >= 20
      words << ones_array[val] if val.positive?
      words.join(' ').strip
    end

    def indian_units_to_words(num, ones_array, tens_array, units)
      num = num.to_i
      return ones_array[0] if num.zero?

      words = []
      unit_index = 0

      loop do
        break if num.zero?
        num, remainder = unit_index.zero? ? num.divmod(1000) : num.divmod(100)
        words.unshift("#{sub_thousand_to_words(remainder, ones_array, tens_array)} #{units[unit_index]}".strip) if remainder.positive?
        unit_index += 1
      end

      words.join(' ').strip
    end

    def sub_thousand_to_words(num, ones_array, tens_array)
      return ones_array[num] if num < 20
      return "#{ones_array[num / 100]} #{ones_array == ONES_HI ? 'सौ' : 'hundred'}" if num >= 100 && (num % 100).zero?

      words = []
      if num >= 100
        words << "#{ones_array[num / 100]} #{ones_array == ONES_HI ? 'सौ' : 'hundred'}"
        num %= 100
      end

      if num >= 20
        words << tens_array[num / 10]
        num %= 10
      end

      words << ones_array[num] if num.positive?
      words.join(' ').strip
    end
  end
end
