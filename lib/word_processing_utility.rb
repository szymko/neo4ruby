class WordProcessingUtility

  def delete_short_words(word_ary, min_length = 2)
    word_ary.reject { |w| w.length < min_length }
  end

  def split_long_sentences(word_ary, max_length = 7)
    word_ary.each_slice(max_length).to_a
  end

end