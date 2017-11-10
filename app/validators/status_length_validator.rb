# frozen_string_literal: true

class StatusLengthValidator < ActiveModel::Validator
  MAX_CHARS = 7777
  MAX_UNCUT_CHARS = 777

  def validate(status)
    return unless status.local? && !status.reblog?
    status.errors.add(:text, I18n.t('statuses.over_character_limit', max: MAX_CHARS)) if too_long?(status)
    status.errors.add(:text, I18n.t('statuses.over_uncut_character_limit', max: MAX_UNCUT_CHARS)) if too_long_uncut?(status)
  end

  private

  def too_long?(status)
    countable_length(status) > MAX_CHARS
  end

  def too_long_uncut?(status)
    (countable_uncut_length(status) > MAX_UNCUT_CHARS) && (countable_spoiler_length(status) < 1)
  end

  def countable_length(status)
    total_text(status).mb_chars.grapheme_length
  end

  def countable_uncut_length(status)
    countable_text(status).mb_chars.grapheme_length
  end

  def countable_spoiler_length(status)
    status.spoiler_text.mb_chars.grapheme_length
  end

  def total_text(status)
    [status.spoiler_text, countable_text(status)].join
  end

  def countable_text(status)
    status.text.dup.tap do |new_text|
      new_text.gsub!(FetchLinkCardService::URL_PATTERN, 'x' * 23)
      new_text.gsub!(Account::MENTION_RE, '@\2')
    end
  end
end
