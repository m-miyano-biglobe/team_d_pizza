class PizzaList
  require 'json'
  JSON_FILE_PATH = './master.json'

  attr_accessor :pizzas

  def initialize
    # 読み込んで
    json = open(JSON_FILE_PATH) do |io|
      JSON.load(io)
    end
    json.each do |category, items|
      if category == 'pizzas'
        @pizzas = items.map do |_, data|
          Pizza.new(data['id'], data['name'], data['price'], data['toppings'])
        end
      end
    end
  end

  def pizza_by_name(name)
    @pizzas.find{|p| p.name == name}
  end

  def pizza_by_id(id)
    @pizzas.find{|p| p.id == id}
  end

  class Pizza
    attr_accessor :id, :name, :price, :topping_ids
    def initialize(id, name, price, toppings)
      @id = id
      @name = name
      @price = price
      @topping_ids = toppings
    end
  end
end