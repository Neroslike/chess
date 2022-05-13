require 'pry-byebug'
class Array
  def add_array(arr)
    [self[0] + arr[0], self[1] + arr[1]]
  end

  def valid?
    (self[0] > -1 && self[1] > -1) && (self[0] < 8 && self[1] < 8)
  end
end

class Node
  attr_accessor :data, :up, :right, :left, :down

  def initialize(data)
    @data = data
    @up = nil
    @down = nil
    @left = nil
    @right = nil
  end
end

class Graph
  attr_accessor :graph

  @@MOVES = { up: [1, 0], down: [-1, 0], left: [0, -1], right: [0, 1] }

  def initialize(node)
    @graph = build_graph(node)
  end

  def build_graph(node, queue = [])
    queue << node
    right = node.data.add_array(@@MOVES[:right])
    up = node.data.add_array(@@MOVES[:up])
    down = node.data.add_array(@@MOVES[:down])
    populate_right(right, down, node, queue)
    node.down = queue.shift if node.data[1] == 7 && !node.data[0].zero?
    populate_up(up, node, queue)
    node
  end

  def populate_right(right, down, node, queue)
    if right.valid?
      node.right = Node.new(right)
      if down.valid? && node.data[1] != 0
        node.down = queue.shift
        node.down.up = node
      end
      build_graph(node.right, queue).left = node
    end
  end

  def populate_up(up, node, queue)
    if up.valid? && node.data[1].zero?
      node.up = Node.new(up)
      node.up.down = queue.shift
      build_graph(node.up, queue)
    end
  end
end

graph = Graph.new(Node.new([0, 0]))
# function that gets a node and a queue to follow these steps:
# 1. add current node to the queue
# 2. check that #right has a valid value, otherwise evaluate next line
#   2.1. if it has a valid value, create a node with that value and assign
#        it to the #right attribute, and assign the current node to the #left
#        attribute of the created node.
#   2.2. if #down has a valid value, shift the queue and assign it to #down
# 3. check that #up has a valid value, and the second value of the node data is 0
#   3.1. if it has a valid value, create a node with that value and assign
#        it to the #up attribute, and assign the current node to the #down
#        attribute of the created node.
# 4. return the node
