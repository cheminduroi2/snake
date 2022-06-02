class Snake
    def initialize(initialBody, initialDirection)
        @body = initialBody
        @direction = initialDirection
    end

    def takeStep(position)
        @body = @body[1..-1] + [position]
    end

    def body
        @body
    end

    def direction
        @direction
    end

    def setDirection=(newDirection)
        @direction = newDirection
    end

    def grows(newTailCoords)
        @body << newTailCoords
    end

    def head
        return @body.last
    end
end