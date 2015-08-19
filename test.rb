# -*- mode:ruby; coding:utf-8 -*-
require 'mecab'
c = MeCab::Tagger.new
puts c.parse("すもももももももものうち")

skilldic = []
skilltag = []

File.foreach('dic.txt') do |skill|
  skilldic.push(skill.chomp)
end

File.foreach('test.txt') do |test|
  # labmenには読み込んだ行が含まれる
#  puts c.parse(test)
  node = c.parseToNode(test)
  until node.stat == 3 do
    node = node.next
    feature = node.feature.to_s.gsub(/ /,'').split(",")
    if /名詞/u =~ feature[0].force_encoding('utf-8')
      unless /数|記号|読点|括弧|接尾/u =~ feature[1].force_encoding('utf-8')
        skilldic.each do |skill|
          if node.surface.upcase == skill.upcase
            temp = 0
            skilltag.each do |skilltag|
              if skilltag == node.surface
                temp = 1
              end
            end

            if temp == 0
              puts "#{node.surface}"
              skilltag.push(node.surface)
            end
          end
        end
      end
    end
  end
end
