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
- Easy to integrate into Ruby or Rails applications.
- Supports numbers up to `duovigintillion` (10^69) in the American system.

---

## Installation

### Using RubyGems

After releasing your gem to [RubyGems.org](https://rubygems.org), install it with:

```bash
# Using Bundler
bundle add gem 'num_words'

# Or install manually
gem install num_words
