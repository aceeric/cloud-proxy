

# 1825 = 5 years

openssl genrsa\
  -out ./key.pem\
  2048

openssl req\
  -x509\
  -new\
  -nodes\
  -key ./key.pem\
  -sha256\
  -subj /CN=tinyproxy\
  -days 1825\
  -out ./cert.pem
