module vector

struct Vector4
    data: @[4:float]

    fn vec3(): Vector3
        return vec3(self.data[0], self.data[1], self.data[2])
    end
end


struct Vector3
    data: @[3:float]
end


fn vec3(): Vector3
    return Vector3{}
end


fn vec3(x: float, y: float, z: float): Vector3
    local v3 = Vector3{}
    v3.data[0] = x
    v3.data[1] = y
    v3.data[2] = z

    return v3
end


fn vec4(): Vector4
    return Vector4{}
end


fn vec4(x: float, y: float, z: float, w: float): Vector4
    local v4 = Vector4{}
    v4.data[0] = x
    v4.data[1] = y
    v4.data[2] = z
    v4.data[3] = w

    return v4
end
