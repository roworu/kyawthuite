# 1) generate new private key 
```bash
openssl genrsa -out MOK.key 4096
```

# 2) generate new self-signed cert
```bash
openssl req -new -x509 -key MOK.key -out MOK.pem -days 3650 -subj "/CN=Secure Boot MOK/"
```

# 3) convert to DER for mokutil
```bash
openssl x509 -in MOK.pem -outform DER -out MOK.der
```

result:
```bash
secureboot/
├── MOK.key   # private key
├── MOK.pem   # cert
└── MOK.der   # key for enrollment
```

`MOK.key` - is a private key and should be kept in secret
