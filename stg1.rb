require 'dxruby'

player_img = Image.load("matsuten/st1back.jpg")

Window.loop do
    Window.draw(100, 100, player_img)
end