from bottle import route, run, template
from jinja2 import Template

@route('/hello/<name>')
def index(name):
    template = Template('Hello {{ name }}!')
    return template.render(name=name)

run(host='localhost', port=8080)

