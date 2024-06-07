require 'dxruby'

require_relative 'player'
require_relative 'enemy'

Window.width = 1820  # 画面の幅を設定
Window.height = 980 # 画面の高さを設定
#Window.full_screen = true # 全画面表示を有効にする

font = Font.new(32)
player_img = Image.load("image/player.png")
enemy_img = Image.load("image/enemy.png")

myshi_img = Image.load("image/myshiro.jpg")
myshi_img.set_color_key(C_WHITE)
tekishi_img = Image.load("image/teki_shiro.jpg")
tekishi_img.set_color_key(C_WHITE)

player = Player.new(1700, 500, player_img)
enemies = Enemy.new(0, 500, enemy_img)
#10.times do
  #enemies << Enemy.new(rand(0..(640 - 32 - 1)), rand((480 - 32 - 1)), enemy_img)
#end

timer = 6000 + 600 # 追加

Window.bgcolor = C_CYAN

Window.loop do
  if timer >= 60 # 追加
    timer -= 1 # 追加
    player.update
    enemies.update
  end

  player.draw

  Sprite.draw(enemies)
  Window.draw_font(10, 0, "スコア：#{player.score}", font)
  Window.draw_font(10, 32, "残り時間：#{timer / 600}秒", font) # 追加
  Window.draw(1700, 500,myshi_img)
  Window.draw(0, 500,tekishi_img)

  Sprite.check(player, enemies)
end
