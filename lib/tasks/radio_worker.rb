class RadioWorker
  def self.task
    Radio.create_or_update_with_radios(Agon.load())
    Radio.create_or_update_with_radios(Animate.load())
    Radio.create_or_update_with_radios(Chnicovideo.load())
    Radio.create_or_update_with_radios(Onsen.load())
  end
end
