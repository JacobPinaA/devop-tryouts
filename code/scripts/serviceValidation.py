import http.client

def check_service(host, port):
    try:
        
        conn = http.client.HTTPConnection(host, port, timeout=5)
        conn.request("GET", "/")
        
        response = conn.getresponse()
    
        if response.status == 200:
            print(f"El servicio en {host}:{port} está activo.")
        else:
            print(f"El servicio en {host}:{port} respondió con el código {response.status}.")
        
        conn.close()
    except Exception as e:
        print(f"No se pudo conectar al servicio en {host}:{port}. Error: {str(e)}")

if __name__ == "__main__":
    host = "x.x.x.x"  # host donde se ejecuta Nginx
    port = 88           # Puerto en el que se ejecuta Nginx
    
    check_service(host, port)
