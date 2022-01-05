class String
  def is_i?
    /\A[-+]?\d+\z/ === self
  end
end

class Node
  attr_accessor :value, :next

  def initialize(value, temp=nil)
    @value = value
    @next = temp
  end
end

class TreeNode
  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end

class BST
  attr_accessor :root, :size, :pi, :pp

  @pi = []
  @pp = []

  def initialize()
    @root = nil
    @size = 0
  end

  def insert(value)
    if @root == nil
      @root = TreeNode.new(value)
    else
      cur = @root
      prev = @root

      while cur != nil
        prev = cur
        cur = value<cur.value ? cur.left : cur.right
      end

      if value < prev.value
        prev.left = TreeNode.new(value)
      else
        prev.right = TreeNode.new(value)
      end
    end
    @size +=1
  end

  def loadit()
    f = open("data_bst.txt")
    arr = f.readlines.map(&:chomp)
    inorder = arr[0].split(" ").map(&:to_i)
    preorder = arr[1].split(" ").map(&:to_i)
    @preIndex = 0
    @size = inorder.size
    @root = build(inorder, preorder, 0, inorder.size-1)
  end

  def build(inorder, preorder, s, e)
    return nil if s>e
    temp = TreeNode.new(preorder[@preIndex])
    @preIndex += 1
    return temp if s == e
    idx = search(inorder, s, e, temp.value)
    temp.left = build(inorder, preorder, s, idx-1)
    temp.right = build(inorder, preorder, idx+1, e)
    temp
  end

  def search(arr, s, e, val)
    s..(e+1).times{|n| return n if arr[n] == val}
  end

  def find_max(node = self.root)
    return nil if node == nil
    return node if node.right == nil
    find_max(node.right)
  end

  def find_min(node = self.root)
    return nil if node == nil
    return node if node.left == nil
    find_min(node.left)
  end

  def contains?(value, node = self.root)
    if node == nil
      return false
    elsif value < node.value
      return contains?(value, node.left)
    elsif value > node.value
      return contains?(value, node.right)
    else
      return true
    end
  end

  def print_inorder(node = self.root)
    if node != nil
      print_inorder(node.left)
      print "#{node.value}, "
      print_inorder(node.right)
    end
  end

  def print_preorder(node = self.root)
    if node != nil
      print "#{node.value}, "
      print_preorder(node.left)
      print_preorder(node.right)
    end
  end

  def print_postorder(node = self.root)
    if node != nil
      print_postorder(node.left)
      print_postorder(node.right)
      print "#{node.value}, "
    end
  end

  def print_levelorder(node = self.root)
    if node != nil
      queue = []
      queue << node
      while queue.size > 0
        print "#{queue[0].value}, "
        node = queue.shift
        queue << node.left if node.left != nil
        queue << node.right if node.right != nil
      end
    end
  end

  def ppi(node = self.root)
    if node != nil
      ppi(node.left)
      @pi << "#{node.value} "
      ppi(node.right)
    end
  end

  def ppp(node = self.root)
    if node != nil
      @pp << "#{node.value} "
      ppp(node.left)
      ppp(node.right)
    end
  end

  def save()
    @pi = []
    @pp = []
    f = File.open("data_bst.txt","w+")
    ppi()
    ppp()
    inorder = ""
    preorder = ""
    @pi.each{|n| inorder+=n.to_s}
    @pp.each{|n| preorder+=n.to_s}
    f.write(inorder)
    f.write("\n")
    f.write(preorder)
    f.write("\n")
    f.close
    puts "file Saved\n\n"
  end

  def pathp(node = self.root)
    path = []
    printp(node, path, 0)
  end

  def printp(node, path, l)
    return nil if node == nil
    if path.size > l
      path[l] = node.value
    else
      path << node.value
    end

    l+=1
    if node.left == nil && node.right == nil
      printArr(path, l)
    else
      printp(node.left, path, l)
      printp(node.right, path, l)
    end
  end

  def printArr(arr, l)
    arr.each{|n| print "#{n}, "}
    print "end\n"
  end

  def remove(value, node = self.root)
    rh(value, node = self.root)
    @size -=1
    node
  end

  private
  def rh(value, node = self.root)
    return nil if node == nil
    if node.value > value
      node.left = rh(value, node.left)
    elsif node.value < value
      node.right = rh(value, node.right)
    else
      if node.left != nil && node.right != nil
        temp = node
        rmin = find_min(node.right)
        node.value = rmin.value
        node.right = rh(rmin.value, node.right)
      elsif node.left != nil
        node = node.left
      elsif node.right != nil
        node = node.right
      else
        node = nil
      end
    end
    node
  end
end

class LinkedList

  def initialize
    @head = nil
  end

  def append(value)
    if @head
      find_tail.next = Node.new(value)
    else
      @head = Node.new(value)
    end
  end

  def find_tail
    node = @head
    return node if !node.next
    return node if !node.next while (node = node.next)
  end

  def append_after(target, value)
    node = find(target)
    return unless node
    node.next = Node.new(value, node.next)
  end

  def find(value)
    node = @head
    return false if node == nil
    while node != nil
      return true if node.value == value
      node = node.next
    end
    return false
  end

  def delete(value)
    if @head == nil || !find(value)
      puts "not in the list"
      return nil
    end
    if @head.value == value
      @head = @head.next
    else
      node = find_before(value)
      node.next = node.next.next
    end
    puts "#{value} is deleted\n\n"
  end

  def find_before(value)
    node = @head

    return false if !node.next
    return node  if node.next.value == value

    while (node = node.next)
      return node if node.next && node.next.value == value
    end
  end

  def reverse()
    return nil if @head == nil
    prev = nil
    curr = @head
    while curr!=nil
      nxt = curr.next
      curr.next = prev
      prev = curr
      curr = nxt
    end
    @head = prev
  end

  def printll()
    if @head == nil
      puts "Empty list"
      return nil
    end
    puts "Printing the Linked List"
    node = @head
    print "#{node.value}, "

    while (node = node.next)
      print "#{node.value}, "
    end
    puts "end"
  end
end


t = BST.new()
ll = LinkedList.new()

def ll_menu(ll)
  while true
    puts "Select from the given options"
    puts "  Enter 1 to insert into end of linked list"
    puts "  Enter 2 to delete a value"
    puts "  Enter 3 to search a value"
    puts "  Enter 4 to reverse the linked list"
    puts "  Enter 5 to print the linked list"
    puts "  Enter anything else to go to main menu"

    option = gets.chomp
    system("clear")
    break unless option.is_i?
    option = option.to_i

    if option == 1
      puts "enter the value you want to insert"
      v = gets.chomp.to_i
      ll.append(v)
      puts "#{v} inserted in the end of linked list\n"
      next
    end

    if option == 2
      puts "enter the value you want to delete"
      v = gets.chomp.to_i
      ll.delete(v)
      next
    end

    if option == 3
      puts "enter the value you want to find"
      v = gets.chomp.to_i
      puts ll.find(v) ? "value found" : "value not found"
      next
    end

    if option == 4
      puts "the linked list is reversed"
      ll.reverse()
      next
    end

    if option == 5
      ll.printll()
      next
    end
  end
end

def bst_menu(t)

  while true
    puts "Select from the given options"
    puts "  Enter 0: to insert multiple elements"
    puts "  Enter 1: to insert value"
    puts "  Enter 2: to delete value"
    puts "  Enter 3: to print BST"
    puts "  Enter 4: to find Max"
    puts "  Enter 5: to find Min"
    puts "  Enter 6: to find if value exists"
    puts "  Enter 7: to print all paths from root"
    puts "  Enter 8: to load the last saved bst"
    puts "  Enter quit to save and exit to main menu"
    puts "  Enter anything else to go to main menu"

    option = gets.chomp
    system("clear")
    if !option.is_i?
      t.save() if option.downcase == "quit"
      break
    end
    option = option.to_i

    if option == 0
      puts "enter multiple elements sepreated with ,"
      arr = gets.chomp.split(",").map(&:to_i)
      arr.each{|i| t.insert(i)}
      puts "\n\n"
      next
    end

    if option == 1
      puts "Enter the value you want to insert"
      v = gets.to_i
      t.insert(v)
      puts "\n#{v} was inserted in the tree"
      puts "size of the tree now is #{t.size} \n\n"
      next
    end

    if option == 2
      puts "Enter the value you want to delete"
      v = gets.to_i
      if t.contains?(v)
        t.remove(v)
        puts "\n#{v} was deleted from the tree"
        puts "size of the tree now is #{t.size} \n\n"
      else
        puts "value not found can't delete it \n\n"
      end
      next
    end

    if option == 3
      puts "Printing the tree in InOrder"
      t.print_inorder()
      puts "end\n Printing the tree in PreOrder"
      t.print_preorder()
      puts "end\n Printing the tree in PostOrder"
      t.print_postorder()
      puts "end\n Printing the tree in LevelOrder"
      t.print_levelorder()
      puts "end\n\n"
      next
    end

    if option == 4
      puts "the maximum is #{t.find_max().value}\n\n"
      next
    end

    if option == 5
      puts "the minimum is #{t.find_min().value}\n\n"
      next
    end

    if option == 6
      puts "Enter value to search it in treee"
      v = t.contains?(gets.to_i)
      puts v ? "value exists" : "value does't exists"
      next
    end

    if option == 7
      puts "Printing all paths from Root"
      t.pathp()
      puts "\n\n"
      next
    end

    if option == 8
      t.loadit()
      puts "Data loaded from the file\n\n"
    end
  end
end

while true
  # option to choose between LL and bst
  puts "Select the tool to use"
  puts "  Enter 1: for using BST functions"
  puts "  Enter 2: for using LL functions"
  puts "  Enter 'exit' to quit the tool"
  o = gets.chomp
  break if o.downcase == "exit"
  o = o.to_i
  system("clear")
  bst_menu(t) if o == 1
  ll_menu(ll) if o == 2
  puts "Incorrect input try again\n" if o!=1 && o!=2
end
system("clear")
