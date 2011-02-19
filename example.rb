require 'gater'

g = Gater.new

puts "Active Gates: #{ g.active_gates.inspect }"

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

