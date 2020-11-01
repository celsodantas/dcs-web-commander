import http.server 
import socketserver 
import os

PORT = 8080

print("Serving at port", PORT) 

web_dir = os.path.join(os.path.dirname(__file__), 'web')
os.chdir(web_dir)

# Creating handle 
Handler = http.server.SimpleHTTPRequestHandler 
  
# Creating TCPServer 
http = socketserver.TCPServer(("", PORT), Handler) 
http.serve_forever()
