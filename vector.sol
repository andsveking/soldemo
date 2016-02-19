module vector

struct Vector4
    x: float
    y: float
    z: float
    w: float

    fn vec3(): Vector3
        return vec3(self.x, self.y, self.z)
    end
end


struct Vector3
    x: float
    y: float
    z: float
end


fn vec3(): Vector3
    return Vector3{}
end


fn vec3(x: float, y: float, z: float): Vector3
    return Vector3{x=x, y=y, z=z}
end


fn vec4(): Vector4
    return Vector4{}
end


fn vec4(x: float, y: float, z: float, w: float): Vector4
    return Vector4{x=x, y=y, z=z, w=w}
end
