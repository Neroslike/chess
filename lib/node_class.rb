require 'pry-byebug'
require 'json'
module JSONable
  # Check every node
  # If it has a piece the node hash key will equal another hash
  # that contains the instance variables for that piece
  # else just add nil as the value for the node key
  def to_json(obj = nil)
    hash = {}
    each do |node|
      if node.piece.nil?
        hash[node.data] = node.piece
      else
        hash[node.data] = {}
        node.piece.instance_variables.each do |var|
          hash[node.data][var] = node.piece.instance_variable_get var
        end
      end
    end
    JSON.generate(hash)
  end

  def from_json!(string)
    JSON.parse(string).each do |var, val|
      if val.nil?
        @board.traverse(var.to_array).remove_piece
      else
        clazz = Kernel.const_get(val['@name']).new(val['@color'])
        place_piece(translate(var.to_array), clazz)
      end
    end
  end
end
class Array
  def add_array(arr)
    [self[0] + arr[0], self[1] + arr[1]]
  end

  def legal_move?
    (self[0] < 8 && self[0] > -1) && (self[1] < 8 && self[1] > -1)
  end

  def diagonal?(array)
    self[0] != array[0] && self[1] != array[1]
  end
end

class String
  def to_array
    [self[1].to_i, self[4].to_i]
  end
end

class NilClass
  def data
    ''
  end
end

class Node
  attr_accessor :piece, :data, :up, :right, :left, :down, :char
  include JSONable

  @@MOVES = { up: [1, 0], down: [-1, 0], left: [0, -1], right: [0, 1] }

  def initialize(data)
    @data = data
    @piece = nil
    @char = '    '
    @up = nil
    @down = nil
    @left = nil
    @right = nil
  end

  def remove_piece
    @piece = nil
    @char = '    '
  end

  def empty?
    @piece.nil?
  end

  def to_s
    "Data: #{@data}\nPiece: #{@piece}\nChar: #{@char}\nUp: #{@up.data}\nDown: #{@down.data}\nLeft: #{@left.data}\nRight: #{@right.data}"
  end

  def inspect
    "Node\nObject ID: #{object_id}\nData: #{@data}\nPiece: #{@piece}\nChar: #{@char}\nUp: #{@up.data}\nDown: #{@down.data}\nLeft: #{@left.data}\nRight: #{@right.data}"
  end

  # Method to build the graph, we first set 3 movement variables
  # to prevent the board from building infinitely.
  def build_graph(node = self, queue = [])
    queue << node
    populate_right(node.data.add_array(@@MOVES[:right]), node.data.add_array(@@MOVES[:down]), node, queue)
    if node.data[1] == 7 && !node.data[0].zero?
      node.down = queue.shift
      node.down.up = node
    end
    populate_up(node.data.add_array(@@MOVES[:up]), node, queue)
    node
  end

  def reset_graph
    each do |node|
      node.remove_piece
    end
  end

  def populate_right(right, down, node, queue)
    if right.legal_move?
      node.right = Node.new(right)
      if down.legal_move? && node.data[1] != 0
        node.down = queue.shift
      end
      node.down.up = node unless node.down.nil?
      build_graph(node.right, queue).left = node
    end
  end

  def populate_up(up, node, queue)
    if up.legal_move? && node.data[1].zero?
      node.up = Node.new(up)
      node.up.down = queue.shift
      build_graph(node.up, queue)
    end
  end

  def pretty_print(output = '', node = top_node)
    until node.nil?
      output += "(#{node.data[0]}, #{node.data[1]}) -"
      right = node.right
      until right.nil? do
        right.data[1] == 7 ? output += " (#{right.data[0]}, #{right.data[1]})\n" : output += " (#{right.data[0]}, #{right.data[1]}) -"
        right = right.right
      end
      node = node.down
    end
    puts output
  end

  # each method starting from 0,0
  def each(node = self, &block)
    block.call(node)
    each(node.right, &block) unless node.right.nil?
    each(node.up, &block) if !node.up.nil? && node.up.data[1].zero?
    node
  end

  def traverse(to, from = self)
    return nil unless to.legal_move?
    return from if from.data == to

    return traverse(to, from.down) if from.data[0] > to[0] 

    return traverse(to, from.up) if from.data[0] < to[0]

    return traverse(to, from.left) if from.data[1] > to[1] 

    return traverse(to, from.right) if from.data[1] < to[1]
  end

  def top_node
    graph = graph.up until graph.up.nil?
    graph
  end
end
