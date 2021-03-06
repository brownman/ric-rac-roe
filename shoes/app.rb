require File.join(File.dirname(__FILE__), 'game_shoes.rb')

Shoes.app(:title => "Ric-rac-roe", :width => 630, :height => 670) do
	background black

	def init_game
		@game = GameShoes.new
		@images = []
		3.times {@images << Array.new(3)}
	end

	def draw_elements
		stack do
			(0..2).each do |row|
				flow do
					(0..2).each do |col|
						@images[col][row] = image "images/empty.gif", :margin => 5
						@images[col][row].click { on_click(col, row) } 
					end
				end
			end
			@status_line = stack do
				@status = para "Let the game begin!", :stroke => white
			end
		end
	end

	init_game
	@gameplay = draw_elements
	

	### helper methods

	def new_game
		init_game
		@gameplay.clear{ draw_elements } 
	end

	def on_click x, y
		play(x, y)
		@status.text = @game.status_message
		end_game if @game.over?
	end

	def play x, y
		@game.play(x, y)
		if @game.squares[y][x] == "X"
			@images[x][y].path =  "images/x.gif"
		else
			@images[x][y].path =  "images/o.gif"
		end
		@images[x][y].click {}
	end

	def end_game
		end_game_msg = @game.winner.nil? ?  "Draw! " : "Player with #{@game.winner}'s won! "
		link = link("New game") { new_game }
		@status_line.clear { para end_game_msg, link , "?", :stroke => white }

		#disable click events on all squares
		(0..2).each do |row|
			(0..2).each do |col|
				@images[col][row].click {}
			end
		end
	end

end
