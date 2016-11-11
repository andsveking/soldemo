module matrix

require math
require vector


struct Matrix
    data: @[16:float]

    fn rotate_X(angle: float): Matrix
        local s = math.sin(angle);
        local c = math.cos(angle);
        local R = Matrix{}

        R.data[0] = 1.0f
        R.data[1] = 0.0f
        R.data[2] = 0.0f
        R.data[3] = 0.0f
        R.data[4] = 0.0f
        R.data[5] = c
        R.data[6] = s
        R.data[7] = 0.0f
        R.data[8] = 0.0f
        R.data[9] = -s
        R.data[10] = c
        R.data[11] = 0.0f
        R.data[12] = 0.0f
        R.data[13] = 0.0f
        R.data[14] = 0.0f
        R.data[15] = 1.0f

        return multiply(R, self)
    end

    function rotate_Y(angle: float): Matrix
        local s = math.sin(angle)
        local c = math.cos(angle)
        local R =  Matrix{}

        R.data[0] = c
        R.data[1] = 0.0f
        R.data[2] = s
        R.data[3] = 0.0f
        R.data[4] = 0.0f
        R.data[5] = 1.0f
        R.data[6] = 0.0f
        R.data[7] = 0.0f
        R.data[8] = -s
        R.data[9] = 0.0f
        R.data[10] = c
        R.data[11] = 0.0f
        R.data[12] = 0.0f
        R.data[13] = 0.0f
        R.data[14] = 0.0f
        R.data[15] = 1.0f

        return multiply(R, self)
    end

    function rotate_Z(angle: float): Matrix
        local s = math.sin(angle)
        local c = math.cos(angle)
        local R = Matrix{}

        R.data[0] = c
        R.data[1] = s
        R.data[2] = 0.0f
        R.data[3] = 0.0f
        R.data[4] = -s
        R.data[5] = c
        R.data[6] = 0.0f
        R.data[7] = 0.0f
        R.data[8] = 0.0f
        R.data[9] = 0.0f
        R.data[10] = 1.0f
        R.data[11] = 0.0f
        R.data[12] = 0.0f
        R.data[13] = 0.0f
        R.data[14] = 0.0f
        R.data[15] = 1.0f

        return multiply(R, self)
    end
end


fn ortho(l: float, r: float, b: float, t: float, n: float, f: float): Matrix
    local mtx = Matrix{}

    --x, y
    mtx.data[0] = 2.0f/(r-l);
    mtx.data[1] = 0.0f;
    mtx.data[2] = 0.0f;
    mtx.data[3] = -(r+l)/(r-l);

    mtx.data[4] = 0.0f;
    mtx.data[5] = 2.0f/(t-b);
    mtx.data[6] = 0.0f;
    mtx.data[7] = -(t+b)/(t-b);

    mtx.data[8] = 0.0f;
    mtx.data[9] = 0.0f;
    mtx.data[10] = -2.0f/(f-n);
    mtx.data[11] = -(f+n)/(f-n);

    mtx.data[12] = 0.0f;
    mtx.data[13] = 0.0f;
    mtx.data[14] = 0.0f;
    mtx.data[15] = 1.0f;

    return mtx
end


function persp(l: float, r: float, b: float, t: float, n: float, f: float): Matrix
    local mtx = Matrix{}

    --x, y
    mtx.data[0] = 2.0f/(r-l);
    mtx.data[1] = 0.0f;
    mtx.data[2] = -(r+l)/(r-l);
    mtx.data[3] = 0.0f;

    mtx.data[4] = 0.0f;
    mtx.data[5] = 2.0f/(t-b);
    mtx.data[6] = -(t+b)/(t-b);
    mtx.data[7] = 0.0f;

    mtx.data[8] = 0.0f;
    mtx.data[9] = 0.0f;
    mtx.data[10] = -(f+n)/(n-f);
    mtx.data[11] = -2.0f*f*n/(n-f);

    mtx.data[12] = 0.0f;
    mtx.data[13] = 0.0f;
    mtx.data[14] = -1.0f;
    mtx.data[15] = 0.0f;
    return mtx
end


function scale(x:float, y:float, z:float): Matrix
    local mtx = Matrix{}
    mtx.data[0] = x
    mtx.data[1] = 0.0f
    mtx.data[2] = 0.0f
    mtx.data[3] = 0.0f

    mtx.data[4] = 0.0f
    mtx.data[5] = y
    mtx.data[6] = 0.0f
    mtx.data[7] = 0.0f

    mtx.data[8] = 0.0f
    mtx.data[9] = 0.0f
    mtx.data[10] = z
    mtx.data[11] = 0.0f

    mtx.data[12] = 0.0f
    mtx.data[13] = 0.0f
    mtx.data[14] = 0.0f
    mtx.data[15] = 1.0f
    return mtx
end


function ident(): Matrix
    return scale(1.0f, 1.0f, 1.0f)
end


function trans(x:float, y:float, z:float): Matrix
    local mtx = ident()
    mtx.data[3] = x
    mtx.data[7] = y
    mtx.data[11] = z
    return mtx
end


fn multiply(a: Matrix, b: Matrix): Matrix
    local result = Matrix{}
    for c=0, 4 do
        for d=0, 4 do
            local sum = 0.0f
            for k=0, 4 do
                sum = sum + a.data[4*c + k] * b.data[4*k + d]
            end
            result.data[4*c + d] = sum
        end
    end
    return result
end


fn interp(a: Matrix, b: Matrix, t:float): Matrix
    local mtx = Matrix{}
    for c=0, 16 do
        mtx.data[c] = a.data[c] * (1f-t) + b.data[c] * t
    end
    return mtx
end


function multiply(mtx: Matrix, vec: vector.Vector3): vector.Vector3
    local out = vector.Vector3{}
    out.x = mtx.data[4*0+0] * vec.x + mtx.data[4*0+1] * vec.y + mtx.data[4*0+2] * vec.z
    out.y = mtx.data[4*1+0] * vec.x + mtx.data[4*1+1] * vec.y + mtx.data[4*1+2] * vec.z
    out.z = mtx.data[4*2+0] * vec.x + mtx.data[4*2+1] * vec.y + mtx.data[4*2+2] * vec.z
    return out
end


function multiply(mtx: Matrix, vec: vector.Vector4): vector.Vector4
    local out = vector.Vector4{}
    out.x = mtx.data[4*0+0] * vec.x + mtx.data[4*0+1] * vec.y + mtx.data[4*0+2] * vec.z + mtx.data[4*0+3] * vec.w
    out.y = mtx.data[4*1+0] * vec.x + mtx.data[4*1+1] * vec.y + mtx.data[4*1+2] * vec.z + mtx.data[4*1+3] * vec.w
    out.z = mtx.data[4*2+0] * vec.x + mtx.data[4*2+1] * vec.y + mtx.data[4*2+2] * vec.z + mtx.data[4*2+3] * vec.w
    out.w = mtx.data[4*3+0] * vec.x + mtx.data[4*3+1] * vec.y + mtx.data[4*3+2] * vec.z + mtx.data[4*3+3] * vec.w
    return out
end
