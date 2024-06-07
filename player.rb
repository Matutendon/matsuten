class Player < Sprite
  attr_accessor :score # 追加

  def initialize(x, y, image) # 追加
    @score = 0
    super
  end

  def update
    
    self.x -= 3
  
  end

  def shot # 追加
    @score += 1
  end
end