require 'gater'

g = Gater.new

g.junction do |switcher|
    switcher.branch :feature1 do |reporter|
        puts "Feature 1 is active"
    end
end

g.junction do |switcher|
    switcher.branch :feature2 do |reporter|
        puts "Feature 2 is active"
    end
end

g.junction do |switcher|
    switcher.branch :feature3 do |reporter|
        puts "Feature 3 is active"
    end
end

# TODO: examples for mutex logic

# Do something special when both feature2 and feature3 are active
g.junction do |switcher|
    switcher.branch :feature2 do |reporter|
        puts "Only Feature 2 is active, all is well"
    end

    switcher.branch [:feature2, :feature3] do |reporter|
        puts "Both features 2 and 3 are active, so I should do something special"
    end
end

# TODO: examples for a default branch

