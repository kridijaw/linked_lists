# frozen_string_literal: true

require_relative './node'
require_relative './display'

# A linked list is a linear collection of data elements (nodes)
# which point to the next node by means of a pointer.
# [ NODE(head) ] -> [ NODE ] -> [ NODE(tail) ] -> nil
class LinkedList
  include Display
  attr_accessor :head_node

  # Adds a new node with given value to the end of self.
  #
  # @param value [Object] the value of the new node
  # @return [Node] the new node
  def append(value)
    if list_empty?
      @head_node = Node.new(value)
    else
      tail.next_node = Node.new(value)
    end
  end

  # Adds a new node with given value to the start of self.
  #
  # @param value [Object] the value of the new node
  # @return [Node] the new node
  def prepend(value)
    @head_node = if list_empty?
                   Node.new(value)
                 else
                   Node.new(value, head)
                 end
  end

  # Returns the total number of nodes of self.
  #
  # @return [Integer] the total number of nodes
  #   or 0 if self is empty
  def size
    traverse('last', 'i')
  end

  # Returns the first node of self.
  #
  # @return [Node] the first node
  #   or nil if self is empty
  def head
    return error_empty_list if list_empty?

    @head_node
  end

  # Returns the last node of self.
  #
  # @return [Node] the last node
  #   or nil if self is empty
  def tail
    traverse('next_to_last', 'selected_node')
  end

  # Returns the node of self at the given Integer index.
  #
  # @param index [Integer] the index of the node
  # @return [Node] the node at the given index
  #   or nil if self is empty
  def at(index)
    return error_index_out_of_range unless index_in_range?(index)

    traverse('next_to_last', 'selected_node', index)
  end

  # Removes the last element from self.
  #
  # @return [Node] the removed node
  #   or nil if self is empty
  def pop
    selected_nodes = # [0,1] = previous node, selected node
      Array.new(traverse('next_to_last', 'previous_node'))

    if selected_nodes[1] == @head_node
      remove_instance_variable(:@head_node)
    else
      selected_nodes[0].next_node = nil
    end
  end

  # Returns true if value is in self and otherwise returns false.
  #
  # @param value [Object] the value to search for
  # @return [Boolean] true if value is in self
  #   or false if self is empty
  def contains?(value)
    result = traverse('last', '', '', value)
    result&.positive? ? true : false
  end

  # Returns the index of the node with given value of self.
  #
  # @param value [Object] the value to search for
  # @return [Integer] the index of the node with given value
  #   or nil if self is empty
  def find(value)
    index = traverse('last', '', '', value)
    return index if index&.positive?

    error_node_not_in_list
  end

  # Returns objects of self as strings in the format:
  # ( value ) -> ( value ) -> ( value ) -> nil
  #
  # @return [String] the objects of self as strings
  #   or nil if self is empty
  def to_s
    return error_empty_list if list_empty?

    traverse('last', 'strings')
  end

  # Inserts node with given value at given Integer index.
  #
  # @param value [Object] the value of the new node
  # @param index [Integer] the index of the new node
  # @return [Node] the new node
  def insert_at(value, index)
    return error_index_out_of_range unless index_in_range?(index, 1)

    selected_nodes = # [0,1] = previous node, selected node
      Array.new(traverse('index_found', 'previous_node', index))

    prepend(value) && return if selected_nodes[1] == @head_node

    selected_nodes[0].next_node = nil
    tmp = Node.new(value, selected_nodes[1])
    selected_nodes[0].next_node = tmp
  end

  # Removes node from self at given Integer index.
  #
  # @param index [Integer] the index of the node to remove
  # @return [Node] the removed node
  def remove_at(index)
    error_index_out_of_range unless index_in_range?(index)

    selected_nodes = # [0,1] = previous node, selected node
      Array.new(traverse('index_found', 'previous_node', index))

    if selected_nodes[1] == @head_node
      @head_node = head_node.next_node
      return
    end

    selected_nodes[0].next_node = selected_nodes[1].next_node
  end

  # Returns true if self has no objects and false otherwise.
  #
  # @return [Boolean] true if self has no objects
  #   or false if self has objects
  def list_empty?
    !instance_variable_defined?(:@head_node)
  end

  # Returns true if index of self is within its size.
  #
  # @param index [Integer] the index to check
  # @param offset [Integer] the offset to add to size
  # @return [Boolean] true if index is within size
  #   or false if index is out of range
  def index_in_range?(index, offset = 0)
    (index < (size + offset)) && index >= 0
  end

  # Returns a method finish the traverse of self.
  #
  # @param last_node [String] the last node to stop at
  # @return [String] the method to finish the traverse
  def traverse_until(last_node)
    case last_node
    when 'last'           # stop at tail
      method = 'selected_node.is_a?(Node) == true'
    when 'next_to_last'   # stop next to tail
      method = 'selected_node.next_node.nil? == false'
    when 'index_found'    # stop after index is found
      method = 'index != i'
    end
    method
  end

  # Starts with head and access each node until last_node.
  #
  # @param last_node [String] the last node to stop at
  # @param var_to_return [String] the variable to return
  # @param index [Integer] the index to stop at
  # @param value [Object] the value to stop at
  # @return [Node, Integer, String] the selected node, index or strings
  def traverse(last_node, var_to_return, index = -1, value = nil)
    return error_empty_list if list_empty?

    method = traverse_until(last_node)

    i = 0
    selected_node = @head_node
    strings = "( #{@head_node.value} )"

    while instance_eval(method)
      return selected_node if index == i
      return i if value == selected_node.value

      previous_node = selected_node
      selected_node = selected_node.next_node
      strings = "#{strings} -> ( #{selected_node&.value} )" if selected_node&.value
      i += 1
    end

    case var_to_return
    when 'strings' then "#{strings} -> nil"
    when 'previous_node' then [previous_node, selected_node]
    when var_to_return then instance_eval(var_to_return)
    end
  end
end
