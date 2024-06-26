require 'dxruby'

# ゲームの設定
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600
INITIAL_HP = 10
INITIAL_COST = 10

# ゲームウィンドウの設定
Window.width = WINDOW_WIDTH
Window.height = WINDOW_HEIGHT

# プレイヤーと敵の陣地のHP
player_hp = INITIAL_HP
enemy_hp = INITIAL_HP

# コストの初期値
cost = INITIAL_COST

# フレームカウンター
frame_counter = 0

# 画像の読み込み
background_image = Image.load('image/b2.jpg')
start_background_image = Image.load('image/b1.jpg')
game_over_background_image = Image.load('image/b1.jpg')
ally_images = {
  1 => Image.load('image/p1.jpg'),
  2 => Image.load('image/p2.jpg'),
  3 => Image.load('image/p3.jpg')
}
enemy_image = Image.load('image/e1.jpg')

# キャラクタークラス
class Character
  attr_reader :x, :y, :hp, :attack

  def initialize(x, y, hp, attack, speed, image)
    @x, @y, @hp, @attack, @speed, @image = x, y, hp, attack, speed, image
  end

  def update
    @x += @speed
  end

  def draw
    Window.draw(@x - @image.width / 2, @y - @image.height / 2, @image)
  end

  def hit(damage)
    @hp -= damage
  end

  def alive?
    @hp > 0
  end
end

# ゲームの状態
state = :start
result = ""

# 敵と味方のリスト
allies = []
enemies = []

# 敵を定期的に生成する
enemy_spawn_interval = 60 # 1秒に一回
enemy_spawn_timer = 0

Window.loop do
  case state
  when :start
    # スタート画面の背景を描画
    Window.draw(0, 0, start_background_image)
    Window.draw_font(300, 250, "Press Space to Start", Font.default)
    state = :play if Input.key_push?(K_SPACE)

  when :play
    frame_counter += 1

    # 背景を描画
    Window.draw(0, 0, background_image)

    # コストの回復
    cost = [cost + 1, INITIAL_COST].min if (frame_counter % 60).zero?

    # 味方の召喚
    if Input.key_push?(K_1) && cost >= 1
      allies << Character.new(100, 300, 1, 1, 2, ally_images[1])
      cost -= 1
    elsif Input.key_push?(K_2) && cost >= 2
      allies << Character.new(100, 300, 2, 2, 2, ally_images[2])
      cost -= 2
    elsif Input.key_push?(K_3) && cost >= 3
      allies << Character.new(100, 300, 3, 3, 2, ally_images[3])
      cost -= 3
    end

    # 敵の生成
    if enemy_spawn_timer <= 0
      enemies << Character.new(WINDOW_WIDTH - 100, 300, 3, 1, -2, enemy_image)
      enemy_spawn_timer = enemy_spawn_interval
    else
      enemy_spawn_timer -= 1
    end

    # 味方と敵の更新
    allies.each(&:update)
    enemies.each(&:update)

    # 衝突判定
    allies.each do |ally|
      enemies.each do |enemy|
        if (ally.x - enemy.x).abs < 20 && (ally.y - enemy.y).abs < 20
          ally.hit(enemy.attack)
          enemy.hit(ally.attack)
        end
      end
    end

    # HPが0以下のキャラクターを削除
    allies.reject! { |ally| !ally.alive? }
    enemies.reject! { |enemy| !enemy.alive? }

    # 陣地への攻撃
    enemies.each do |enemy|
      if enemy.x < 100
        player_hp -= enemy.attack
        enemy.hit(100) # 確実に敵を消すために大きなダメージを与える
      end
    end

    allies.each do |ally|
      if ally.x > WINDOW_WIDTH - 100
        enemy_hp -= ally.attack
        ally.hit(100) # 確実に味方を消すために大きなダメージを与える
      end
    end

    # 勝敗判定
    if player_hp <= 0
      state = :game_over
      result = "あなたの負けです！"
    elsif enemy_hp <= 0
      state = :game_over
      result = "あなたの勝ちです！"
    end

    # 情報を描画
    Window.draw_font(10, 10, "Player HP: #{player_hp}", Font.default)
    Window.draw_font(10, 30, "Enemy HP: #{enemy_hp}", Font.default)
    Window.draw_font(10, 50, "Cost: #{cost}", Font.default)

    # キャラクターを描画
    allies.each(&:draw)
    enemies.each(&:draw)

  when :game_over
    # コンテニュー画面の背景を描画
    Window.draw(0, 0, game_over_background_image)
    Window.draw_font(300, 250, result, Font.default)
    Window.draw_font(250, 300, "Press Space to Continue", Font.default)
    if Input.key_push?(K_SPACE)
      state = :start

      # リセット
      player_hp = INITIAL_HP
      enemy_hp = INITIAL_HP
      cost = INITIAL_COST
      frame_counter = 0
      allies.clear
      enemies.clear
    end
  end
end
