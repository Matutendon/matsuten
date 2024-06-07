class Enemy < Sprite
  def hit
      self.vanish
  end
  def update
    
    self.x += 3
  
  end
end