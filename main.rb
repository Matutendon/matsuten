require 'dxruby'

require_relative 'player'
require_relative 'enemy'

Window.width = 1820  # 画面の幅を設定
Window.height = 980 # 画面の高さを設定
# Window.full_screen = true # 全画面表示を有効にする

font = Font.new(32)
player_img = Image.load("image/player.png")
enemy_img = Image.load("image/enemy.png")

myshi_img = Image.load("image/myshiro.jpg")
myshi_img.set_color_key(C_WHITE)
tekishi_img = Image.load("image/teki_shiro.jpg")
tekishi_img.set_color_key(C_WHITE)

players = []  # プレイヤーオブジェクトを管理する配列
enemies = Enemy.new(0, 500, enemy_img)

timer = 6000 + 600

Window.bgcolor = C_CYAN

Window.loop do
  if timer >= 60
    timer -= 1

    # 1キーが押された場合に新しいプレイヤーを追加
    if Input.key_down?(K_1)
      players << Player.new(1700, 500, player_img)
    end

    # すべてのプレイヤーをアップデートおよび描画
    players.each do |player|
      player.update
      player.draw
    end

    enemies.update
  end

  Sprite.draw(enemies)

  # すべてのプレイヤーのスコアを表示（ここでは最初のプレイヤーのスコアを表示）
  Window.draw_font(10, 0, "スコア：#{players.empty? ? 0 : players[0].score}", font)
  
  # 残り時間を表示
  Window.draw_font(10, 32, "残り時間：#{timer / 600}秒", font)
  
  #Window.draw(1700, 500, myshi_img)
  #Window.draw(0, 500, tekishi_img)

  # すべてのプレイヤーに対して敵との衝突判定を行う
  players.each do |player|
    Sprite.check(player, enemies)
  end
end
