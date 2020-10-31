# from http.server import HTTPServer, BaseHTTPRequestHandler

# class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
#     def do_GET(self):
#         print("new connection")
#         self.send_response(200)
#         self.end_headers()
#         self.wfile.write(b'Hello, world!')


# httpd = HTTPServer(('localhost', 8000), SimpleHTTPRequestHandler)
# httpd.serve_forever()


print("Starting server...")

import socket

HOST = 'localhost'
PORT = 15001


# SOCK_STREAM
with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
    print("server listening...")
    s.bind((HOST, PORT))
    s.settimeout(1)
    # s.listen(1)

    
    # conn, addr = s.accept()
    # print("accepted...")
    # with con  n:
    # print("sonnected by", addr)
    counter = 0 
    while True:
        try: 
            if(counter % 10 == 0):
                s.sendto(data, ip)
            
            data, ip = s.recvfrom(10240)
            if not data:
                break
            s.sendto(data, ip)
        except socket.timeout:
            counter = counter + 1
            print("timeout. retrying...")

        # conn.sendall(data)


# import socketserver
# import time

# class MyUDPHandler(socketserver.StreamRequestHandler):
#     def handle(self):
#         # data = self.request[0].strip()
#         # data = self..rfile.readline().strip()
#         # socket = self.request[1]
#         # data = socket.recv(1024).strip()
#         data = self.rfile.readline().strip()
#         # print("{} wrote:".format(self.client_address[0]))
#         print(data)

#         time.sleep(10)
#         # socket.sendto(data.upper(), self.client_address)



# if __name__ == "__main__":
#     HOST, PORT = "localhost", 15001
#     with socketserver.UDPServer((HOST, PORT), MyUDPHandler) as server:
#         server.serve_forever()