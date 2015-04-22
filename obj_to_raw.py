import sys, struct

vertices = []
uv = []
normals = []
faces = []

for line in open(sys.argv[1]):
    line = line.strip()
    a = line.split(' ')
    if a[0] == 'v':
        vertices.append(map(float, a[1:]))
    elif a[0] == 'vt':
        uv.append(map(float, a[1:]))
    elif a[0] == 'vn':
        normals.append(map(float, a[1:]))
    elif a[0] == 'f':
        assert len(a[1:]) == 3

        f1 = map(int, a[1].split('/'))
        f2 = map(int, a[1].split('/'))
        f3 = map(int, a[1].split('/'))
        faces.append([f1, f2, f3])
    else:
        pass
        #print a

out = open('test', 'wb')

print(len(faces))
for f in faces:
    # print(f)
    for i in range(3):
        # print(f, i)
        # print(vertices[f[i][0]][0])
        p = struct.pack('fff', vertices[f[i][0] - 1][0], vertices[f[i][0] - 1][1], vertices[f[i][0] - 1][2])
        # u = struct.pack('ff', uv[f[i][1]][0], uv[f[i][1]][1])
        # n = struct.pack('fff', normals[f[i][2]][0], normals[f[i][2]][1], normals[f[i][2]][2])

        out.write(p)
        # out.write(n)
        # out.write(u)
