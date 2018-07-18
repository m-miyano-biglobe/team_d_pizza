class Menu
  require 'json'
  JSON_FILE_PATH = './master.json'

  attr_accessor :pizzas, :toppings

  def initialize
    # 読み込んで
    json = open(JSON_FILE_PATH) do |io|
      JSON.load(io)
    end
    json.each do |category, items|
      case category
      when 'pizzas'
        @pizzas = items.map do |_, data|
          Pizza.new(data['id'], data['name'], data['price'], data['toppings'])
        end
      when 'toppings'
        @toppings = items.map do |_, data|
          Topping.new(data['id'], data['name'], data['price'])
        end
      end
    end
  end

  def pizza_id_by_name(name)
    @pizzas.find{|p| p.name == name}.id
  end

  def topping_id_by_name(name)
    @toppings.find{|p| p.name == name}.id
  end

  def pizza_name_list
    @pizzas.map(&:name)
  end

  def topping_name_list
    @toppings.map(&:name)
  end

  class Pizza
    attr_accessor :id, :name, :price, :toppings
    def initialize(id, name, price, toppings)
      @id = id
      @name = name
      @price = price
      @toppings = toppings
    end
  end

  class Topping
    attr_accessor :id, :name, :price
    def initialize(id, name, price)
      @id = id
      @name = name
      @price = price
    end
  end
end
