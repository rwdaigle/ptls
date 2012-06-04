class UnitObserver < ActiveRecord::Observer

  observe :unit

  def after_create(unit)
    $queue.enqueue('Unit.process!', unit.id)
  end
end
