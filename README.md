# NumWords

**NumWords** is a Ruby gem that converts numbers into words in multiple numbering systems, including US, European, UK, French, and Indian. It supports both integer and decimal numbers and is useful for invoices, financial documents, or any application that requires converting numeric values into readable text.

---

## Features

- Convert integers and decimals to words.
- Supports multiple country numbering systems:
  - **US / American** – `thousand, million, billion`
  - **European** – `thousand, million, milliard, billion`
  - **UK** – `thousand, million, billion`
  - **France** – `mille, million, milliard`
  - **India** – `thousand, lakh, crore`
- Supports multiple languages:
  - **English** (`:en`)
  - **Hindi** (`:hi`)
  - **French** (`:fr`) *(optional / extended)*
- Easy to integrate into Ruby or Rails applications.
- Supports numbers up to `duovigintillion` (10^69) in the American system.
- Handles both integers and decimal numbers.

# In US system
- NumWords.to_words(123456789012345, country: :us, language: :en)
  - "one hundred and twenty-three trillion four hundred and fifty-six billion seven hundred and eighty-nine million twelve thousand three hundred and forty-five"

# In Hindi
- NumWords.to_words(123456789012345, country: :hi, language: :hi)
  - "बारह खरब चौतीस अरब छप्पन करोड़ सात करोड़ अस्सी लाख बारह हज़ार तीन सौ पैंतालीस"

# Indian number with decimals
- NumWords.to_words(1234567890.123, country: :in, language: :en)
  - "one hundred and twenty-three crore forty-five lakh sixty-seven thousand eight hundred and ninety and one two three"

---

## Installation

### Using RubyGems

After releasing your gem to [RubyGems.org](https://rubygems.org), install it with:

```bash
# Using Bundler
bundle add gem "num_words"

# Or using gem install
gem install num_words



