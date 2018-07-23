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
  attr_reader :pizza_id, :count, :toppings
  def initialize(pizza_id, count, *toppings)
    @pizza_id = pizza_id
    @count = count
    @toppings = add_topping(*toppings)
  end

  # 追加のトッピングのlistを返す
  def add_topping(*toppings)
    topping_list = []
    toppings.each do |topping_id|
      # ピザクラスからベーストッピングIDのリストを取得
      # 追加トッピングIDがベーストッピングリストになければtopping_listに追加
    end
    p topping_list
  end

  # 注文商品の金額を返す
  def product_price
    #(ピザクラスから取得した金額 + 追加トッピングの金額) * count
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
  ORDER_LIST = OrderList.new

  def initialize
    # 注文
		print "名前："
		name = gets
		print "住所："
		address = gets
		print "マルゲリータの枚数："
		count = gets.to_i
    ORDER_LIST.add_order(Order.new(name, address, count))
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
