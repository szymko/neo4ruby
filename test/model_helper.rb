module ModelHelper

  def assert_changed(opts) #opts = { model:..., by: }
    previous = opts[:model].count
    yield
    assert opts[:by], (previous - opts[:model].count).abs
  end
end