from collections import namedtuple
from flask import Flask
app = Flask(__name__)

AWSCredentials = namedtuple("AWSCredentials", "ACCESS_KEY SECRET_KEY")

@app.route('/')
def hello_world():
    cred = AWSCredentials("AKIATTBVSLXTYETZQQTY", "Q6BjTGLbnErx2x1rR+U7HyW+1Ak3xRSnSxhXB9G7")
    return cred
