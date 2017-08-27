class NilClass
  alias old_to_i to_i

  def to_i(mode = nil)
    old_to_i
  end
end

class String
  alias old_to_i to_i
  alias old_to_time to_time

  def to_i(mode = nil)
    if mode == :currency
      currency_to_integer
    elsif mode == :term
      term_to_integer
    elsif !mode.nil?
      old_to_i(mode)
    else
      old_to_i
    end
  end

  def clean_up
    delete("\r\n\t").gsub(/\xc2\xa0/, '').strip
  end

  def to_time
    processed_string = gsub(/年|月/, '-').gsub(/時|分/, ':').delete('日秒')

    processed_string.old_to_time
  end

  def to_half
    tr('０-９ａ-ｚＡ-Ｚ，．', '0-9a-zA-Z,.')
  end

private
  def currency_to_integer
    cleaned_string = self.delete(',¥￥円 ')

    if cleaned_string =~ /\A\d+\z/
      cleaned_string.to_i
    elsif cleaned_string =~ /\A\d+万\z/
      cleaned_string.to_i * 10000
    elsif cleaned_string =~ /\A\d+億(?:\d+万)?\z/
      cleaned_string.to_i * 100000000 + cleaned_string.split('億').last.to_i * 10000
    else
      # TODO: あとでto_i呼び出しに修正
      cleaned_string
    end
  end

  def term_to_integer
    if self =~ /\A約?\d+\s*[ヶヵ]月\z/
      self.to_i
    elsif self =~ /\A約?\d+\s*年\z/
      self.to_i * 12
    elsif self =~ /\A\d+\z/
      self.to_i
    else
      # TODO: あとでto_i呼び出しに修正
      self
    end
  end
end
