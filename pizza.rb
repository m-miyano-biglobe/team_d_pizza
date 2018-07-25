class OrderList
  attr_accessor :order
	def initialize
		@order = []
  end

  def add_order(order)
    @order.push(order)
  end

	def self.create_id
		# idを自動生成させる。
    Time.now().strftime("%Y%m%d%H%M%S")
	end
end

class Order
  attr_reader :id, :status, :customer, :product
  attr_accessor :uber_id
	def initialize(name, address, count)
    @status = Status.new
		@id = OrderList.create_id
    @customer = Customer.new(name, address)
    @product = OrderedProduct.new(count)
  end

  def profit
    if @status.is_deliveried
      @product.count * @product.price
    end
  end
end

class Customer
	attr_reader :name, :address
	def initialize(name, address)
		@name = name
		@address = address
	end
end

class OrderedProduct
  attr_reader :count, :name, :price
	def initialize(count)
		@count = count
		@name = 'マルゲリータ'
		@price = 500
  end
end

class Status
  attr_accessor :status
 	def initialize
		@status = OrderedStatus.new
  end

  def is_deliveried
    @status.name == '配達完了'
  end

  def to_next_status
    case @status.name
    when '申し込み'
      @status = CookingStatus.new
    when '調理中'
      @status = DeliveryStatus.new
    when '配達'
      @status = CompleteStatus.new
    end
  end
end

class OrderedStatus
  attr_reader :name
	def initialize
		@name = '申し込み'
	end
end

class CookingStatus
  attr_reader :name
	def initialize
		@name = '調理中'
	end
end

class DeliveryStatus
  attr_reader :name
	def initialize
		@name = '配達'
	end
end

class CompleteStatus
  attr_reader :name
	def initialize
		@name = '配達完了'
	end
end

class Main
  load './pizza_list.rb'
  load './topping_list.rb'
  
  ORDER_LIST = OrderList.new

  def initialize
    # 注文
		print "名前："
    
		name = gets.chomp!
    print "住所："
		address = gets.chomp!

    ordering = true
    order_list = []
    while(ordering)
      print "以下からピザを選択してください\n"
      print "#{PizzaList.new.pizzas.map(&:name).join(' ')}\n"
      print "ピザ："
      pizza = gets.chomp!
      print "ピザの枚数："
      pizza_count = gets.to_i
      print "トッピングは必要ですか(y/n):"
      need_topping = gets.chomp! == 'y'
      toppings = []
      while(need_topping)
        print "以下からトッピングを選択してください\n"
        print "#{ToppingList.new.toppings.map(&:name).join(' ')}\n"
        print "トッピング："
        toppings << gets.chomp!
        print "トッピングの追加を終了しますか(y/n):"
        need_topping = !(gets.chomp! == 'y')
      end
      print "注文を終了しますか(y/n):"
      ordering = !(gets.chomp! == 'y')
      order_list << [pizza, pizza_count, toppings]
    end

    ORDER_LIST.add_order(name, address, order_list)

    # 調理中
    ORDER_LIST.order.each do |item|
      item.status.to_next_status
    end
    # 配達
    ORDER_LIST.order.each do |item|
      item.status.to_next_status
      item.uber_id = 'uber_id'
    end
    # 配達完了
    ORDER_LIST.order.each do |item|
      item.status.to_next_status
      p item.profit
    end
  end
end

Main.new
