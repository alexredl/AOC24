import base64 as b
exec(''.join(chr(ord(c) ^ 155) for c in b.b64decode(e).decode()))