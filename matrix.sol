module matrix

require math

struct Matrix
    data: @[16:float]
end

fn create(): Matrix
    return Matrix{}
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


fn * (a: Matrix, b: Matrix): Matrix
    return multiply(a, b)
end


function multiply(a: Matrix, b: Matrix): Matrix
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


fn rotate_X(Q: Matrix, angle: float): Matrix
    local s = math.sin(angle);
    local c = math.cos(angle);
    local R = Matrix{}

    R.data[0] = 1.f;
    R.data[1] = 0.f;
    R.data[2] = 0.f;
    R.data[3] = 0.f;
    R.data[4] = 0.f;
    R.data[5] =   c;
    R.data[6] =   s;
    R.data[7] = 0.f;
    R.data[8] = 0.f;
    R.data[9] =  -s;
    R.data[10] =   c;
    R.data[11] = 0.f;
    R.data[12] = 0.f;
    R.data[13] = 0.f;
    R.data[14] = 0.f;
    R.data[15] = 1.f;

    return multiply(R, Q)
end

function rotate_Y(Q: Matrix, angle: float): Matrix
    local s = math.sin(angle)
    local c = math.cos(angle)
    local R =  Matrix{}

    R.data[0] = c
    R.data[1] = 0.f
    R.data[2] = s
    R.data[3] = 0.f
    R.data[4] = 0.f
    R.data[5] = 1.f
    R.data[6] = 0.f
    R.data[7] = 0.f
    R.data[8] = -s
    R.data[9] = 0.f
    R.data[10] = c
    R.data[11] = 0.f
    R.data[12] = 0.f
    R.data[13] = 0.f
    R.data[14] = 0.f
    R.data[15] = 1.f

    return multiply(R, Q)
end

function rotate_Z(Q: Matrix, angle: float): Matrix
    local s = math.sin(angle)
    local c = math.cos(angle)
    local R = Matrix{}

    R.data[0] = c
    R.data[1] = s
    R.data[2] = 0.f
    R.data[3] = 0.f
    R.data[4] = -s
    R.data[5] = c
    R.data[6] = 0.f
    R.data[7] = 0.f
    R.data[8] = 0.f
    R.data[9] = 0.f
    R.data[10] = 1.f
    R.data[11] = 0.f
    R.data[12] = 0.f
    R.data[13] = 0.f
    R.data[14] = 0.f
    R.data[15] = 1.f

    return multiply(R, Q)
end

function multiply(mtx: Matrix, vec:[float]) : [float]
    local out = [4:float]
    for k=0, 4 do
        out[k] = mtx.data[4*k+0] * vec[0] + mtx.data[4*k+1] * vec[1] + mtx.data[4*k+2] * vec[2] + mtx.data[4*k+3] * vec[3];
    end
    return out
end

