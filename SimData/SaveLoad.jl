module SaveLoad
    using Serialization


    export save_content, load_content

    function save_content(filepath::String, content)
        open(filepath, "w") do io
            serialize(io, content)
        end
    end

    function load_content(filepath::String)
        open(filepath, "r") do io
            return deserialize(io)
        end
    end
end