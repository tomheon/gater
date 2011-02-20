require 'lib/gater'

Gater.junction do |switcher|
    switcher.branch :feature1 do |reporter|
        puts "Feature 1 is active"
    end

    switcher.branch do |reporter|
        puts "Feature 1 isn't active"
    end
end

Gater.junction do |switcher|
    switcher.branch :feature2 do |reporter|
        puts "Feature 2 is active"
    end

    switcher.branch :feature3 do |reporter|
        puts "Feature 3 is active"
    end

    switcher.branch [:feature2, :feature3] do |reporter|
        puts "Both features 2 and 3 are active, so I should do something special"
    end
end


