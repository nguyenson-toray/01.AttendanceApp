# This Python file uses the following encoding: utf-8


class AttMachine:
    def __init__(self, name, ip, port):
        self.name = name
        self.port = port
    def __str__(self):
        return f"name : {self.name} ip: {self.ip}"
