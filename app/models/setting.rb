class Setting < ApplicationRecord
  belongs_to :user

  after_save do
    if name == 'parallel_scans'
      #ScanWorker.num_workers = value.to_i
      #ScanParseJob.num_workers = value.to_i
      #ScreenshotJob.num_workers = value.to_i
    end
  end
end
