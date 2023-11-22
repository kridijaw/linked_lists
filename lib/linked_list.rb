# frozen_string_literal: false

require_relative './node'

# https://www.theodinproject.com/lessons/ruby-linked-lists

#------------------------------------------------------------------------------#
# Todo LinkedList Methods:

# #at(index) returns the node at the given index

# #pop removes the last element from the list

# #contains?(value) returns true if the passed in value is in the list
# and otherwise returns false.

# #find(value) returns the index of the node containing value,
# or nil if not found.

# #to_s represent your LinkedList objects as strings,
# so you can print them out and preview them in the console.
# format: ( value ) -> ( value ) -> ( value ) -> nil

# extra:
# #insert_at(value, index) that inserts a new node with
# the provided value at the given index.
# cave: update #next_node link for affected nodes

# #remove_at(index) that removes the node at the given index.
# cave: update #next_node link for affected nodes
#------------------------------------------------------------------------------#

# Linear collection of data elements (nodes) which
# point to the next node by means of a pointer.
# [ NODE(head) ] -> [ NODE ] -> [ NODE(tail) ] -> nil
class LinkedList
  attr_accessor :head_node

  # Initialize with nil valued head node
  def initialize
    @head_node = Node.new
  end

  # Adds a new node containing value to the end of the list
  def append(value)
    @tail_node = Node.new(value)
    if @head_node.value.nil?
      @head_node = @tail_node
    else
      tail.next_node = @tail_node
    end
  end

  # Adds a new node containing value to the start of the list
  def prepend(value)
    @head_node = if @head_node.value.nil?
                   Node.new(value)
                 else
                   Node.new(value, head)
                 end
  end

  # Returns the total number of nodes in the list
  def size
    nil
  end

  # Returns the first node in the list
  def head
    @head_node
  end

  # Returns the last node in the list
  def tail
    selected_node = @head_node
    selected_node = selected_node.next_node until selected_node.next_node.nil?
    selected_node
  end
end

list = LinkedList.new
list.prepend('node1')
p list.head
list.append('node2')
p list.head
list.prepend('node0')
p list.head
list.append('node3')
p list.head
