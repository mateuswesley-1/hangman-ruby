require 'json'


## estamos criando um modulo, para usar dentro de qualquer classe
module BasicSerializable
  # allow us to change our serialization method
  @@serializer = JSON

  def serialize
    # transforma as variaveis do obj em uma hash
    # para dps serializar, transformando em json ou YAML
    obj = {}
    # para cada variavel de instancia objeto, cria um valor na hash
    # com a variavel como key e o valor da variavel como value
    instance_variables.map do |var|
      obj[var] = instance_variable_get(var)
    end
    # transforma a hash em JSON ou YAML
    @@serializer.dump obj
  end

  def unserialize(string)
    obj = @@serializer.parse(string)
    obj.each_key do |key|
      instance_variable_set(key, obj[key])
    end
  end
end
