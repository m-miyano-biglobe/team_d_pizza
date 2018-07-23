class ToppingList
  require 'json'
  JSON_FILE_PATH = './master.json'

  attr_accessor :toppings

  def initialize
    # 読み込んで
    json = open(JSON_FILE_PATH) do |io|
      JSON.load(io)
    end
    json.each do |category, items|
      if category == 'toppings'
        @toppings = items.map do |_, data|
          Topping.new(data['id'], data['name'], data['price'])
        end
      end
    end
  end

  def topping_by_name(name)
    @toppings.find{|t| t.name == name}
  end

  def topping_by_id(id)
  @toppings.find{|t| t.id == id}
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

