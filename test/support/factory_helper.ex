defmodule Constable.FactoryHelper do
  defmacro factory(factory_name, do: block) do
    quote do
      def factory(unquote(factory_name), var!(attrs)) do
        !var!(attrs) # Removes unused variable warning if attrs wasn't used
        unquote(block)
      end
    end
  end

  defmacro assoc(factory_name) do
    quote do
      assoc(var!(attrs), unquote(factory_name)).id
    end
  end
end
