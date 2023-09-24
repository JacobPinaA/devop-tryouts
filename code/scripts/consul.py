import consul_kv

def get_consul_kv_value(key, consul_host='localhost', consul_port=8500):
    client = consul_kv.Client(host=consul_host, port=consul_port)
    
    try:
        value = client.get(key)
        
        if value:
            print(f"Valor de '{key}': {value}")
        else:
            print(f"La clave '{key}' no existe en Consul KV.")
    except Exception as e:
        print(f"Error al obtener el valor de '{key}' en Consul KV: {str(e)}")

if __name__ == "__main__":
    key_to_get = "config/app"  
    consul_host = "localhost" 
    
    get_consul_kv_value(key_to_get, consul_host)
