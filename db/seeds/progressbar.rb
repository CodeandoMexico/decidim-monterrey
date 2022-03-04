module Seeds
  module Progressbar
    def self.create(title:, total:)
      ProgressBar.create(
        title: title,
        total: total,
        format: "%a %b\u{15E7}%i %p%% %t",
        progress_mark: " ",
        remainder_mark: "\u{FF65}"
      )
    end
  end
end
