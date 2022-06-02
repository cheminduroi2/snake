require 'json'
require 'colorize'

require_relative 'snake'

UP = [0, 1]
DOWN = [0, -1]
LEFT = [-1, 0]
RIGHT = [1, 0]

class Game
    HEAD_SYMBOL = "☻"
    BODY_SYMBOL = "▪"
    APPLE_SYMBOL = "🍎"
    def initialize(w,h)
        @width, @height = w, h
        @playerScore = 0
        @apple = nil
        @snake = Snake.new(
            [[0, 0],[1, 0],[2, 0],[3, 0], [4, 0]],
            UP
        )
    end

    def boardMatrix
        board = Array.new(@width) { Array.new(@height, " ") }
        @snake.body.each do | snakeBodyPart |
            board[snakeBodyPart[0]][snakeBodyPart[1]] = BODY_SYMBOL
        end
        snakeHead = @snake.head
        board[snakeHead[0]][snakeHead[1]] = HEAD_SYMBOL
        board[@apple[0]][@apple[1]] = APPLE_SYMBOL
        return board
    end

    def colorOutput(output)
        if output == HEAD_SYMBOL or output == BODY_SYMBOL
            return output.green
        end
        return output
    end

    def render
        board = boardMatrix
        puts "+#{"-"*@width}+".yellow
        (0...@height).each do | row |
            rowToDisplay = "|".yellow
            (0...@width).each do | col |
                rowToDisplay += colorOutput(board[col][@height - 1 - row])
            end
            puts rowToDisplay + ("|".yellow)
        end
        puts "+#{"-"*@width}+".yellow
        print "Score: #@playerScore\n\n"
    end

    def getNewApple
        begin
            newApple = [rand(@width), rand(@height)]
        end while @snake.body.include?(newApple)
        return newApple
    end

    def getHighScore
        return JSON.parse(File.read("highscore.json"))["highscore"]
    end

    def setHighScore
        File.open("highscore.json", "w") do | f |
            f.write(Hash["highscore"=>@playerScore].to_json)
        end
    end

    def endGameHandler
        if @playerScore > getHighScore
            print "\nCONGRATS! NEW HIGH SCORE OF #@playerScore!\n\n".green
            setHighScore
        else
            print "\nGAME OVER! SCORE: #@playerScore\n\n"
        end
    end

    def start
        print "Welcome to Snake! Press Q to quit.\n\n"
        @apple = getNewApple
        render
        while true do
            case gets.chomp.upcase
            when "W", @snake.direction != DOWN
                @snake.setDirection = UP
            when "S", @snake.direction != UP
                @snake.setDirection = DOWN
            when "A", @snake.direction != RIGHT
                @snake.setDirection = LEFT
            when "D", @snake.direction != LEFT
                @snake.setDirection = RIGHT
            when "Q"
                endGameHandler
                break
            else
                print "Invalid direction. Valid directions: W (UP), A (LEFT), S (DOWN), D (RIGHT)\n\n".red
                next
            end
            snakeNextDirection = [
                (@snake.head[0] + @snake.direction[0]) % @width,
                (@snake.head[1] + @snake.direction[1]) % @height
            ] 
            if @snake.body.include?(snakeNextDirection)
                endGameHandler
                break
            end
            if snakeNextDirection == @apple
                @playerScore += 1
                @snake.grows(snakeNextDirection)
                @apple = getNewApple
            else
                @snake.takeStep(snakeNextDirection)
            end
            render
        end
    end
end

g = Game.new(30, 10)
g.start
    